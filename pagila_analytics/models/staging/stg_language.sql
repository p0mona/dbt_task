{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('pagila', 'language') }}
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by language_id, name order by last_update desc) as rn
        from source
    ) t
    where rn = 1
)

select 
    language_id,
    name,
    last_update
from deduped
where language_id is not null 
    and name is not null 
order by language_id