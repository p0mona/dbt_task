{{ config(materialized='table') }}

select 
    s.staff_id,
    s.first_name,
    s.last_name,
    s.email,
    s.username,
    s.password,
    s.active,

    a.address_id,
    a.address,
    a.district,

    c.city_id,
    c.city,

    co.country_id,
    co.country,

    a.postal_code,
    a.phone

from {{ ref('stg_staff') }} s
left join {{ ref('stg_address') }} a on a.address_id = s.address_id
left join {{ ref('stg_city') }} c on a.city_id = c.city_id
left join {{ ref('stg_country') }} co on c.country_id = co.country_id
