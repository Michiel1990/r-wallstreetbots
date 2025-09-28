# for fetching the API key from a .env file:
from dotenv import load_dotenv
import os
# for making the API request:
import requests
# for storing the response (raw csv) in pandas dataframe:
import pandas as pd
from io import StringIO
# for writing content of the dataframe (as clean csv) to a path of choice:
import csv
from pathlib import Path

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
resp = requests.get(BASE_URL, params=params, timeout=30)

# store the response (csv format) as a dataframe
df = pd.read_csv(StringIO(resp.text))

# define the path for the final output
out_path = Path("/Users/akagi/Downloads/")
out_path_file = out_path / 'alphavantage_tickers.csv'

# write the data as a clean csv file to the file path
df.to_csv(out_path_file
            ,quoting=csv.QUOTE_ALL
            ,sep=','
            ,header=True
            ,index=False
            ,encoding='utf-8')