{{ config(materialized='table') }}

select
    r.rental_id,
    r.rental_date,
    r.return_date,

    c.customer_id,
    c.first_name as customer_name,
    c.last_name as customer_surname,
    c.email as customer_email,

    s.staff_id,
    s.first_name as staff_name,
    s.last_name as staff_surname,
    s.email as staff_email,

    a.address_id,
    a.address,
    a.district,

    ci.city_id,
    ci.city,

    a.postal_code,

    co.country_id,
    co.country,

    f.film_id,
    f.title as film_title,
    f.release_year as film_year,
    f.rental_duration,
    f.rental_rate,

    l.language_id,
    l.name as film_language

from {{ ref('stg_rental') }} r

left join {{ ref('stg_customer') }} c on c.customer_id=r.customer_id
left join {{ ref('stg_staff') }} s on s.staff_id=r.staff_id
left join {{ ref('stg_address') }} a on a.address_id=s.address_id
left join {{ ref('stg_city') }} ci on ci.city_id=a.city_id
left join {{ ref('stg_country') }} co on co.country_id=ci.country_id
left join {{ ref('stg_inventory') }} i on i.inventory_id=r.inventory_id
left join {{ ref('stg_film') }} f on f.film_id=i.film_id
left join {{ ref('stg_language') }} l on l.language_id=f.language_id

order by r.rental_id