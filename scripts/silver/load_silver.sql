/*
script purpose:
this script cleans and transforms data from the bronze
layer and loads it into the silver layer tables.

transformations include:
- removing duplicate customer records
- trimming whitespace and standardizing text values
- handling missing and invalid values
- converting data types
- standardizing customer gender, marital status, and country names
- validating dates and correcting sales data
- transforming product keys and deriving product end dates
*/


truncate table silver_crm_cust_info;

insert into silver_crm_cust_info(cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
select 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
case
when upper(trim(cst_marital_status)) = "S" then "Single"
when upper(trim(cst_marital_status)) = "M" then "Married"
else "n/a"
end as cst_marital_status,
case
when upper(trim(cst_gndr)) = "F" then "Female"
when upper(trim(cst_gndr)) = "M" then "Male"
else "n/a"
end as cst_gndr,
cst_create_date
from
	(select *,
		row_number() over(partition by cst_id order by cst_create_date desc) as flag_list
		from bronze_crm_cust_info
		where cst_id is not null and TRIM(cst_id) <> "") as t 
where flag_list = 1;


truncate table silver_crm_prd_info;

insert into silver_crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
select
    prd_id,
    replace(substring(prd_key, 1, 5), '-', '_') as cat_id,
    substring(prd_key, 7, char_length(prd_key)) as prd_key,
    prd_nm,
    if(prd_cost is null or prd_cost = "", 0, prd_cost) as prd_cost,
    case
        when upper(trim(prd_line)) = 'M' then 'Mountain'
        when upper(trim(prd_line)) = 'R' then 'Road'
        when upper(trim(prd_line)) = 'S' then 'Other Sales'
        when upper(trim(prd_line)) = 'T' then 'Touring'
        else 'n/a'
    end as prd_line,
    cast(prd_start_dt as date) as prd_start_dt,
    date_sub(
        lead(prd_start_dt) over (
            partition by prd_key
            order by prd_start_dt
        ),
        interval 1 DAY
    ) as prd_end_dt
from bronze_crm_prd_info;


truncate table silver_crm_sales_details;

insert into silver_crm_sales_details (
    sls_ord_num, sls_prd_key, sls_cust_id,
    sls_order_dt, sls_ship_dt, sls_due_dt,
    sls_sales, sls_quantity, sls_price
)
select
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    case
        when sls_order_dt is null or sls_order_dt = "" or sls_order_dt = "0" or char_length(sls_order_dt) <> 8
        then null
        else str_to_date(sls_order_dt, '%Y%m%d')
    end as sls_order_dt,
    case
        when sls_ship_dt is null or sls_ship_dt = "" or sls_ship_dt = "0" or char_length(sls_ship_dt) <> 8
        then null
        else str_to_date(sls_ship_dt, '%Y%m%d')
    end as sls_ship_dt,
    case
        when sls_due_dt is null or sls_due_dt = "" or sls_due_dt = "0" or char_length(sls_due_dt) <> 8
        then null
        else str_to_date(sls_due_dt, '%Y%m%d')
    end as sls_due_dt,
    case
    when nullif(trim(sls_sales), '') is null
        or cast(nullif(trim(sls_sales), '') as signed) <= 0
        or cast(nullif(trim(sls_sales), '') as signed)
            <> cast(nullif(trim(sls_quantity), '') as signed)
            * abs(cast(nullif(trim(sls_price), '') as signed))
    then cast(nullif(trim(sls_quantity), '') as signed)
         * abs(cast(nullif(trim(sls_price), '') as signed))
    else cast(nullif(trim(sls_sales), '') as signed)
end as sls_sales,

cast(nullif(trim(sls_quantity), '') as signed) as sls_quantity,

case
    when nullif(trim(sls_price), '') is null
        or cast(nullif(trim(sls_price), '') as signed) <= 0
    then cast(nullif(trim(sls_sales), '') as signed)
         / nullif(cast(nullif(trim(sls_quantity), '') as signed), 0)
    else cast(nullif(trim(sls_price), '') as signed)
end as sls_price
from bronze_crm_sales_details;


truncate table silver_erp_cust_az12;

insert into silver_erp_cust_az12(CID,BDATE,GEN)
select 
case 
when CID like "NAS%" then substring(CID, 4, length(CID))
else CID
end as CID,
if(BDATE > curdate(), NULL, BDATE) as BDATE,
case 
	when upper(trim(GEN)) in ("MALE","M") then "Male"
	when upper(trim(GEN)) in ("FEMALE","F") then "Female"
	else "n/a"
end as GEN
from bronze_erp_cust_az12;


truncate table silver_erp_loc_a101;

insert into silver_erp_loc_a101(CID,CNTRY)
select 
replace(CID, "-", "_") as CID,
case 
	when trim(CNTRY) in ("US", "USA") then "United States"
	when trim(CNTRY) = "DE" then "Germany"
	when trim(CNTRY) = "" then "n/a"
	else trim(CNTRY)
end as CNTRY 
from bronze_erp_loc_a101;


truncate table silver_erp_px_cat_g1v2;

insert into silver_erp_px_cat_g1v2(ID,CAT,SUBCAT,MAINTENANCE)
select 
ID,CAT,SUBCAT,MAINTENANCE
from bronze_erp_px_cat_g1v2;


