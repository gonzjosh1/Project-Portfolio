-- ==================================================================
-- TechNest | 01 Create Tables
-- Creates the technest database and its 10 tables.
-- Requires MySQL 8.0.16 or later so CHECK constraints are enforced.
-- Parent tables are created before the tables that reference them.
-- ==================================================================

CREATE DATABASE IF NOT EXISTS technest;
USE technest;

CREATE TABLE discounttiers (
    MinPoints INT PRIMARY KEY,
    DiscountPercent INT NOT NULL,

    CHECK (MinPoints BETWEEN 0 AND 3000),
    CHECK (DiscountPercent BETWEEN 0 AND 100)
) ENGINE = InnoDB;

CREATE TABLE infractiontypes (
    InfractionTypeID INT AUTO_INCREMENT PRIMARY KEY,
    InfractionType VARCHAR(100) NOT NULL UNIQUE,
    Points INT NOT NULL,

    CHECK (Points > 0)
) ENGINE = InnoDB;

CREATE TABLE trainingcourse (
    CourseID INT AUTO_INCREMENT PRIMARY KEY,
    CourseType VARCHAR(100) NOT NULL,
    CourseDescription TEXT NOT NULL
) ENGINE = InnoDB;

CREATE TABLE customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FName VARCHAR(100) NOT NULL,
    LName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Phone VARCHAR(25) NOT NULL UNIQUE,
    Address VARCHAR(255),
    DOB DATE,
    LoyaltyPoints INT NOT NULL DEFAULT 0,
    Subscription TINYINT(1) NOT NULL DEFAULT 1,
    Registration DATE NOT NULL,

    CHECK (LoyaltyPoints BETWEEN 0 AND 3000),
    CHECK (Subscription IN (0, 1))
) ENGINE = InnoDB;

CREATE TABLE employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FName VARCHAR(100) NOT NULL,
    LName VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    EmploymentType VARCHAR(20) NOT NULL,
    DateHired DATE NOT NULL,
    SickTime TINYINT NOT NULL DEFAULT 0,
    VacationTime TINYINT NOT NULL DEFAULT 0,
    PersonalTime TINYINT NOT NULL DEFAULT 0,
    Phone VARCHAR(25) NOT NULL UNIQUE,
    Address VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Department VARCHAR(100) NOT NULL,
    Position VARCHAR(100) NOT NULL,

    CHECK (EmploymentType IN ('Full-Time', 'Part-Time')),
    CHECK (SickTime BETWEEN 0 AND 9),
    CHECK (VacationTime BETWEEN 0 AND 14),
    CHECK (PersonalTime BETWEEN 0 AND 7),
    CHECK (DateHired >= DOB)
) ENGINE = InnoDB;

CREATE TABLE products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(150) NOT NULL,
    Description TEXT,
    Category VARCHAR(100) NOT NULL,
    Features TEXT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    ReorderThreshold INT NOT NULL DEFAULT 0,
    LastRestockDate DATE,

    CHECK (Price >= 0),
    CHECK (StockQuantity >= 0),
    CHECK (ReorderThreshold >= 0)
) ENGINE = InnoDB;

CREATE TABLE orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    EmployeeID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    Payment VARCHAR(50) NOT NULL,
    OrderStatus VARCHAR(50) NOT NULL,
    FulfillmentType VARCHAR(10) NOT NULL,
    ShippingAddress VARCHAR(255),
    DeliveryDate DATETIME,
    PickupDate DATETIME,
    AppliedDiscountPercent INT NOT NULL DEFAULT 0,

    FOREIGN KEY (CustomerID)
        REFERENCES customers(CustomerID),

    FOREIGN KEY (EmployeeID)
        REFERENCES employees(EmployeeID),

    CHECK (FulfillmentType IN ('Ship', 'Pickup')),
    CHECK (AppliedDiscountPercent BETWEEN 0 AND 100),

    CHECK (
        (FulfillmentType = 'Ship'
            AND ShippingAddress IS NOT NULL
            AND PickupDate IS NULL)
        OR
        (FulfillmentType = 'Pickup'
            AND ShippingAddress IS NULL
            AND DeliveryDate IS NULL)
    ),

    CHECK (
        DeliveryDate IS NULL
        OR DeliveryDate >= OrderDate
    ),

    CHECK (
        PickupDate IS NULL
        OR PickupDate >= OrderDate
    )
) ENGINE = InnoDB;

CREATE TABLE employeeinfractions (
    InfractionID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    InfractionTypeID INT NOT NULL,
    InfractionDate DATE NOT NULL,

    FOREIGN KEY (EmployeeID)
        REFERENCES employees(EmployeeID),

    FOREIGN KEY (InfractionTypeID)
        REFERENCES infractiontypes(InfractionTypeID)
) ENGINE = InnoDB;

CREATE TABLE training (
    TrainingID INT AUTO_INCREMENT PRIMARY KEY,
    CourseID INT NOT NULL,
    EmployeeID INT NOT NULL,
    TrainerID INT NOT NULL,
    TrainingDate DATE NOT NULL,
    Results BOOLEAN,

    FOREIGN KEY (CourseID)
        REFERENCES trainingcourse(CourseID),

    FOREIGN KEY (EmployeeID)
        REFERENCES employees(EmployeeID),

    FOREIGN KEY (TrainerID)
        REFERENCES employees(EmployeeID),

    CHECK (Results IN (0, 1))
) ENGINE = InnoDB;

CREATE TABLE lineitems (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (OrderID, ProductID),

    FOREIGN KEY (OrderID)
        REFERENCES orders(OrderID),

    FOREIGN KEY (ProductID)
        REFERENCES products(ProductID),

    CHECK (Quantity > 0),
    CHECK (UnitPrice >= 0)
) ENGINE = InnoDB;

-- Confirm all 10 tables were created
SHOW TABLES;
