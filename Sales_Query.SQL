IF OBJECT_ID (N'DBO.PBI_Monthly_Customer_Revenue', N'V') IS NOT NULL
BEGIN 
    DROP VIEW PBI_Monthly_Customer_Revenue
END
GO

CREATE VIEW PBI_Monthly_Customer_Revenue
AS
SELECT YEAR(I.InvoiceDate) InvoiceYear
    , MONTH(I.InvoiceDate) InvoiceMonth
    , I.InvoiceDate
    , C.CustomerID
    , C.CustomerCategoryID
    , SUM(IL.Quantity * IL.UnitPrice) NetRevenue
    , COUNT(DISTINCT IL.InvoiceID) NumOrders
FROM Sales.InvoiceLines IL
JOIN Sales.Invoices I
    ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C
    ON i.CustomerID = c.CustomerID
GROUP BY YEAR(I.InvoiceDate) 
    , MONTH(I.InvoiceDate) 
    , C.CustomerID
    , C.CustomerCategoryID
    , I.InvoiceDate
GO


IF OBJECT_ID (N'DBO.PBI_Customer_Revenue', N'V') IS NOT NULL
BEGIN 
    DROP VIEW PBI_Customer_Revenue
END
GO

CREATE VIEW PBI_Customer_Revenue
AS
SELECT C.CustomerID
    , C.CustomerCategoryID
    , SUM(IL.Quantity * IL.UnitPrice) NetRevenue
    , COUNT(DISTINCT IL.InvoiceID) NumOrders
    , ROUND(SUM(IL.Quantity * IL.UnitPrice) / COUNT(DISTINCT IL.InvoiceID), 2) AvgOrderValue
    , DENSE_RANK () OVER (ORDER BY SUM(IL.Quantity * IL.UnitPrice) DESC) CustomerRank
FROM Sales.InvoiceLines IL
JOIN Sales.Invoices I
    ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C
    ON i.CustomerID = c.CustomerID
GROUP BY C.CustomerID
    , C.CustomerCategoryID
GO


IF OBJECT_ID (N'DBO.PBI_Monthly_Revenue', N'V') IS NOT NULL
BEGIN 
    DROP VIEW PBI_Monthly_Revenue
END
GO

CREATE VIEW PBI_Monthly_Revenue
AS
SELECT YEAR(I.InvoiceDate) InvoiceYear
    , MONTH(I.InvoiceDate) InvoiceMonth
    , I.InvoiceDate
    , SUM(IL.Quantity * IL.UnitPrice) NetRevenue
    , SUM(IL.Quantity) UnitsSold
    , COUNT(DISTINCT IL.InvoiceID) NumOrders
    , ROUND(SUM(IL.Quantity * IL.UnitPrice) / COUNT(DISTINCT IL.InvoiceID), 2) AvgOrderValue
FROM Sales.InvoiceLines IL
JOIN Sales.Invoices I
    ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C
    ON i.CustomerID = c.CustomerID
GROUP BY YEAR(I.InvoiceDate) 
    , MONTH(I.InvoiceDate) 
    , I.InvoiceDate
GO


IF OBJECT_ID (N'DBO.PBI_Monthly_Product_Revenue', N'V') IS NOT NULL
BEGIN 
    DROP VIEW PBI_Monthly_Product_Revenue
END
GO

CREATE VIEW PBI_Monthly_Product_Revenue
AS
SELECT YEAR(I.InvoiceDate) InvoiceYear
    , MONTH(I.InvoiceDate) InvoiceMonth
    , I.InvoiceDate
    , IL.StockItemID
    , SUM(IL.Quantity * IL.UnitPrice) NetRevenue
    , SUM(IL.Quantity) UnitsSold
FROM Sales.InvoiceLines IL
JOIN Sales.Invoices I
    ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C
    ON i.CustomerID = c.CustomerID
GROUP BY YEAR(I.InvoiceDate) 
    , MONTH(I.InvoiceDate) 
    , IL.StockItemID
    , I.InvoiceDate
GO

IF OBJECT_ID (N'DBO.PBI_Product_Revenue', N'V') IS NOT NULL
BEGIN 
    DROP VIEW PBI_Product_Revenue
END
GO
CREATE VIEW PBI_Product_Revenue
AS
SELECT IL.StockItemID
    , SUM(IL.Quantity * IL.UnitPrice) NetRevenue
    , SUM(IL.Quantity) UnitsSold
    , ROUND(AVG(IL.UnitPrice), 2) AvgUnitPrice
    , DENSE_RANK () OVER (ORDER BY SUM(IL.Quantity * IL.UnitPrice) DESC) ProductRank
FROM Sales.InvoiceLines IL
JOIN Sales.Invoices I
    ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C
    ON i.CustomerID = c.CustomerID
GROUP BY IL.StockItemID
GO
