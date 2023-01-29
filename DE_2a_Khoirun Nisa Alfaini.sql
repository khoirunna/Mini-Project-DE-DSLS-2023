-- 1. Tulis query untuk mendapatkan jumlah customer tiap bulan yang melakukan order pada tahun 1997.
SELECT
	MONTH(OrderDate) as month_,
	COUNT(DISTINCT CustomerID) as customer_counts
FROM Orders
WHERE year(OrderDate) = 1997
GROUP BY MONTH(OrderDate)
ORDER BY month_
GO

-- 2. Tulis query untuk mendapatkan nama employee yang termasuk Sales Representative.
SELECT (LastName + ' ' + FirstName) AS sales_representative
FROM Employees
WHERE Title = 'Sales Representative'
GO

-- 3. Tulis query untuk mendapatkan top 5 nama produk yang quantitynya paling banyak diorder pada bulan Januari 1997.
SELECT TOP(5)
	ProductName,
	SUM(od.Quantity) AS quantity
FROM [Products] AS p
	JOIN [Order Details] AS od ON p.ProductID = od.ProductID
	JOIN [Orders] AS o ON od.OrderID = o.OrderID
WHERE OrderDate BETWEEN '19970101' AND '19970131'
GROUP BY p.ProductName
ORDER BY SUM(od.Quantity) DESC
GO

-- 4. Tulis query untuk mendapatkan nama company yang melakukan order Chai pada bulan Juni 1997.
SELECT DISTINCT(CompanyName)
FROM [Customers] AS c
	JOIN [Orders] AS o ON c.CustomerID = o.CustomerID
	JOIN [Order Details] AS od ON o.OrderID = od.OrderID
	JOIN [Products] AS p on od.ProductID = p.ProductID
WHERE OrderDate BETWEEN '19970601' AND '19970630'
    AND ProductName = 'Chai'
GO

-- 5. Tulis query untuk mendapatkan jumlah OrderID yang pernah melakukan pembelian (unit_price dikali quantity) <=100, 100<x<=250, 250<x<=500, dan >500 
WITH a AS (SELECT 
	OrderID,
	CASE WHEN SUM((UnitPrice - UnitPrice * Discount) * Quantity) <= 100 THEN '<= 100'
		WHEN SUM((UnitPrice - UnitPrice * Discount) * Quantity) BETWEEN 100 AND 250 THEN '100 < x <= 250'
		WHEN SUM((UnitPrice - UnitPrice * Discount) * Quantity) BETWEEN 250 AND 500 THEN '250 < x <= 500'
		ELSE '> 500'
		END AS category
	FROM [Order Details]
	GROUP BY OrderID)
SELECT COUNT(OrderID) AS order_counts, category
FROM a
GROUP BY category
GO

-- 6. Tulis query untuk mendapatkan Company name pada tabel customer yang melakukan pembelian di atas 500 pada tahun 1997.
SELECT CompanyName, 
SUM((UnitPrice - UnitPrice * Discount) * Quantity) AS purchase_amt
FROM [Order Details] AS od
	JOIN [Orders] AS o ON od.OrderID = o.OrderID
	JOIN [Customers] AS c ON o.CustomerID = c.CustomerID
WHERE YEAR(OrderDate) = 1997
GROUP BY CompanyName
HAVING SUM((UnitPrice - UnitPrice * Discount) * Quantity) > 500
ORDER BY purchase_amt
GO

-- 7. Tulis query untuk mendapatkan nama produk yang merupakan Top 5 sales tertinggi tiap bulan di tahun 1997. 
WITH ranked_sales
	AS (SELECT
			ProductName,
			SUM((od.UnitPrice - od.UnitPrice * Discount) * Quantity) AS net_sales,
			MONTH(OrderDate) AS month_,
			DENSE_RANK() OVER(PARTITION BY MONTH(OrderDate)
				ORDER BY SUM((od.UnitPrice - od.UnitPrice * Discount) * Quantity) DESC) AS sales_rank
		FROM [Order Details] AS od
			JOIN [Orders] AS o ON od.OrderID = o.OrderID
			JOIN [Products] AS p ON p.ProductID = od.ProductID
		WHERE YEAR(OrderDate) = 1997
		GROUP BY ProductName, MONTH(OrderDate)
		)
SELECT *
FROM ranked_sales
WHERE sales_rank <= 5
GO

-- 8. Buatlah view untuk melihat Order Details yang berisi OrderID, ProductID, ProductName, UnitPrice, Quantity, Discount, Harga setelah diskon.
SELECT  
	OrderID, 
	od.ProductID, 
	ProductName, 
	od.UnitPrice, 
	Quantity, 
	Discount,
	(od.UnitPrice - od.UnitPrice * Discount ) AS net_price
FROM [Order Details] AS od
	JOIN [Products] AS p ON p.ProductID = od.ProductID
GO

-- 9. Buatlah procedure Invoice untuk memanggil CustomerID, CustomerName/CompanyName, OrderID, OrderDate, RequiredDate, ShippedDate jika terdapat inputan CustomerID tertentu.
CREATE PROCEDURE Invoice
@CustomerID nchar(5)
AS SELECT 
	c.CustomerID,
	CompanyName, 
	OrderID,
	OrderDate,
	RequiredDate,
	ShippedDate
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE c.CustomerID = @CustomerID








