/* 03_sample_validation_queries.sql
   Run after a successful target load.
*/
SELECT
    COUNT(*) AS RowCount,
    COUNT(DISTINCT OrderID) AS DistinctOrders,
    SUM(SaleAmountUSD) AS TotalSalesUSD
FROM dbo.SalesEnriched;

SELECT
    Currency,
    COUNT(*) AS RowCount,
    SUM(SaleAmountOriginal) AS OriginalAmount,
    SUM(SaleAmountUSD) AS USDAmount
FROM dbo.SalesEnriched
GROUP BY Currency;

SELECT
    Region,
    SUM(SaleAmountUSD) AS SalesUSD
FROM dbo.SalesEnriched
GROUP BY Region
ORDER BY SalesUSD DESC;

SELECT
    BatchID,
    COUNT(*) AS RejectedCount
FROM dbo.RejectedRecords
GROUP BY BatchID
ORDER BY RejectedCount DESC;
