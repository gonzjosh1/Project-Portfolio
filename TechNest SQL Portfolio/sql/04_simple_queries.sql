-- ==================================================================
-- TechNest | 04 Simple Queries
-- ==================================================================

-- Expected results reflect the data as of late October 2026. Queries that
-- use CURDATE() or NOW() compare against today's date, so some results
-- shift over time (see "A note on dates" in the README).

USE technest;

-- ------------------------------------------------------------------
-- 1. Time Off Eligibility (Rule 10)
-- Question: Which employees have PTO before completing six months?
-- Expected: Employee 23
-- ------------------------------------------------------------------
SELECT
    EmployeeID,
    FName AS `First Name`,
    LName AS `Last Name`,
    DateHired,
    SickTime,
    VacationTime,
    PersonalTime,
    DATE_ADD(DateHired, INTERVAL 6 MONTH) AS PTOEligibleFrom
FROM employees
WHERE CURDATE() < DATE_ADD(DateHired, INTERVAL 6 MONTH)
  AND (
      SickTime > 0
      OR VacationTime > 0
      OR PersonalTime > 0
  );

-- ------------------------------------------------------------------
-- 2. Loyalty Points Notification (Rule 18)
-- Question: Which customers have 2,000+ points and need a reminder?
-- Expected: Customers 30, 29, and 28
-- ------------------------------------------------------------------
SELECT
    CustomerID,
    FName AS `First Name`,
    LName AS `Last Name`,
    LoyaltyPoints,
    Email AS `Contact Email`
FROM customers
WHERE LoyaltyPoints >= 2000
ORDER BY LoyaltyPoints DESC;

-- ------------------------------------------------------------------
-- 3. Return Eligibility (Rule 20)
-- Question: Which orders are inside the return window, and for which returns?
-- Expected: Orders up to 180 days old are 'Opened or Unopened'. 181-365 days are 'Unopened Only'
-- ------------------------------------------------------------------
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    DATEDIFF(CURDATE(), OrderDate) AS DaysSinceOrder,
    CASE
        WHEN DATE(OrderDate) >= DATE_SUB(CURDATE(), INTERVAL 180 DAY)
            THEN 'Opened or Unopened'
        ELSE 'Unopened Only'
    END AS ReturnEligibility
FROM orders
WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 365 DAY)
  AND OrderDate <= NOW()
ORDER BY OrderDate DESC;

-- ------------------------------------------------------------------
-- 4. Restock Threshold (Rule 22)
-- Question: Which products are below their reorder threshold, and by how much?
-- Expected: Products 1-4
-- ------------------------------------------------------------------
SELECT
    ProductID,
    ProductName,
    StockQuantity,
    ReorderThreshold,
    ReorderThreshold - StockQuantity AS UnitsNeeded
FROM products
WHERE StockQuantity < ReorderThreshold
ORDER BY UnitsNeeded DESC, ProductID;

-- ------------------------------------------------------------------
-- 5. Membership Counts (Rule 24)
-- Question: How many customers are members and how many are not?
-- Expected: 29 members, 1 nonmember
-- ------------------------------------------------------------------
SELECT
    CASE
        WHEN Subscription = 1 THEN 'Member'
        WHEN Subscription = 0 THEN 'Nonmember'
        ELSE 'Unknown'
    END AS MembershipStatus,
    COUNT(*) AS CustomerCount
FROM customers
GROUP BY Subscription
ORDER BY Subscription DESC;
