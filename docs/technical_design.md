# Technical Design, Assumptions and Trade-offs

## 1. Validation rules

| Rule | Action |
|---|---|
| Exact duplicate row | Remove before quality-gate calculation |
| `SaleAmount` null | Reject |
| `SaleAmount` < 0 | Reject; assumption: returns are not defined in the source contract |
| `OrderDate` null/unparseable | Reject |
| Product lookup fails | Reject |
| `Region` null/blank | Reject |
| `Currency` null/blank | Reject |
| `CustomerID` null | Default to `UNKNOWN` |
| `Discount` null | Default to `0` |
| Unsupported exchange currency | Fail conversion / data-quality handling; never silently use null |

The negative-amount rule is an explicit implementation assumption because the assessment requires validation but does not define a returns process. If the business confirms negative amounts are valid refunds, replace this rule with a transaction-type/return model.

## 2. Currency API strategy

The assessment asks for an external exchange-rate API and specifically gives the EUR-base endpoint as an example. The notebook calls the endpoint once per batch rather than once per record.

For an EUR-base response:
- EUR -> USD = returned `USD` rate.
- GBP -> USD = `USD per EUR / GBP per EUR`.
- USD -> USD = `1.0`.

The notebook writes a timestamped cache after a successful API call. On API failure it attempts the cache, then uses configurable default rates. The source of the rate (`API`, `CACHE`, or `DEFAULT`) is persisted in the conversion log and target.

For a production implementation, the default rates should be governed configuration, not silently chosen by developers.

## 3. Error handling

Every rejected record receives:
- batch ID
- error type(s)
- error message
- raw record context
- timestamp

Rejected rows are archived separately. Error logs are retained independently so operational monitoring does not depend on the rejected-record dataset.

The job enforces:
`rejection_rate = rejected_records / deduplicated_input_records`

If the rate is greater than 5%, the pipeline raises a hard failure after archiving/logging and before target publication.

## 4. Architecture

### High level
POS CSV, inventory SQL, and loyalty API data enter ADLS Gen2/Synapse orchestration. Synapse Spark performs validation, deduplication, transformation and enrichment. Exchange-rate API integration is controlled through the Spark/API layer. Curated data is loaded to Azure SQL/Synapse SQL and exposed through Power BI.

### Low level
The design separates Bronze/Silver/Curated layers, uses broadcast lookup for the small product reference, performs API retrieval once per batch, and keeps rejected records outside the curated path. The architecture scenario also carries the inventory SQL source (product + stock) and loyalty API source (customer profile + transactions) through the orchestration layer, even though the supplied CSV task data contains only sales and product-reference files.

## 5. Large datasets and wide tables

- Use partition pruning on date columns.
- Store intermediate data in Delta/Parquet rather than CSV.
- Broadcast only small reference datasets such as the product table.
- Avoid collecting large DataFrames to the driver.
- Fetch the exchange-rate API once per batch and broadcast the resulting small map.
- Select only required columns before joins.
- Repartition by a stable business/date key only when justified by workload.
- Control Spark shuffle partitions based on actual data volume.
- For very wide datasets, project required columns early and avoid repeated serialization.
- For skewed keys, use salting or other skew-mitigation only when profiling proves it is necessary.

## 6. Orchestration

Recommended Synapse Pipeline sequence:

1. Validate source arrival.
2. Copy/land raw files to ADLS Bronze.
3. Run PySpark transformation notebook.
4. Persist rejected/error/conversion audit outputs.
5. Evaluate notebook quality-gate status.
6. If successful, load Azure SQL curated table.
7. Refresh Power BI semantic model.
8. Send operational alert on failure.

## 7. Security

- Managed Identity for Synapse where supported.
- Azure Key Vault for secrets/configuration.
- Private endpoints / managed virtual network where required.
- ADLS RBAC and ACLs with least privilege.
- Azure SQL firewall/private networking controls.
- Power BI row-level security if business access requires it.
- Audit logging through Azure Monitor / Log Analytics.

## 8. Monitoring

Monitor:
- source row counts
- duplicate counts
- rejected row counts
- rejection percentage
- API latency/failure
- rate source (`API`/`CACHE`/`DEFAULT`)
- Spark duration and failed stages
- SQL load duration/row counts
- batch ID correlation across all logs

Alert when the 5% quality threshold is breached, API fallback is used, source files are missing, or the SQL load fails.

## 9. Idempotency

Use `BatchID` and source/file metadata. In production, persist an ingestion-control table containing source file name, file checksum/ETag, ingestion timestamp, batch ID and status. Do not reload an already-successful file without an explicit replay operation.

## 10. Assessment alignment

The solution covers:
- Advanced ETL and robust data cleaning
- lookup enrichment
- exchange-rate API integration
- API failure fallback
- USD conversion
- conversion logging
- detailed error logging
- rejection archive
- >5% hard failure
- Azure SQL target schema
- high-level and low-level architecture
- technical trade-offs and assumptions
- setup/run instructions
