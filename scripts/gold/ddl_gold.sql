/*
ddl script: create gold views

script purpose:
this script creates views for the gold layer of the data warehouse.
the gold layer represents the final dimension and fact views organized
according to the star schema.

each view combines and transforms data from the silver layer to provide
clean, enriched, and business-ready datasets for analytics and reporting.

views created:
- gold_dim_customers: combines customer information from crm and erp sources,
including customer details, birthdates, gender, and country.
- gold_dim_products: combines product information with category details
and includes only current products.
- gold_fact_sales: combines sales transactions with customer and product
dimensions to provide sales metrics and related keys.
*/


use DataWarehouse;

-- creating dimensions

drop view if exists gold_dim_customers;

create view gold_dim_customers as
select
row_number() over (order by cst_id)                     as customer_key,
ci.cst_id												as customer_id,
ci.cst_key												as customer_number,
ci.cst_firstname										as firstname,
ci.cst_lastname											as lastname,
az.bdate												as birthdate,
case 
	when ci.cst_gndr != "n/a" then ci.cst_gndr
	else if(az.gen is null,"n/a",az.gen)
end														as gender,
loc.cntry												as country,
ci.cst_marital_status									as marital_status,
ci.cst_create_date										as create_date
from silver_crm_cust_info ci 
left join silver_erp_cust_az12 az on ci.cst_key = az.cid
left join silver_erp_loc_a101 loc on loc.cid = ci.cst_key;


drop view if exists gold_dim_products;

create view gold_dim_products as
select
row_number() over (order by prd_start_dt, prd_key)      as product_key,
prd_id													as product_id,
prd_key													as product_number,
prd_nm													as product_name,
cat_id													as category_id,
CAT														as category,
SUBCAT													as subcategory,
MAINTENANCE												as maintenance,
prd_cost												as product_cost,
prd_line												as product_line,
prd_start_dt											as start_date
from silver_crm_prd_info prd 
left join silver_erp_px_cat_g1v2 g1v2 
on g1v2.id = prd.cat_id
where prd.prd_end_dt is null; -- filter current products

-- creating facts

drop view if exists gold_fact_sales;

create view gold_fact_sales as
select
    sd.sls_ord_num  							as order_number,
    pr.product_key  							as product_key,
    cu.customer_key 							as customer_key,
    sd.sls_order_dt 							as order_date,
    sd.sls_ship_dt  							as shipping_date,
    sd.sls_due_dt   							as due_date,
    sd.sls_sales    							as sales_amount,
    sd.sls_quantity 							as quantity,
    sd.sls_price    							as price
from silver_crm_sales_details sd
left join gold_dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold_dim_customers cu
on sd.sls_cust_id = cu.customer_id;