/*
 ===============================================================================
 DDL Script: Create Bronze Tables
 ===============================================================================
 Purpose:
 Create Bronze tables in the DataWarehouse database.
 Drop existing tables before recreating them.
 ===============================================================================
 */
USE DataWarehouse;
DROP TABLE IF EXISTS bronze_crm_cust_info;
create table bronze_crm_cust_info (
    cst_id int,
    cst_key varchar(50),
    cst_firstname varchar(50),
    cst_lastname varchar(50),
    cst_marital_status varchar(50),
    -- Use a wider data type in the Bronze layer to accommodate unexpected values
    cst_gndr varchar(50),
    cst_create_date date
);
DROP TABLE IF EXISTS bronze_crm_prd_info;
create table bronze_crm_prd_info (
    prd_id int,
    prd_key varchar(50),
    prd_nm varchar(100),
    prd_cost int,
    prd_line varchar(50),
    prd_start_dt date,
    prd_end_dt date
);
DROP TABLE IF EXISTS bronze_crm_sales_details;
create table bronze_crm_sales_details (
    sls_ord_num varchar(50),
    sls_prd_key varchar(50),
    sls_cust_id int,
    sls_order_dt int,
    sls_ship_dt int,
    sls_due_dt int,
    sls_sales int,
    sls_quantity int,
    sls_price int
);
DROP TABLE IF EXISTS bronze_erp_cust_az12;
create table bronze_erp_cust_az12 (
    CID varchar(50),
    BDATE date,
    GEN varchar(50)
);
DROP TABLE IF EXISTS bronze_erp_loc_a101;
create table bronze_erp_loc_a101 (CID varchar(50), CNTRY varchar(50));
DROP TABLE IF EXISTS bronze_erp_px_cat_g1v2;
create table bronze_erp_px_cat_g1v2 (
    ID varchar(50),
    CAT varchar(50),
    SUBCAT varchar(50),
    MAINTENANCE varchar(50)
);