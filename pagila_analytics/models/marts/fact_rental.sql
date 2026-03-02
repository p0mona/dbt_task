{{ config(materialized='table') }}

select 
    r.rental_id,
    cast(d_rental.full_date as date) as rental_date,
    cast(d_return.full_date as date) as return_date,
    c.customer_id,
    r.staff_id,
    r.address_id,
    f.film_id

from {{ ref('int_rental_facts') }} r
left join {{ ref('dim_film') }} f on f.film_id=r.film_id
left join {{ ref('dim_customer') }} c on c.customer_id=r.customer_id
left join {{ ref('dim_date') }} d_rental on cast(r.rental_date as date) = d_rental.full_date
left join {{ ref('dim_date') }} d_return on cast(r.return_date as date) = d_return.full_date

