{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('pagila', 'film_actor') }}
)

select 
    film_id,
    actor_id,
    last_update
from source
where film_id is not null 
    and actor_id is not null
order by film_id