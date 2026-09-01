# Senior Data Engineer Technical Assessment – Solution

## Files included

- `notebooks/advanced_etl_pipeline_synapse.ipynb` – modular PySpark implementation for Azure Synapse Spark.
- `sql/01_schema.sql` – target, error, rejected-record, and currency-conversion tables.
- `sql/02_indexes_and_quality.sql` – indexes and operational quality queries.
- `sql/03_validation_queries.sql` – post-load validation queries.
- `sql/04_ingestion_control.sql` – idempotency / source-file run-control table.
- `architecture/high_level_architecture.png` / `.pdf` – required high-level diagram.
- `architecture/low_level_architecture.png` / `.pdf` – required low-level diagram.
- `sample_outputs/expected_rejected_records.csv` – expected rejected rows from the supplied sample.
- `docs/technical_design.md` – assumptions, trade-offs, controls, and runbook.
- `docs/requirements_traceability.md` – requirement-to-implementation matrix.

## Source-data findings

The supplied sales file contains **20 rows**. There is **1 exact duplicate**, leaving **19 rows after deduplication**.

The supplied data also contains:
- 1 null `SaleAmount`
- 1 null `OrderDate`
- 1 invalid date value (`2023-13-01`)
- 1 unmatched `ProductID` (`PX1`)
- 2 negative `SaleAmount` values
- 3 null `Discount` values
- 1 null `CustomerID`

The notebook treats `Discount` and `CustomerID` as non-critical and defaults them to `0` and `UNKNOWN`, respectively. Critical data-quality failures are rejected.

Under the documented validation rules, **6 of 19 deduplicated records are rejected = 31.58%**. Because the assessment requires the job to fail when rejection exceeds 5%, the supplied sample is expected to trigger the quality gate. This is a controlled failure: bad records are archived and logged, and the target table is not published.

## Azure run sequence

1. Upload `sales_data.csv` and `product_reference.csv` to ADLS Gen2 bronze storage.
2. Execute `sql/01_schema.sql` against Azure SQL Database / SQL Server.
3. Open the notebook in Azure Synapse Studio and attach a Spark pool.
4. Configure the ADLS paths, SQL connection method, and approved exchange-rate cache location.
5. Run the notebook.
6. Review rejected-record and error-log outputs.
7. If rejection rate <= 5%, load `target_df` into `dbo.SalesEnriched`.
8. If rejection rate > 5%, stop the pipeline and investigate the archived records.
9. Record source-file hash/status in `dbo.IngestionControl` to prevent accidental duplicate reprocessing.
10. Schedule/orchestrate the notebook with Synapse Pipelines.
11. Publish `dbo.SalesEnriched` to Power BI using a governed semantic model.

## Security

Use Managed Identity wherever possible. Store SQL/API secrets or configuration in Azure Key Vault. Apply least-privilege RBAC to ADLS, Synapse, and Azure SQL. Do not hard-code credentials in the notebook.
