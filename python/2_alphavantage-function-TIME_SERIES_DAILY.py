from sqlalchemy import create_engine
import pandas as pd

# Define connection string
engine = create_engine("postgresql+psycopg2://username:password@host:port/dbname")

# Example: Fetch data into a DataFrame
query = "SELECT * FROM your_table;"
df = pd.read_sql(query, engine)

result_list = df['your_column_name'].tolist()
