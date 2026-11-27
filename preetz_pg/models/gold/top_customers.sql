with cust_by_lifetime as (select 
*,
rank() over (order by lifetime_value desc) as rnk
from 
{{
    ref('silver_customers')
}}
where customer_type !='no_orders'
)
select * from cust_by_lifetime 
where rnk <= 10