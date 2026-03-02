{{ config(materialized='table') }}

select 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,

    a.address_id,
    a.address,
    a.district,

    ci.city_id,
    ci.city,

    a.postal_code,

    cou.country_id,
    cou.country,

    a.phone,

    c.activebool,
    c.create_date
    
from {{ ref('stg_customer') }} c

left join {{ ref('stg_address') }} a on c.address_id=a.address_id
left join {{ ref('stg_city') }} ci on ci.city_id=a.city_id
left join {{ ref('stg_country') }} cou on cou.country_id=ci.country_id

order by c.customer_id