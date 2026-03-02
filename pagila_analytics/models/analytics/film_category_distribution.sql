{{ config(materialized='table') }}

select
    category_name,
    count(film_id) as count_of_films
from {{ ref('dim_film') }}
group by category_name