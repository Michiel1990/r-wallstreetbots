select
*
from {{ source('alphavantage', 'listing_status') }}