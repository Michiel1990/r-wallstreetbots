{{ config(
    materialized='incremental',
    indexes=[
      {'columns': ['str_company_ticker']}
    ]
) }}

select
	md5(concat("timestamp","ticker")) as str_stock_price_id
	,cast("timestamp" as date) as dt_price
	,"ticker" as str_company_ticker
	,cast("open" as decimal) as dec_open
	,cast("high" as decimal) as dec_high
	,cast("low" as decimal) as dec_low
	,cast("close" as decimal) as dec_close
	,cast("volume" as integer) as int_volume
	,cast("dt" as date) as dt_loaded
from {{ source('alphavantage', 'time_series_daily') }}

{% if is_incremental() %}
	where "ticker" not in (
		select str_company_ticker from {{ this }}
	)
{% endif %}