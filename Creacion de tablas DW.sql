use AdventuresWorksSales_ElkaDW;
--se eliminaron los xml de ProductModel
--se eliminaron los (fiscalQuarter y fiscalYear)
--Limpiar tablas si ya existen
if exists (select * from sysobjects where id = object_id(N'[dbo].[Sales_Fact]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table [dbo].[Sales_Fact]
GO

if exists (select * from sysobjects where id = object_id(N'[dbo].[Date_Dim]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table [dbo].[Date_Dim]
GO

if exists (select * from sysobjects where id = object_id(N'[dbo].[Product_Dim]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table [dbo].[Product_Dim]
GO

if exists (select * from sysobjects where id = object_id(N'[dbo].[Territory_Dim]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table [dbo].[Territory_Dim]
GO

if exists (select * from sysobjects where id = object_id(N'[dbo].[Address_Dim]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table [dbo].[Address_Dim]
GO

if exists (select * from sysobjects where id = object_id(N'[dbo].[SalesPerson_Dim]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table [dbo].[SalesPerson_Dim]
GO

if exists (select * from sysobjects where id = object_id(N'[dbo].[Store_Dim]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table [dbo].[Store_Dim]
GO


if exists (select * from sysobjects where id = object_id(N'[dbo].[StateProvince_Hier]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table [dbo].[StateProvince_Hier]
GO

if exists (select * from sysobjects where id = object_id(N'[dbo].[CountryRegion_Hier]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table [dbo].[CountryRegion_Hier]
GO


-- Creación de dimensión de Tiempo

CREATE TABLE [dbo].[Date_Dim](
	DateKey int IDENTITY(1,1) NOT NULL,
	TheDate datetime NOT NULL,
	DayName nvarchar(30) NOT NULL,
	DayNumber int NOT NULL,
	MonthName nvarchar(30) NOT NULL,
	MonthNumber int NOT NULL,
	QuaterName nvarchar(2) NOT NULL,
	--FiscalQuaterName nvarchar(2) NOT NULL,
	DayOfWeek nvarchar(30) NOT NULL,
	Weekend varchar(1) NULL,
	Year int NOT NULL,
	DayOfYear int NOT NULL,
	--FiscalYear int NOT NULL,
	CONSTRAINT PK_Date_Dim PRIMARY KEY(DateKey)
)

CREATE TABLE [dbo].[Product_Dim](
	ProductKey int IDENTITY(1,1) NOT NULL,
	ProductID int NOT NULL,
	ProductCategoryID int NOT NULL,
	ProductCategoryName nvarchar(50) NOT NULL,
	ProductSubCategoryID int NOT NULL,
	ProductSubcategoryName nvarchar(50) NOT NULL,
	ProductModelID int NOT NULL,
	ProductModelName nvarchar(50) NOT NULL,

	Name nvarchar (50) NOT NULL,
	ProductNumber nvarchar (25) NOT NULL,
	MakeFlag nvarchar(15) NOT NULL,
	MakeFlag_value bit NOT NULL,
	FinishedGoodsFlag nvarchar(15) NOT NULL,
	FinishedGoodsFlag_value bit NOT NULL,
	Color nvarchar (15) NULL,
	SafetyStockLevel smallint NOT NULL,
	ReorderPoint smallint NOT NULL,
	StandardCost money NOT NULL,
	ListPrice money NOT NULL,
	Size nvarchar (15) NULL,
	SizeUnitMeasureCode nvarchar (15) NULL,
	WeightUnitMeasureCode nvarchar (15) NULL,
	Weight decimal (8, 2) NULL,
	DaysToManufacture int NOT NULL,
	ProductLine nvarchar (15) NULL,
	ProductLine_value nvarchar (15) NULL,
	Class nvarchar (15) NULL,
	Class_value nvarchar (15) NULL,
	Style nvarchar (15) NULL,
	Style_value nvarchar (15) NULL,
	SellStartDate datetime NOT NULL,
	SellEndDate datetime NULL,
	DiscontinuedDate datetime NULL,
	CONSTRAINT PK_Product_Dim PRIMARY KEY(ProductKey)
)

CREATE TABLE [dbo].[Territory_Dim](
	TerritoryKey int IDENTITY(1,1) NOT NULL,
	TerritoryID int NOT NULL,
	CountryRegionKey_FK int NOT NULL,
	Name nvarchar(50) NOT NULL,
	SalesYTD money NOT NULL,
	SalesLastYear money NOT NULL,
	CostYTD money NOT NULL,
	CostLastYear money NOT NULL,
	Groups nvarchar(50) NOT NULL,
	CONSTRAINT PK_Territory_Dim PRIMARY KEY(TerritoryKey)
)

CREATE TABLE [dbo].[Address_Dim](
	AddressKey int IDENTITY(1,1) NOT NULL,
	AddressID int NOT NULL,
	StateProvinceKey_FK int NOT NULL,
	CityName nvarchar(30) NOT NULL,
	AddressLine1 nvarchar(60) NOT NULL,
	AddressLine2 nvarchar(60) NULL,
	CONSTRAINT PK_Address_Dim PRIMARY KEY(AddressKey)
)

CREATE TABLE [dbo].[SalesPerson_Dim](
	SalesPersonKey int IDENTITY(1,1) NOT NULL,
	SalesPersonID int NOT NULL,
	SalesQuota money NULL,
	Bonus money NOT NULL,
	CommissionPct smallmoney NOT NULL,
	SalesYTD money NOT NULL,
	SalesLastYear money NOT NULL,
	CONSTRAINT PK_SalesPerson_Dim PRIMARY KEY(SalesPersonKey)
)

CREATE TABLE [dbo].[Store_Dim](
	StoreKey int IDENTITY(1,1) NOT NULL,
	StoreID int NOT NULL,
	Name nvarchar(50) NOT NULL,
	Demographics xml NULL,
	CONSTRAINT PK_Store_Dim PRIMARY KEY(StoreKey)
)

CREATE TABLE [dbo].[CountryRegion_Hier](
	CountryRegionKey int IDENTITY(1,1) NOT NULL,
	CountryRegionID nvarchar(3) NOT NULL,
	Name nvarchar(50) NOT NULL,
	CONSTRAINT PK_CountryRegion_Hier PRIMARY KEY(CountryRegionKey)
)

CREATE TABLE [dbo].[StateProvince_Hier](
	StateProvinceKey int IDENTITY(1,1) NOT NULL,
	StateProvinceID int NOT NULL,
	CountryRegionKey_FK int NOT NULL,
	StateProvinceCode nvarchar(15) NOT NULL,
	IsOnlyStateProvinceFlag bit NOT NULL,
	Name nvarchar(50) NOT NULL,
	CONSTRAINT PK_StateProvince_Hier PRIMARY KEY(StateProvinceKey)
)


CREATE TABLE [dbo].[Sales_Fact](
	ProductKey_FK int,
	SalesPersonTerritoryKey_FK int,
	SalesTerritoryKey_FK int,
	BillToKey_FK int,
	ShipToKey_FK int,
	OrderDateKey_FK int,
	DueDateKey_FK int,
	ShipDateKey_FK int,
	SalesPersonKey_FK int,
	StoreKey_FK int,
	SalesOrderID int,
	OnLineOrderFlag bit NOT NULL,
	LineTotal int,
	OrderQty int,
	UnitPrice money,
	CONSTRAINT PK_Sales_Fact PRIMARY KEY(ProductKey_FK,SalesPersonTerritoryKey_FK,SalesTerritoryKey_FK,BillToKey_FK,ShipToKey_FK,OrderDateKey_FK,DueDateKey_FK,ShipDateKey_FK,SalesPersonKey_FK,StoreKey_FK, SalesOrderID, OnLineOrderFlag)
)


ALTER TABLE [dbo].[Territory_Dim] WITH CHECK ADD CONSTRAINT FK_Territory_Dim_CountryRegion_Hier FOREIGN KEY(CountryRegionKey_FK) REFERENCES CountryRegion_Hier(CountryRegionKey);
ALTER TABLE [dbo].[Address_Dim] WITH CHECK ADD	CONSTRAINT FK_Adress_Dim_StateProvince_Hier FOREIGN KEY (StateProvinceKey_FK) REFERENCES StateProvince_Hier(StateProvinceKey);
ALTER TABLE [dbo].[StateProvince_Hier] WITH CHECK ADD CONSTRAINT FK_StateProvince_Hier_CountryRegion_Hier FOREIGN KEY (CountryRegionKey_FK) REFERENCES CountryRegion_Hier(CountryRegionKey); 

ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT FK_Sales_Fact_Product_Dim FOREIGN KEY(ProductKey_FK) REFERENCES Product_Dim(ProductKey); 
ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT FK_Sales_Fact_Territory_Dim_SalesPersonTerritory FOREIGN KEY(SalesPersonTerritoryKey_FK) REFERENCES Territory_Dim(TerritoryKey); 
ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT FK_Sales_Fact_Territory_Dim_SalesTerritory FOREIGN KEY(SalesTerritoryKey_FK) REFERENCES Territory_Dim(TerritoryKey); 
ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT FK_Sales_Fact_Address_Dim_BillTo FOREIGN KEY(BillToKey_FK) REFERENCES Address_Dim(AddressKey); 
ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT FK_Sales_Fact_Address_Dim_ShipTo FOREIGN KEY(ShipToKey_FK) REFERENCES Address_Dim(AddressKey); 
ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT FK_Sales_Fact_Date_Dim_OrderDate FOREIGN KEY(OrderDateKey_FK) REFERENCES Date_Dim(DateKey); 
ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT FK_Sales_Fact_Date_Dim_DueDate FOREIGN KEY(DueDateKey_FK) REFERENCES Date_Dim(DateKey); 
ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT FK_Sales_Fact_Date_Dim_ShipDate FOREIGN KEY(ShipDateKey_FK) REFERENCES Date_Dim(DateKey); 
ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT FK_Sales_Fact_SalePerson_Dim FOREIGN KEY(SalesPersonKey_FK) REFERENCES SalesPerson_Dim(SalesPersonKey); 
ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT FK_Sales_Fact_Store_Dim FOREIGN KEY(StoreKey_FK) REFERENCES Store_Dim(StoreKey);