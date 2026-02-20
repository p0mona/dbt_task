{{ config(materialized='table') }}

with source as (
    select *
    from pagila.payment
),

deduped as (
    select *
    from (
        select *,
            row_number() over (partition by payment_id order by payment_date desc) as rn
        from source
    ) t
    where rn = 1 
)

select 
    amount,
    staff_id,
    rental_id,
    payment_id,
    customer_id,
    payment_date,
from deduped
where payment_id is not null 
    and amount is not null 
    and customer_id is not null
    and payment_date is not null
order by payment_id