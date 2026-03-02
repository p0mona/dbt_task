{{ config(materialized='table') }}

select 
    i.inventory_id,
    i.film_id,

    i.store_id,
    s.address_id as store_address_id,
    a.address as store_address,
    a.district as store_district,
    a.city_id as store_city_id,
    city.city as store_city,
    a.postal_code as store_postal_code,
    city.country_id as store_country_id,
    co.country as store_country,
    a.phone as store_phone,

    s.manager_staff_id,
    st.first_name as staff_name,
    st.last_name as staff_surname,
    st.email as staff_email,
    ad.address_id as staff_address_id,
    ad.address as staff_address,
    ad.district as staff_district,
    ad.city_id as staff_city_id,
    ci.city as staff_city,
    ad.postal_code as staff_postal_code,
    ci.country_id as staff_country_id,
    cou.country as staff_country,
    ad.phone as staff_phone
    
from {{ ref('stg_inventory') }} i
left join {{ ref('stg_store') }} s on i.store_id = s.store_id
left join {{ ref('stg_address') }} a on a.address_id = s.address_id
left join {{ ref('stg_city') }} city on city.city_id = a.city_id
left join {{ ref('stg_country') }} co on co.country_id = city.country_id
left join {{ ref('stg_staff') }} st on st.staff_id = s.manager_staff_id

left join {{ ref('stg_address') }} ad on ad.address_id = st.address_id
left join {{ ref('stg_city') }} ci on ci.city_id = ad.city_id
left join {{ ref('stg_country') }} cou on cou.country_id = ci.country_id

order by i.inventory_id