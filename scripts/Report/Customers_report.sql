/*
=============================================================
Customer Report
=============================================================
Script Purpose:
    This script shows Key customer matrics and behaviour 
    Highlights:
    - Gathers essential columns such as product names , product number , age and transaction details.
    - Segments customer into categories (VIP , Regular , New) and age-groups.
    - Aggregate customer-level matrics.
	   1.total order place.
	   2.total sales.
	   3.total quantity purchased.
	   4.total products purchased.
	   5.lifespan(months between first and last purchase)
    - Calculates valueable KPI's:
	   1.recency (months since last order).
	   2.average order value.
	   3.average monthly spend.

Usage:
    Run these queries to create a view of Customer Report.

-- =============================================================
*/

if object_id('gold.report_customers' , 'V') is not null
   drop view gold.report_customers
go

create view gold.report_customers as
with base_query as(
---==================================
-- Base Query:- Retrieves core columns from table
---==================================
select
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales,
	s.quantity ,
	c.customer_key,
	c.customer_number,
	concat(c.first_name , ' ' ,c.last_name) as customer_name,
	datediff(year , c.birth_date , getdate()) as age
from gold.fact_sales as s
left join gold.dim_customers as c
on c.customer_key = s.customer_key
where order_date is not null
),
---==================================
-- Customer Aggregation Query:- Summarizes key matrics at the customer-level
---==================================
customer_aggregation as(
select 
	customer_key,
	customer_number,
	customer_name,
	age,
	count(distinct order_number) as total_orders,
	count(distinct product_key) as total_products,
	sum(sales) as total_sales,
	sum(quantity) as total_quantity,
	max(order_date) as last_order_date,
	datediff(month, min(order_date) , max(order_date)) as lifespan
	from base_query
	group by customer_number,
	customer_key,
	customer_name,
	age
)
select
	customer_key,
	customer_number,
	customer_name,
	age,
	case 
		when age is null then 'n/a'
		when age > 0 and age < 18 then 'Under 18' 		
		when age between 18 and 30 then '18-30'
		when age between 30 and 40 then '30-40'
		when age between 40 and 50 then '40-50'
		when age > 50 then 'Above 50'
		end as age_group,
	case 
		when lifespan >= 12 and total_sales > 5000 then 'VIP'
		when lifespan >= 12 and total_sales <= 5000 then 'Regular'
		else 'New' end as cst_segment,
	-- Computing time from last order in Months
	datediff(month , last_order_date, getdate()) as recency,
	total_orders,
	total_products,
	total_sales,
	total_quantity,
	lifespan,
	-- Compute Average Order Value (AOV)
	case when total_orders = 0 then 0
		 else total_sales/total_orders end as AOM,
	-- Compute Average Monthly Spend (AMS)
	case when lifespan = 0 then 0
		 else total_sales/lifespan end as AMS
from customer_aggregation

