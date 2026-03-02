{{ config(materialized='table') }}

with dates as (
    select dateadd(day, seq4(), '2022-01-01') as full_date
    from table(generator(rowcount => 365))
)

select
    row_number() over (order by full_date) as date_sk,
    to_number(to_char(full_date,'YYYYMMDD')) as date_id,
    full_date,
    year(full_date) as year,
    quarter(full_date) as quarter,
    month(full_date) as month,
    to_char(full_date,'Month') as month_name,
    day(full_date) as day,
    dayofweek(full_date) as day_of_week,
    to_char(full_date,'Day') as day_name,
    case when dayofweek(full_date) in (1,7) then true else false end as is_weekend
from dates
order by full_date