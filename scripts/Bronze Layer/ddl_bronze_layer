/*
=============================================================
 DDL Scripts :-  Create Tables For Bronze Layer
=============================================================
Script Purpose:
    This script creates table for 'Bronze' schema after checking if it already exists. 
    If the tables already exists, it is dropped and recreated.
	
WARNING:
    Running this script will drop the tables in 'Bronze' shema if it exists. 
    All data in the tables will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/



if object_id('bronze.crm_cust_info' , 'U') is not null
   drop table bronze.crm_cust_info;
create table bronze.crm_cust_info(
	cst_id int,
	cst_key varchar(30),
	cst_firstname varchar(30),
	cst_lastname varchar(30),
	cst_marital_status varchar(5),
	cst_gndr varchar(5),
	cst_createdate date
);

if object_id('bronze.crm_prd_info' , 'U') is not null
   drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(
	prd_id int,
	prd_key varchar(30),
	prd_nm varchar(50),
	prd_cost int,
	prd_line varchar(15),
	prd_start_dt date,
	prd_end_dt date
);

if object_id('bronze.crm_sales_details' , 'U') is not null
   drop table bronze.crm_sales_details;
create table bronze.crm_sales_details(
	sls_ord_num varchar(30),
	sls_prd_key varchar(30),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);
 

if object_id('bronze.erp_CUST_AZ12' , 'U') is not null
   drop table bronze.erp_CUST_AZ12;
create table bronze.erp_CUST_AZ12(
cid varchar(30),
bdate date,
gen varchar(10)
);

if object_id('bronze.erp_LOC_A101' , 'U') is not null
   drop table bronze.erp_LOC_A101;
create table bronze.erp_LOC_A101(
cid varchar(30),
cntry varchar(20)
);

if object_id('bronze.erp_PX_CAT_G1V2' , 'U') is not null
   drop table bronze.erp_PX_CAT_G1V2;
create table bronze.erp_PX_CAT_G1V2(
id varchar(30),
cat varchar(30),
subcat varchar(30),
maintanance varchar(30)
);

