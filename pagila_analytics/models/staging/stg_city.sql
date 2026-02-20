{{ config(materialized='table') }}

with source as (
    select *
    from pagila.city
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by city_id order by last_update desc) as rn
        from source
    ) t
    where rn = 1
)

select 
    city_id,
    city,
    country_id,
    last_update    
from deduped
where city_id is not null 
    and city is not null 
    and country_id is not null 
order by city_id