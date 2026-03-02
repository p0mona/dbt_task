{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('pagila', 'customer') }}
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by customer_id, email order by last_update desc) as rn
        from source
    ) t
    where rn = 1 
)

select 
    customer_id,
    store_id,
    first_name,
    last_name,
    email,
    address_id,
    activebool,
    create_date,
    last_update,
    active  
from deduped
where customer_id is not null 
    and first_name is not null 
    and last_name is not null 
    and email is not null
    and activebool is not null
order by customer_id