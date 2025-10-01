{{ config(
    post_hook="GRANT SELECT ON {{ this }} TO loader;",
) }}

select
	ls."symbol" as str_company_ticker
	,ls."name" as str_company_name
	,ls."exchange" as str_company_exchange
	,ls."assetType" as str_asset_type
	,cast(ls."ipoDate" as date) as dt_ipo
	,case 	when ls."status" = 'Active' 
			then true else false
			end as bl_active
	,case 	when sp.symbol is not null
			then true else false
			end as bl_sp500
	,sp.sector as str_sp500_sector
	,cast(ls."dt" as date) as dt_loaded
	,case 	when ls."symbol" in (
				select distinct "ticker" from {{ source('alphavantage', 'time_series_daily') }}
                )
			then false else true
			end as bl_data_missing_at_dt_min_one
from {{ source('alphavantage', 'listing_status') }} ls
left join {{ source('alphavantage', 'sp500_tickers') }} sp
	on ls."symbol" = sp.symbol