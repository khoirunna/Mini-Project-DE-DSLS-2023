-- Get Q3 1997 raw data
SELECT 
	o.OrderID,
	c.CustomerID,
	c.CompanyName AS cust,
	OrderDate,
	ShipCountry,
	ProductName,
	CategoryName,
	od.UnitPrice,
	Quantity,
	Discount,
	s.CompanyName AS supplier,
	s.Country AS sup_country
FROM
	Orders AS o
	JOIN Customers AS c ON o.CustomerID = c.CustomerID
	JOIN [Order Details] AS od ON od.OrderID = o.OrderID
	JOIN Products AS p ON p.ProductID = od.ProductID
	JOIN Suppliers AS s ON s.SupplierID = p.SupplierID
	JOIN Categories AS ct ON ct.CategoryID = p.CategoryID
WHERE OrderDate BETWEEN '1997-07-01' AND '1997-09-30'
GO

-- Get Q4 1997 raw data
SELECT 
	o.OrderID,
	c.CustomerID,
	c.CompanyName AS cust,
	OrderDate,
	ShipCountry,
	ProductName,
	CategoryName,
	od.UnitPrice,
	Quantity,
	Discount,
	s.CompanyName AS supplier,
	s.Country AS sup_country
FROM
	Orders AS o
	JOIN Customers AS c ON o.CustomerID = c.CustomerID
	JOIN [Order Details] AS od ON od.OrderID = o.OrderID
	JOIN Products AS p ON p.ProductID = od.ProductID
	JOIN Suppliers AS s ON s.SupplierID = p.SupplierID
	JOIN Categories AS ct ON ct.CategoryID = p.CategoryID
WHERE OrderDate BETWEEN '1997-10-01' AND '1997-12-31'

