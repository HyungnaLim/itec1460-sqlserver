/* Terminal command to run query */
/* sqlcmd -S localhost -U sa -P P@ssw0rd -d Northwind -Q " */
/* add sql query and a double quate in the end */

/* SELECT */
SELECT C.CompanyName, O.OrderDate FROM Customers AS c JOIN Orders AS o ON c.CustomerID = o.CustomerID;

/* LEFT JOIN */
SELECT c.CustomerID, /* Unique identifier for each customer */ 
    c.CompanyName, /* Name of the customer's company */
    o.OrderID, /* Order number (will be NULL if no orders) */
    o.OrderDate /* Date of order (will be NULL if no orders) */
FROM Customers c /* Main (left) table */
LEFT JOIN Orders o /* Table we're matching against */
ON c.CustomerID = o.CustomerID; /* The matching condition */

/* Built-In Functions - Round, Sum, Count */
SELECT OrderID,
    ROUND( /* Format to 2 decimal places */ SUM( /* Add up all line items */ UnitPrice * Quantity * /* Basic line item total */ (1 - Discount) /* Apply any discount */ ), 2 ) AS TotalValue,
    COUNT(*) AS NumberOfItems /* Count items in order */
FROM [Order Details]
GROUP BY OrderID /* Calculate per order */
ORDER BY TotalValue DESC; /* Show highest value first */

/* GROUP BY with HAVING Clause */
SELECT p.ProductID, p.ProductName, COUNT(od.OrderID) AS TimesOrdered
FROM Products p
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(od.OrderID) > 10
ORDER BY TimesOrdered DESC;

/* Subquery */
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM Products
)
ORDER BY UnitPrice;

/* Combining Multiple Concepts */
SELECT TOP 5
    c.CustomerID,
    c.CompanyName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalPurchase
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalPurchase DESC;

/* Challenge */
SELECT TOP 10
    o.CustomerID, ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalRevenue, COUNT(o.OrderID) AS OrderCount
FROM orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY o.CustomerID
ORDER BY TotalRevenue DESC;