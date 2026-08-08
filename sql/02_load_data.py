"""
Loads the Olist CSVs into a local SQLite database called olist.db.

HOW TO USE:
1. pip install pandas
2. Put all 9 downloaded CSVs into the /data folder (same names as Kaggle gives them)
3. Run: python 02_load_data.py
4. This creates olist.db in the project root, ready for SQL queries or Power BI.
"""

import sqlite3
import pandas as pd
import os

DATA_DIR = "../data"
DB_PATH = "../olist.db"
SCHEMA_PATH = "01_schema.sql"

# Map: CSV filename -> table name
FILES_TO_TABLES = {
    "olist_customers_dataset.csv": "customers",
    "olist_orders_dataset.csv": "orders",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "olist_geolocation_dataset.csv": "geolocation",
    "product_category_name_translation.csv": "category_translation",
}

def main():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # 1. Create schema
    with open(SCHEMA_PATH, "r") as f:
        cursor.executescript(f.read())
    conn.commit()
    print("Schema created.")

    # 2. Load each CSV into its table
    for filename, table in FILES_TO_TABLES.items():
        filepath = os.path.join(DATA_DIR, filename)
        if not os.path.exists(filepath):
            print(f"WARNING: {filename} not found in /data — skipping.")
            continue
        df = pd.read_csv(filepath)
        df.to_sql(table, conn, if_exists="append", index=False)
        print(f"Loaded {len(df):,} rows into '{table}'")

    conn.close()
    print("\nDone. Database ready at:", os.path.abspath(DB_PATH))

if __name__ == "__main__":
    main()
