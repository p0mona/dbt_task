{{ config(materialized='table') }}

select
    film_id,
    title,
    release_year,
    description_text,
    language,
    name as category_name,
    rental_duration,
    rental_rate,
    length_value,
    replacement_cost,
    rating,
    special_features,
    full_text
from {{ ref('int_film_enriched') }}