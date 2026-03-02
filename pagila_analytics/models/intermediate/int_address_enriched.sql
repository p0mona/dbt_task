{{ config(materialized='table') }}

select 
    a.address_id,
    a.address,
    a.district,

    c.city_id,
    c.city,

    co.country_id,
    co.country,

    a.postal_code,
    a.phone

from {{ ref('stg_address') }} a
left join {{ ref('stg_city') }} c on a.city_id = c.city_id
left join {{ ref('stg_country') }} co on co.country_id = c.country_id