/*Base de datos = AdventureWorksSales_Elka
/Data Werehouse = AdventuresWorksSales_ElkaDW.dbo.*/
SELECT
    ObtenerOrderDate.DateKey AS OrderDate,
    ObtenerDueDate.DateKey AS DueDate,
    ObtenerShipDate.DateKey AS ShipDate,
    AdventuresWorksSales_ElkaDW.dbo.Product_Dim.ProductKey,
    ObtenerSalesTerritory.TerritoryKey AS SalesTerritory,
    ObtenerSalesPersonTerritory.TerritoryKey AS SalesPersonTerritory,
    ObtenerBillTo.AddressKey AS BillTo,
    ObtenerShipTo.AddressKey AS ShipTo,
    AdventuresWorksSales_ElkaDW.dbo.SalesPerson_Dim.SalesPersonKey,
    StD.StoreKey,
    AdventureWorksSales_Elka.Sales.SalesOrderHeader.OnlineOrderFlag,
    AdventureWorksSales_Elka.Sales.SalesOrderHeader.SalesOrderID,
    SOD.UnitPrice,
    SOD.OrderQty,
    SOD.LineTotal
    FROM Sales.SalesOrderHeader SOH
        INNER JOIN Sales.SalesOrderDetail SOD
            ON SOH.SalesOrderID = SOD.SalesOrderID
        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.Date_Dim ObtenerOrderDate
            ON SOH.OrderDate = ObtenerOrderDate.TheDate
        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.Date_Dim ObtenerDueDate
            ON SOH.DueDate = ObtenerDueDate.TheDate
        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.Date_Dim ObtenerShipDate
            ON SOH.ShipDate = ObtenerShipDate.TheDate
        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.Product_Dim
            ON SOD.ProductID = AdventuresWorksSales_ElkaDW.dbo.Product_Dim.ProductID
        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.Territory_Dim ObtenerSalesTerritory
            ON SOH.TerritoryID = ObtenerSalesTerritory.TerritoryID
        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.Address_Dim ObtenerBillTo
            ON SOH.BillToAddressID = ObtenerBillTo.AddressID
        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.Address_Dim ObtenerShipTo
            ON SOH.ShipToAddressID = ObtenerShipTo.AddressID,
        INNER JOIN Sales.SalesPerson SP
            ON SOH.SalesPersonId = SP.SalesPersonId
        INNER JOIN Sales.SalesTerritory ST1
            ON SP.TerritoryID = ST1.TerritoryID
        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.Territory_Dim ObtenerSalesPersonTerritory
            ON ST1.TerritoryID = ObtenerSalesPersonTerritory.TerritoryID,
        INNER JOIN Sales.Customer Cus
            ON SOH.CustomerID = Cus.CustomerID
        INNER JOIN Sales.Store St
            ON Cus.StoreID = St.BusinessEntityID
        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.Store_Dim StD
            ON  St.BusinessEntityID = StD.StoreID
    WHERE (Sales.SalesOrderHeader.OrderDate IS NOT NULL)

/*OrderID - SalesPersonID = SalesPerson->SalesPersonID, SalesPErson->territorio = DW.territorio 

SELECT
    NorthwindDM.dbo.Time_Dim.TimeKey,
    NorthwindDM.dbo.Customer_Dim.CustomerKey,
    NorthwindDM.dbo.Shipper_Dim.ShipperKey,
    NorthwindDM.dbo.Product_Dim.ProductKey,
    NorthwindDM.dbo.Employee_Dim.EmployeeKey,
    Northwind.dbo.Orders.RequiredDate,
    [Order Details].UnitPrice * [Order Details].Quantity AS LineItemTotal,
    [Order Details].Quantity AS LineItemQuantity,
    [Order Details].Discount * [Order Details].UnitPrice *
    [Order Details].Quantity AS LineItemDiscount
FROM Orders
    INNER JOIN [Order Details]
        ON Orders.OrderID = [Order Details].OrderID
    INNER JOIN NorthwindDM.dbo.Product_Dim
        ON [Order Details].ProductID = NorthwindDM.dbo.Product_Dim.ProductID
    INNER JOIN NorthwindDM.dbo.Customer_Dim
        ON Orders.CustomerID COLLATE DATABASE_DEFAULT = NorthwindDM.dbo.Customer_Dim.CustomerID
    INNER JOIN NorthwindDM.dbo.Time_Dim
        ON Orders.ShippedDate = NorthwindDM.dbo.Time_Dim.TheDate
    INNER JOIN NorthwindDM.dbo.Shipper_Dim
        ON Orders.ShipVia = NorthwindDM.dbo.Shipper_Dim.ShipperID
    INNER JOIN NorthwindDM.dbo.Employee_Dim
        ON Orders.EmployeeID = NorthwindDM.dbo.Employee_Dim.EmployeeID
WHERE (Orders.ShippedDate IS NOT NULL)



        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.SalesPerson_Dim
            ON SOH.SalesPersonID = AdventuresWorksSales_ElkaDW.dbo.SalesPerson_Dim.SalesPersonID
        INNER JOIN AdventuresWorksSales_ElkaDW.dbo.Territory_Dim ObtenerSalesPersonTerritory
            ON AdventureWorksSales_Elka.Sales.SalesPerson.TerritoryID = ObtenerSalesPersonTerritory.TerritoryID

*/


