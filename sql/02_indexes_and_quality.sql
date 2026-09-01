/* 02_indexes_and_quality.sql */
CREATE INDEX IX_SalesEnriched_OrderDate
    ON dbo.SalesEnriched(OrderDate);

CREATE INDEX IX_SalesEnriched_ProductID
    ON dbo.SalesEnriched(ProductID);

CREATE INDEX IX_SalesEnriched_CustomerID
    ON dbo.SalesEnriched(CustomerID);

CREATE INDEX IX_SalesEnriched_Region
    ON dbo.SalesEnriched(Region);

CREATE INDEX IX_SalesEnriched_BatchID
    ON dbo.SalesEnriched(BatchID);

CREATE INDEX IX_ErrorLog_BatchID_Timestamp
    ON dbo.ErrorLog(BatchID, ErrorTimestamp);

CREATE INDEX IX_RejectedRecords_BatchID
    ON dbo.RejectedRecords(BatchID);

CREATE INDEX IX_CurrencyConversionLog_BatchID
    ON dbo.CurrencyConversionLog(BatchID);

-- Optional operational checks:
-- SELECT BatchID, COUNT(*) AS ErrorCount
-- FROM dbo.ErrorLog
-- GROUP BY BatchID
-- ORDER BY MAX(ErrorTimestamp) DESC;
