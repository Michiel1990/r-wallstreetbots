from dotenv import load_dotenv
import os
import requests
import pandas as pd
from io import StringIO
import csv
from pathlib import Path
from datetime import date
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError


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

# several variables needed in the API loop
BASE_URL = "https://www.alphavantage.co/query"
today_str = date.today().isoformat()
out_path = Path("/home/michielsmulders/data/csv_exports/balance_sheet")
schema_name = 'rawalphavantage'
table_name = "balance_sheet"

# execute the GET request for every ticker in the list
for ticker in tickers:
    # make the API call
    params = {
        "function": "BALANCE_SHEET",
        "apikey": API_KEY,
        "symbol": ticker
    }
    resp = requests.get(BASE_URL, params=params, timeout=120)

    # store the response as a dataframe
    df = pd.read_csv(StringIO(resp.text))

    # define the path for the final output
    out_path_file = out_path / f"{ticker}.csv"

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
    try:
        query = text("delete from rawalphavantage.balance_sheet where ticker = :query_ticker")
        with engine.connect() as conn:
            result = conn.execute(query, {"query_ticker": ticker})
            print(f"{result.rowcount} rows deleted from {schema_name}.{table_name}")
            conn.commit()
            conn.close()
    except SQLAlchemyError as e:
        print(f"Database error: {str(e)}")

    # write the df data to a PostgreSQL database
    df.to_sql(table_name
              ,engine
              ,schema = schema_name
              ,if_exists="append"
              ,index=False
              ,method="multi"
              ,chunksize=1000)

    # return succesfull run results to airflow
    print(f"Inserted {len(df)} '{ticker}' rows into {schema_name}.{table_name} successfully.")