/*
=============================================================
 SQL EDA Script: Customer, Product, and Sales Insights
=============================================================
Script Purpose:
    This script performs Exploratory Data Analysis (EDA) on customer, product, and sales data. 
    It includes:
    - Aggregating sales by product category and customer.
    - Calculating key metrics like total sales, average price, and sales percentages.
    - Analyzing top/lowest performing products and customers.
    - Exploring sales trends, order dates, and customer demographics.

Usage:
    Run these queries to uncover patterns, trends, and key insights in the sales and customer data.

=============================================================
*/


-- Exploring all objects in database
select * from INFORMATION_SCHEMA.TABLES

=============================================================
-- Exploring all columns in database
select * from INFORMATION_SCHEMA.COLUMNS

=============================================================
-- Exploring all Countries our customer come from
select distinct country from gold.dim_customers

=============================================================
-- Exploring all Categoris we have
select distinct category , sub_category , product_name from gold.dim_product
order by 1,2,3

=============================================================
-- Sales % by Category
SELECT p.category,
	   SUM(s.sales) AS total_sales,
       format((SUM(s.sales) * 1.0 / (select sum(sales) from gold.fact_sales) * 100),'N2')   as sales_percentage
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_product AS p
    ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC

=============================================================
-- Find date of first order and last order
-- And how many years of orders are available
select min(order_date) as first_order_date,
	   max(order_date) as last_order_date,
	   datediff(year,min(order_date),max(order_date)) as order_range_years
from gold.fact_sales

=============================================================
-- Find youngest and oldest customer
select DATEDIFF(year, min(birth_date) , getdate()) as oldest_customer,
DATEDIFF(year, max(birth_date) , getdate()) as youngest_customer
from gold.dim_customers

=============================================================
-- Find the total sales
select sum(sales) as total_sales from gold.fact_sales

=============================================================
-- Find how many items are sold
select sum(quantity) as total_quantity  from gold.fact_sales

=============================================================
-- Find average seeling price 
select avg(sales) as avg_selling_price from gold.fact_sales

=============================================================
-- Find total number of orders
select count(distinct order_number) as total_orders from gold.fact_sales

=============================================================
-- Find total number of products
select count(product_key) as total_products from gold.dim_product

=============================================================
-- Find total number of customers
select count(customer_key) as total_customer from gold.dim_customers

=============================================================
-- Find number of customer that has placed an order
select count(distinct customer_key) total_customer from gold.fact_sales

=============================================================
-- Generate a report that shows all the key matrics of buisness
select 'Total Sales' as Measure_Name, sum(sales) as Measure_Value from gold.fact_sales
union all
select 'Total Quantity' as Measure_Name, sum(quantity) as Measure_Value from gold.fact_sales
union all
select 'Avg Selling Price' as Measure_Name, avg(sales) as Measure_Value from gold.fact_sales
union all
select 'Total Orders' as Measure_Name, count(distinct order_number) as Measure_Value from gold.fact_sales
union all
select 'Total Products' as Measure_Name, count(product_key) as Measure_Value from gold.dim_product
union all
select 'Total Customer' as Measure_Name, count(customer_key) as Measure_Value from gold.dim_customers
union all
select 'Total Sales Last Year' AS Measure_Name, SUM(sales) AS Measure_Value from gold.fact_sales 
where year(order_date) = (select year(max(order_date)) from gold.fact_sales)
union all
select 'Total Sales Last Month' AS Measure_Name, SUM(sales) AS Measure_Value from gold.fact_sales 
where year(order_date) = (select year(max(order_date)) from gold.fact_sales)
and month(order_date) = (select month(max(order_date)) from gold.fact_sales)

=============================================================
-- Top 5 Higest Revenue generating Products
select top 5 
p.product_name , 
sum(s.sales) as total_sales 
from gold.fact_sales as s 
left join gold.dim_product as p
on p.product_key = s.product_key
group by product_name
order by total_sales desc

-- Another way for solving this
select * 
from(
select row_number() over(order by sum(sales) desc)as rank,
p.product_name ,
sum(sales) as total_sales 
from gold.fact_sales as s 
left join gold.dim_product as p
on p.product_key = s.product_key
group by product_name 
)t 
where rank <=5

=============================================================
-- Top 5 Lowest Revenue generating Products
select top 5 p.product_name , sum(s.sales) as total_sales from gold.fact_sales as s 
left join gold.dim_product as p
on p.product_key = s.product_key
group by product_name
order by total_sales

=============================================================
-- Top 10 Higest Revenue generating Customers
select * 
from(
select row_number() over(order by sum(sales) desc)as rank,
c.customer_number,
c.first_name +' ' + c.last_name as full_name,
sum(sales) as total_sales 
from gold.fact_sales as s 
left join gold.dim_customers as c
on c.customer_key = s.customer_key
group by c.first_name , c.last_name,customer_number
)t 
where rank <=10

=============================================================
-- Top 5 Lowest Revenue generating Customers
select * 
from(
select row_number() over(order by sum(sales))as rank,
c.customer_number,
c.first_name +' ' + c.last_name as full_name,
sum(sales) as total_sales 
from gold.fact_sales as s 
left join gold.dim_customers as c
on c.customer_key = s.customer_key
group by c.first_name , c.last_name,customer_number
)t 
where rank <=5
=============================================================
