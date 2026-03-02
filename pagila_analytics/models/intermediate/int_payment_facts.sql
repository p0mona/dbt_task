{{ config(materialized='table') }}

select 
    p.payment_id,
    p.amount,
    cast(p.payment_date as date) as payment_date,
    
    p.staff_id,
    s.first_name as staff_name,
    s.last_name as staff_surname,
    s.email as staff_email,
    s.address_id as staff_address_id,

    a.address as staff_address,
    a.district as staff_district,
    a.city_id as staff_city_id,
    city.city as staff_city,
    a.postal_code as staff_postal_code,
    city.country_id as staff_country_id,
    cou.country as staff_country,
    a.phone as staff_phone,

    p.rental_id,
    r.rental_date,
    r.return_date,
    f.rental_duration,

    f.film_id,
    f.title as film_title,
    f.release_year,
    
    r.customer_id,
    c.first_name as customer_name,
    c.last_name as customer_surname,
    c.email as customer_email,

    ad.address_id as customer_address_id,
    ad.address as customer_address,
    ad.district as customer_district,
    ad.city_id as customer_city_id,
    city.city as customer_city,
    ad.postal_code as customer_postal_code,
    city.country_id as customer_country_id,
    cou.country as customer_country,
    ad.phone as customer_phone


from {{ ref('stg_payment') }} p
left join {{ ref('stg_staff') }} s on p.staff_id=s.staff_id
left join {{ ref('stg_address') }} a on s.address_id=a.address_id
left join {{ ref('stg_city') }} city on a.city_id=city.city_id
left join {{ ref('stg_country') }} cou on cou.country_id=city.country_id
left join {{ ref('stg_rental') }} r on r.rental_id=p.rental_id
left join {{ ref('stg_inventory') }} i on i.inventory_id=r.inventory_id
left join {{ ref('stg_film') }} f on i.film_id=f.film_id
left join {{ ref('stg_customer') }} c on c.customer_id=r.customer_id
left join {{ ref('stg_address') }} ad on ad.address_id=c.address_id
left join {{ ref('stg_city') }} city_ad on ad.city_id=city_ad.city_id
left join {{ ref('stg_country') }} cou_ad on cou_ad.country_id=city_ad.country_id

order by p.payment_id