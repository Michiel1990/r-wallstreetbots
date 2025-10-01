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
    select str_company_ticker as ticker from devsilver.dim_companies
    where bl_data_missing_at_dt_min_one = true
    order by dt_ipo asc limit 12;
"""
df_tickers = pd.read_sql(query_tickers, engine)
tickers = df_tickers['ticker'].tolist()

# several variables needed in the API loop
BASE_URL = "https://www.alphavantage.co/query"
today_str = date.today().isoformat()
out_path_y = Path("/home/michielsmulders/data/csv_exports/balance_sheet/annual_reports")
out_path_q = Path("/home/michielsmulders/data/csv_exports/balance_sheet/quarterly_reports")
schema_name = 'rawalphavantage'
table_name_y = "balance_sheet_annual"
table_name_q = "balance_sheet_quarterly"

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
    resp_json = resp.json()
    df_y = pd.json_normalize(resp_json, record_path=['annualReports'])
    df_q = pd.json_normalize(resp_json, record_path=['quarterlyReports'])


    # define the path for the final output
    out_path_file_y = out_path_y / f"{ticker}.csv"
    out_path_file_q = out_path_q / f"{ticker}.csv"

    # add dt column and name of ticker
    df_y['dt'] = today_str
    df_q['dt'] = today_str
    df_y['ticker'] = ticker
    df_q['ticker'] = ticker

    # write the df data as a csv file to the file path
    df_y.to_csv(out_path_file_y
                ,quoting=csv.QUOTE_ALL
                ,sep=','
                ,header=True
                ,index=False
                ,encoding='utf-8')

    df_q.to_csv(out_path_file_q
                ,quoting=csv.QUOTE_ALL
                ,sep=','
                ,header=True
                ,index=False
                ,encoding='utf-8')

    # return status to airflow
    print(f"Written {len(df_y)} rows into '{out_path_file_y}' successfully.")
    print(f"Written {len(df_q)} rows into '{out_path_file_q}' successfully.")

    # make sure the data of the company has not been loaded before
    try:
        query = text("delete from rawalphavantage.balance_sheet_annual where ticker = :query_ticker")
        with engine.connect() as conn:
            result = conn.execute(query, {"query_ticker": ticker})
            print(f"{result.rowcount} rows deleted from {schema_name}.{table_name_y}")
            conn.commit()
            conn.close()
    except SQLAlchemyError as e:
        print(f"Database error: {str(e)}")

    try:
        query = text("delete from rawalphavantage.balance_sheet_quarterly where ticker = :query_ticker")
        with engine.connect() as conn:
            result = conn.execute(query, {"query_ticker": ticker})
            print(f"{result.rowcount} rows deleted from {schema_name}.{table_name_q}")
            conn.commit()
            conn.close()
    except SQLAlchemyError as e:
        print(f"Database error: {str(e)}")

    # write the df data to a PostgreSQL database
    df_y.to_sql(table_name_y
                ,engine
                ,schema = schema_name
                ,if_exists="append"
                ,index=False
                ,method="multi"
                ,chunksize=1000)

    df_q.to_sql(table_name_q
                ,engine
                ,schema = schema_name
                ,if_exists="append"
                ,index=False
                ,method="multi"
                ,chunksize=1000)


    # return succesfull run results to airflow
    print(f"Inserted {len(df_y)} '{ticker}' rows into {schema_name}.{table_name_y} successfully.")
    print(f"Inserted {len(df_q)} '{ticker}' rows into {schema_name}.{table_name_q} successfully.")



# execute after first load in PostgreSQL
#set role loader;
#CREATE INDEX balance_sheet_annual_idx_ticker ON rawalphavantage.balance_sheet_annual ("ticker");
#CREATE INDEX balance_sheet_quarterly_idx_ticker ON rawalphavantage.balance_sheet_quarterly ("ticker");