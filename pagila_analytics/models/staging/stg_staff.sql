{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('pagila', 'staff') }}
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by staff_id, username order by last_update desc) as rn
        from source
    ) t
    where rn = 1
)

select 
    staff_id,
    first_name,
    last_name,
    email,
    username,
    password,
    active,
    address_id,
    store_id,
    last_update
from deduped
where staff_id is not null 
    and first_name is not null 
    and last_name is not null 
    and username is not null 
    and password is not null 
    and email is not null 
order by staff_id