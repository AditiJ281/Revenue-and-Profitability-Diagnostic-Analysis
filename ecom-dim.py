import pandas as pd


orders = pd.read_csv(r"C:\Users\Adigvijay\Downloads\data analytics\ecom_dim\olist_orders_dataset.csv")
order_items = pd.read_csv(r"C:\Users\Adigvijay\Downloads\data analytics\ecom_dim\olist_order_items_dataset.csv")
customers = pd.read_csv(r"C:\Users\Adigvijay\Downloads\data analytics\ecom_dim\olist_customers_dataset.csv")
products = pd.read_csv(r"C:\Users\Adigvijay\Downloads\data analytics\ecom_dim\olist_products_dataset.csv")
payments = pd.read_csv(r"C:\Users\Adigvijay\Downloads\data analytics\ecom_dim\olist_order_payments_dataset.csv")
reviews = pd.read_csv(r"C:\Users\Adigvijay\Downloads\data analytics\ecom_dim\olist_order_reviews_dataset.csv")
sellers = pd.read_csv(r"C:\Users\Adigvijay\Downloads\data analytics\ecom_dim\olist_sellers_dataset.csv")
geolocation = pd.read_csv(r"C:\Users\Adigvijay\Downloads\data analytics\ecom_dim\olist_geolocation_dataset.csv")
category_translation = pd.read_csv(r"C:\Users\Adigvijay\Downloads\data analytics\ecom_dim\product_category_name_translation.csv")


dfs = {
    "orders": orders,
    "order_items": order_items,
    "payments": payments,
    "customers": customers,
    "products": products,
    "sellers": sellers
}

print(type(dfs))
for name, df in list(locals().items()):
    if isinstance(df, pd.DataFrame):
        print(name, df.shape)

for name, df in list(locals().items()):
    if isinstance(df, pd.DataFrame):
        print(name, df.info)

orders.isnull().sum().sort_values(ascending=False)
customers.isnull().sum().sort_values(ascending=False)
order_items.sum().sort_values(ascending=False)
products.isnull().sum().sort_values(ascending=False)
payments.isnull().sum().sort_values(ascending=False)


for name, df in dfs.items():
    dup_rows = df.duplicated().sum()
    print(f"{name}: {dup_rows} duplicate rows")


# Convert to datetime first
date_cols = ['order_purchase_timestamp', 'order_delivered_customer_date', 'order_estimated_delivery_date']
for col in date_cols:
    df[col] = pd.to_datetime(df[col])

# Calculate delivery time in days
df['actual_delivery_days'] = (df['order_delivered_customer_date'] - df['order_purchase_timestamp']).dt.days

# Calculate 'Delivery Delta' (Positive = Late, Negative = Early)
df['delivery_delta'] = (df['order_delivered_customer_date'] - df['order_estimated_delivery_date']).dt.days