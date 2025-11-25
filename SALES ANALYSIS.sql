/* Sales Performance Analysis (SQL Project)
    Project Overview
    This project analyzes the overall sales performance of an e-commerce business using SQL. It covers monthly revenue trends, best-selling products,
             customer spending analysis, category-wise revenue, and KPIs.*/
----------------------------------------------------------------------------------------------------------------------------------------------

-- Business Problem: Company cannot track monthly revenue and top-performing products.
   -- Solution: Designed Orders, Products tables; created views & procedures for monthly reports.
   
   CREATE DATABASE SalesDB;
   USE SalesDB;
   
   CREATE TABLE Customers (
CustomerID INT PRIMARY KEY AUTO_INCREMENT,
CustomerName VARCHAR(100),
Country VARCHAR(50)
);

CREATE TABLE Products (
ProductID INT PRIMARY KEY AUTO_INCREMENT,
ProductName VARCHAR(100),
Category VARCHAR(50),
Price DECIMAL(10,2)
);

CREATE TABLE Orders (
OrderID INT PRIMARY KEY AUTO_INCREMENT,
CustomerID INT,
OrderDate DATE,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
OrderID INT,
ProductID INT,
Quantity INT,
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers (CustomerName, Country) VALUES
('Rahul Sharma', 'India'),
('Amit Verma', 'India'),
('John Smith', 'USA'),
('Emma Wilson', 'UK'),
('David Brown', 'Canada');

INSERT INTO Products (ProductName, Category, Price) VALUES
('Laptop', 'Electronics', 55000),
('Mouse', 'Electronics', 800),
('Keyboard', 'Electronics', 1200),
('Office Chair', 'Furniture', 4500),
('Table Lamp', 'Home Decor', 1500);

INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2024-01-10'),
(2, '2024-01-12'),
(3, '2024-02-05'),
(1, '2024-02-15'),
(4, '2024-03-01');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 1, 1),
(4, 4, 1),
(5, 5, 3);

-- 1. TOTAL REVENUE
SELECT SUM(OD.Quantity * P.Price) AS TotalRevenue
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID;

-- 2.MONTHLY REVENUE TREND
SELECT
DATE_FORMAT(O.OrderDate, '%Y-%m') AS Month,
SUM(OD.Quantity * P.Price) AS Revenue
FROM Orders O
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY Month
ORDER BY Month;

-- 3. TOP 5 BEST SELLING PRODUCTS
SELECT
P.ProductName,
SUM(OD.Quantity) AS TotalSold
FROM Products P
JOIN OrderDetails OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductName
ORDER BY TotalSold DESC
LIMIT 5;

-- 4.REVENUE BY CATEGORY
SELECT
Category,
SUM(OD.Quantity * P.Price) AS TotalRevenue
FROM Products P
JOIN OrderDetails OD ON P.ProductID = OD.ProductID
GROUP BY Category
ORDER BY TotalRevenue DESC;

-- 5.TOP CUSTOMERS BY SPENDING
SELECT
C.CustomerName,
SUM(OD.Quantity * P.Price) AS TotalSpent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY C.CustomerName
ORDER BY TotalSpent DESC
LIMIT 5;

-- 6.AVERAGE ORDER values
SELECT
SUM(OD.Quantity * P.Price) / COUNT(DISTINCT O.OrderID) AS AvgOrderValue
FROM Orders O
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID;

























