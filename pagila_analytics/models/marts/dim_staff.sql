{{ config(materialized='table') }}

select 
    staff_id,
    first_name,
    last_name,
    email,
    active,
    address,
    district,
    city,
    country,
    postal_code,
    phone

from {{ ref('int_staff_enriched') }} 