with customer_info as (select 
id as customer_id, 
(first_name || ' ' || last_name) as full_name from 
{{ ref('bronze_customers')}}
), order_details as (
    select cust.customer_id, cust.full_name, 
    min(order_date) as first_order_date,
    max(order_date) as most_recent_order_date,
    count(ord.order_id) as number_of_orders, 
    sum(case when is_returned then 0 else ord.total_amount end) as lifetime_value,
    case when count(ord.order_id) = 1 then 'new' 
         when count(ord.order_id) > 1 then 'returning' 
         when count(ord.order_id) = 0 then 'no_orders' end as customer_type
    from customer_info cust
    left join {{ref('silver_orders')}} ord
    on ord.customer_id = cust.customer_id 
    group by cust.customer_id, cust.full_name
    order by cust.full_name ) 
select *
from order_details