-- ==================================================================
-- TechNest | 05 Complex Queries
-- ==================================================================

-- Expected results reflect the data as of late October 2026. Queries that
-- use CURDATE() or NOW() compare against today's date, so some results
-- shift over time (see "A note on dates" in the README).

USE technest;

-- ------------------------------------------------------------------
-- 1. Training Results (Rule 5)
-- Question: Which courses has each employee taken, with whom, and did they pass?
-- Expected: Failed Basic Enrollment Training for Employees 1 and 2, listed first
-- ------------------------------------------------------------------
SELECT
    tr.EmployeeID,
    CONCAT(e.FName, ' ', e.LName) AS EmployeeName,
    tc.CourseType AS TrainingCourse,
    CONCAT(t.FName, ' ', t.LName) AS TrainerName,
    tr.TrainingDate,
    CASE
        WHEN tr.Results = 1 THEN 'Pass'
        WHEN tr.Results = 0 THEN 'Fail'
        ELSE 'Not Recorded'
    END AS TrainingResult
FROM training AS tr
JOIN employees AS e
    ON tr.EmployeeID = e.EmployeeID
JOIN trainingcourse AS tc
    ON tr.CourseID = tc.CourseID
JOIN employees AS t
    ON tr.TrainerID = t.EmployeeID
ORDER BY tr.Results, tr.EmployeeID, tr.CourseID;

-- ------------------------------------------------------------------
-- 2. Employee Infraction Details (Rules 6 and 8)
-- Question: Which infractions are on record, and are their points active or expired?
-- Expected: 15 infractions. Employee 1's are expired
-- ------------------------------------------------------------------
SELECT
    e.EmployeeID,
    CONCAT(e.FName, ' ', e.LName) AS EmployeeName,
    it.InfractionType,
    it.Points,
    ei.InfractionDate,
    DATE_ADD(ei.InfractionDate, INTERVAL 1 YEAR) AS ExpirationDate,
    CASE
        WHEN CURDATE() >= DATE_ADD(ei.InfractionDate, INTERVAL 1 YEAR)
            THEN 'Expired'
        ELSE 'Active'
    END AS PointStatus
FROM employeeinfractions AS ei
JOIN employees AS e
    ON ei.EmployeeID = e.EmployeeID
JOIN infractiontypes AS it
    ON ei.InfractionTypeID = it.InfractionTypeID
ORDER BY e.EmployeeID, ei.InfractionDate DESC;

-- ------------------------------------------------------------------
-- 3. Highest-Selling Employee (Rule 13)
-- Question: Who has the highest sales after discounts this calendar year?
-- Expected: The top seller for the current year. Tied employees are all returned
-- ------------------------------------------------------------------
WITH EmployeeSales AS (
    SELECT
        e.EmployeeID,
        CONCAT(e.FName, ' ', e.LName) AS EmployeeName,
        COUNT(DISTINCT o.OrderID) AS TotalOrders,
        ROUND(
            SUM(
                li.Quantity * li.UnitPrice
                * (1 - o.AppliedDiscountPercent / 100.0)
            ),
            2
        ) AS TotalSales
    FROM employees AS e
    JOIN orders AS o
        ON e.EmployeeID = o.EmployeeID
    JOIN lineitems AS li
        ON o.OrderID = li.OrderID
    WHERE YEAR(o.OrderDate) = YEAR(CURDATE())
      AND o.OrderDate <= NOW()
    GROUP BY e.EmployeeID, e.FName, e.LName
),
RankedSales AS (
    SELECT
        EmployeeID,
        EmployeeName,
        TotalOrders,
        TotalSales,
        RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
    FROM EmployeeSales
)
SELECT
    EmployeeID,
    EmployeeName,
    TotalOrders,
    TotalSales,
    1000.00 AS BonusAmount
FROM RankedSales
WHERE SalesRank = 1
ORDER BY EmployeeID;

-- ------------------------------------------------------------------
-- 4. Product Sales Performance (Rule 22)
-- Question: How many units and how much revenue did each product bring in this year?
-- Expected: Units sold and sales after discounts per product, highest sales first
-- ------------------------------------------------------------------
SELECT
    p.ProductID,
    p.ProductName,
    SUM(li.Quantity) AS UnitsSold,
    ROUND(
        SUM(
            li.Quantity * li.UnitPrice
            * (1 - o.AppliedDiscountPercent / 100.0)
        ),
        2
    ) AS TotalSales
FROM products AS p
JOIN lineitems AS li
    ON p.ProductID = li.ProductID
JOIN orders AS o
    ON li.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = YEAR(CURDATE())
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSales DESC, p.ProductID;

-- ------------------------------------------------------------------
-- 5. Nonmember Purchase Check (Rule 24)
-- Question: Has anyone without a membership placed an order?
-- Expected: Zero rows (the only nonmember, Customer 1, has no orders)
-- ------------------------------------------------------------------
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    CONCAT(c.FName, ' ', c.LName) AS CustomerName,
    c.Subscription,
    o.Payment,
    o.OrderStatus
FROM orders AS o
JOIN customers AS c
    ON o.CustomerID = c.CustomerID
WHERE c.Subscription = 0
ORDER BY o.OrderDate DESC;
