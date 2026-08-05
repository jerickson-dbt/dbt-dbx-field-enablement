{{
    config(
        materialized = 'table',
    )
}}

with

base_dates as (
    {{
        dbt.date_spine(
            'day',
            "DATE('2024-01-01')",
            "DATE('2027-01-01')"
        )
    }}
),

final as (
    select
        cast(date_day as date) as date_day
    from base_dates
)

select *
from final
where date_day > dateadd(year, -5, current_date())  -- Keep recent dates only
  and date_day < dateadd(day, 30, current_date())