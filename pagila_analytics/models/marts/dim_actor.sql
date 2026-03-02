{{ config(materialized='table') }}

select
    actor_id,
    last_name,
    first_name
from {{ ref('stg_actor') }}
order by actor_id