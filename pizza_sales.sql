-- Pizza Sales Analysis
-- This SQL script explores various sales metrics and trends from the 'pizza_sales' dataset.

-------------------------------------------------------------------------------------------
-- 1. Total_Revenue:
select SUM(total_price) as Total_Revenue from pizza_sales;

-- Output:
-- Total_Revenue
-- ---------------
-- 817860.05083847
-- (1 row)

-------------------------------------------------------------------------------------------
-- 2. Average_order_value:
Select sum(total_price) / count(Distinct order_id) as Avg_order_value  from pizza_sales;

-- Output:
-- avg_order_value 
-- -----------------
-- 38.3072623343546 
-- (1 row)

-------------------------------------------------------------------------------------------
-- 3. Total_pizza_sold :
Select sum(quantity) from pizza_sales;

-- Output:
-- (No column name) 
-- ----------------- 
-- 49574 
-- (1 row)

-------------------------------------------------------------------------------------------
-- 4. Total_orders :
Select count(distinct order_id) Total_orders from pizza_sales;

-- Output:
-- Total_orders
-- --------------
-- 21350 
-- (1 row)

-------------------------------------------------------------------------------------------
-- 5. Average_pizza_per_order:
Select cast(cast(sum(quantity) As decimal (10,2)) / cast(count(distinct order_id) As decimal(10,2)) as decimal(10,2)) from pizza_sales;

-- Output:
-- (No column name) 
-- ----------------- 
-- 2.32 
-- (1 row)

-------------------------------------------------------------------------------------------
-- 6. Daily Trend for total orders: 
Select datename(dw,order_date) as order_day, count(distinct order_id) as total_orders from pizza_sales
group by datename(dw, order_date) ;

-- Output:
-- order_day   | total_orders
-- ------------+--------------
-- Saturday    | 3158
-- Wednesday   | 3024
-- Monday      | 2794
-- Sunday      | 2624
-- Friday      | 3538
-- Thursday    | 3239
-- Tuesday     | 2973
-- (7 rows)

------------------------------------------------------------------------------------------
-- 7. Hourly Trend for total orders: 
Select datepart(hour,order_time) as order_hours, count(distinct order_id) as total_orders from pizza_sales
group by datepart(hour,order_time)
order by datepart(hour, order_time) ;

-- Output:
-- order_hours | total_orders
-- ------------+--------------
-- 9           | 1
-- 10          | 8
-- 11          | 1231
-- 12          | 2520
-- 13          | 2455
-- 14          | 1472
-- 15          | 1468
-- 16          | 1920
-- 17          | 2336
-- 18          | 2399
-- 19          | 2009
-- 20          | 1642
-- 21          | 1198
-- 22          | 663
-- 23          | 28
-- (15 rows)

------------------------------------------------------------------------------------------
-- 8. Percentage of sales by pizza category (for January): 
Select pizza_category, sum(total_price) as total_sales , sum(total_price) *100 / (select sum(total_price)  From pizza_sales where month(order_date)=1) as pct from pizza_sales
where month(order_date) = 1 --january
group by pizza_category;

-- Output:
-- pizza_category | total_sales     | pct
-- ---------------+-----------------+-----------------
-- Classic        | 18619.400015259 | 26.6779189176038
-- Chicken        | 16188.75        | 23.1952780348435
-- Veggie         | 17055.4000778198| 24.4370162489706
-- Supreme        | 17929.7499866486| 25.6897867985821
-- (4 rows)

------------------------------------------------------------------------------------------
-- 9. Percentage of sales by pizza size: 
Select pizza_size, sum(total_price) as total_sales , sum(total_price) *100 / (select sum(total_price)  From pizza_sales ) as pct from pizza_sales
group by pizza_size
order by pct desc;

-- Output:
-- pizza_size | total_sales     | pct
-- -----------+-----------------+-----------------
-- L          | 375318.701004028| 45.890333024488
-- M          | 249382.25       | 30.492044420599
-- S          | 178076.49981308 | 21.7734684107037
-- XL         | 14076           | 1.72107684995364
-- XXL        | 1006.6000213623 | 0.123077294254725
-- (5 rows)

------------------------------------------------------------------------------------------
-- 10. Total pizza sold by pizza category:
Select pizza_category, sum(quantity) as total_pizza_sold  from pizza_sales
group by pizza_category; 

-- Output:
-- pizza_category | total_pizza_sold
-- ---------------+------------------
-- Classic        | 14888
-- Chicken        | 11050
-- Veggie         | 11649
-- Supreme        | 11987
-- (4 rows)
-----------------------------------------------------------------------------------------
-- 11. Top 5 best sellers by total pizza sold:
Select top 5 pizza_name, sum(quantity) as total_pizza_sold  from pizza_sales 
group by pizza_name
order by total_pizza_sold desc;

-- Output:
-- pizza_name                | total_pizza_sold
-- --------------------------+------------------
-- The Classic Deluxe Pizza  | 2453
-- The Barbecue Chicken Pizza| 2432
-- The Hawaiian Pizza        | 2422
-- The Pepperoni Pizza       | 2418
-- The Thai Chicken Pizza    | 2371
-- (5 rows)

-----------------------------------------------------------------------------------------
-- 12. Bottom 5 sellers by total pizza sold: 
Select top 5 pizza_name, sum(quantity) as total_pizza_sold  from pizza_sales 
group by pizza_name
order by total_pizza_sold asc;

-- Output:
-- pizza_name               | total_pizza_sold
-- -------------------------+------------------
-- The Brie Carree Pizza    | 490
-- The Mediterranean Pizza  | 934
-- The Calabrese Pizza      | 937
-- The Spinach Supreme Pizza| 950
-- The Soppressata Pizza    | 961
-- (5 rows)

