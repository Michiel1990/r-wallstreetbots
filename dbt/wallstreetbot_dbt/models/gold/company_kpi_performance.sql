select
    str_company_ticker
    ,str_company_name
    ,str_company_exchange
    ,str_sp500_sector
    ,dt_fiscal_ending

    ,(current_ratio * 33.33)
    +(quick_ratio * 33.33)
    +(cash_ratio * 33.33)
        as liquidity_score
    
    ,((1 - debt_ratio) * 33.33)
    +((1 - debt_to_equity_ratio) * 33.33)
    +((1 - liabilities_to_equity_ratio) * 33.33)
        as debt_score

    ,((1 - asset_to_equity_ratio) * 33.33)
    ,(book_value_per_share * 33.33)
    ,((1 - price_to_book_ratio) * 33.33)
        as equity_score

from {{ ref('dim_company_health_quarterly') }}