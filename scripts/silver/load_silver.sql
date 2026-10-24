
insert into silver_crm_cust_info(cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
select cst_id,
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
 
