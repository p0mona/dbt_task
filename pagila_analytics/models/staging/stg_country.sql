{{ config(materialized='table') }}

with source as (
    select *
    from pagila.country
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by country_id, country order by last_update desc) as rn
        from source
    ) t
    where rn = 1
)

select 
    country_id,
    country,
    last_update
from deduped
where country_id is not null 
    and country is not null 
order by country_id