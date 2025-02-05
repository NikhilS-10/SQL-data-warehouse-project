/*
=============================================================
 Store Procedure :-  Load Data into Silver Layer(Bronze -> Siver)
=============================================================
Script Purpose:
    This Store Procedure loads data into 'Silver' schema from Bronze Layer tables.
	It performs the following actions:
	- Truncate the tables before loading the data.
	- Uses 'Bulk Load' to load data from Bronze Layer tables to Silver Layer tables.
	
Parameters:
	This Store Procedure does not accept any parameters or returns any value.

Usage:
	Example :- exec silver.load_silver;
*/
exec silver.load_silver;

create or alter procedure silver.load_silver as
begin
begin try
	declare @strttime datetime , @endtime datetime , @ovrlstrtime datetime , @ovrlendtime datetime;
	set @ovrlstrtime = getdate();
	print '==================================';
	print 'Loading Silver Layer';
	print '==================================';

	print 'Loading CRM Tables';
	print '==================================';

	set @strttime = getdate();
    print 'Truncating and Loading Table :- silver.crm_cust_info';

	truncate table silver.crm_cust_info;
	insert into silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_createdate
	)
	select cst_id,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	case upper(trim(cst_marital_status))
	when 'S' then 'Single'
	when 'M' then 'Married'
	else 'n/a' end as cst_marital_status,
	case upper(trim(cst_gndr))
	when 'F' then 'Female'
	when 'M' then 'Male'
	else 'n/a' end as cst_gndr,
	cst_createdate
	from(
	select *,
	row_number() over(partition by cst_id order by cst_createdate desc) as flag
	from bronze.crm_cust_info )t
	where flag = 1


	set @endtime = getdate();
	print 'Load Duration :- ' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';

	print '=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=';
	set @strttime = getdate();
	print 'Truncating and Loading Table :- silver.crm_prd_info';

	truncate table silver.crm_prd_info;
	insert into silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)
	select prd_id,
	substring(prd_key , 1 , 5) as cat_id,
	substring(prd_key , 7 , len(prd_key) ) as prd_key,
	trim(prd_nm) as prd_nm,
	isnull(prd_cost , 0) as prd_cost,
	case upper(trim(prd_line))
	when 'R' then 'Road'
	when 'S' then 'Other Sales'
	when 'M' then 'Mountain'
	when 'T' then 'Touring'
	else 'n/a' end as prd_line,
	prd_start_dt,
	DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_nm ORDER BY prd_start_dt)) as prd_end_dt
	from bronze.crm_prd_info

	set @endtime = getdate();
	print 'Load Duration :- ' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';

	print '=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=';
	set @strttime = getdate();
	print 'Truncating and Loading Table :- silver.crm_sales_details';

	truncate table silver.crm_sales_details;
	insert into silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)
	select sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	case when sls_order_dt = 0 or len(sls_order_dt) != 8 then null
	else cast(cast(sls_order_dt as nvarchar)as date) end as sls_order_dt,
	case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then null
	else cast(cast(sls_ship_dt as nvarchar)as date) end as sls_ship_dt,
	case when sls_due_dt = 0 or len(sls_due_dt) != 8 then null
	else cast(cast(sls_due_dt as nvarchar)as date) end as sls_due_dt,
	case when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price) 
	then sls_quantity * abs(sls_price)
	else sls_sales end as sls_sales,
	sls_quantity,
	case when sls_price is null or sls_price <= 0
	then sls_sales / nullif(sls_quantity,0)
	else sls_price end as sls_price
	from bronze.crm_sales_details

	set @endtime = getdate();
	print 'Load Duration :- ' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';

	print '==================================';
	print 'Loading ERP Tables'
	print '==================================';
    set @strttime = getdate();
    print 'Truncating and Loading Table :- silver.erp_CUST_AZ12';

	truncate table silver.erp_CUST_AZ12;
	insert into silver.erp_CUST_AZ12(cid , bdate , gen)
	select
	case when cid like 'NAS%' then substring(cid ,4, len(cid))
	else cid end as cid,
	case when bdate > getdate() then null
	else bdate end as bdate,
	case when upper(trim(gen)) in('F' , 'Female' , 'f' , 'female') then 'Female'
	when upper(trim(gen)) in('M' , 'Male' , 'm' , 'male') then 'Male' 
	else 'n/a' end as gen
	from bronze.erp_CUST_AZ12

	set @endtime = getdate();
	print 'Load Duration :- ' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';


	print '=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-='
	set @strttime = getdate();
    print 'Truncating and Loading Table :- silver.erp_LOC_A101';

	truncate table silver.erp_LOC_A101;
	insert into silver.erp_LOC_A101(cid , cntry)
	select replace(cid , '-' , '') as cid,
	case when upper(trim(cntry)) in ('US' , 'United States' , 'USA') then 'United States'
	when upper(trim(cntry)) in ('DE' , 'Germany') then 'Germany'
	when upper(trim(cntry)) = '' or cntry is null then 'n/a'
	else trim(cntry) end as cntry
	from bronze.erp_LOC_A101

	set @endtime = getdate();
	print 'Load Duration :- ' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';

	print '=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-='
	set @strttime = getdate();
    print 'Truncating and Loading Table :- silver.erp_PX_CAT_G1V2';

	truncate table silver.erp_PX_CAT_G1V2;
	insert into silver.erp_PX_CAT_G1V2(id , cat , subcat , maintanance)
	select replace(id , '_' , '-') as id,
	trim(cat) as cat,
	trim(subcat) as subcat,
	trim(maintanance)  as maintanance
	from bronze.erp_PX_CAT_G1V2

set @endtime = getdate();
	print 'Load Duration :- ' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';
	print '=================================='
	set @ovrlendtime = getdate()
	print 'Data loading for the Silver Layer has been successfully completed.'
	print 'Overall Load Duration :- ' + cast(datediff(second , @ovrlstrtime , @ovrlendtime) as nvarchar) + 'Seconds';
end try
begin catch
	print '==================================';
	print 'Error Occur During Loading Silver Layer';
	print 'Error Message' + error_message();
	print 'Error Message' + cast(error_number() as nvarchar);
	print 'Error Message' + cast(error_state() as nvarchar);
	print '==================================';
end catch
end
