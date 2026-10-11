CREATE DATABASE IF NOT EXISTS capstone_aesthetic_db;
USE capstone_aesthetic_db;

DROP TABLE IF EXISTS raw_aesthetic_sales;

CREATE TABLE raw_aesthetic_sales (
    Order_ID VARCHAR(50),
    Order_Date VARCHAR(50),
    Customer_ID VARCHAR(50),
    Product_Category VARCHAR(50),
    Fabric VARCHAR(50),
    Aesthetic_Style VARCHAR(50),
    Color_Palette VARCHAR(100),
    Preferred_Cafe_Style VARCHAR(100),
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Discount_Percent DECIMAL(5,2),
    Total_Sales DECIMAL(10,2),
    Profit DECIMAL(10,2),
    City VARCHAR(50),
    Payment_Method VARCHAR(50)
);


-- Step 0: Disable Safe Updates to allow mass UPDATE operations
SET SQL_SAFE_UPDATES = 0;

-- STEP 1: TRIM WHITESPACE (TEXT / VARCHAR COLUMNS ONLY)
-- Removes accidental leading and trailing spaces from text fields

UPDATE raw_aesthetic_sales
SET 
    Order_ID             = TRIM(Order_ID),
    Order_Date           = TRIM(Order_Date),
    Customer_ID          = TRIM(Customer_ID),
    Product_Category     = TRIM(Product_Category),
    Fabric               = TRIM(Fabric),
    Aesthetic_Style      = TRIM(Aesthetic_Style),
    Color_Palette        = TRIM(Color_Palette),
    Preferred_Cafe_Style = TRIM(Preferred_Cafe_Style),
    City                 = TRIM(City),
    Payment_Method       = TRIM(Payment_Method);


-- STEP 2: STANDARDIZE TEXT CASING


UPDATE raw_aesthetic_sales
SET Fabric = CONCAT(UPPER(SUBSTRING(Fabric, 1, 1)), LOWER(SUBSTRING(Fabric, 2)))
WHERE Fabric IS NOT NULL AND Fabric != '';

UPDATE raw_aesthetic_sales
SET Product_Category = CONCAT(UPPER(SUBSTRING(Product_Category, 1, 1)), LOWER(SUBSTRING(Product_Category, 2)))
WHERE Product_Category IS NOT NULL AND Product_Category != '';

UPDATE raw_aesthetic_sales
SET City = CONCAT(UPPER(SUBSTRING(City, 1, 1)), LOWER(SUBSTRING(City, 2)))
WHERE City IS NOT NULL AND City != '';


-- STEP 3: IMPUTE MISSING AND NULL TEXT VALUES

UPDATE raw_aesthetic_sales
SET Fabric = 'Unspecified'
WHERE Fabric IS NULL OR Fabric = '';

UPDATE raw_aesthetic_sales
SET City = 'Unknown'
WHERE City IS NULL OR City = '';

UPDATE raw_aesthetic_sales
SET Preferred_Cafe_Style = 'Unspecified'
WHERE Preferred_Cafe_Style IS NULL OR Preferred_Cafe_Style = '';


-- Replaces negative quantities (-1) with 0 and recalculates total sales
UPDATE raw_aesthetic_sales
SET Quantity = CASE 
    WHEN Quantity < 0 THEN 0 
    ELSE Quantity 
END;

UPDATE raw_aesthetic_sales
SET Total_Sales = ROUND(Quantity * Unit_Price * (1 - Discount_Percent), 2),
    Profit = ROUND(Total_Sales * 0.45, 2);


-- STEP 5: REMOVE DUPLICATE RECORDS USING A CTE & WINDOW FUNCTION


DROP TABLE IF EXISTS cleaned_aesthetic_sales;

CREATE TABLE cleaned_aesthetic_sales AS
WITH RankedOrders AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Order_ID 
               ORDER BY Order_Date
           ) AS row_num
    FROM raw_aesthetic_sales
)
SELECT 
    Order_ID,
    Order_Date,
    Customer_ID,
    Product_Category,
    Fabric,
    Aesthetic_Style,
    Color_Palette,
    Preferred_Cafe_Style,
    Quantity,
    Unit_Price,
    Discount_Percent,
    Total_Sales,
    Profit,
    City,
    Payment_Method
FROM RankedOrders
WHERE row_num = 1;


-- STEP 6: VERIFY CLEANED DATASET RECORD COUNT

SELECT COUNT(*) AS total_cleaned_records FROM cleaned_aesthetic_sales;

-- Re-enable Safe Updates
SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM cleaned_aesthetic_sales
WHERE Order_Date IS NULL;
