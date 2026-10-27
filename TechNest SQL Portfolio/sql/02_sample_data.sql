-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: technest
-- ------------------------------------------------------
-- Server version	8.0.46
   USE technest;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `CustomerID` int NOT NULL AUTO_INCREMENT,
  `FName` varchar(100) NOT NULL,
  `LName` varchar(100) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Phone` varchar(25) NOT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `LoyaltyPoints` int NOT NULL DEFAULT '0',
  `Subscription` tinyint(1) NOT NULL DEFAULT '1',
  `Registration` date NOT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Phone` (`Phone`),
  CONSTRAINT `customers_chk_1` CHECK ((`LoyaltyPoints` between 0 and 3000)),
  CONSTRAINT `customers_chk_2` CHECK ((`Subscription` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `discounttiers`
--

DROP TABLE IF EXISTS `discounttiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discounttiers` (
  `MinPoints` int NOT NULL,
  `DiscountPercent` int NOT NULL,
  PRIMARY KEY (`MinPoints`),
  CONSTRAINT `discounttiers_chk_1` CHECK ((`MinPoints` between 0 and 3000)),
  CONSTRAINT `discounttiers_chk_2` CHECK ((`DiscountPercent` between 0 and 100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employeeinfractions`
--

DROP TABLE IF EXISTS `employeeinfractions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employeeinfractions` (
  `InfractionID` int NOT NULL AUTO_INCREMENT,
  `EmployeeID` int NOT NULL,
  `InfractionTypeID` int NOT NULL,
  `InfractionDate` date NOT NULL,
  PRIMARY KEY (`InfractionID`),
  KEY `EmployeeID` (`EmployeeID`),
  KEY `InfractionTypeID` (`InfractionTypeID`),
  CONSTRAINT `employeeinfractions_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`),
  CONSTRAINT `employeeinfractions_ibfk_2` FOREIGN KEY (`InfractionTypeID`) REFERENCES `infractiontypes` (`InfractionTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `EmployeeID` int NOT NULL AUTO_INCREMENT,
  `FName` varchar(100) NOT NULL,
  `LName` varchar(100) NOT NULL,
  `DOB` date NOT NULL,
  `EmploymentType` varchar(20) NOT NULL,
  `DateHired` date NOT NULL,
  `SickTime` tinyint NOT NULL DEFAULT '0',
  `VacationTime` tinyint NOT NULL DEFAULT '0',
  `PersonalTime` tinyint NOT NULL DEFAULT '0',
  `Phone` varchar(25) NOT NULL,
  `Address` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Department` varchar(100) NOT NULL,
  `Position` varchar(100) NOT NULL,
  PRIMARY KEY (`EmployeeID`),
  UNIQUE KEY `Phone` (`Phone`),
  UNIQUE KEY `Email` (`Email`),
  CONSTRAINT `employees_chk_1` CHECK ((`EmploymentType` in (_utf8mb4'Full-Time',_utf8mb4'Part-Time'))),
  CONSTRAINT `employees_chk_2` CHECK ((`SickTime` between 0 and 9)),
  CONSTRAINT `employees_chk_3` CHECK ((`VacationTime` between 0 and 14)),
  CONSTRAINT `employees_chk_4` CHECK ((`PersonalTime` between 0 and 7)),
  CONSTRAINT `employees_chk_5` CHECK ((`DateHired` >= `DOB`))
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `infractiontypes`
--

DROP TABLE IF EXISTS `infractiontypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `infractiontypes` (
  `InfractionTypeID` int NOT NULL AUTO_INCREMENT,
  `InfractionType` varchar(100) NOT NULL,
  `Points` int NOT NULL,
  PRIMARY KEY (`InfractionTypeID`),
  UNIQUE KEY `InfractionType` (`InfractionType`),
  CONSTRAINT `infractiontypes_chk_1` CHECK ((`Points` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lineitems`
--

DROP TABLE IF EXISTS `lineitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lineitems` (
  `OrderID` int NOT NULL,
  `ProductID` int NOT NULL,
  `Quantity` int NOT NULL,
  `UnitPrice` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderID`,`ProductID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `lineitems_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`),
  CONSTRAINT `lineitems_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `products` (`ProductID`),
  CONSTRAINT `lineitems_chk_1` CHECK ((`Quantity` > 0)),
  CONSTRAINT `lineitems_chk_2` CHECK ((`UnitPrice` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `CustomerID` int NOT NULL,
  `EmployeeID` int NOT NULL,
  `OrderDate` datetime NOT NULL,
  `Payment` varchar(50) NOT NULL,
  `OrderStatus` varchar(50) NOT NULL,
  `FulfillmentType` varchar(10) NOT NULL,
  `ShippingAddress` varchar(255) DEFAULT NULL,
  `DeliveryDate` datetime DEFAULT NULL,
  `PickupDate` datetime DEFAULT NULL,
  `AppliedDiscountPercent` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`OrderID`),
  KEY `CustomerID` (`CustomerID`),
  KEY `EmployeeID` (`EmployeeID`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`),
  CONSTRAINT `orders_chk_1` CHECK ((`FulfillmentType` in (_utf8mb4'Ship',_utf8mb4'Pickup'))),
  CONSTRAINT `orders_chk_2` CHECK ((`AppliedDiscountPercent` between 0 and 100)),
  CONSTRAINT `orders_chk_3` CHECK ((((`FulfillmentType` = _utf8mb4'Ship') and (`ShippingAddress` is not null) and (`PickupDate` is null)) or ((`FulfillmentType` = _utf8mb4'Pickup') and (`ShippingAddress` is null) and (`DeliveryDate` is null)))),
  CONSTRAINT `orders_chk_4` CHECK (((`DeliveryDate` is null) or (`DeliveryDate` >= `OrderDate`))),
  CONSTRAINT `orders_chk_5` CHECK (((`PickupDate` is null) or (`PickupDate` >= `OrderDate`)))
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `ProductID` int NOT NULL AUTO_INCREMENT,
  `ProductName` varchar(150) NOT NULL,
  `Description` text,
  `Category` varchar(100) NOT NULL,
  `Features` text,
  `Price` decimal(10,2) NOT NULL,
  `StockQuantity` int NOT NULL DEFAULT '0',
  `ReorderThreshold` int NOT NULL DEFAULT '0',
  `LastRestockDate` date DEFAULT NULL,
  PRIMARY KEY (`ProductID`),
  CONSTRAINT `products_chk_1` CHECK ((`Price` >= 0)),
  CONSTRAINT `products_chk_2` CHECK ((`StockQuantity` >= 0)),
  CONSTRAINT `products_chk_3` CHECK ((`ReorderThreshold` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `training`
--

DROP TABLE IF EXISTS `training`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `training` (
  `TrainingID` int NOT NULL AUTO_INCREMENT,
  `CourseID` int NOT NULL,
  `EmployeeID` int NOT NULL,
  `TrainerID` int NOT NULL,
  `TrainingDate` date NOT NULL,
  `Results` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`TrainingID`),
  KEY `CourseID` (`CourseID`),
  KEY `EmployeeID` (`EmployeeID`),
  KEY `TrainerID` (`TrainerID`),
  CONSTRAINT `training_ibfk_1` FOREIGN KEY (`CourseID`) REFERENCES `trainingcourse` (`CourseID`),
  CONSTRAINT `training_ibfk_2` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`),
  CONSTRAINT `training_ibfk_3` FOREIGN KEY (`TrainerID`) REFERENCES `employees` (`EmployeeID`),
  CONSTRAINT `training_chk_1` CHECK ((`Results` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trainingcourse`
--

DROP TABLE IF EXISTS `trainingcourse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trainingcourse` (
  `CourseID` int NOT NULL AUTO_INCREMENT,
  `CourseType` varchar(100) NOT NULL,
  `CourseDescription` text NOT NULL,
  PRIMARY KEY (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-26 20:26:12
