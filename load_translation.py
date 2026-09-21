import pandas as pd
from sqlalchemy import create_engine

password = "YOUR_PASSWORD_HERE"
host = "localhost"
database = "olist"
filepath = "C:/Users/Pratyush/Downloads/DataAnalytics/1/product_category_name_translation.csv"

engine = create_engine(f"mysql+mysqlconnector://root:{password}@{host}/{database}")

print("Loading category translation...")
df = pd.read_csv(filepath)
df.to_sql("category_translation", con=engine, if_exists="replace", index=False)
print(f"Done: {len(df)} rows loaded into category_translation")