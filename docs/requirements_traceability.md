# Requirements Traceability Matrix

| Assessment requirement | Implementation / evidence |
|---|---|
| sales_data.csv | Notebook source ingestion |
| product_reference.csv lookup | Broadcast product lookup |
| External FX API | Batch API call using the specified EUR-base example endpoint |
| Null handling | CustomerID/Discount defaulting + critical-null rejection |
| Duplicate removal | Exact duplicate removal before quality-gate calculation |
| Data validation | OrderID, SaleAmount, OrderDate, Product lookup, Region, Currency checks |
| Parse FX response | EUR->USD and GBP->USD derived from API response |
| API fallback | API -> cache -> default rate hierarchy |
| Convert SaleAmount to USD | `SaleAmountUSD` transformation |
| Conversion audit | `CurrencyConversionLog` with timestamp, rate and record info |
| Detailed error logging | `ErrorLog` with batch, type, message, record details, timestamp |
| Fail if >5% rejected | Hard quality gate before target publication |
| Rejected archive | Separate rejected-record ADLS path + `RejectedRecords` table |
| Azure SQL / SQL Server target | `dbo.SalesEnriched` schema + JDBC load function |
| Target schema for analytics | Monetary, date, region, customer, product/category and batch fields + indexes |
| PySpark notebook | `advanced_etl_pipeline_synapse.ipynb` |
| SQL scripts | `sql/01` through `sql/04` |
| High-level architecture | PNG + PDF |
| Low-level architecture | PNG + PDF |
| Large/wide dataset strategy | Partition pruning, projection, broadcast only small refs, shuffle/skew controls |
| Orchestration | Synapse Pipeline run sequence in README/design doc |
| Security | Managed Identity, Key Vault, RBAC, private networking guidance |
| Monitoring | Azure Monitor / Log Analytics and operational metrics |
| README setup/run steps | `README.md` |
| Trade-offs / assumptions | `docs/technical_design.md` |
