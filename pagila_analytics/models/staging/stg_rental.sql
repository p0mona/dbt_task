{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('pagila', 'rental') }}
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by rental_id, rental_date order by last_update desc) as rn
        from source
    ) t
    where rn = 1 
)

select 
    rental_id,
    rental_date,
    inventory_id,
    customer_id,
    return_date, 
    staff_id,
    last_update
from deduped
where rental_id is not null 
    and rental_date is not null 
    and customer_id is not null
    and inventory_id is not null
order by rental_id