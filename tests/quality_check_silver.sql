/*
===============================================================================
quality checks
===============================================================================
script purpose:
    this script performs various quality checks for data consistency, accuracy,
    and standardization across the silver layer. it includes checks for:
    - null or duplicate primary keys.
    - unwanted spaces in string fields.
    - data standardization and consistency.
    - invalid date ranges and orders.
    - data consistency between related fields.

usage notes:
    - run these checks after loading the silver layer.
    - investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

use DataWarehouse;

-- ====================================================================
-- checking silver_crm_cust_info
-- ====================================================================

-- check for nulls or duplicates in primary key
-- expectation: no results
select
    cst_id,
    count(*)
from silver_crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null or cst_id = "";

-- check for unwanted spaces
-- expectation: no results
select
    cst_key
from silver_crm_cust_info
where cst_key <> trim(cst_key);

-- ====================================================================
-- checking silver_crm_prd_info
-- ====================================================================

-- check for nulls or duplicates in primary key
-- expectation: no results
select
    prd_id,
    count(*)
from silver_crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null or prd_id = "";

-- check for unwanted spaces
-- expectation: no results
select
    prd_nm
from silver_crm_prd_info
where prd_nm <> trim(prd_nm);

-- check for nulls or negative values in cost
-- expectation: no results
select
    prd_cost
from silver_crm_prd_info
where cast(prd_cost as signed) < 0 or prd_cost is null or prd_cost = "";

-- check for invalid date orders (start date > end date)
-- expectation: no results
select *
from silver_crm_prd_info
where cast(prd_end_dt as signed) < cast(prd_start_dt as signed);


-- ====================================================================
-- checking silver_crm_sales_details
-- ====================================================================

-- check for invalid dates in bronze
-- expectation: no invalid dates
select
    sls_due_dt
from bronze_crm_sales_details
where sls_due_dt is not null
  and sls_due_dt <> ''
  and (
      char_length(sls_due_dt) <> 8
      or sls_due_dt = '0'
      or sls_due_dt > '20500101'
      or sls_due_dt < '19000101'
      or str_to_date(sls_due_dt, '%Y%m%d') is null
  );

-- check for invalid date orders (order date > shipping/due dates)
-- expectation: no results
select *
from silver_crm_sales_details
where cast(sls_order_dt as signed) > cast(sls_ship_dt as signed)
   or cast(sls_order_dt as signed) > cast(sls_due_dt as signed);

-- check data consistency: sales = quantity * price
-- expectation: no results
select distinct
    sls_sales,
    sls_quantity,
    sls_price
from silver_crm_sales_details
where cast(sls_sales as signed) <> cast(sls_quantity as signed) * cast(sls_price as signed)
   or sls_sales is null
   or sls_sales = ""
   or sls_quantity is null
   or sls_quantity = ""
   or sls_price is null
   or sls_price = ""
   or cast(sls_sales as signed) <= 0
   or cast(sls_quantity as signed) <= 0
   or cast(sls_price as signed) <= 0
order by sls_sales, sls_quantity, sls_price;


-- ====================================================================
-- checking silver_erp_cust_az12
-- ====================================================================

-- identify out-of-range birthdates
-- expectation: birthdates between 1900-01-01 and today
select distinct
    BDATE
from silver_erp_cust_az12
where BDATE < '1900-01-01'
   or BDATE > curdate();


-- ====================================================================
-- checking silver_erp_loc_a101
-- ====================================================================

select distinct
    CNTRY
from silver_erp_loc_a101
order by CNTRY;


-- ====================================================================
-- checking silver_erp_px_cat_g1v2
-- ====================================================================

-- check for unwanted spaces
-- expectation: no results
select *
from silver_erp_px_cat_g1v2
where CAT <> trim(CAT)
   or SUBCAT <> trim(SUBCAT)
   or MAINTENANCE <> trim(MAINTENANCE);
