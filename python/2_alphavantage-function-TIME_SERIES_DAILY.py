from dotenv import load_dotenv
import os
import requests
import pandas as pd
from io import StringIO
import csv
from pathlib import Path
from datetime import date
from sqlalchemy import create_engine, text


# read the .env file to fetch the secrets
load_dotenv()
API_KEY = os.getenv("ALPHAVANTAGE_API_KEY")
POSTGRESQL_LOADER_PWD = os.getenv("POSTGRESQL_LOADER_PWD")

# define the connection to the PostgreSQL database
username = "loader"
password = POSTGRESQL_LOADER_PWD
host = "localhost"
port = "5432"
db_name = "wallstreetbots_dwh"

# create the SQLalchemy - PostgreSQL engine
connection_string = f"postgresql+psycopg2://{username}:{password}@{host}:{port}/{db_name}"
engine = create_engine(connection_string)

# Fetch the next 12 companies to fetch data from and store in a list
query_tickers = """
    select "symbol" as ticker from rawalphavantage.listing_status
    where "symbol" in ('MSFT','GOOGL','AMZN');
"""
df_tickers = pd.read_sql(query_tickers, engine)
tickers = df_tickers['ticker'].tolist()
tickers = ['MSFT', 'GOOGL', 'AMZN']

# several variables needed in the API loop
BASE_URL = "https://www.alphavantage.co/query"
today_str = date.today().isoformat()
out_path = Path("/home/michielsmulders/data/csv_exports/listing_status")
out_path = Path("/Users/akagi/Downloads")
schema_name = 'rawalphavantage'
table_name = "time_series_daily"

# execute the GET request for every ticker in the list
for ticker in tickers:
    params = {
        "function": "TIME_SERIES_DAILY",
        "apikey": API_KEY,
        "symbol": ticker,
        "outputsize": "full",
        "datatype": "csv"
    }
    resp = requests.get(BASE_URL, params=params, timeout=120)

    # store the response (csv format) as a dataframe
    df = pd.read_csv(StringIO(resp.text))

    # define the path for the final output
    out_path_file = out_path / f"{ticker}_{today_str}.csv"

    # add dt column and name of ticker
    df['dt'] = today_str
    df['ticker'] = ticker

    # write the df data as a csv file to the file path
    df.to_csv(out_path_file
                ,quoting=csv.QUOTE_ALL
                ,sep=','
                ,header=True
                ,index=False
                ,encoding='utf-8')
    
    # return status to airflow
    print(f"Written {len(df)} rows into '{out_path_file}' successfully.")

    # make sure the data of the company has not been loaded before
    query = text("delete from rawalphavantage.time_series_daily where dt = ticker = :query_ticker")
    with engine.connect() as conn:
        conn.execute(query, {"query_ticker": ticker})
        conn.commit()
        conn.close()

    # write the df data to a PostgreSQL database
    df.to_sql(table_name
              ,engine
              ,schema = schema_name
              ,if_exists="append"
              ,index=False
              ,method="multi"
              ,chunksize=1000)

    # return succesfull run results to airflow
    print(f"Inserted {len(df)} rows into PostgreSQL table '{table_name}' for ticker '{ticker}' successfully.")