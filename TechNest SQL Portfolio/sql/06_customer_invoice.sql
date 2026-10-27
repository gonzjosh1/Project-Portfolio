-- ==================================================================
-- TechNest | 06 Customer Invoice (Rules 21 and 25)
-- Builds an itemized invoice for one order: fulfillment details,
-- payment, saved prices, loyalty discount, and order total.
-- Run the whole file in order. Each SET picks the order for the
-- invoice query that follows it.
-- ==================================================================

USE technest;

-- Pick the first customer with at least two orders,
-- then that customer's most recent order (Expected: Customer 2, Order 15)
SET @customer_id = (
    SELECT CustomerID
    FROM orders
    GROUP BY CustomerID
    HAVING COUNT(*) >= 2
    ORDER BY CustomerID
    LIMIT 1
);

SET @order_id = (
    SELECT OrderID
    FROM orders
    WHERE CustomerID = @customer_id
    ORDER BY OrderDate DESC, OrderID DESC
    LIMIT 1
);

-- Invoice 1: most recent order
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    CONCAT(c.FName, ' ', c.LName) AS CustomerName,
    CONCAT(e.FName, ' ', e.LName) AS EmployeeName,
    o.Payment,
    o.OrderStatus,
    o.FulfillmentType,
    o.ShippingAddress,
    o.DeliveryDate,
    o.PickupDate,
    p.ProductName,
    li.Quantity,
    li.UnitPrice,
    ROUND(li.Quantity * li.UnitPrice, 2) AS LineSubtotal,
    o.AppliedDiscountPercent AS DiscountPercent,
    ROUND(
        li.Quantity * li.UnitPrice
        * (1 - o.AppliedDiscountPercent / 100.0),
        2
    ) AS DiscountedLineTotal,
    ROUND(
        SUM(li.Quantity * li.UnitPrice)
        OVER (PARTITION BY o.OrderID),
        2
    ) AS OrderSubtotal,
    ROUND(
        SUM(
            li.Quantity * li.UnitPrice
            * (1 - o.AppliedDiscountPercent / 100.0)
        ) OVER (PARTITION BY o.OrderID),
        2
    ) AS OrderTotal
FROM orders AS o
JOIN customers AS c
    ON o.CustomerID = c.CustomerID
JOIN employees AS e
    ON o.EmployeeID = e.EmployeeID
JOIN lineitems AS li
    ON o.OrderID = li.OrderID
JOIN products AS p
    ON li.ProductID = p.ProductID
WHERE o.CustomerID = @customer_id
  AND o.OrderID = @order_id
ORDER BY p.ProductID;

-- Switch to the same customer's previous order (Expected: Order 35)
SET @order_id = (
    SELECT OrderID
    FROM orders
    WHERE CustomerID = @customer_id
    ORDER BY OrderDate DESC, OrderID DESC
    LIMIT 1 OFFSET 1
);

-- Invoice 2: previous order
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    CONCAT(c.FName, ' ', c.LName) AS CustomerName,
    CONCAT(e.FName, ' ', e.LName) AS EmployeeName,
    o.Payment,
    o.OrderStatus,
    o.FulfillmentType,
    o.ShippingAddress,
    o.DeliveryDate,
    o.PickupDate,
    p.ProductName,
    li.Quantity,
    li.UnitPrice,
    ROUND(li.Quantity * li.UnitPrice, 2) AS LineSubtotal,
    o.AppliedDiscountPercent AS DiscountPercent,
    ROUND(
        li.Quantity * li.UnitPrice
        * (1 - o.AppliedDiscountPercent / 100.0),
        2
    ) AS DiscountedLineTotal,
    ROUND(
        SUM(li.Quantity * li.UnitPrice)
        OVER (PARTITION BY o.OrderID),
        2
    ) AS OrderSubtotal,
    ROUND(
        SUM(
            li.Quantity * li.UnitPrice
            * (1 - o.AppliedDiscountPercent / 100.0)
        ) OVER (PARTITION BY o.OrderID),
        2
    ) AS OrderTotal
FROM orders AS o
JOIN customers AS c
    ON o.CustomerID = c.CustomerID
JOIN employees AS e
    ON o.EmployeeID = e.EmployeeID
JOIN lineitems AS li
    ON o.OrderID = li.OrderID
JOIN products AS p
    ON li.ProductID = p.ProductID
WHERE o.CustomerID = @customer_id
  AND o.OrderID = @order_id
ORDER BY p.ProductID;
