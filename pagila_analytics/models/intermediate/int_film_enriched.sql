{{ config(materialized='table') }}

select 
    f.film_id,
    f.title,
    f.release_year,

    c.category_id,
    c.name,

    f.description_text,

    l.language_id,
    l.name as language,

    f.rental_duration,
    f.rental_rate,
    f.length_value,
    f.replacement_cost,
    f.rating,
    f.special_features,
    f.full_text

    
from {{ ref('stg_film') }} f
left join {{ ref('stg_language') }} l on f.language_id = l.language_id
left join {{ ref('stg_film_category') }} fc on fc.film_id = f.film_id
left join {{ ref('stg_category') }} c on fc.category_id = c.category_id

order by f.film_id
