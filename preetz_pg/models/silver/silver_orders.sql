with joined_query as (select 
ord.id as order_id, 
pay.payment_id as payment_id,
ord.user_id as customer_id, 
ord.order_date,
ord.status, 
pay.payment_method,
pay.amount_usd as amount,
case when ord.status = 'returned' then true 
     when ord.status = 'return_pending' then true 
     else false end as is_returned
from {{ref('bronze_orders')}} ord
left join {{ ref('silver_payments')}} pay
on ord.id = pay.order_id 
) 
select order_id, customer_id,
order_date, status, is_returned,
sum(case when payment_method='credit_card' then amount else 0 end) as credit_card_amount,
sum(case when payment_method='bank_transfer' then amount else 0 end) as bank_transfer_amount,
sum(case when payment_method='coupon' then amount else 0 end) as coupon_amount,
sum(case when payment_method='gift_card' then amount else 0 end) as gift_card_amount,
coalesce(sum(amount), 0) as total_amount
from joined_query
group by order_id, customer_id, order_date, status, is_returned  