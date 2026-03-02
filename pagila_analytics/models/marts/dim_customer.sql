{{ config(materialized='table') }}

select
    customer_id,
    first_name,
    last_name,
    email,
    activebool,
    create_date
from {{ ref('int_customer_enriched') }}