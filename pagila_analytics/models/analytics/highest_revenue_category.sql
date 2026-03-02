{{ config(materialized='table') }}

select
    f.category_name,
    sum(amount) as amount
    
from {{ ref('fact_revenue') }} r
left join {{ ref('dim_film') }} f on r.film_id = f.film_id
group by f.category_name
order by amount desc
limit 1