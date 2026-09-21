import pandas as pd
from sqlalchemy import create_engine

password = "YOUR_PASSWORD_HERE"
host = "localhost"
database = "olist"
filepath = "C:/Users/Pratyush/Downloads/DataAnalytics/1/olist_geolocation_dataset.csv"

engine = create_engine(f"mysql+mysqlconnector://root:{password}@{host}/{database}")

print("Loading geolocation...")
df = pd.read_csv(filepath)
df.to_sql("geolocation", con=engine, if_exists="replace", index=False, chunksize=5000)
print(f"Done: {len(df)} rows loaded into geolocation")