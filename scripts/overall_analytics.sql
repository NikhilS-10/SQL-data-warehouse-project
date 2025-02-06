/*
=============================================================
 SQL Analysis Script :- Customer(Dimension), Product(Dimension), and Sales(Fact) Insights
=============================================================
Script Purpose:
    This script provides analytical queries for customer, product, and sales data.
    It includes:
    - Aggregating sales by product, region, and customer.
    - Calculating total and average sales, trends, and top performers.
    - Analyzing product categories, return rates, and purchase frequencies.

    These queries offer insights for business intelligence and reporting.

Usage:
    Execute these queries to analyze sales performance and customer behaviors.

=============================================================
*/


---==================================
-- 1. Total Sales by Product
-- Find the total sales (sum of sales amount) for each product in the dataset.
---==================================

select
p.product_name , sum(s.sales) as total_sales
from gold.fact_sales as s
left join gold.dim_product as p
on s.product_key = p.product_key
group by p.product_name
order by sum(s.sales) desc


---==================================
-- 2.Top 5 Products by Total Sales
-- Identify the top 5 products with the highest total sales.
---==================================

select top 5
p.product_name , sum(s.sales) as total_sales
from gold.fact_sales as s
left join gold.dim_product as p
on s.product_key = p.product_key
group by p.product_name
order by sum(s.sales) desc


---==================================
-- 3.Average Sale per Customer
-- Calculate the average sales amount per customer.
---==================================


select first_name + ' ' + last_name as full_name , avg(sales) as avg_sales
from gold.fact_sales as s
left join gold.dim_customers as c
on s.customer_key = c.customer_key
group by first_name , last_name
order by avg_sales desc


---==================================
-- 4.Sales by Region
-- If there’s a region column in your customer data, calculate the total sales by region..
---==================================

select country , sum(sales) as total_sales ,avg(sales) as avg_sales 
from gold.fact_sales as s
left join gold.dim_customers as c
on s.customer_key = c.customer_key
group by country
order by total_sales desc


---==================================
-- 5. Customer Purchase Frequency
-- Find out how many times each customer has made a purchase.
---==================================

select customer_id , count(s.order_number) as total_orders , count(distinct s.order_number) as total_distinct_orders
from gold.fact_sales as s
left join gold.dim_customers as c
on s.customer_key = c.customer_key
group by customer_id
order by total_orders desc 



---==================================
-- 6.Sales Trend Over Time
-- Calculate total sales for each month in the dataset. This assumes you have a order_date column.
---==================================

select month(order_date) as month_num ,year(order_date) as years, sum(sales) as total_sales
from gold.fact_sales
group by year(order_date) , month(order_date)
order by years desc , month_num desc


---==================================
-- 7. Customer's Most Frequently Purchased Product
-- For each customer, determine which product they have bought the most.
---==================================

select first_name + ' ' + last_name as full_name ,product_name , count(product_name) as order_count
from gold.fact_sales as s
left join gold.dim_customers as c
on s.customer_key = c.customer_key
left join gold.dim_product as p
on s.product_key = p.product_key
group by first_name , last_name , product_name
order by order_count desc


---==================================
-- 8. Sales by Product Category
-- If you have a product category column, calculate total sales per category.
---==================================


select
p.category , sum(s.sales) as total_sales
from gold.fact_sales as s
left join gold.dim_product as p
on s.product_key = p.product_key
group by p.category
order by sum(s.sales) desc



---==================================
-- 9. Top Customers by Total Spend
-- Find the top 10 customers who have spent the most money.
---==================================

select top 10
customer_id,
first_name + ' ' + last_name as full_name , sum(sales) as total_sales
from gold.fact_sales as s
left join gold.dim_customers as c
on s.customer_key = c.customer_key
group by customer_id , first_name , last_name
order by total_sales desc


---==================================
-- 10. Sales by Product Category and Sub-Catergory
-- If you have a product category and sub-category column, calculate total sales per category.
---==================================

select
p.category, sub_category , sum(s.sales) as total_sales
from gold.fact_sales as s
left join gold.dim_product as p
on s.product_key = p.product_key
group by p.category , sub_category
order by category
