{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('pagila', 'category') }}
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by category_id order by last_update desc) as rn
        from source
    ) t
    where rn = 1
)

select 
    category_id,
    name,
    last_update    
from deduped
where category_id is not null 
    and name is not null 
order by category_id