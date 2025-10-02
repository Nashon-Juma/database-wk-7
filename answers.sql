-- =============================================
-- Database Design and Normalization Assignment
-- =============================================

-- Question 1: Achieving 1NF (First Normal Form)
-- =============================================

/*
Explanation of 1NF:
First Normal Form requires that:
1. Each table cell should contain a single value
2. Each record needs to be unique
3. There should be no repeating groups of columns

In the given ProductDetail table, the 'Products' column contains multiple values
separated by commas, which violates 1NF. We need to split these into individual rows.
*/

-- Step 1: Create the original table (for demonstration purposes)
CREATE DATABASE IF NOT EXISTS normalization_assignment;
USE normalization_assignment;

-- Create the original table structure
CREATE TABLE IF NOT EXISTS ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Insert sample data
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Display original table
SELECT 'Original Table (Violating 1NF):' AS '';
SELECT * FROM ProductDetail;

-- Step 2: Transform to 1NF by creating a new normalized table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50)
);

-- Insert data into 1NF table (splitting the Products column)
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Display 1NF table
SELECT '';
SELECT 'Table in 1NF:' AS '';
SELECT * FROM ProductDetail_1NF;


-- Step 1: Create the 1NF table (given in the problem)
CREATE TABLE IF NOT EXISTS OrderDetails_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

-- Insert sample data
INSERT INTO OrderDetails_1NF (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Display 1NF table
SELECT '';
SELECT 'Table in 1NF (with partial dependencies):' AS '';
SELECT * FROM OrderDetails_1NF;

-- Step 2: Analyze the partial dependency
/*
Partial Dependency Analysis:
- CustomerName depends only on OrderID, not on the entire primary key (OrderID, Product)
- This means if we have multiple products for the same order, CustomerName is repeated
- This creates redundancy and update anomalies
*/

-- Step 3: Transform to 2NF by removing partial dependencies
-- Create two tables: Orders (customer information) and OrderItems (product information)

-- Table 1: Orders table (contains order-level information)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Table 2: OrderItems table (contains product-level information)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into Orders table (remove duplicates)
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails_1NF;

-- Insert data into OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails_1NF;

-- Display 2NF tables
SELECT '';
SELECT '2NF Tables - Orders Table:' AS '';
SELECT * FROM Orders;

SELECT '';
SELECT '2NF Tables - OrderItems Table:' AS '';
SELECT * FROM OrderItems;

-- Step 4: Verify 2NF compliance
/*
Verification of 2NF:
- Orders table: CustomerName fully depends on OrderID (primary key)
- OrderItems table: Quantity fully depends on the entire primary key (OrderID, Product)
- No partial dependencies remain
*/

-- =============================================
-- Demonstration Queries
-- =============================================

-- Show how to reconstruct the original information using JOIN
SELECT '';
SELECT 'Reconstructed Order Details (using JOIN):' AS '';
SELECT o.OrderID, o.CustomerName, oi.Product, oi.Quantity
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
ORDER BY o.OrderID, oi.Product;

-- =============================================
-- Cleanup (optional - for testing purposes)
-- =============================================
/*
-- Uncomment these lines if you want to clean up the database after testing
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderDetails_1NF;
DROP TABLE IF EXISTS ProductDetail_1NF;
DROP TABLE IF EXISTS ProductDetail;
DROP DATABASE IF EXISTS normalization_assignment;
*/
