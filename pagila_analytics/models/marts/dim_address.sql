{{ config(materialized='table') }}

select 
    address_id,
    address,
    district,
    city,
    country,
    postal_code,
    phone

from {{ ref('int_address_enriched') }}