-- Create DB only if it doesn't exist
IF NOT EXISTS (
    SELECT name
    FROM sys.databases
    WHERE name = 'tpchDW'
)
BEGIN
    CREATE DATABASE tpchDW;
END
GO

USE tpchDW;
GO

--------------------------
--  Dimensions - Start  --
--------------------------
CREATE TABLE DimDate (
    DateKey        INT PRIMARY KEY,

    Year           INT NOT NULL,
    Quarter        INT NOT NULL,
    Month          INT NOT NULL,
    Day            INT NOT NULL
);

CREATE TABLE DimClient (
    ClientKey          INT IDENTITY(1,1) PRIMARY KEY,
    SourceCustomerKey  INT NOT NULL UNIQUE,

    Customer           VARCHAR(100) NOT NULL,
    Segment            VARCHAR(50),
    Nation             VARCHAR(50),
    Region             VARCHAR(50)
);

CREATE TABLE DimProduct (
    ProductKey         INT IDENTITY(1,1) PRIMARY KEY,
    SourcePartKey      INT NOT NULL UNIQUE,

    Product            VARCHAR(100) NOT NULL,
    Type               VARCHAR(50),
    Brand              VARCHAR(50)
);

CREATE TABLE DimSupplier (
    SupplierKey        INT IDENTITY(1,1) PRIMARY KEY,
    SourceSupplierKey  INT NOT NULL UNIQUE,

    Supplier           VARCHAR(100) NOT NULL,
    Nation             VARCHAR(50),
    Region             VARCHAR(50)
);

--------------------------
--  Dimensions - End  --
--------------------------


--------------------------
--      Fact Table      --
--------------------------

CREATE TABLE FactSales (
    SalesKey       INT IDENTITY(1,1) PRIMARY KEY,

    DateKey        INT NOT NULL,
    ClientKey      INT NOT NULL,
    ProductKey     INT NOT NULL,
    SupplierKey    INT NOT NULL,

    QuantitySold   INT NOT NULL,
    SalesValue     DECIMAL(15,2) NOT NULL,
    Discount       DECIMAL(12,2) DEFAULT 0,
    NetRevenue     DECIMAL(12,2) NOT NULL,
    Cost           DECIMAL(12,2) NOT NULL,
    Profit         DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_FactSales_Date
        FOREIGN KEY (DateKey)
        REFERENCES DimDate(DateKey),

    CONSTRAINT FK_FactSales_Client
        FOREIGN KEY (ClientKey)
        REFERENCES DimClient(ClientKey),

    CONSTRAINT FK_FactSales_Product
        FOREIGN KEY (ProductKey)
        REFERENCES DimProduct(ProductKey),

    CONSTRAINT FK_FactSales_Supplier
        FOREIGN KEY (SupplierKey)
        REFERENCES DimSupplier(SupplierKey)
);