
/*
=============================================================
 DDL Scripts :-  Create Tables For Silver Layer
=============================================================
Script Purpose:
    This script creates table for 'Silver' schema after checking if it already exists. 
    If the tables already exists, it is dropped and recreated.
	
WARNING:
    Running this script will drop the tables in 'Silver' shema if it exists. 
    All data in the tables will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

-- =============================================================
---- Creating 'silver.crm_cust_info' Table ----
-- =============================================================

if object_id('silver.crm_cust_info' , 'U') is not null
   drop table silver.crm_cust_info;
create table silver.crm_cust_info(
	cst_id int,
	cst_key varchar(30),
	cst_firstname varchar(30),
	cst_lastname varchar(30),
	cst_marital_status varchar(15),
	cst_gndr varchar(15),
	cst_createdate date,
	dwh_createdate datetime2 default getdate()
);

-- =============================================================
---- Creating 'silver.crm_prd_info' Table ----
-- =============================================================

if object_id('silver.crm_prd_info' , 'U') is not null
   drop table silver.crm_prd_info;
create table silver.crm_prd_info(
	prd_id int,
	cat_id varchar(30),
	prd_key varchar(30),
	prd_nm varchar(50),
	prd_cost int,
	prd_line varchar(15),
	prd_start_dt date,
	prd_end_dt date,
	dwh_createdate datetime2 default getdate()
);

-- =============================================================
---- Creating 'silver.crm_sales_details' Table ----
-- =============================================================

if object_id('silver.crm_sales_details' , 'U') is not null
   drop table silver.crm_sales_details;
create table silver.crm_sales_details(
	sls_ord_num varchar(30),
	sls_prd_key varchar(30),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_createdate datetime2 default getdate()
);
 
 -- =============================================================
---- Creating 'silver.erp_CUST_AZ12' Table ----
-- =============================================================

if object_id('silver.erp_CUST_AZ12' , 'U') is not null
   drop table silver.erp_CUST_AZ12;
create table silver.erp_CUST_AZ12(
	cid varchar(30),
	bdate date,
	gen varchar(10),
	dwh_createdate datetime2 default getdate()
	);

-- =============================================================
---- Creating 'silver.erp_LOC_A101' Table ----
-- =============================================================

if object_id('silver.erp_LOC_A101' , 'U') is not null
   drop table silver.erp_LOC_A101;
create table silver.erp_LOC_A101(
	cid varchar(30),
	cntry varchar(20),
	dwh_createdate datetime2 default getdate()
	);

-- =============================================================
---- Creating 'silver.erp_PX_CAT_G1V2' Table ----
-- =============================================================

if object_id('silver.erp_PX_CAT_G1V2' , 'U') is not null
   drop table silver.erp_PX_CAT_G1V2;
	create table silver.erp_PX_CAT_G1V2(
	id varchar(30),
	cat varchar(30),
	subcat varchar(30),
	maintanance varchar(30),
	dwh_createdate datetime2 default getdate()
);
