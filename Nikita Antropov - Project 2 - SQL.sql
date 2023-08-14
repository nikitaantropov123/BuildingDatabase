
--/* Project#2 */--

use AdventureWorks2019

--1--
GO

SELECT pro.ProductID,
		pro.Name,
		pro.Color,
		pro.ListPrice,
		pro.Size
FROM Production.Product pro LEFT JOIN Sales.SalesOrderDetail sod
ON pro.ProductID = sod.ProductID
WHERE sod.SalesOrderID IS NULL

--2--
GO

update sales.customer set personid=customerid
 where customerid <=290
update sales.customer set personid=customerid+1700
 where customerid >= 300 and customerid<=350
update sales.customer set personid=customerid+1700
 where customerid >= 352 and customerid<=701

GO

 SELECT cus.CustomerID,
		ISNULL(per.LastName,'unknown') LastName,
		ISNULL(per.LastName,'unknown')	FirstName	
 FROM Sales.Customer cus LEFT JOIN Sales.SalesOrderHeader ordh
 ON cus.CustomerID = ordh.CustomerID LEFT JOIN Person.Person per
 ON cus.CustomerID = per.BusinessEntityID
 WHERE ordh.SalesOrderID IS NULL
 ORDER BY CustomerID 

 --3--
 GO

 SELECT DISTINCT TOP 10 
		cus.CustomerID,
		per.LastName,
		per.FirstName,
		COUNT(SalesOrderID) OVER(PARTITION BY cus.customerid) order_qnty
 FROM Sales.Customer cus LEFT JOIN Sales.SalesOrderHeader ordh
 ON cus.CustomerID = ordh.CustomerID LEFT JOIN Person.Person per
 ON cus.PersonID = per.BusinessEntityID
 GROUP BY per.LastName,
		per.FirstName,
		cus.CustomerID,
		SalesOrderID
ORDER BY order_qnty DESC

--4--
GO

SELECT per.FirstName,
		per.LastName,
		emp.JobTitle,
		emp.HireDate,
		COUNT(*) OVER(PARTITION BY emp.JobTitle) AS 'CountOfTitle'
FROM HumanResources.Employee emp JOIN Person.Person per
ON emp.BusinessEntityID = per.BusinessEntityID
GROUP BY per.LastName,
		emp.JobTitle,
		emp.HireDate,
		per.FirstName
ORDER BY emp.JobTitle

--5--
GO

WITH ord
AS 
(
    SELECT 
        per.FirstName,
        per.LastName,
        cus.CustomerID,
        hed.SalesOrderID,
        hed.OrderDate LastOrder,
        ROW_NUMBER() OVER (PARTITION BY cus.CustomerID ORDER BY hed.OrderDate DESC) AS RowNum,
		LAG(OrderDate) OVER(PARTITION BY cus.CustomerID ORDER BY hed.OrderDate) as PrevOrder
    FROM 
        Sales.Customer cus JOIN Person.Person per
		ON cus.PersonID = per.BusinessEntityID INNER JOIN Sales.SalesOrderHeader hed
		ON cus.CustomerID = hed.CustomerID
	
)
SELECT ord.SalesOrderID,
		ord.CustomerID,
		ord.LastName,
		ord.FirstName,
		ord.LastOrder,
		ord.PrevOrder
FROM ord
WHERE RowNum = 1

--6--
GO

WITH max_ord 
AS
(
    SELECT YEAR(OrderDate) AS OrderYear, MAX(TotalDue) AS MaxTotalDue
    FROM Sales.SalesOrderHeader 
    GROUP BY YEAR(OrderDate)
)
SELECT mo.OrderYear,
		hed.SalesOrderID,
		per.FirstName,
		per.LastName,
		mo.MaxTotalDue
FROM Sales.SalesOrderHeader hed JOIN Sales.Customer cus
ON hed.CustomerID = cus.CustomerID JOIN Person.Person per 
ON cus.PersonID = per.BusinessEntityID JOIN max_ord mo
ON mo.MaxTotalDue = hed.TotalDue

--7--
GO

SELECT *
FROM 
(
	SELECT YEAR(OrderDate) as [YY],
		MONTH(OrderDate) as [Month],
		SalesOrderID
	FROM Sales.SalesOrderHeader
	GROUP BY YEAR(OrderDate), MONTH(OrderDate), SalesOrderID
) sub
PIVOT
(
	COUNT(SalesOrderID)
	FOR [YY] IN ([2011],[2012],[2013],[2014])
) pvt
ORDER BY [Month]

--8--
GO

WITH tbl1 
AS 
(
    SELECT YEAR(OrderDate) AS [Year],
			MONTH(OrderDate) AS [Month],
			SUM(TotalDue) AS Sum_Price
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),
tbl2
AS
(
    SELECT [Year],
			SUM(Sum_Price) AS TotalOrders
    FROM tbl1
    GROUP BY [Year]
)
SELECT [Year],
		[Month], 
		Sum_Price,
		CASE WHEN ROW_NUMBER() OVER (PARTITION BY [Year] ORDER BY [Month]) = 1 THEN 'grand_total'
		END AS YearSummary
FROM (SELECT mo.[Year],
			mo.[Month],
			mo.Sum_Price,
			yr.TotalOrders
			FROM tbl1 mo INNER JOIN tbl2 yr 
			ON mo.[Year] = yr.[Year]) q
GROUP BY [Year],
		[Month],	
		Sum_Price
ORDER BY [Year],[Month]

--9--
GO 

WITH sen
AS
(
	SELECT DATEDIFF(MM,emp.HireDate,GETDATE()) AS Sen,
			emp.BusinessEntityID as B_ID, 
			per.FirstName+' '+per.LastName AS 'PrevFullName',
			CONVERT(varchar,emp.HireDate) AS 'PrevHireDate',
			LAG(emp.HireDate) OVER(ORDER BY DATEDIFF(MM,emp.HireDate,GETDATE()) DESC) AS 'Prev'		
	FROM HumanResources.Employee emp JOIN Person.Person per
	ON emp.BusinessEntityID = per.BusinessEntityID JOIN HumanResources.EmployeeDepartmentHistory edh
	ON emp.BusinessEntityID =  edh.BusinessEntityID JOIN HumanResources.Department dep
	ON edh.DepartmentID = dep.DepartmentID
), sen2
AS
(
	SELECT DISTINCT dep.[Name] AS DepName,
			per.BusinessEntityID AS BusinessEntityID, 
			per.FirstName+' '+per.LastName AS 'Full Name',
			emp.HireDate AS HireDate,
			DATEDIFF(MM,emp.HireDate,GETDATE()) AS Seniority,
			LAG(sen.PrevFullName,1,0) OVER(PARTITION BY dep.[Name] ORDER BY sen.sen DESC) AS 'PrevFullName',
			LAG(sen.PrevHireDate) OVER(PARTITION BY dep.[Name] ORDER BY sen.sen DESC) AS 'PrevHireDate'
	FROM Person.Person per JOIN HumanResources.EmployeeDepartmentHistory edh
	ON per.BusinessEntityID = edh.BusinessEntityID JOIN HumanResources.Department dep
	ON edh.DepartmentID = dep.DepartmentID JOIN HumanResources.Employee emp
	ON per.BusinessEntityID = emp.BusinessEntityID JOIN sen 
	ON sen.B_ID = per.BusinessEntityID
)
SELECT *, 
	DATEDIFF(DD,sen2.PrevHireDate,sen2.HireDate) AS DiffDays
FROM sen2
ORDER BY sen2.DepName, sen2.HireDate DESC

--10--
GO

SELECT emp.HireDate,
		dep.DepartmentID,
		STUFF((SELECT ', '+CONVERT(VARCHAR,emp.BusinessEntityID)+' '+ per.FirstName+' '+per.LastName
				FROM HumanResources.Employee emp2 JOIN HumanResources.EmployeeDepartmentHistory dep2
				ON emp.BusinessEntityID = dep2.BusinessEntityID
				WHERE emp2.HireDate = emp.HireDate AND dep2.DepartmentID = dep.DepartmentID
				FOR XML PATH(''), TYPE).value('.', 'VARCHAR(50)'), 1, 2, '') AS Employees
FROM HumanResources.Employee emp JOIN HumanResources.EmployeeDepartmentHistory dep
	ON emp.BusinessEntityID = dep.BusinessEntityID JOIN Person.Person per
	ON emp.BusinessEntityID = per.BusinessEntityID
GROUP BY
    emp.HireDate,
    dep.DepartmentID,
	emp.BusinessEntityID,
	per.FirstName,
	per.LastName
ORDER BY emp.HireDate 
