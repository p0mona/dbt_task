{{ config(materialized='table') }}

select 
    f.category_name,
    round(avg(datediff(day, r.rental_date, r.return_date))) as avg_of_days,
    sum(datediff(day, r.rental_date, r.return_date)) as count_of_days
    
from {{ ref('dim_film') }} f
left join {{ ref('fact_rental') }} r on r.film_id=f.film_id
group by f.category_name