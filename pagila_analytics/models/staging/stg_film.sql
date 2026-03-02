{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('pagila', 'film') }}
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by film_id, release_year order by last_update desc) as rn
        from source
    ) t
    where rn = 1 
)

select 
    film_id,
    title,
    description as description_text,
    release_year,
    language_id,
    rental_duration,
    rental_rate,
    length as length_value,
    replacement_cost,
    rating,
    last_update,
    special_features,
    fulltext as full_text
from deduped
where film_id is not null 
    and title is not null 
    and release_year is not null
order by film_id