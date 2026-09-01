/* 04_ingestion_control.sql */
IF OBJECT_ID('dbo.IngestionControl','U') IS NULL
BEGIN
    CREATE TABLE dbo.IngestionControl (
        IngestionID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        BatchID UNIQUEIDENTIFIER NOT NULL,
        SourceName VARCHAR(200) NOT NULL,
        SourceFileName VARCHAR(500) NULL,
        SourceFileHash VARCHAR(128) NULL,
        IngestionStartedAt DATETIME2(3) NOT NULL,
        IngestionCompletedAt DATETIME2(3) NULL,
        InputRowCount BIGINT NULL,
        RejectedRowCount BIGINT NULL,
        RejectionRate DECIMAL(9,6) NULL,
        Status VARCHAR(30) NOT NULL,
        ErrorMessage NVARCHAR(2000) NULL
    );

    CREATE INDEX IX_IngestionControl_SourceHash
        ON dbo.IngestionControl(SourceName, SourceFileHash);

    CREATE INDEX IX_IngestionControl_BatchID
        ON dbo.IngestionControl(BatchID);
END;
GO

-- Idempotency rule: a source file hash that already has STATUS='SUCCEEDED'
-- should not be loaded again unless an explicit replay is requested.
