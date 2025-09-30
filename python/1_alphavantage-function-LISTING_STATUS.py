from dotenv import load_dotenv
import os
import requests
import pandas as pd
from io import StringIO
import csv
from pathlib import Path
from datetime import date
from sqlalchemy import create_engine, text


try:

    # read the .env file to fetch the AlphaVantage API Key
    load_dotenv()
    API_KEY = os.getenv("ALPHAVANTAGE_API_KEY")
    
    # define the basic parameters of our GET request
    BASE_URL = "https://www.alphavantage.co/query"
    params = {
        "function": "LISTING_STATUS",
        "apikey": API_KEY
    }
    
    # execute the GET request
    resp = requests.get(BASE_URL, params=params, timeout=120)
    
    # store the response (csv format) as a dataframe
    df = pd.read_csv(StringIO(resp.text))
    
    # define the path for the final output
    today_str = date.today().isoformat()
    out_path = Path("/home/michielsmulders/data/csv_exports/listing_status")
    out_path_file = out_path / f"{today_str}.csv"

    # add dt column
    df['dt'] = today_str
    
    # write the df data as a csv file to the file path
    df.to_csv(out_path_file
                ,quoting=csv.QUOTE_ALL
                ,sep=','
                ,header=True
                ,index=False
                ,encoding='utf-8')

    # define the connection to the PostgreSQL database
    username = "loader"
    password = os.getenv("POSTGRESQL_LOADER_PWD")
    host = "localhost"
    port = "5432"
    db_name = "raw"
    schema_name = 'alphavantage'
    table_name = "listing_status"

    # create the SQLalchemy - PostgreSQL engine
    connection_string = f"postgresql+psycopg2://{username}:{password}@{host}:{port}/{db_name}"
    engine = create_engine(connection_string)

    # make sure the data of today has not been loaded before
    query = text("delete from raw.alphavantage.listing_status where dt = :query_dt")
    with engine.connect() as conn:
        conn.execute(query, {"query_dt": today_str})
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
    print(f"Inserted {len(df)} rows into '{table_name}' successfully.")

except Exception as e:
    print(f"Error occurred: {e}")
    raise  # Airflow will mark the task as failed