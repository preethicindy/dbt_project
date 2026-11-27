select 
id as payment_id, 
order_id,
payment_method,
(amount/100.0)::decimal(16,2) as amount_usd,
case when payment_method = 'coupon' then true else false end as is_coupon
from 
{{ref('bronze_payments')}}
