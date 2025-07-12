-- ========================================================================================
-- Blinkit Grocery Data Analysis Project
-- ========================================================================================

-- DATA CLEANING QUERIES
-------------------------------------------------------------------------------------------
SELECT * FROM [BlinkIT Grocery Data];
---------
SELECT COUNT(*) FROM [BlinkIT Grocery Data];
------
UPDATE [BlinkIT Grocery Data]
SET Item_Fat_Content =
CASE
    WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
    WHEN Item_Fat_Content = 'reg' THEN 'Regular'
    ELSE Item_Fat_Content
END;
----------
SELECT DISTINCT(Item_Fat_Content) FROM [BlinkIT Grocery Data];

-- Output:
-- Item_Fat_Content
-- -----------------
-- Low Fat
-- Regular
-- (2 rows)

-------------------------------------------------------------------------------------------

-- KPI
SELECT CAST(SUM(Total_Sales) / 1000000 AS DECIMAL(10,2)) AS TOTAL_SALES_MILLIONS 
FROM [BlinkIT Grocery Data];

-- Output:
-- TOTAL_SALES_MILLIONS
-- --------------------
-- 1.20
-- (1 row)

-------------------------------------------------------------------------------------------

SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS TOTAL_SALES_MILLIONS 
FROM [BlinkIT Grocery Data];

-- Output:
-- TOTAL_SALES_MILLIONS
-- --------------------
-- 141
-- (1 row)

-------------------------------------------------------------------------------------------

SELECT COUNT(*) AS NO_of_ITEMS FROM [BlinkIT Grocery Data];

-- Output:
-- NO_of_ITEMS
-- -----------
-- 8523
-- (1 row)

-------------------------------------------------------------------------------------------

SELECT AVG(Rating) AS AVG_RATING FROM [BlinkIT Grocery Data];

-- Output:
-- AVG_RATING
-- ------------
-- 3.96585709104848
-- (1 row)

-------------------------------------------------------------------------------------------

-- Total Sales by Fat Content
SELECT Item_Fat_Content, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,2)) AS avg_Sales,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Ratings,
       COUNT(*) AS No_of_Items
FROM [BlinkIT Grocery Data] 
GROUP BY Item_Fat_Content
ORDER BY Item_Fat_Content DESC;

-- Output:
-- Item_Fat_Content | Total_Sales | Total_Sales | AVG_Ratings | No_of_Items
-- -----------------+-------------+-------------+-------------+------------
-- Regular          | 425361.80   | 141.50      | 3.97        | 3006
-- Low Fat          | 776319.68   | 140.71      | 3.97        | 5517
-- (2 rows)

-------------------------------------------------------------------------------------------

-- Total Sales by Item Type
SELECT Item_Type, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS AVG_Sales,
       COUNT(*) AS No_of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Ratings
FROM [BlinkIT Grocery Data] 
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- Output:
-- Item_Type            | Total_Sales | AVG_Sales | No_of_Items | AVG_Ratings
-- ---------------------+-------------+-----------+-------------+------------
-- Fruits and Vegetables| 178124.08   | 144.6     | 1232        | 3.96
-- Snack Foods          | 175433.92   | 146.2     | 1200        | 3.95
-- Household            | 135976.53   | 149.4     | 910         | 4.00
-- Frozen Foods         | 118558.88   | 138.5     | 856         | 3.97
-- Dairy                | 101276.46   | 148.5     | 682         | 3.97
-- Canned               | 90706.73    | 139.8     | 649         | 3.99
-- Baking Goods         | 81894.74    | 126.4     | 648         | 3.98
-- Health and Hygiene   | 68025.84    | 130.8     | 520         | 3.99
-- Meat                 | 59449.86    | 139.9     | 425         | 4.02
-- Soft Drinks          | 58514.16    | 131.5     | 445         | 3.92
-- Breads               | 35379.12    | 141.0     | 251         | 3.88
-- Hard Drinks          | 29334.68    | 137.1     | 214         | 3.91
-- Others               | 22451.89    | 132.9     | 169         | 3.95
-- Starchy Foods        | 21880.03    | 147.8     | 148         | 3.92
-- Breakfast            | 15596.70    | 141.8     | 110         | 3.93
-- Seafood              | 9077.87     | 141.8     | 64          | 3.96
-- (16 rows)

-------------------------------------------------------------------------------------------

-- Top 5 Items
SELECT TOP 5 Item_Type, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS AVG_Sales,
       COUNT(*) AS No_of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Ratings
FROM [BlinkIT Grocery Data] 
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- Output:
-- Item_Type            | Total_Sales | AVG_Sales | No_of_Items | AVG_Ratings
-- ---------------------+-------------+-----------+-------------+------------
-- Fruits and Vegetables| 178124.08   | 144.6     | 1232        | 3.96
-- Snack Foods          | 175433.92   | 146.2     | 1200        | 3.95
-- Household            | 135976.53   | 149.4     | 910         | 4.00
-- Frozen Foods         | 118558.88   | 138.5     | 856         | 3.97
-- Dairy                | 101276.46   | 148.5     | 682         | 3.97
-- (5 rows)

-------------------------------------------------------------------------------------------

-- Fat Content by Outlet Location (Pivot)
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat,
       ISNULL([Regular], 0) AS Regular 
FROM (
    SELECT Outlet_Location_Type, Item_Fat_Content,
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales 
    FROM [BlinkIT Grocery Data]
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS Source_table
PIVOT (
    SUM(Total_Sales) FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PIVOT_TABLE
ORDER BY Outlet_Location_Type;

-- Output:
-- Outlet_Location_Type | Low_Fat    | Regular
-- ---------------------+------------+-----------
-- Tier 1               | 215047.91  | 121349.90
-- Tier 2               | 254464.77  | 138685.87
-- Tier 3               | 306806.99  | 165326.03
-- (3 rows)

-------------------------------------------------------------------------------------------

-- Total Sales by Outlet Establishment Year
SELECT Outlet_Establishment_Year,
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,2)) AS Avg_Sales,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_ratings,
       COUNT(*) AS no_of_item
FROM [BlinkIT Grocery Data]
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

-- Output:
-- Outlet_Establishment_Year | Total_Sales | Avg_Sales | Avg_ratings | no_of_item
-- --------------------------+-------------+-----------+-------------+-----------
-- 1998                      | 204522.26   | 139.80    | 3.97        | 1463
-- 2000                      | 131809.02   | 141.43    | 3.95        | 932
-- 2010                      | 132113.37   | 142.06    | 3.96        | 930
-- 2011                      | 78131.56    | 140.78    | 3.98        | 555
-- 2012                      | 130476.86   | 140.30    | 3.99        | 930
-- 2015                      | 130942.78   | 140.95    | 3.96        | 929
-- 2017                      | 133103.91   | 143.12    | 3.94        | 930
-- 2020                      | 129103.96   | 139.42    | 3.98        | 926
-- 2022                      | 131477.77   | 141.68    | 3.97        | 928
-- (9 rows)

-------------------------------------------------------------------------------------------

-- Percentage of Sales by Outlet Size
SELECT Outlet_Size,
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER() AS DECIMAL(10,2)) AS sales_percentage
FROM [BlinkIT Grocery Data]
GROUP BY Outlet_Size
ORDER BY Outlet_Size;

-- Output:
-- Outlet_Size | Total_Sales | sales_percentage
-- ------------+-------------+------------------
-- High        | 248991.58   | 20.72
-- Medium      | 507895.73   | 42.27
-- Small       | 444794.17   | 37.01
-- (3 rows)

-------------------------------------------------------------------------------------------

-- Sales by Outlet Location
SELECT Outlet_Location_Type, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM [BlinkIT Grocery Data] 
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

-- Output:
-- Outlet_Location_Type | Total_Sales
-- ---------------------+------------
-- Tier 3               | 472133.03
-- Tier 2               | 393150.64
-- Tier 1               | 336397.81
-- (3 rows)

-------------------------------------------------------------------------------------------

-- All Metrics by Outlet Type
SELECT Outlet_Type, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,2)) AS Avg_Sales,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Ratings,
       COUNT(*) AS No_of_Items
FROM [BlinkIT Grocery Data] 
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;

-- Output:
-- Outlet_Type      | Total_Sales | Avg_Sales | AVG_Ratings | No_of_Items
-- -----------------+-------------+-----------+-------------+-----------
-- Supermarket Type1| 787549.89   | 141.21    | 3.96        | 5577
-- Grocery Store    | 151939.15   | 140.29    | 3.99        | 1083
-- Supermarket Type2| 131477.77   | 141.68    | 3.97        | 928
-- Supermarket Type3| 130714.67   | 139.80    | 3.95        | 935
-- (4 rows)
