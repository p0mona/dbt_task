{{ config(materialized='table') }}

select
    a.first_name,
    a.last_name,
    count(f.film_id) as count
from {{ ref('dim_film') }} f
left join {{ ref('int_film_actor_bridge') }} b on b.film_id = f.film_id
left join {{ ref('dim_actor') }} a on a.actor_id = b.actor_id
where f.category_name = 'Children'
group by  a.first_name, a.last_name
order by count desc
limit 5