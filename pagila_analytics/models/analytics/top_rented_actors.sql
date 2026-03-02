{{ config(materialized='table') }}

select
    a.first_name,
    a.last_name,
    count(f.rental_id) as count
from {{ ref('fact_rental') }} f
left join {{ ref('int_film_actor_bridge') }} b on f.film_id = b.film_id
left join {{ ref('dim_actor') }} a on a.actor_id = b.actor_id
group by a.first_name, a.last_name
order by count desc
limit 5