with cte_window_functions as (
    select
        str_company_ticker
        ,quarter_end_date
        ,quarterly_close
        ,lag(quarterly_close,1) 
            over (partition by str_company_ticker 
                    order by quarter_end_date asc)
            as quarterly_close_min_1
        ,lag(quarterly_close,4) 
            over (partition by str_company_ticker 
                    order by quarter_end_date asc)
            as quarterly_close_min_4
    from {{ ref('fact_stock_prices_eoq') }}
)

select
    str_company_ticker
    ,quarter_end_date
    ,quarterly_close
    ,(quarterly_close - quarterly_close_min_1)
        / quarterly_close
        as increase_qoq
    ,(quarterly_close - quarterly_close_min_4)
        / quarterly_close
        as increase_yoy
from cte_window_functions