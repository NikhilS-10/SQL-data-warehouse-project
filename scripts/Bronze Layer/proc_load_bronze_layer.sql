/*
=============================================================
 Store Procedure :-  Load Data into Bronze Layer(Source -> Bronze)
=============================================================
Script Purpose:
    This Store Procedure loads data into 'Bronze' schema from external CSV files.
	It performs the following actions:
	- Truncate the tables before loading the data.
	- Uses 'Bulk Load' to load data from CSV files to Bronze Layer tables.
	
Parameters:
	This Store Procedure does not accept any parameters or returns any value.

Usage:
	Example :- exec bronze.load_bronze;
*/


exec bronze.load_bronze;

create or alter procedure bronze.load_bronze as
begin
begin try
	declare @strttime datetime , @endtime datetime , @ovrlstrtime datetime , @ovrlendtime datetime;
	set @ovrlstrtime = getdate();
	print '==================================';
	print 'Loading Bronze Layer';
	print '==================================';

	print 'Loading CRM Tables';
	print '==================================';

	set @strttime = getdate();
    print 'Truncating and Loading Table :- bronze.crm_cust_info';
	truncate table bronze.crm_cust_info;
	bulk insert bronze.crm_cust_info
	from 'C:\Users\Akivna-PC1\Downloads\Project_DWH\source_crm\cust_info.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	)
	set @endtime = getdate();
	print 'Load Duration :-' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';

	print '=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=';
	set @strttime = getdate();
	print 'Truncating and Loading Table :- bronze.crm_prd_info';
	truncate table bronze.crm_prd_info;
	bulk insert bronze.crm_prd_info
	from 'C:\Users\Akivna-PC1\Downloads\Project_DWH\source_crm\prd_info.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	)
	set @endtime = getdate();
	print 'Load Duration :-' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';

	print '=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=';
	set @strttime = getdate();
	print 'Truncating and Loading Table :- bronze.crm_sales_details';
	truncate table bronze.crm_sales_details;
	bulk insert bronze.crm_sales_details
	from 'C:\Users\Akivna-PC1\Downloads\Project_DWH\source_crm\sales_details.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);
	set @endtime = getdate();
	print 'Load Duration :-' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';

	print '==================================';
	print 'Loading ERP Tables'
	print '==================================';
    set @strttime = getdate();
    print 'Truncating and Loading Table :- bronze.erp_CUST_AZ12';
	truncate table bronze.erp_CUST_AZ12;
	bulk insert bronze.erp_CUST_AZ12
	from 'C:\Users\Akivna-PC1\Downloads\Project_DWH\source_erp\CUST_AZ12.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	)
	set @endtime = getdate();
	print 'Load Duration :-' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';


	print '=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-='
	set @strttime = getdate();
    print 'Truncating and Loading Table :- bronze.erp_LOC_A101';
	truncate table bronze.erp_LOC_A101;
	bulk insert bronze.erp_LOC_A101
	from 'C:\Users\Akivna-PC1\Downloads\Project_DWH\source_erp\LOC_A101.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	)
	set @endtime = getdate();
	print 'Load Duration :-' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';

	print '=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-='
	set @strttime = getdate();
    print 'Truncating and Loading Table :- bronze.erp_PX_CAT_G1V2';
	truncate table bronze.erp_PX_CAT_G1V2;
	bulk insert bronze.erp_PX_CAT_G1V2
	from 'C:\Users\Akivna-PC1\Downloads\Project_DWH\source_erp\PX_CAT_G1V2.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	)
	set @endtime = getdate();
	print 'Load Duration :-' + cast(datediff(second , @strttime , @endtime) as nvarchar) + 'Seconds';
	print '=================================='
	set @ovrlendtime = getdate()
	print 'Data loading for the Bronze Layer has been successfully completed.'
	print 'Overall Load Duration :- ' + cast(datediff(second , @ovrlstrtime , @ovrlendtime) as nvarchar) + 'Seconds';
end try
begin catch
	print '==================================';
	print 'Error Occur During Loading Bronze Layer';
	print 'Error Message' + error_message();
	print 'Error Message' + cast(error_number() as nvarchar);
	print 'Error Message' + cast(error_state() as nvarchar);
	print '==================================';
end catch
end

