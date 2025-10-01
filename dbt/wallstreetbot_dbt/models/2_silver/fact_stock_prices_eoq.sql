-- taking into account the longest NYSE closure was 4 days (9/11), 
-- we can safely say a -2/+2 day window should ALWAYS return a stock price
with cte_window_functions as (
	select
		d.str_company_ticker
		,d.date_day
		,d.quarter_end_date
		,sp.dec_close
		,lag(sp.dec_close,1) 
			over (partition by d.str_company_ticker 
				  order by d.date_day asc)
			as dec_close_min_1
		,lag(sp.dec_close,2) 
			over (partition by d.str_company_ticker 
				  order by d.date_day asc)
			as dec_close_min_2
		,lead(sp.dec_close,1) 
			over (partition by d.str_company_ticker 
				  order by d.date_day asc)
			as dec_close_plus_1
		,lead(sp.dec_close,2) 
			over (partition by d.str_company_ticker 
				  order by d.date_day asc)
			as dec_close_plus_2
	from {{ ref('dim_dates') }} d
	left join {{ ref('fact_stock_prices') }} sp
		on d.str_company_ticker = sp.str_company_ticker
		and d.date_day = sp.dt_price
	)
select
	str_company_ticker
	,quarter_end_date
	,coalesce(dec_close,dec_close_min_1,dec_close_plus_1,dec_close_min_2,dec_close_plus_2)
		as quarterly_close
from cte_window_functions
where date_day = quarter_end_date