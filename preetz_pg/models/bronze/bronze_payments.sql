select * from 
{{
    source('postgres_source', 'raw_payments')
}}