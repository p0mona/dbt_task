{{ config(materialized='table') }}

select 
    p.payment_id,
    p.amount,
    s.staff_id,
    p.staff_address_id,
    f.film_id,
    c.customer_id,
    p.customer_address_id

from {{ ref('int_payment_facts') }} p
left join {{ ref('dim_staff') }} s on s.staff_id = p.staff_id
left join {{ ref('dim_address') }} staff_a on staff_a.address_id = p.staff_address_id
left join {{ ref('dim_film') }} f on f.film_id = p.film_id
left join {{ ref('dim_customer') }} c on c.customer_id = p.customer_id
left join {{ ref('dim_address') }} c_a on c_a.address_id = p.customer_address_id