{{ config(materialized='table') }}

with source as (
    select *
    from pagila.inventory
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by inventory_id order by last_update desc) as rn
        from source
    ) t
    where rn = 1 
)

select 
    inventory_id,
    film_id,
    store_id,
    last_update
from deduped
where inventory_id is not null 
    and film_id is not null 
    and store_id is not null
order by inventory_id