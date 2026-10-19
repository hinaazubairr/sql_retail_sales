-- SQL Retail Sales Analysis - P1

-- STEP#1 : DROP THE TABLE IF EXISTS
DROP TABLE IF EXISTS retail_sales;

-- STEP#2: CREATE THE TABLE 'retail_sales' from dataset columns names.
CREATE TABLE retail_sales 
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),	 
	quantiy INT,
	price_per_unit FLOAT,
	cogs	FLOAT,
	total_sale FLOAT
	);

SELECT * FROM retail_sales;

SELECT * FROM retail_sales
limit 10;

SELECT COUNT(*) FROM retail_sales

-- DATA CLEANING
select * from retail_sales 
WHERE transactions_ID IS NULL 


SELECT * from retail_sales 
WHERE 
	transactions_id IS NULL 
	or 	sale_date IS NULL 
	OR	sale_time IS NULL 
	OR gender IS NULL 
	OR category IS NULL 
	OR quantiy IS NULL 
	OR cogs IS NULL 
	OR total_sale IS NULL; 

DELETE FROM retail_sales 
WHERE 
	transactions_id IS NULL 
	or 	sale_date IS NULL 
	OR	sale_time IS NULL 
	OR gender IS NULL 
	OR category IS NULL 
	OR quantiy IS NULL 
	OR cogs IS NULL 
	OR total_sale IS NULL; 


--DATA EXPLORATION

--HOW MANY SALES WE HAVE / HOW MANY RECORDS WE HAVE
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- HOW MANY CUSTOMERS WE HAVE
SELECT COUNT(customer_id) AS total_customers FROM retail_sales;

	-- HOW MANY UNIQUE CUSTOMERS WE HAVE
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

	-- HOW MANY CATEGORIES WE HAVE
SELECT COUNT(DISTINCT category) AS total_categories FROM retail_sales;

	-- HOW MANY CATEGORIES NAMES WE HAVE
SELECT DISTINCT category AS total_categories_names FROM retail_sales;


--Data Analysis & Business Key problems & Answers:
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';
-- when I run this code, then it gives me all the sales which made on this specific date.
--It shows 11 sales.



-- Q.2 Write a SQL query to retrieve all transactions 
-- where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing' 
	AND
	TO_CHAR(sale_date,'YYYY-MM')='2022-11'
	AND
	quantiy >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 	SUM(total_sale) AS total_sale, category
FROM retail_sales
GROUP BY category;

-- if i need total orders as well: then i write
SELECT 	SUM(total_sale) AS total_sale, category, count(*) as total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	ROUND(AVG(age),2) AS avg_age
FROM retail_sales
where category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
	*
FROM retail_sales
where total_sale >1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) 
--made by each gender in each category.
SELECT 
	category,gender, count(*)
FROM retail_sales
group by category,gender
order by 1 -- that is how the data is going to be organized by the category name


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year, month, avg_sale from
(
	SELECT 
		EXTRACT (YEAR FROM sale_date) as year,
		EXTRACT (MONTH FROM sale_date) as month,
		AVG (total_sale) AS avg_sale,
		rank() over (partition by EXTRACT (YEAR FROM sale_date) order by AVG (total_sale) desc )
	FROM retail_sales
	group by 1,2
) as t1
where rank=1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 


SELECT 
	customer_id, 
	sum(total_sale ) as total_sales
FROM retail_sales
group by 1
order by 2 desc
limit 5



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	count(distinct customer_id), 
	category
FROM retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders 
--(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT 
	*
FROM retail_sales

--common table expression-CTE
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT ( HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT ( HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
select 
	shift,
	count(*) as total_orders  from hourly_sale
group by shift

--end of project
