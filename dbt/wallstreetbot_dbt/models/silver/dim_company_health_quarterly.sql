select
-- company dimensions:
	b.str_company_ticker
	,c.str_company_name
	,c.str_company_exchange
	,c.str_sp500_sector
	,b.dt_fiscal_ending

-- higher is better KPIs:
	,b.int_total_current_assets / b.int_total_current_liabilities
		as current_ratio
		-- Measures short-term liquidity, ability to cover obligations

	,(b.int_total_current_assets - coalesce(b.int_inventory,0) )
		/ b.int_total_current_liabilities
		as quick_ratio
		-- Measures liquidity, focusing on most liquid assets

	,b.int_cash_and_cash_equivalents_at_carrying_value / b.int_total_current_liabilities
		as cash_ratio
		-- Assesses immediate liquidity for obligational coverage

	,b.int_total_shareholder_equity / b.int_common_stock_shares_outstanding
		as book_value_per_share
		-- Measures the net asset value of the company attributable to each share.
	
-- lower is better KPIs:
	,b.int_total_liabilities / b.int_total_assets
		as debt_ratio
		-- Indicates proportion of assets financed by liabilities

	,b.int_short_long_term_debt_total / b.int_total_shareholder_equity
		as debt_to_equity_ratio
		-- Assesses leverage and capital structure

	,b.int_total_liabilities / b.int_total_shareholder_equity
		as liabilities_to_equity_ratio
		-- Assesses leverage and capital structure

	,b.int_total_assets / b.int_total_shareholder_equity
		as asset_to_equity_ratio
		-- Shows how much of the company’s assets are financed by shareholders versus creditors.
	
	,sp.quarterly_close
		/ (b.int_total_shareholder_equity / b.int_common_stock_shares_outstanding)
		as price_to_book_ratio
		-- Measures how the market values the company's net assets.

from {{ ref('dim_balance_sheets_quarterly') }} b
left join {{ ref('dim_companies') }} c
	on b.str_company_ticker = c.str_company_ticker
left join {{ ref('fact_stock_prices_eoq') }} sp
	on b.str_company_ticker = sp.str_company_ticker
	and b.dt_fiscal_ending = sp.quarter_end_date

-- NetIncome would be a nice addition for EPS and P/E ratios