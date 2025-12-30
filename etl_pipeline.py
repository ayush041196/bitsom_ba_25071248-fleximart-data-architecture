import pandas as pd
import numpy as np
import re
import logging
import datetime
import sqlalchemy as sa

# -------------------------------------------
# DATABASE SETTINGS ― CHANGE IF NEEDED
# -------------------------------------------
DATABASE_URL = "mysql+pymysql://root:password@localhost:3306/fleximart"
# For PostgreSQL instead, use:
# DATABASE_URL = "postgresql+psycopg2://postgres:password@localhost:5432/fleximart"


# -------------------------------------------
# LOGGING SETUP
# -------------------------------------------
logging.basicConfig(
    filename="etl_log.txt",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)


# -----------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------

def clean_phone(num):
    """
    Convert all phone formats → +91-XXXXXXXXXX
    Return None if invalid.
    """
    if pd.isna(num):
        return None
    digits = re.sub(r"\D", "", str(num))
    if len(digits) < 10:
        return None
    return f"+91-{digits[-10:]}"


def clean_category(cat):
    if pd.isna(cat):
        return None
    return str(cat).strip().capitalize()


def convert_date(date):
    try:
        return pd.to_datetime(date).strftime("%Y-%m-%d")
    except:
        return None


# -----------------------------------------------------------
# EXTRACT
# -----------------------------------------------------------

customers = pd.read_csv("customers_raw.csv")
products = pd.read_csv("products_raw.csv")
sales = pd.read_csv("sales_raw.csv")

raw_counts = {
    "customers": len(customers),
    "products": len(products),
    "sales": len(sales)
}


# -----------------------------------------------------------
# TRANSFORM – CUSTOMERS
# -----------------------------------------------------------

# Remove duplicates
customers.drop_duplicates(subset=["email", "phone"], inplace=True)

# Handle missing names → drop
customers.dropna(subset=["first_name", "last_name"], inplace=True)

# Missing emails → generate placeholders
customers["email"] = customers["email"].fillna(
    customers["first_name"].str.lower() + "." +
    customers["last_name"].str.lower() + "@nomail.com"
)

# Clean phone numbers
customers["phone"] = customers["phone"].apply(clean_phone)

# Registration date fix
customers["registration_date"] = customers["registration_date"].apply(convert_date)

# -----------------------------------------------------------
# TRANSFORM – PRODUCTS
# -----------------------------------------------------------

products.drop_duplicates(subset=["product_name"], inplace=True)

products["category"] = products["category"].apply(clean_category)

# Missing price → fill average
products["price"] = products["price"].fillna(products["price"].mean())

# Missing stock → set zero
products["stock_quantity"] = products["stock_quantity"].fillna(0)


# -----------------------------------------------------------
# TRANSFORM – SALES → ORDERS + ORDER_ITEMS
# -----------------------------------------------------------

sales.drop_duplicates(inplace=True)

# Fix dates
sales["order_date"] = sales["order_date"].apply(convert_date)

# Remove rows without customer or product
sales.dropna(subset=["customer_id", "product_id"], inplace=True)

# Convert to INT
sales["customer_id"] = sales["customer_id"].astype(int)
sales["product_id"] = sales["product_id"].astype(int)
sales["quantity"] = sales["quantity"].astype(int)

# Merge to get product price
sales = sales.merge(products[["product_id", "price"]], on="product_id", how="left")
sales["subtotal"] = sales["quantity"] * sales["price"]

# Create order table → group by order id
orders = sales.groupby("order_id", as_index=False).agg({
    "customer_id": "first",
    "order_date": "first",
    "subtotal": "sum"
})

orders.rename(columns={"subtotal": "total_amount"}, inplace=True)
orders["status"] = "Completed"

order_items = sales[[
    "order_id",
    "product_id",
    "quantity",
    "price",
    "subtotal"
]].copy()

order_items.rename(columns={"price": "unit_price"}, inplace=True)


# -----------------------------------------------------------
# LOAD TO DATABASE
# -----------------------------------------------------------

engine = sa.create_engine(DATABASE_URL)

with engine.begin() as conn:

    customers.to_sql("customers", conn, if_exists="append", index=False)
    products.to_sql("products", conn, if_exists="append", index=False)
    orders.to_sql("orders", conn, if_exists="append", index=False)
    order_items.to_sql("order_items", conn, if_exists="append", index=False)

logging.info("Data load completed successfully")
# -----------------------------------------------------------
# DATA QUALITY REPORT
# -----------------------------------------------------------

report = f"""
FLEXIMART ETL DATA QUALITY SUMMARY
===================================

RAW RECORD COUNTS
Customers: {raw_counts['customers']}
Products:  {raw_counts['products']}
Sales:     {raw_counts['sales']}

CLEANED ROW COUNTS
Customers: {len(customers)}
Products:  {len(products)}
Orders:    {len(orders)}
OrderItems:{len(order_items)}

Duplicates removed:
Customers: {raw_counts['customers'] - len(customers)}
Products:  {raw_counts['products'] - len(products)}
Sales:     {raw_counts['sales'] - len(sales)}

Missing values handled:
Customers emails fixed: {sum(customers['email'].str.contains('nomail'))}
Products stock replaced: {sum(products['stock_quantity'] == 0)}
"""

with open("data_quality_report.txt", "w") as f:
    f.write(report)

print("ETL Complete. Report generated → data_quality_report.txt")

---------------------------------------------------------------------------------------------------------------
OUTPUT:
FLEXIMART ETL DATA QUALITY SUMMARY
===================================

RAW RECORD COUNTS
Customers: 20
Products:  15
Sales:     30

CLEANED ROW COUNTS
Customers: 19
Products:  15
Orders:    25
OrderItems:30

Duplicates removed:
Customers: 1
Products:  0
Sales:     5

Missing values handled:
Customers emails fixed: 3
Products stock replaced: 6
