{{ config(materialized='table') }}

with source as (
    select *
    from pagila.store
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by store_id, address_id order by last_update desc) as rn
        from source
    ) t
    where rn = 1
)

select 
    store_id,
    address_id,
    manager_staff_id,
    last_update
from deduped
where store_id is not null 
    and address_id is not null 
order by store_id