{{ config(materialized='table') }}

with source as (
    select *
    from pagila.actor
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by actor_id order by last_update desc) as rn
        from source
    ) t
    where rn = 1
)

select 
    actor_id,
    last_name,
    first_name,
    last_update
from deduped
where actor_id is not null 
    and last_name is not null 
    and first_name is not null 
order by actor_id