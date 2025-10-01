select
	md5(concat("fiscalDateEnding","ticker")) as str_balance_sheet_id
	,"ticker" as str_company_ticker
	,cast("fiscalDateEnding" as date) as dt_fiscal_ending
	,"reportedCurrency" as str_reported_currency
	,cast(nullif("totalAssets",'None') as float) as int_total_assets
	,cast(nullif("totalCurrentAssets",'None') as float) as int_total_Current_Assets
	,cast(nullif("cashAndCashEquivalentsAtCarryingValue",'None') as float) as int_cash_And_Cash_Equivalents_At_Carrying_Value
	,cast(nullif("cashAndShortTermInvestments",'None') as float) as int_cash_And_Short_Term_Investments
	,cast(nullif("inventory",'None') as float) as int_inventory
	,cast(nullif("currentNetReceivables",'None') as float) as int_current_Net_Receivables
	,cast(nullif("totalNonCurrentAssets",'None') as float) as int_total_Non_Current_Assets
	,cast(nullif("propertyPlantEquipment",'None') as float) as int_property_Plant_Equipment
	,cast(nullif("accumulatedDepreciationAmortizationPPE",'None') as float) as int_accumulated_Depreciation_Amortization_PPE
	,cast(nullif("intangibleAssets",'None') as float) as int_intangible_Assets
	,cast(nullif("intangibleAssetsExcludingGoodwill",'None') as float) as int_intangible_Assets_Excluding_Goodwill
	,cast(nullif("goodwill",'None') as float) as int_goodwill
	,cast(nullif("investments",'None') as float) as int_investments
	,cast(nullif("longTermInvestments",'None') as float) as int_long_Term_Investments
	,cast(nullif("shortTermInvestments",'None') as float) as int_short_Term_Investments
	,cast(nullif("otherCurrentAssets",'None') as float) as int_other_Current_Assets
	,cast(nullif("otherNonCurrentAssets",'None') as float) as int_other_Non_Current_Assets
	,cast(nullif("totalLiabilities",'None') as float) as int_total_Liabilities
	,cast(nullif("totalCurrentLiabilities",'None') as float) as int_total_Current_Liabilities
	,cast(nullif("currentAccountsPayable",'None') as float) as int_current_Accounts_Payable
	,cast(nullif("deferredRevenue",'None') as float) as int_deferred_Revenue
	,cast(nullif("currentDebt",'None') as float) as int_current_Debt
	,cast(nullif("shortTermDebt",'None') as float) as int_short_Term_Debt
	,cast(nullif("totalNonCurrentLiabilities",'None') as float) as int_total_Non_Current_Liabilities
	,cast(nullif("capitalLeaseObligations",'None') as float) as int_capital_Lease_Obligations
	,cast(nullif("longTermDebt",'None') as float) as int_long_Term_Debt
	,cast(nullif("currentLongTermDebt",'None') as float) as int_current_Long_Term_Debt
	,cast(nullif("longTermDebtNoncurrent",'None') as float) as int_long_Term_Debt_Noncurrent
	,cast(nullif("shortLongTermDebtTotal",'None') as float) as int_short_Long_Term_Debt_Total
	,cast(nullif("otherCurrentLiabilities",'None') as float) as int_other_Current_Liabilities
	,cast(nullif("otherNonCurrentLiabilities",'None') as float) as int_other_Non_Current_Liabilities
	,cast(nullif("totalShareholderEquity",'None') as float) as int_total_Shareholder_Equity
	,cast(nullif("treasuryStock",'None') as float) as int_treasury_Stock
	,cast(nullif("retainedEarnings",'None') as float) as int_retained_Earnings
	,cast(nullif("commonStock",'None') as float) as int_common_Stock
	,cast(nullif("commonStockSharesOutstanding",'None') as float) as int_common_Stock_Shares_Outstanding
from {{ source('alphavantage', 'balance_sheet_quarterly') }}
