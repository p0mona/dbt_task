{{ config(materialized='table') }}

with source as (
    select *
    from pagila.film_category
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by film_id order by last_update desc) as rn
        from source
    ) t
    where rn = 1
)

select 
    film_id,
    category_id,
    last_update    
from deduped
where film_id is not null 
    and category_id is not null 
order by film_id