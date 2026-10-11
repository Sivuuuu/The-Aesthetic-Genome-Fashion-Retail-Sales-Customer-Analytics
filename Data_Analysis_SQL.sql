USE capstone_aesthetic_db;
-- Objective: Inspect the first few rows of the cleaned table to verify schema and column values.
SELECT 
    Order_ID, 
    Order_Date, 
    Customer_ID, 
    Product_Category, 
    Total_Sales, 
    Profit
FROM cleaned_aesthetic_sales
LIMIT 10;

-- Objective: Extract high-value orders where Total_Sales exceeds $200 and the payment method is Credit Card.   
SELECT 
    Order_ID, 
    Customer_ID, 
    Product_Category, 
    Total_Sales, 
    Payment_Method
FROM cleaned_aesthetic_sales
WHERE Total_Sales > 200.00 
  AND Payment_Method = 'Credit Card'
ORDER BY Total_Sales DESC;

-- Objective: List all unique product categories and aesthetic style combinations available in the catalog.

SELECT DISTINCT 
    Product_Category, 
    Aesthetic_Style, 
    Fabric
FROM cleaned_aesthetic_sales
ORDER BY Product_Category, Aesthetic_Style;

-- Objective: Calculate Total Orders, Total Revenue, Total Profit, and Overall Average Order Value (AOV).   
SELECT 
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    ROUND(SUM(Total_Sales), 2) AS Gross_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Total_Sales), 2) AS Overall_AOV
FROM cleaned_aesthetic_sales;

-- Objective: Group performance metrics by product category to find top-selling apparel lines.
SELECT 
    Product_Category,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Quantity) AS Total_Units_Sold,
    ROUND(SUM(Total_Sales), 2) AS Category_Revenue,
    ROUND(SUM(Profit), 2) AS Category_Profit
FROM cleaned_aesthetic_sales
GROUP BY Product_Category
ORDER BY Category_Revenue DESC;

-- Objective: Find cities generating over $5,000 in revenue and filter out low-volume markets.   
SELECT 
    City,
    COUNT(Order_ID) AS Total_Orders,
    ROUND(SUM(Total_Sales), 2) AS City_Revenue
FROM cleaned_aesthetic_sales
GROUP BY City
HAVING SUM(Total_Sales) > 5000.00
ORDER BY City_Revenue DESC;

-- Objective: Break down total revenue, profit, and profit margin percentage across aesthetic styles (e.g., Cottagecore, Y2K, Dark Academia).

SELECT 
    Aesthetic_Style,
    COUNT(Order_ID) AS Order_Count,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Total_Sales)) * 100, 2) AS Profit_Margin_Pct
FROM cleaned_aesthetic_sales
GROUP BY Aesthetic_Style
ORDER BY Total_Revenue DESC;

-- Objective: Analyze interaction patterns between lifestyle traits (Preferred_Cafe_Style) and product choices (Fabric).
SELECT 
    Preferred_Cafe_Style,
    Fabric,
    COUNT(Order_ID) AS Total_Purchases,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM cleaned_aesthetic_sales
GROUP BY Preferred_Cafe_Style, Fabric
ORDER BY Preferred_Cafe_Style, Total_Purchases DESC;

--  Objective: Categorize customers into VIP, Mid-Tier, and Low-Spend tiers based on total spend.
SELECT 
    Customer_ID,
    COUNT(Order_ID) AS Lifetime_Orders,
    ROUND(SUM(Total_Sales), 2) AS Lifetime_Spend,
    CASE 
        WHEN SUM(Total_Sales) >= 500 THEN 'High-Value VIP'
        WHEN SUM(Total_Sales) BETWEEN 200 AND 499.99 THEN 'Mid-Tier Customer'
        ELSE 'Casual Shopper'
    END AS Customer_Tier
FROM cleaned_aesthetic_sales
GROUP BY Customer_ID
ORDER BY Lifetime_Spend DESC;
-- Objective: Evaluate how discount tiers (No Discount, 1–10%, >10%) influence order quantities.
SELECT 
    CASE 
        WHEN Discount_Percent = 0 THEN '0% (Full Price)'
        WHEN Discount_Percent BETWEEN 0.01 AND 0.10 THEN '1% - 10% Discount'
        ELSE 'Over 10% Discount'
    END AS Discount_Band,
    COUNT(Order_ID) AS Total_Orders,
    ROUND(AVG(Quantity), 2) AS Avg_Units_Per_Order,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM cleaned_aesthetic_sales
GROUP BY 
    CASE 
        WHEN Discount_Percent = 0 THEN '0% (Full Price)'
        WHEN Discount_Percent BETWEEN 0.01 AND 0.10 THEN '1% - 10% Discount'
        ELSE 'Over 10% Discount'
    END
ORDER BY Total_Revenue DESC;

-- Objective: Pivot payment preferences across aesthetic styles using conditional aggregation.
SELECT 
    Aesthetic_Style,
    COUNT(CASE WHEN Payment_Method = 'Credit Card' THEN 1 END) AS Credit_Card_Orders,
    COUNT(CASE WHEN Payment_Method = 'PayPal' THEN 1 END) AS PayPal_Orders,
    COUNT(CASE WHEN Payment_Method = 'UPI' THEN 1 END) AS UPI_Orders,
    COUNT(CASE WHEN Payment_Method = 'Cash on Delivery' THEN 1 END) AS COD_Orders
FROM cleaned_aesthetic_sales
GROUP BY Aesthetic_Style
ORDER BY Aesthetic_Style;


-- Objective: Extract monthly time trends using DATE_FORMAT()
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Order_Month,
    COUNT(Order_ID) AS Monthly_Orders,
    ROUND(SUM(Total_Sales), 2) AS Monthly_Revenue,
    ROUND(SUM(Profit), 2) AS Monthly_Profit
FROM cleaned_aesthetic_sales
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Order_Month ASC;

-- Objective: Identify individual orders where revenue higher than the overall average revenue per order.
SELECT 
    Order_ID,
    Customer_ID,
    Product_Category,
    Total_Sales
FROM cleaned_aesthetic_sales
WHERE Total_Sales > (
    SELECT AVG(Total_Sales) 
    FROM cleaned_aesthetic_sales
)
ORDER BY Total_Sales DESC;

-- Objective: Rank top product categories within every aesthetic style independently.
WITH RankedCategories AS (
    SELECT 
        Aesthetic_Style,
        Product_Category,
        ROUND(SUM(Total_Sales), 2) AS Category_Revenue,
        DENSE_RANK() OVER (
            PARTITION BY Aesthetic_Style 
            ORDER BY SUM(Total_Sales) DESC
        ) AS Category_Rank
    FROM cleaned_aesthetic_sales
    GROUP BY Aesthetic_Style, Product_Category
)
SELECT 
    Aesthetic_Style,
    Product_Category,
    Category_Revenue,
    Category_Rank
FROM RankedCategories
WHERE Category_Rank <= 3;

-- Objective: Calculate running total revenue chronologically across dates.
SELECT 
    Order_Date,
    ROUND(SUM(Total_Sales), 2) AS Daily_Revenue,
    ROUND(SUM(SUM(Total_Sales)) OVER (
        ORDER BY Order_Date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS Cumulative_Revenue
FROM cleaned_aesthetic_sales
GROUP BY Order_Date
ORDER BY Order_Date ASC;

-- Objective: Use LAG() to calculate days elapsed between consecutive purchases for repeat customers.
WITH CustomerOrders AS (
    SELECT 
        Customer_ID,
        Order_ID,
        Order_Date,
        LAG(Order_Date, 1) OVER (
            PARTITION BY Customer_ID 
            ORDER BY Order_Date
        ) AS Previous_Order_Date
    FROM cleaned_aesthetic_sales
)
SELECT 
    Customer_ID,
    Order_ID,
    Order_Date,
    Previous_Order_Date,
    DATEDIFF(Order_Date, Previous_Order_Date) AS Days_Between_Orders
FROM CustomerOrders
WHERE Previous_Order_Date IS NOT NULL
ORDER BY Customer_ID, Order_Date;

SELECT * FROM cleaned_aesthetic_sales  WHERE Order_Date IS NULL;

-- Objective: Aggregate city sales first, then join city metrics back to high-value order counts
WITH CitySummary AS (
    SELECT 
        City,
        COUNT(Order_ID) AS Total_City_Orders,
        ROUND(SUM(Total_Sales), 2) AS City_Revenue,
        ROUND(AVG(Total_Sales), 2) AS City_AOV
    FROM cleaned_aesthetic_sales
    GROUP BY City
),
HighValueCityOrders AS (
    SELECT 
        City,
        COUNT(Order_ID) AS High_Value_Orders
    FROM cleaned_aesthetic_sales
    WHERE Total_Sales >= 250.00
    GROUP BY City
)
SELECT 
    cs.City,
    cs.Total_City_Orders,
    COALESCE(hv.High_Value_Orders, 0) AS High_Value_Orders,
    cs.City_Revenue,
    cs.City_AOV
FROM CitySummary cs
LEFT JOIN HighValueCityOrders hv ON cs.City = hv.City
ORDER BY cs.City_Revenue DESC;

-- Objective: Calculate cumulative percentage of total sales contributed by customers ranked by spend.
WITH CustomerTotals AS (
    SELECT 
        Customer_ID,
        ROUND(SUM(Total_Sales), 2) AS Customer_Spend
    FROM cleaned_aesthetic_sales
    GROUP BY Customer_ID
),
RankedCustomers AS (
    SELECT 
        Customer_ID,
        Customer_Spend,
        SUM(Customer_Spend) OVER (ORDER BY Customer_Spend DESC) AS Cumulative_Spend,
        SUM(Customer_Spend) OVER () AS Total_Business_Spend
    FROM CustomerTotals
)
SELECT 
    Customer_ID,
    Customer_Spend,
    Cumulative_Spend,
    ROUND((Cumulative_Spend / Total_Business_Spend) * 100, 2) AS Cumulative_Revenue_Pct
FROM RankedCustomers
ORDER BY Customer_Spend DESC;

-- Objective: Compute each category's revenue percentage contribution to its respective city's total revenue.
WITH CityCategorySales AS (
    SELECT 
        City,
        Product_Category,
        ROUND(SUM(Total_Sales), 2) AS Category_Revenue
    FROM cleaned_aesthetic_sales
    GROUP BY City, Product_Category
)
SELECT 
    City,
    Product_Category,
    Category_Revenue,
    SUM(Category_Revenue) OVER (PARTITION BY City) AS Total_City_Revenue,
    ROUND((Category_Revenue / SUM(Category_Revenue) OVER (PARTITION BY City)) * 100, 2) AS Pct_Contribution_To_City
FROM CityCategorySales
ORDER BY City, Pct_Contribution_To_City DESC;

-- Objective: Calculate month-over-month revenue growth percentage.   

WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
        ROUND(SUM(Total_Sales), 2) AS Current_Month_Revenue
    FROM cleaned_aesthetic_sales
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
),
MonthlyGrowth AS (
    SELECT 
        Sales_Month,
        Current_Month_Revenue,
        LAG(Current_Month_Revenue, 1) OVER (ORDER BY Sales_Month) AS Previous_Month_Revenue
    FROM MonthlySales
)
SELECT 
    Sales_Month,
    Current_Month_Revenue,
    Previous_Month_Revenue,
    ROUND(((Current_Month_Revenue - Previous_Month_Revenue) / Previous_Month_Revenue) * 100, 2) AS MoM_Growth_Pct
FROM MonthlyGrowth;
