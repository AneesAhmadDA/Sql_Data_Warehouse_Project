/*
****************************************************************************
DDL SCRIPT FOR BRONZE LAYER CREATION(TABLES & STORED PROCEDURE)
****************************************************************************
SCRIPT PURPOSE:
THIS SCRIT CREATES TABLES FOR BRONZE LAYERS THEN DATA IS INSERTED 
TO EACH TABLE USING THE STORED PROCEDURE bronze.load_bronze 
SO RUNNING THIS SCRIPT WILL RESULT IN CREATION AND INSERTION OF THE DATA INTO 
THE TABLES IN THE BRONZE SCHEMA.
*/


--Building Bronze layer
--1) this is for CRM tables
if OBJECT_ID('Bronze.crm_cust_info','U') IS NOT NULL
    DROP TABLE Bronze.crm_cust_info
Create TABLE Bronze.crm_cust_info(
    cst_id int,
    cst_key NVARCHAR(50),
    cst_first_name NVARCHAR(50),
    cst_last_name NVARCHAR(50),
    cst_material_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date date,
)

if OBJECT_ID('Bronze.crm_prd_info','U') IS NOT NULL
    DROP TABLE Bronze.crm_prd_info
create TABLE Bronze.crm_prd_info(
    prd_id int,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(100),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
)

if OBJECT_ID('Bronze.crm_sales_details','U') IS NOT NULL
    DROP TABLE Bronze.crm_sales_details
CREATE TABLE Bronze.crm_sales_details(
    sls_ord_num VARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
)
--2)this is for ERP tables 

if OBJECT_ID('Bronze.erp_loc_A101','U') IS NOT NULL
    DROP TABLE Bronze.erp_loc_A101
create TABLE Bronze.erp_loc_A101(
    CID NVARCHAR(50)    ,
    CNTRY NVARCHAR(50)
)

if OBJECT_ID('Bronze.erp_cust_AZ12','U') IS NOT NULL
    DROP TABLE Bronze.erp_cust_AZ12
CREATE TABLE Bronze.erp_cust_AZ12(
        CID NVARCHAR(50),
        BDATE DATE,
        GEN NVARCHAR(50)
)

if OBJECT_ID('Bronze.erp_px_cat_g1v2','U') IS NOT NULL
    DROP TABLE Bronze.erp_px_cat_g1v2
CREATE TABLE Bronze.erp_px_cat_g1v2(
    ID NVARCHAR(50),
    CAT NVARCHAR(50),
    SUBCAT NVARCHAR(50),
    MAINTENANCE NVARCHAR(50)
)


drop TABLE IF EXISTS [Bronze].[cust_info]

--cheching if all tables exist now or not 
select * from bronze.crm_cust_info
select * from bronze.crm_prd_info
select * from bronze.crm_sales_details
select * from bronze.erp_loc_A101
select * from bronze.erp_cust_AZ12
select * from bronze.erp_px_cat_g1v2
GO
--creating the stored Procedure
 create or alter Procedure bronze.load_bronze As
	Declare @Start_time_bronze datetime, @End_time_bronze datetime
	set @Start_time_bronze=GETDATE()
	BEGIN
		DECLARE @Start_time datetime, @End_time datetime
		BEGIN TRY
			PRINT '=========================================';
			PRINT 'Loading Bronze Layer';
			PRINT '=========================================';
			PRINT '-----------------------------------------';
			PRINT 'Loading CRM Tables '
			PRINT '-----------------------------------------';
			--Loading the data(Full load method(truncate & insert)) into Bronze layer tables
			--1) for custinfo tables
			set @Start_time=GETDATE()
			PRINT '>> Truncating Table:Bronze.crm_cust_info'
			TRUNCATE TABLE Bronze.crm_cust_info
			PRINT '>> Inserting Data Into:Bronze.crm_cust_info'
			BULK INSERT Bronze.crm_cust_info
			FROM 'C:\Users\pc\OneDrive\Documents\UdemyDAcourse\SQL by Data WIth Baraa\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			WITH
			(
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				tablock
			);
			set @End_time=GETDATE()
			PRINT'<< Load Duration :' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+ ' Seconds'
			PRINT'*****************************************************************'
			--2) for prd_info tables
			set @Start_time=GETDATE()
			PRINT '>> Truncating Table:Bronze.crm_prd_info'
			TRUNCATE TABLE Bronze.crm_prd_info
			PRINT '>> Inserting Data Into:Bronze.crm_prd_info'
			BULK INSERT Bronze.crm_prd_info
			FROM 'C:\Users\pc\OneDrive\Documents\UdemyDAcourse\SQL by Data WIth Baraa\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			WITH
			(
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				tablock
			);
			set @End_time=GETDATE()
			PRINT'<< Load Duration :' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+ ' Seconds'
			PRINT'*****************************************************************'

			--3) for sales details tables
			set @Start_time=GETDATE()
			PRINT '>> Truncating Table:Bronze.crm_sales_details '
			TRUNCATE TABLE Bronze.crm_sales_details 
			PRINT '>> Inserting Data Into:Bronze.crm_sales_details'
			BULK INSERT Bronze.crm_sales_details
			FROM 'C:\Users\pc\OneDrive\Documents\UdemyDAcourse\SQL by Data WIth Baraa\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			WITH
			(
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				tablock
			);
			set @End_time=GETDATE()
			PRINT'<< Load Duration :' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+ ' Seconds'
			PRINT'*****************************************************************'

			PRINT '-----------------------------------------';
			PRINT 'Loading ERP Tables '
			PRINT '-----------------------------------------';
			--4) for erp_loc_A101 tables
			set @Start_time=GETDATE()
			PRINT '>> Truncating Table:Bronze.erp_loc_A101'
			TRUNCATE TABLE Bronze.erp_loc_A101
			PRINT '>> Inserting Data Into:Bronze.erp_loc_A101'
			bulk insert Bronze.erp_loc_A101
			FROM 'C:\Users\pc\OneDrive\Documents\UdemyDAcourse\SQL by Data WIth Baraa\sql-data-warehouse-project\datasets\source_erp\loc_A101.csv'
			with(
				firstrow = 2,
				fieldterminator = ',',
				tablock 
			)
			set @End_time=GETDATE()
			PRINT'<< Load Duration :' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+ ' Seconds'
			PRINT'*****************************************************************'

			--5) for erp_cust_AZ12 tables
			set @Start_time=GETDATE()
			PRINT '>> Truncating Table:Bronze.erp_cust_AZ12'
			TRUNCATE TABLE Bronze.erp_cust_AZ12
			PRINT '>> Inserting Data Into:Bronze.erp_cust_AZ12'
			bulk insert Bronze.erp_cust_AZ12
			from 'C:\Users\pc\OneDrive\Documents\UdemyDAcourse\SQL by Data WIth Baraa\sql-data-warehouse-project\datasets\source_erp\cust_AZ12.csv'
			with(
				firstrow = 2,
				fieldterminator = ',',
				tablock
			)
			set @End_time=GETDATE()
			PRINT'<< Load Duration :' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+ ' Seconds'
			PRINT'*****************************************************************'

			--6) for erp_px_cat_g1v2 tables
			set @Start_time=GETDATE()
			PRINT '>> Truncating Table:Bronze.erp_px_cat_g1v2'
			TRUNCATE TABLE Bronze.erp_px_cat_g1v2
			PRINT '>> Inserting Data Into:Bronze.erp_px_cat_g1v2'
			bulk insert Bronze.erp_px_cat_g1v2
			from 'C:\Users\pc\OneDrive\Documents\UdemyDAcourse\SQL by Data WIth Baraa\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
			with(
				firstrow = 2,
				fieldterminator = ',',
				tablock
			)
			set @End_time=GETDATE()
			PRINT'<< Load Duration :' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+ ' Seconds'
			PRINT'*****************************************************************'

		END TRY
		BEGIN CATCH 
			PRINT '=========================================='
			PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
			PRINT 'ERROR MASSAGE' + ERROR_MESSAGE();
			PRINT 'ERROR MASSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
			PRINT 'ERROR MASSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
			PRINT '=========================================='

		END CATCH
	set @End_time_bronze=GETDATE()
	PRINT'******************LOADING COMPLETED**************************'
	PRINT'<< TOTAL BRONZE LOAD Duration '+ CAST(DATEDIFF(SECOND,@Start_time_bronze,@End_time_bronze) as Nvarchar)+ ' Seconds'
	END
--Checking overall loading and tables & stored Procdure
exec Bronze.load_bronze
