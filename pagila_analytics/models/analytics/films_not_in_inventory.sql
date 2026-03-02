{{ config(materialized='table') }}

select 
    f.title
    
from {{ ref('dim_film') }} f
left join {{ ref('int_inventory_enriched') }} i on f.film_id = i.film_id
where i.inventory_id is null