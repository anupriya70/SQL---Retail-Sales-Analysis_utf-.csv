-- SQL Retail Sales Analysis - P1
drop database if exists SQL_Project_p1;
create database SQL_Project_p1;
drop table retail_sales;
CREATE TABLE RETAIL_SALES (
	TRANSACTIONS_ID INT PRIMARY KEY,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(12),
	AGE INT,
	CATEGORY VARCHAR(14),
	QUANTIY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);

SELECT
	*
FROM
RETAIL_SALES;

SELECT
	COUNT(*)
FROM
	RETAIL_SALES;
--Data Cleaning--
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;
--Delete all null  values from table
DELETE FROM RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;
SELECT
	COUNT(*)
FROM
	RETAIL_SALES;
--Data Exploration--
--How many sales we have ?
SELECT
	COUNT(*) AS TOTAL_SALE
FROM
	RETAIL_SALES;
--How many unique customer we have ?
SELECT
	COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_SALE
FROM
	RETAIL_SALES;
--HOw many unique category we have?
SELECT
	COUNT(DISTINCT CATEGORY) AS TOTAL_SALE
FROM
	RETAIL_SALES;
--Data Analysis & Business Key Problem answer--
--- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05';
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
	AND QUANTIY >= 4
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS NET_SALE,
	COUNT(*) AS TOTal_order from retail_sales 
group by 1;
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the '
SELECT
	ROUND(AVG(AGE), 2)
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALE > 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT
	CATEGORY,
	GENDER,
	COUNT(*) AS TOTAL_TRANSACTION
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY,
	GENDER
ORDER BY
	1;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

--End of Project