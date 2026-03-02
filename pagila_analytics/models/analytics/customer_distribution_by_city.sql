{{ config(materialized='table') }}

select 
    a.city,
    count(r.customer_id) as count_of_customers

from {{ ref('fact_revenue') }} r
left join {{ ref('dim_address') }} a on a.address_id=r.customer_address_id
group by city