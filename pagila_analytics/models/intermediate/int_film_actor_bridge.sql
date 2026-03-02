{{ config(materialized='table') }}

select 
    f.film_id,
    f.title,
    f.release_year,

    a.actor_id,
    a.last_name as actor_name,
    a.first_name as actor_surname,

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
    
from {{ ref('stg_film_actor') }} fa

left join {{ ref('stg_film') }} f on fa.film_id=f.film_id
left join {{ ref('stg_actor') }} a on fa.actor_id=a.actor_id
left join {{ ref('stg_language') }} l on l.language_id=f.language_id

order by fa.film_id