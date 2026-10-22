-- vim: set filetype=sql:

/*===============================================================================
Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
This script loads data from external CSV files into the Bronze layer.
It performs the following actions:
- Truncates the Bronze tables before loading new data.
- Uses LOAD DATA LOCAL INFILE to import data from CSV files into MySQL tables.
*/

USE DataWarehouse;

TRUNCATE TABLE bronze_crm_cust_info;

LOAD DATA LOCAL INFILE '/Users/timofiy_filipenko/Documents/sql/data_warehouse/data/crm/cust_info.csv'
INTO TABLE bronze_crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


TRUNCATE TABLE bronze_crm_prd_info;

LOAD DATA LOCAL INFILE '/Users/timofiy_filipenko/Documents/sql/data_warehouse/data/crm/prd_info.csv'
INTO TABLE bronze_crm_prd_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


TRUNCATE TABLE bronze_crm_sales_details;

LOAD DATA LOCAL INFILE '/Users/timofiy_filipenko/Documents/sql/data_warehouse/data/crm/sales_details.csv'
INTO TABLE bronze_crm_sales_details
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


TRUNCATE TABLE bronze_erp_cust_az12;

LOAD DATA LOCAL INFILE '/Users/timofiy_filipenko/Documents/sql/data_warehouse/data/erp/CUST_AZ12.csv'
INTO TABLE bronze_erp_cust_az12
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


TRUNCATE TABLE bronze_erp_loc_a101;

LOAD DATA LOCAL INFILE '/Users/timofiy_filipenko/Documents/sql/data_warehouse/data/erp/LOC_A101.csv'
INTO TABLE bronze_erp_loc_a101
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


TRUNCATE TABLE bronze_erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE '/Users/timofiy_filipenko/Documents/sql/data_warehouse/data/erp/PX_CAT_G1V2.csv'
INTO TABLE bronze_erp_px_cat_g1v2
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;