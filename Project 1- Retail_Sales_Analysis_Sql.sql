CREATE TABLE RetailSales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME(0),
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
    quantiy INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);



-- Insert From Tem to [dbo].[RetailSales] ----------------------
INSERT INTO [dbo].[RetailSales] (
    transactions_id,
    sale_date,
    sale_time,
    customer_id,
    gender,
    age,
    category,
    quantiy,
    price_per_unit,
    cogs,
    total_sale
)
SELECT 
    transactions_id,
    sale_date,
    sale_time,
    customer_id,
    gender,
    age,
    category,
    quantiy,
    price_per_unit,
    cogs,
    total_sale
FROM [dbo].[SQL - Retail Sales Analysis_utf -Tem];


Select * from [dbo].[RetailSales];
select count(*) from [dbo].[RetailSales];

-- To check Null value -----------------------
Select * from [dbo].[RetailSales]
where transactions_id is null;
Select * from [dbo].[RetailSales]
where sale_date is null;
Select * from [dbo].[RetailSales]
where sale_time is null;
Select * from [dbo].[RetailSales]
where
	transactions_id is null
	Or
	sale_date is null
	Or
	sale_time is null
	Or
	customer_id is null
	Or
	gender is null
	Or
	age is null
	Or
	category is null
	Or
	quantiy is null
	Or
	price_per_unit is null
	Or
	cogs is null
	Or
	total_sale is null;

-- Data Exploration

-- How many sales we have?
select count(*) as Sales 
from [dbo].[RetailSales];

-- How many customers we have?

select count(distinct customer_id) as Total_customers
From [dbo].[RetailSales]; 

--- How many category we have?
select distinct category as Total_category
From [dbo].[RetailSales]; 

-- Data Analysis & Busniess key Problems & Answers?

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
Select *
from [dbo].[RetailSales]
where sale_date = '2022-11-05';
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Month is November Category is clothing And Quantity is more than 4


Select
	category,
	sum(quantiy)
from [dbo].[RetailSales]
where category= 'Clothing'
Group By category

Select
	*
from [dbo].[RetailSales]
where category= 'Clothing'
	AND
	FORMAT(sale_date, 'yyyy-MM') = '2022-11'
	And
	quantiy >=4;




-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

Select
	category,
	SUM(total_sale)as [total sale],
	count(*) as total_orders
from [dbo].[RetailSales]
Group By Category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select
	ROUND(avg(age),2) as avg_age
from [dbo].[RetailSales]
where category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select
	transactions_id,
	sum(total_sale) as Sales
from [dbo].[RetailSales]
where total_sale >1000
group by transactions_id;

Select * from [dbo].[RetailSales]
where total_sale >1000;




-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select
	category,
	gender,
	count(*) as total_trans
from [dbo].[RetailSales]
Group
	By
	category,
	gender
Order By category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
Select
	year,
	month,
	avg_sale
From
(
Select
	Year(sale_date) as year,
	month(sale_date) as month,
	Avg(total_sale) as avg_sale,
	Rank() Over(Partition by Year(sale_date) Order by Avg(total_sale) Desc) as rank
From [dbo].[RetailSales]
Group by Year(sale_date),month(sale_date)
) as t1
where rank = 1
Order by Year(sale_date),Avg(total_sale) Desc;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

Select
	top 5
	customer_id,
	sum(total_sale) as total_sales
from [dbo].[RetailSales]
group by customer_id
Order by customer_id;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

Select
	category,
	count(distinct customer_id) as cnt_Unique_cs
from [dbo].[RetailSales]
group by category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
With hourly_sales
As
(
select *,
	Case
		When DATEPART(HOUR, sale_time) < 12 Then 'Morning'
		When DATEPART(HOUR, sale_time) Between 12 And 17 Then 'Afternoon'
		Else 'Evening'
	End as shift
from [dbo].[RetailSales]
)
Select
	shift,
	count(*) as total_orders
from hourly_sales
group by shift
order by total_orders;
Select
DATEPART(HOUR, sale_time)
from [dbo].[RetailSales];
SELECT DATEPART(HOUR, GETDATE()) AS current_hour;
