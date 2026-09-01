/* 01_schema.sql
   Target schema for Azure SQL Database / SQL Server.
*/
IF SCHEMA_ID('dbo') IS NULL EXEC('CREATE SCHEMA dbo');
GO

IF OBJECT_ID('dbo.SalesEnriched','U') IS NULL
BEGIN
    CREATE TABLE dbo.SalesEnriched (
        SalesEnrichedID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        OrderID BIGINT NOT NULL,
        ProductID VARCHAR(50) NOT NULL,
        ProductName NVARCHAR(200) NOT NULL,
        Category NVARCHAR(100) NOT NULL,
        SaleAmountOriginal DECIMAL(18,2) NOT NULL,
        Currency CHAR(3) NOT NULL,
        ConversionRateToUSD DECIMAL(18,8) NOT NULL,
        SaleAmountUSD DECIMAL(18,2) NOT NULL,
        OrderDate DATE NOT NULL,
        Region NVARCHAR(50) NOT NULL,
        CustomerID VARCHAR(100) NOT NULL,
        Discount DECIMAL(8,4) NOT NULL,
        ConversionTimestamp DATETIME2(3) NOT NULL,
        RateSource VARCHAR(20) NOT NULL,
        BatchID UNIQUEIDENTIFIER NOT NULL,
        LoadTimestamp DATETIME2(3) NOT NULL
    );
END;
GO

IF OBJECT_ID('dbo.ErrorLog','U') IS NULL
BEGIN
    CREATE TABLE dbo.ErrorLog (
        ErrorID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        BatchID UNIQUEIDENTIFIER NOT NULL,
        OrderID BIGINT NULL,
        ProductID VARCHAR(50) NULL,
        ErrorType VARCHAR(500) NOT NULL,
        ErrorMessage NVARCHAR(2000) NOT NULL,
        RecordDetails NVARCHAR(MAX) NULL,
        ErrorTimestamp DATETIME2(3) NOT NULL
    );
END;
GO

IF OBJECT_ID('dbo.RejectedRecords','U') IS NULL
BEGIN
    CREATE TABLE dbo.RejectedRecords (
        RejectedRecordID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        BatchID UNIQUEIDENTIFIER NOT NULL,
        OrderID BIGINT NULL,
        ProductID VARCHAR(50) NULL,
        SaleAmount DECIMAL(18,2) NULL,
        OrderDateRaw VARCHAR(50) NULL,
        OrderDate DATE NULL,
        Region NVARCHAR(50) NULL,
        CustomerID VARCHAR(100) NULL,
        Discount DECIMAL(8,4) NULL,
        Currency CHAR(3) NULL,
        ErrorType VARCHAR(500) NOT NULL,
        ErrorMessage NVARCHAR(2000) NOT NULL,
        ErrorTimestamp DATETIME2(3) NOT NULL
    );
END;
GO

IF OBJECT_ID('dbo.CurrencyConversionLog','U') IS NULL
BEGIN
    CREATE TABLE dbo.CurrencyConversionLog (
        ConversionLogID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        BatchID UNIQUEIDENTIFIER NOT NULL,
        OrderID BIGINT NOT NULL,
        ProductID VARCHAR(50) NOT NULL,
        SourceCurrency CHAR(3) NOT NULL,
        OriginalAmount DECIMAL(18,2) NOT NULL,
        ConversionRateToUSD DECIMAL(18,8) NOT NULL,
        ConvertedAmountUSD DECIMAL(18,2) NOT NULL,
        ConversionTimestamp DATETIME2(3) NOT NULL,
        RateSource VARCHAR(20) NOT NULL,
        RecordInfo NVARCHAR(MAX) NULL
    );
END;
GO
