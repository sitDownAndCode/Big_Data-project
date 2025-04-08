-- Select all records from the 'customers_data' table
SELECT * 
FROM customers_data;

-- Select records where any column has NULL, empty string, or zero values
-- Useful for identifying incomplete or missing data
SELECT * FROM customers_data
WHERE 
    Age IS NULL OR Age = 0  -- Check if 'Age' is NULL or zero (INT column)
    OR TRIM(Gender) = '' OR Gender IS NULL  -- Check if 'Gender' is NULL or empty (TEXT column)
    OR TRIM(`Item Purchased`) = '' OR `Item Purchased` IS NULL  -- Check if 'Item Purchased' is NULL or empty (TEXT column)
    OR TRIM(Category) = '' OR Category IS NULL  -- Check if 'Category' is NULL or empty (TEXT column)
    OR `Purchase Amount (USD)` IS NULL OR `Purchase Amount (USD)` = 0  -- Check if 'Purchase Amount (USD)' is NULL or zero (DOUBLE column)
    OR TRIM(Location) = '' OR Location IS NULL  -- Check if 'Location' is NULL or empty (TEXT column)
    OR TRIM(Size) = '' OR Size IS NULL  -- Check if 'Size' is NULL or empty (TEXT column)
    OR TRIM(Color) = '' OR Color IS NULL  -- Check if 'Color' is NULL or empty (TEXT column)
    OR TRIM(Season) = '' OR Season IS NULL  -- Check if 'Season' is NULL or empty (TEXT column)
    OR `Review Rating` IS NULL OR `Review Rating` = 0  -- Check if 'Review Rating' is NULL or zero (DOUBLE column)
    OR TRIM(`Subscription Status`) = '' OR `Subscription Status` IS NULL  -- Check if 'Subscription Status' is NULL or empty (TEXT column)
    OR TRIM(`Payment Method`) = '' OR `Payment Method` IS NULL  -- Check if 'Payment Method' is NULL or empty (TEXT column)
    OR TRIM(`Shipping Type`) = '' OR `Shipping Type` IS NULL  -- Check if 'Shipping Type' is NULL or empty (TEXT column)
    OR TRIM(`Promo Code Used`) = '' OR `Promo Code Used` IS NULL  -- Check if 'Promo Code Used' is NULL or empty (TEXT column)
    OR `Previous Purchases` IS NULL OR `Previous Purchases` = 0  -- Check if 'Previous Purchases' is NULL or zero (INT column)
    OR TRIM(`Preferred Payment Method`) = '' OR `Preferred Payment Method` IS NULL  -- Check if 'Preferred Payment Method' is NULL or empty (TEXT column)
    OR TRIM(`Frequency of Purchases`) = '' OR `Frequency of Purchases` IS NULL;  -- Check if 'Frequency of Purchases' is NULL or empty (TEXT column)

-- Show the structure of the 'customers_data' table (columns, data types, etc.)
DESC customers_data;

-- Count the total records and distinct values for each column
-- This helps to understand the data distribution and identify columns with unique values
SELECT 
    COUNT(*) AS Total_Records,  -- Total number of records in the table
    COUNT(DISTINCT Age) AS Unique_Ages,  -- Count of unique ages
    COUNT(DISTINCT Gender) AS Unique_Genders,  -- Count of unique genders
    COUNT(DISTINCT `Item Purchased`) AS Unique_Items,  -- Count of unique items purchased
    COUNT(DISTINCT Category) AS Unique_Categories,  -- Count of unique categories
    COUNT(DISTINCT `Purchase Amount (USD)`) AS Unique_Purchase_Amounts,  -- Count of unique purchase amounts
    COUNT(DISTINCT Location) AS Unique_Locations,  -- Count of unique locations
    COUNT(DISTINCT Size) AS Unique_Sizes,  -- Count of unique sizes
    COUNT(DISTINCT Color) AS Unique_Colors,  -- Count of unique colors
    COUNT(DISTINCT Season) AS Unique_Seasons,  -- Count of unique seasons
    COUNT(DISTINCT `Review Rating`) AS Unique_Review_Ratings,  -- Count of unique review ratings
    COUNT(DISTINCT `Subscription Status`) AS Unique_Subscription_Statuses,  -- Count of unique subscription statuses
    COUNT(DISTINCT `Payment Method`) AS Unique_Payment_Methods,  -- Count of unique payment methods
    COUNT(DISTINCT `Shipping Type`) AS Unique_Shipping_Types,  -- Count of unique shipping types
    COUNT(DISTINCT `Promo Code Used`) AS Unique_Promo_Usage,  -- Count of unique promo codes used
    COUNT(DISTINCT `Previous Purchases`) AS Unique_Previous_Purchases,  -- Count of unique previous purchases
    COUNT(DISTINCT `Preferred Payment Method`) AS Unique_Preferred_Payment_Methods,  -- Count of unique preferred payment methods
    COUNT(DISTINCT `Frequency of Purchases`) AS Unique_Purchase_Frequencies  -- Count of unique purchase frequencies
FROM customers_data;

-- Get the minimum, maximum, and average values for numeric columns
-- This helps to understand the range and central tendency of these columns
SELECT 
    MIN(Age) AS Min_Age, MAX(Age) AS Max_Age, AVG(Age) AS Avg_Age,  -- Age statistics
    MIN(`Purchase Amount (USD)`) AS Min_Spend, MAX(`Purchase Amount (USD)`) AS Max_Spend, AVG(`Purchase Amount (USD)`) AS Avg_Spend,  -- Spend statistics
    MIN(`Review Rating`) AS Min_Rating, MAX(`Review Rating`) AS Max_Rating, AVG(`Review Rating`) AS Avg_Rating,  -- Review rating statistics
    MIN(`Previous Purchases`) AS Min_Prev_Purchases, MAX(`Previous Purchases`) AS Max_Prev_Purchases, AVG(`Previous Purchases`) AS Avg_Prev_Purchases  -- Previous purchases statistics
FROM customers_data;

-- Calculate gender distribution: count of each gender and percentage of total records
SELECT Gender, COUNT(*) AS Count, 
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers_data)), 2) AS Percentage  -- Percentage of each gender in total
FROM customers_data
GROUP BY Gender
ORDER BY Count DESC;  -- Order by count of each gender

-- Group customers by age range and count the number of customers in each group
SELECT 
    CASE 
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'  -- Group ages between 18 and 25
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'  -- Group ages between 26 and 35
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'  -- Group ages between 36 and 45
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'  -- Group ages between 46 and 60
        ELSE '60+'  -- Group ages above 60
    END AS Age_Group, 
    COUNT(*) AS Customer_Count  -- Count of customers in each age group
FROM customers_data
GROUP BY Age_Group
ORDER BY Age_Group;  -- Order by age group

-- Group customers by location and count the number of customers in each location
SELECT Location, COUNT(*) AS Customer_Count
FROM customers_data
GROUP BY Location
ORDER BY Customer_Count DESC  -- Order locations by number of customers
LIMIT 50;  -- Get top 50 locations with the highest customer count

-- Calculate the total spending per item purchased and order the items by total spending
SELECT `Item Purchased`, SUM(`Purchase Amount (USD)`) AS Total_Spending
FROM customers_data
GROUP BY `Item Purchased`
ORDER BY Total_Spending DESC  -- Order items by total spending
LIMIT 25;  -- Get top 25 items with the highest spending

-- Group customers by age range and calculate average spending in each age group
SELECT 
    CASE 
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'  -- Group ages between 18 and 25
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'  -- Group ages between 26 and 35
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'  -- Group ages between 36 and 45
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'  -- Group ages between 46 and 60
        ELSE '60+'  -- Group ages above 60
    END AS Age_Group, 
    AVG(`Purchase Amount (USD)`) AS Avg_Spending  -- Calculate average spending in each age group
FROM customers_data
GROUP BY Age_Group
ORDER BY Age_Group;  -- Order by age group

-- Group customers by category and calculate total revenue per category
SELECT Category, SUM(`Purchase Amount (USD)`) AS Total_Revenue
FROM customers_data
GROUP BY Category
ORDER BY Total_Revenue DESC;  -- Order categories by total revenue

-- Calculate usage count for each payment method
SELECT `Payment Method`, COUNT(*) AS Usage_Count
FROM customers_data
GROUP BY `Payment Method`
ORDER BY Usage_Count DESC;  -- Order payment methods by usage count

-- Calculate the count of purchases per item purchased and order by the most purchased items
SELECT `Item Purchased`, COUNT(*) AS Purchase_Count
FROM customers_data
GROUP BY `Item Purchased`
ORDER BY Purchase_Count DESC  -- Order by purchase count
LIMIT 10;  -- Get top 10 most purchased items

-- Group customers by previous purchase count and order by descending count
SELECT `Previous Purchases`, COUNT(*) AS Customer_Count
FROM customers_data
GROUP BY `Previous Purchases`
ORDER BY `Previous Purchases` DESC;  -- Order by previous purchases count

-- Group customers by frequency of purchases and order by descending count
SELECT `Frequency of Purchases`, COUNT(*) AS Customer_Count
FROM customers_data
GROUP BY `Frequency of Purchases`
ORDER BY Customer_Count DESC;  -- Order by frequency of purchases count

-- Calculate transactions and average spend for each promo code used
SELECT `Promo Code Used`, 
       COUNT(*) AS Transactions,  -- Count the number of transactions for each promo code
       AVG(`Purchase Amount (USD)`) AS Avg_Spend  -- Calculate the average spend for each promo code
FROM customers_data
GROUP BY `Promo Code Used`
ORDER BY Transactions DESC;  -- Order by number of transactions

-- Calculate average review rating per category and order by the highest average rating
SELECT Category, AVG(`Review Rating`) AS Avg_Review
FROM customers_data
GROUP BY Category
ORDER BY Avg_Review DESC;  -- Order categories by average review rating

-- Select items with high review ratings and order by purchase amount
SELECT `Item Purchased`, `Purchase Amount (USD)`, `Review Rating`
FROM customers_data
WHERE `Review Rating` >= 4.5  -- Filter for items with high ratings
ORDER BY `Purchase Amount (USD)` DESC  -- Order by highest purchase amount
LIMIT 100;

-- Group by category and item, filter by reviews >= 4.0, and order by average rating and purchase count
SELECT 
    Category,
    `Item Purchased`,
    SUM(`Purchase Amount (USD)`) AS Total_Purchase_Amount,
    AVG(`Review Rating`) AS Avg_Review_Rating,
    COUNT(*) AS Purchase_Count
FROM customers_data
WHERE `Review Rating` >= 4.0  -- Filter for items with ratings >= 4.0
GROUP BY Category, `Item Purchased`
ORDER BY Avg_Review_Rating DESC, Purchase_Count DESC  -- Order by average rating and purchase count
LIMIT 100;
