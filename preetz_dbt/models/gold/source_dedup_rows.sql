with dedup as (
SELECT 
*, 
row_number() over(partition by item_id order by updated_at desc) as row_number
from {{ source('source', 'items')}}
)

select * from dedup
where row_number = 1