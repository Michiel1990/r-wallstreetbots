with cte_companies_with_data as (
  select 
    str_company_ticker
    ,min(dt_price) as earliest_dt_price
  from {{ ref('fact_stock_prices') }}
  group by str_company_ticker
)

select
  c.str_company_ticker
  ,d.date_day
  ,d.quarter_end_date
from cte_companies_with_data c
left join {{ ref('dbt_get_dates') }} d
  on c.earliest_dt_price <= d.date_day
  and d.date_day <= current_date