/*
=============================================================
 DDl Script :-  Load Data into Gold Layer(Silver -> Gold)
                (Creating Views)
=============================================================
Script Purpose:
    This Script loads data into 'Gold' schema from Silver Layer tables.
	It performs the following actions:
	- Drops the Views if they already exists
	- Then create Views for Gold Layer in the data Warehouse.
	- The Gold Layer contains final dimension and fact tables(Star Schema)

    Each View performs transactions and combines data from the Silver
	Layer to produce a clean, enriched and ready to use dataset.
	
Usage :
	These Views can be queried directly for analytics and reporting.

=============================================================
*/

-- =============================================================
---- Creating Customer Dimension ----
-- =============================================================

if object_id('gold.dim_customers' , 'V') is not null
   drop view gold.dim_customers;
go

create view gold.dim_customers as
select
	row_number() over(order by cst_id) as customer_key,
	cst_id as customer_id,
	c.cst_key as customer_number,
	c.cst_firstname as first_name,
	c.cst_lastname as last_name,
	l.cntry as country,
	case when cst_gndr != 'n/a' then cst_gndr
	else coalesce(gen , 'n/a') end as gender,
	c.cst_marital_status as marital_status,
	e.bdate as birth_date,
	 c.cst_createdate as created_date
from silver.crm_cust_info as c
left join silver.erp_CUST_AZ12 as e
on c.cst_key = e.cid
left join silver.erp_LOC_A101 as l
on c.cst_key = l.cid;

go

-- =============================================================
---- Creating Product Dimension ----
-- =============================================================


if object_id('gold.dim_product' , 'V') is not null
   drop view gold.dim_product;
go

create view gold.dim_product as
select
	row_number() over(order by prd_start_dt, prd_id) as product_key,
	prd_id as product_id,
	prd_key as product_num,
	prd_nm as product_name,
	cat_id as category_id,
	cat as category,
	subcat as sub_category,
	maintanance,
	prd_cost as cost,
	prd_line as product_line,
	prd_start_dt as start_date
from silver.crm_prd_info as cp
left join silver.erp_PX_CAT_G1V2 as ep
on cp.cat_id = ep.id
where prd_end_dt is null

go

-- =============================================================
---- Creating Saled Fact ----
-- =============================================================


if object_id('gold.fact_sales' , 'V') is not null
   drop view gold.fact_sales;
go

create view gold.fact_sales as
select
	sls_ord_num as order_number,
	customer_key,
	product_key,
	sls_order_dt as order_date,
	sls_ship_dt as shiping_date,
	sls_due_dt as due_date,
	sls_sales as sales,
	sls_quantity as quantity,
	sls_price as price
from silver.crm_sales_details
left join gold.dim_customers as dc
on sls_cust_id = dc.customer_id
left join gold.dim_product
on sls_prd_key = product_num
