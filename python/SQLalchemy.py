import pandas as pd
import matplotlib.pyplot as plt
import os
from sqlalchemy import create_engine

# 1. Setup your connection
# Format: mysql+pymysql://user:password@host/db_name
engine = create_engine('mysql+pymysql://root:root@localhost/ecom')

required_files = {
    'orders': 'olist_orders_dataset.csv',
    'items': 'olist_order_items_dataset.csv',
    'payments': 'olist_order_payments_dataset.csv',
    'products': 'olist_products_dataset.csv',
    'translation': 'product_category_name_translation.csv'
}

more_files = {
    'customers': 'olist_customers_dataset.csv',
    'sellers' : 'olist_sellers_dataset.csv'
}
# 2. Load your local CSV into Python (This is very fast)
path = r'C:\Users\Adigvijay\Downloads\data analytics\ecom_dim'

for table_name, file_name in more_files.items():
    full_path = os.path.join(path, file_name)
    
    # Load to Python
    temp_df = pd.read_csv(full_path)
    
    # Push to SQL (chunksize makes it fast for 100k rows)
    temp_df.to_sql(table_name, con=engine, if_exists='replace', index=False, chunksize=5000)
    
    print(f"Successfully uploaded {table_name} to the database.")

# Define our 'Audit' queries
audits = {
    "Orphan Orders": "SELECT COUNT(*) FROM orders o LEFT JOIN items i ON o.order_id = i.order_id WHERE i.order_id IS NULL",
    "Logic Error Dates": "SELECT COUNT(*) FROM orders WHERE order_delivered_customer_date < order_purchase_timestamp",
    "Missing Categories": "SELECT COUNT(*) FROM products WHERE product_category_name IS NULL",
    "Zero Price Items": "SELECT COUNT(*) FROM items WHERE price <= 0"
}

print("--- DATA QUALITY AUDIT REPORT ---")
for test_name, query in audits.items():
    res = pd.read_sql(query, engine).iloc[0, 0]
    status = "❌ FAIL" if res > 0 else "✅ PASS"
    print(f"{test_name}: {res} errors found [{status}]")

df = pd.read_sql("SELECT MIN(order_purchase_timestamp) as start, MAX(order_purchase_timestamp) as end FROM orders", engine)

print(f"Start: {df['start'][0]}")
print(f"End: {df['end'][0]}")

# 1. Pull the data from our CLEAN view
query = "SELECT order_purchase_timestamp, net_revenue FROM v_clean_revenue_diagnostic"
df = pd.read_sql(query, engine)
df['order_purchase_timestamp'] = pd.to_datetime(df['order_purchase_timestamp'])

# 2. Resample by Month ('ME' stands for Month End)
# We set the date as index first to allow time-series grouping
df.set_index('order_purchase_timestamp', inplace=True)
monthly_revenue = df['net_revenue'].resample('ME').sum()

# 3. Quick Plot to see the "Health"
plt.figure(figsize=(12,6))
monthly_revenue.plot(kind='line', marker='o', color='teal')
plt.title('Monthly Net Revenue Trend (2016-2018)')
plt.ylabel('Revenue (BRL)')
plt.grid(True)
plt.show()

# 4. Show the numbers
print(monthly_revenue.tail(5))

# 1. Pull category-level revenue
cat_query = """
SELECT final_category, SUM(net_revenue) as total_revenue
FROM v_clean_revenue_diagnostic
GROUP BY final_category
ORDER BY total_revenue DESC
"""
df_cat = pd.read_sql(cat_query, engine)

# 2. Calculate Cumulative Percentage
df_cat['cum_percent'] = 100 * df_cat['total_revenue'].cumsum() / df_cat['total_revenue'].sum()

# 3. Filter for the Top 10
top_10 = df_cat.head(10)

# 4. Visualization
plt.figure(figsize=(12,6))
plt.bar(top_10['final_category'], top_10['total_revenue'], color='slateblue')
plt.xticks(rotation=45, ha='right')
plt.title('Top 10 Categories by Net Revenue')
plt.ylabel('Revenue (BRL)')
plt.show()

print(top_10[['final_category', 'total_revenue', 'cum_percent']])


# Updated Query: Pulling the ID, Date, Revenue, and Category
query = """
SELECT 
    order_id, 
    order_purchase_timestamp, 
    net_revenue, 
    final_category 
FROM v_clean_revenue_diagnostic
"""
df = pd.read_sql(query, engine)

# 1. Convert timestamp again (just to be safe)
df['order_purchase_timestamp'] = pd.to_datetime(df['order_purchase_timestamp'])

# 2. NOW check for duplicates
duplicates = df['order_id'].duplicated().sum()
print(f"Total Duplicate Rows: {duplicates}")

# 3. Check for 'Ghost' Categories (Portuguese leftovers)
unique_cats = df['final_category'].unique()
print(f"Total Unique Categories: {len(unique_cats)}")

# This will show us the categories that might still be in Portuguese
print(df['final_category'].sort_values().unique())

import pandas as pd
df = pd.read_sql("SELECT DISTINCT final_category FROM v_clean_revenue_diagnostic", engine)
print(df)
