select *
from orders;
select *
from payments;


ALTER TABLE orders 
MODIFY COLUMN order_id VARCHAR(32) NOT NULL,
MODIFY COLUMN customer_id VARCHAR(32) NOT NULL,
MODIFY COLUMN order_purchase_timestamp DATETIME,
MODIFY COLUMN order_approved_at DATETIME,
MODIFY COLUMN order_delivered_carrier_date DATETIME,
MODIFY COLUMN order_delivered_customer_date DATETIME,
MODIFY COLUMN order_estimated_delivery_date DATETIME,
ADD PRIMARY KEY (order_id);


ALTER TABLE items 
MODIFY COLUMN order_id VARCHAR(32) NOT NULL,
MODIFY COLUMN product_id VARCHAR(32) NOT NULL,
MODIFY COLUMN shipping_limit_date datetime,
MODIFY COLUMN price DECIMAL(10,2),
MODIFY COLUMN freight_value DECIMAL(10,2),
ADD PRIMARY KEY (order_id, order_item_id);


ALTER TABLE products 
MODIFY COLUMN product_id VARCHAR(32) NOT NULL,
ADD PRIMARY KEY (product_id);


ALTER TABLE payments
MODIFY COLUMN order_id VARCHAR(32) NOT NULL;


ALTER TABLE items 
ADD CONSTRAINT fk_items_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
ADD CONSTRAINT fk_items_products FOREIGN KEY (product_id) REFERENCES products(product_id),
ADD CONSTRAINT fk_payments_orders FOREIGN KEY (order_id) REFERENCES orders(order_id); -- this is wrong code, we are currently adding constraint in items table.

-- dont do above
 -- this is the correct approach
 -- First, fix the items table connections
/*ALTER TABLE items ( dont run this as u have already created the fk with name given below)
ADD CONSTRAINT fk_items_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
ADD CONSTRAINT fk_items_products FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Second, you MUST call the payments table separately to add its key
ALTER TABLE payments
ADD CONSTRAINT fk_payments_orders FOREIGN KEY (order_id) REFERENCES orders(order_id);*/


SELECT order_id, order_purchase_timestamp, order_delivered_customer_date
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;


WITH OrderTotals AS (
    SELECT order_id, SUM(price + freight_value) AS expected_total
    FROM items
    GROUP BY order_id
),
PaymentTotals AS (
    SELECT order_id, SUM(payment_value) AS actual_collected
    FROM payments
    GROUP BY order_id
)
SELECT 
    ot.order_id, 
    ROUND(ot.expected_total, 2) AS expected, 
    ROUND(pt.actual_collected, 2) AS collected,
    ROUND(pt.actual_collected - ot.expected_total, 2) AS diff
FROM OrderTotals ot
JOIN PaymentTotals pt ON ot.order_id = pt.order_id
WHERE ABS(pt.actual_collected - ot.expected_total) > 0.05 
ORDER BY ABS(diff) DESC
LIMIT 10;



SELECT *
FROM payments 
WHERE order_id = '8d9c0dc8d5a2ce804f6b925d8f8e6c1d';

WITH Discrepancy AS (
    SELECT 
        p.payment_type,
        p.payment_installments,
        (p.payment_value - (i.price + i.freight_value)) as diff
    FROM payments p
    JOIN items i ON p.order_id = i.order_id
)
SELECT 
    payment_type,
    payment_installments,
    AVG(diff) as avg_error,
    COUNT(*) as affected_rows
FROM Discrepancy
GROUP BY payment_type, payment_installments
HAVING ABS(avg_error) > 0.01;


SELECT o.order_id, o.order_status
FROM orders o
LEFT JOIN items i ON o.order_id = i.order_id
WHERE i.order_id IS NULL;

SELECT 
    p.product_category_name AS original_name,
    t.product_category_name_english AS translated_name,
    COUNT(*) AS occurrences
FROM products p
LEFT JOIN translation t ON p.product_category_name = t.product_category_name
WHERE t.product_category_name_english IS NULL 
  AND p.product_category_name IS NOT NULL
GROUP BY p.product_category_name, t.product_category_name_english -- Added both here
ORDER BY occurrences DESC;

-- Updated Logic for your View
CREATE OR REPLACE VIEW v_clean_revenue_diagnostic AS
SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    -- The "Triple Check" Logic
    CASE 
        WHEN t.product_category_name_english IS NOT NULL THEN t.product_category_name_english
        WHEN p.product_category_name IS NOT NULL THEN p.product_category_name -- Keep original if no translation exists
        ELSE 'others_uncategorized' 
    END AS final_category,
    i.price,
    i.freight_value,
    (i.price * 0.90) AS net_revenue
FROM orders o
INNER JOIN items i ON o.order_id = i.order_id
LEFT JOIN products p ON i.product_id = p.product_id
LEFT JOIN translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered';

CREATE OR REPLACE VIEW v_clean_revenue_diagnostic AS
SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    COALESCE(t.product_category_name_english, 'others_uncategorized') AS category_english,
    i.price,
    i.freight_value,
    (i.price * 0.90) AS net_revenue,
    (i.price * 0.90) - (i.freight_value * 0.05) AS est_profit
FROM orders o
INNER JOIN items i ON o.order_id = i.order_id 
LEFT JOIN products p ON i.product_id = p.product_id
LEFT JOIN translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered';

CREATE OR REPLACE VIEW v_clean_revenue_diagnostic AS
SELECT 
    i.order_item_id,
    o.order_id,
    o.order_purchase_timestamp,
    CASE 
        WHEN p.product_category_name = 'pc_gamer' THEN 'PC Gamer'
        WHEN p.product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos' THEN 'Kitchen Appliances'
        WHEN p.product_category_name = 'eletroportateis' THEN 'Small Appliances'
        WHEN t.product_category_name_english IS NOT NULL THEN REPLACE(t.product_category_name_english, '_', ' ')
        ELSE 'Others/Uncategorized'
    END AS final_category,
    i.price,
    i.freight_value,
    (i.price * 0.90) AS net_revenue
FROM orders o
INNER JOIN items i ON o.order_id = i.order_id
LEFT JOIN products p ON i.product_id = p.product_id
LEFT JOIN translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered';

SELECT DISTINCT final_category FROM v_clean_revenue_diagnostic;

CREATE OR REPLACE VIEW v_clean_customers AS
SELECT 
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    -- Standardizing city names to look professional on the dashboard
    UPPER(customer_city) AS customer_city,
    customer_state
FROM customers;

CREATE OR REPLACE VIEW v_clean_sellers AS
SELECT 
    seller_id,
    seller_zip_code_prefix,
    UPPER(seller_city) AS seller_city,
    seller_state
FROM sellers;


CREATE OR REPLACE VIEW v_clean_products AS
SELECT 
    p.product_id,
    CASE 
        WHEN p.product_category_name = 'pc_gamer' THEN 'PC Gamer'
        WHEN p.product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos' THEN 'Kitchen Appliances'
        WHEN t.product_category_name_english IS NOT NULL THEN t.product_category_name_english
        ELSE 'Others/Uncategorized'
    END AS final_category,
    p.product_weight_g
FROM products p
LEFT JOIN translation t ON p.product_category_name = t.product_category_name;

SELECT MIN(order_purchase_timestamp), MAX(order_purchase_timestamp) FROM orders;

CREATE OR REPLACE VIEW v_fact_sales AS
SELECT 
    i.order_id,
    i.order_item_id,
    o.customer_id,
    i.product_id,
    o.order_purchase_timestamp,
    i.price,
    i.freight_value,
    (i.price * 0.90) AS net_revenue 
FROM orders o
INNER JOIN items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered';

CREATE OR REPLACE VIEW v_fact_sales AS
SELECT 
    i.order_id,
    i.order_item_id,
    o.customer_id,
    i.product_id,
    i.seller_id,   
    DATE(o.order_purchase_timestamp) AS order_date,
    i.price,
    i.freight_value,
    (i.price * 0.90) AS net_revenue
FROM orders o
INNER JOIN items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered';

CREATE OR REPLACE VIEW v_fact_orders AS
SELECT
    o.order_id,
    o.customer_id,
    DATE(o.order_purchase_timestamp) AS order_date,
    DATE(o.order_delivered_customer_date) AS delivered_date,
    o.order_status,
    SUM(op.payment_value) AS total_payment,
    SUM(i.freight_value) AS total_freight,
    SUM(i.price) AS items_value
FROM orders o
LEFT JOIN payments op
    ON o.order_id = op.order_id
LEFT JOIN items i
    ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    o.order_id,
    o.customer_id,
    DATE(o.order_purchase_timestamp),
    DATE(o.order_delivered_customer_date),
    o.order_status;
    
CREATE OR REPLACE VIEW v_fact_items AS
SELECT
    i.order_id,
    i.order_item_id,
    o.customer_id,
    i.product_id,
    i.seller_id,
    DATE(o.order_purchase_timestamp) AS order_date,
    i.price,
    i.freight_value

FROM orders o

INNER JOIN items i
    ON o.order_id = i.order_id

WHERE o.order_status = 'delivered';

UPDATE products p
JOIN translation t 
  ON p.product_category_name = t.product_category_name
SET p.product_category_name = CONCAT(
    UPPER(LEFT(REPLACE(t.product_category_name_english, '_', ' '), 1)),
    LOWER(SUBSTRING(REPLACE(t.product_category_name_english, '_', ' '), 2))
);
select  distinct product_category_name
from products;
UPDATE products
SET product_category_name = 'Other / Miscellaneous'
WHERE product_category_name LIKE '%_%' 
   OR product_category_name IS NULL;

select *
from translation;
