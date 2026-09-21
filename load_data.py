import pandas as pd
from sqlalchemy import create_engine

# --- CONFIG ---
password = "YOUR_PASSWORD_HERE"  
host = "localhost"
database = "olist"
data_folder = "C:/Users/Pratyush/Downloads/DataAnalytics/1/"

# maps CSV filename -> target MySQL table name
files_to_tables = {
    "olist_orders_dataset.csv": "orders",
    "olist_customers_dataset.csv": "customers",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "payments",
    "olist_order_reviews_dataset.csv": "reviews",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
}

engine = create_engine(f"mysql+mysqlconnector://root:{password}@{host}/{database}")

for filename, table in files_to_tables.items():
    filepath = data_folder + filename
    print(f"Loading {filename} into {table}...")
    df = pd.read_csv(filepath)
    df.to_sql(table, con=engine, if_exists="replace", index=False)
    print(f"  Done: {len(df)} rows loaded into {table}")

print("All files loaded.")