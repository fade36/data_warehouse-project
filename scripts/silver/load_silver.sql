
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