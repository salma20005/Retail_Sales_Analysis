select * FROM Sales_Retail
-- Data exploration & cleaning
-- Getting total number of record
select count(*) as total_records
from Sales_Retail 

-- Find out how many unique customers are in the dataset.
select  count(distinct customer_id)as total_customers
from Sales_Retail

--Identify all unique product categories in the dataset.
select distinct category
from Sales_Retail

-- Check for any null values in the dataset and delete records with missing data.
select * from Sales_Retail
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Deleting records with missing data
Delete from Sales_Retail
where 
sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs  IS NULL;

-- Data analysis & Findings
-- SQL query to retrieve all columns for sales made on '2022-11-05'
select *
from  Sales_Retail
where sale_date = '2022-11-05'

-- SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select *
from Sales_Retail
where category = 'Clothing' and quantity >= 4 and YEAR(sale_date) = 2022 and month(sale_date) = 11

--  SQL query to calculate the total sales (total_sale) for each category
select category , sum(total_sale) as total_sales_per_category
from Sales_Retail
group by category

-- SQL query to find the average age of customers who purchased items from the 'Beauty' category
select AVG(age) as average_age
from Sales_Retail
where category = 'Beauty'

-- SQL query to find all transactions where the total_sale is greater than 1000
select * 
from Sales_Retail
where total_sale > 1000

--  SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select  category , gender , count(transactions_id) as total_transactions
from Sales_Retail
group by category , gender
order by 1 

-- SQL query to calculate the average sale for each month. Find out best selling month in each year
with cte as (
select  year(sale_date) as year_date,month(sale_date) as month_date, avg(total_sale) as average_sales
from Sales_Retail
group by year(sale_date),month(sale_date) 

), cte2 as (
select *,
rank() over(partition by year_date order by average_sales desc) as rn
from cte
)
select * from cte2
where rn = 1

-- another solution
with cte3 as (
select  year(sale_date) as year_date,month(sale_date) as month_date, avg(total_sale) as average_sales,
rank() over(partition by year(sale_date)  order by avg(total_sale) desc) as rn
from Sales_Retail
group by year(sale_date),month(sale_date) 
)
select * from cte3
where rn = 1

--  SQL query to find the top 5 customers based on the highest total sales
select top 5 customer_id , sum(total_sale) as total_sales
from Sales_Retail
group by customer_id
order by 2 desc

-- SQL query to find the number of unique customers who purchased items from each category
select category , count( distinct customer_id) as unique_customers
from Sales_Retail
group by category


-- SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with shifts as (
SELECT *,
CASE 
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
    WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END AS time_period
FROM Sales_Retail
)
select time_period ,count(*) as total_orders_per_shift
from shifts
group by time_period
