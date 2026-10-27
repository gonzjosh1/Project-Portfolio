-- ==================================================================
-- TechNest | 08 Subqueries
-- ==================================================================

-- Expected results reflect the data as of late October 2026. Queries that
-- use CURDATE() or NOW() compare against today's date, so some results
-- shift over time (see "A note on dates" in the README).

USE technest;

-- ------------------------------------------------------------------
-- 1. No Active Infractions (Rules 6 and 8)
-- Question: Which employees have a clean record, not counting expired points?
-- Expected: 16 employees, including Employee 1
-- ------------------------------------------------------------------
SELECT
    e.EmployeeID,
    e.FName AS `First Name`,
    e.LName AS `Last Name`
FROM employees AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM employeeinfractions AS ei
    WHERE ei.EmployeeID = e.EmployeeID
      AND ei.InfractionDate <= CURDATE()
      AND DATE_ADD(ei.InfractionDate, INTERVAL 1 YEAR) > CURDATE()
)
ORDER BY e.EmployeeID;

-- ------------------------------------------------------------------
-- 2. Above-Average Customer Orders
-- Question: Which customers order more often than the average customer?
-- Expected: Customers with 2 or more orders (average is 50 / 30, about 1.67)
-- ------------------------------------------------------------------
SELECT
    c.CustomerID,
    CONCAT(c.FName, ' ', c.LName) AS CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM customers AS c
LEFT JOIN orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FName, c.LName
HAVING COUNT(o.OrderID) > (
    (SELECT COUNT(*) FROM orders)
    /
    (SELECT COUNT(*) FROM customers)
)
ORDER BY TotalOrders DESC, c.CustomerID;

-- ------------------------------------------------------------------
-- 3. Products Not Selling
-- Question: Which products have had no sales in the last 90 days?
-- Expected: Product 25, plus any other product without recent sales
-- ------------------------------------------------------------------
SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    p.StockQuantity
FROM products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM lineitems AS li
    JOIN orders AS o
        ON li.OrderID = o.OrderID
    WHERE li.ProductID = p.ProductID
      AND o.OrderDate >= NOW() - INTERVAL 90 DAY
      AND o.OrderDate <= NOW()
)
ORDER BY p.ProductID;

-- ------------------------------------------------------------------
-- 4. Termination Threshold (Rule 8)
-- Question: Who has 15 or more active infraction points?
-- Expected: Employee 4 (17 active points)
-- ------------------------------------------------------------------
SELECT
    e.EmployeeID,
    CONCAT(e.FName, ' ', e.LName) AS EmployeeName,
    active.ActivePoints
FROM employees AS e
JOIN (
    SELECT
        ei.EmployeeID,
        SUM(it.Points) AS ActivePoints
    FROM employeeinfractions AS ei
    JOIN infractiontypes AS it
        ON ei.InfractionTypeID = it.InfractionTypeID
    WHERE ei.InfractionDate <= CURDATE()
      AND DATE_ADD(ei.InfractionDate, INTERVAL 1 YEAR) > CURDATE()
    GROUP BY ei.EmployeeID
    HAVING SUM(it.Points) >= 15
) AS active
    ON e.EmployeeID = active.EmployeeID
ORDER BY active.ActivePoints DESC, e.EmployeeID;

-- ------------------------------------------------------------------
-- 5. Popular Products
-- Question: Which products have sold more than 5 units in total?
-- Expected: Every product with more than 5 units sold, highest first
-- ------------------------------------------------------------------
SELECT
    p.ProductID,
    p.ProductName,
    sales.TotalUnitsSold
FROM products AS p
JOIN (
    SELECT
        ProductID,
        SUM(Quantity) AS TotalUnitsSold
    FROM lineitems
    GROUP BY ProductID
    HAVING SUM(Quantity) > 5
) AS sales
    ON p.ProductID = sales.ProductID
ORDER BY sales.TotalUnitsSold DESC, p.ProductID;
