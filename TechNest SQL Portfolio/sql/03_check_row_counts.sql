-- ==================================================================
-- TechNest | 03 Check Row Counts
-- Run after loading the sample data to confirm it arrived.
-- Expected: 312 rows across 10 tables.
-- ==================================================================

USE technest;

SELECT 'Customers' AS TableName, COUNT(*) AS RowCount FROM customers
UNION ALL
SELECT 'Discount Tiers', COUNT(*) FROM discounttiers
UNION ALL
SELECT 'Employees', COUNT(*) FROM employees
UNION ALL
SELECT 'Infraction Types', COUNT(*) FROM infractiontypes
UNION ALL
SELECT 'Employee Infractions', COUNT(*) FROM employeeinfractions
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Line Items', COUNT(*) FROM lineitems
UNION ALL
SELECT 'Training Courses', COUNT(*) FROM trainingcourse
UNION ALL
SELECT 'Employee Training', COUNT(*) FROM training;
