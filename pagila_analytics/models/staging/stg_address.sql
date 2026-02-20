{{ config(materialized='table') }}

with source as (
    select *
    from pagila.address
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by address_id order by last_update desc) as rn
        from source
    ) t
    where rn = 1
)

select 
    address_id,
    address,
    address2,
    district,
    city_id,
    postal_code,
    phone,
    last_update
from deduped
where address_id is not null 
    and address is not null 
order by address_id