select
  c.str_company_ticker
  ,d.date_day
  ,d.quarter_end_date
from {{ ref('dim_companies') }} c
  ,{{ ref('dbt_get_dates') }} d