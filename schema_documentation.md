 Entity–Relationship Description

ENTITY: customers

Purpose: Stores information about individuals registered with FlexiMart.
Attributes:

customer_id – Primary key; uniquely identifies each customer.

first_name – Customer’s first name.

last_name – Customer’s last name.

email – Unique customer email address used for communication/login.

phone – Customer’s contact phone number.

city – City of customer residence.

registration_date – When the customer first registered.

Relationships:

One customer can place many orders (1:M relationship with orders table).

ENTITY: products

Purpose: Stores product catalog details sold by FlexiMart.
Attributes:

product_id – Primary key; unique ID per product.

product_name – Name of the product.

category – Type/category classification.

price – Selling price for one unit.

stock_quantity – Number of units available in inventory.

Relationships:

One product may belong to many order items (1:M with order_items table).

ENTITY: orders

Purpose: Tracks individual orders placed by customers.
Attributes:

order_id – Primary key; unique identifier per order.

customer_id – Foreign key linking to customers.

order_date – When the order was created.

total_amount – Combined cost of items within an order.

status – Current order status (Pending/Completed/etc.).

Relationships:

One order consists of many order items (1:M with order_items).

Each order belongs to exactly one customer (M:1 with customers).

ENTITY: order_items

Purpose: Holds item-level breakdown of individual orders.
Attributes:

order_item_id – Primary key; unique record per item line.

order_id – Foreign key linking to orders.

product_id – Foreign key linking to products.

quantity – Number of units purchased.

unit_price – Product price at time of purchase.

subtotal – price × quantity.

Relationships:

Each order item belongs to one order (M:1 with orders).

Each order item references one product (M:1 with products).

2. Normalization Summary (3NF Justification – ~220 words)

The FlexiMart database schema follows Third Normal Form (3NF) principles to ensure data consistency, reduce redundancy, and improve data integrity.

First, the structure satisfies 1NF: all tables contain atomic values, rows are uniquely identifiable through primary keys, and attributes contain only one value per field.

Next, the schema meets 2NF requirements: every non-key attribute depends on the whole primary key. For example, in the orders table, attributes such as order_date, total_amount, and status depend solely on order_id—not on customer_id. Similarly, order_items introduce a surrogate primary key (order_item_id), ensuring unit_price and subtotal depend on a single key rather than a composite pair.

The schema also satisfies 3NF by removing transitive dependencies. Customer attributes (e.g., name, phone, city) are stored only in customers, never duplicated in orders. Product price and stock exist exclusively in products, not repeated in order_items. Functional dependencies include:

customer_id → first_name, last_name, email, phone, city

product_id → product_name, category, price

order_id → order_date, total_amount, status

This structure prevents anomalies:

Update anomalies are avoided because changing a product price requires altering only one table.

Insert anomalies are avoided since products can exist without orders.

Delete anomalies are prevented because deleting an order does not remove customer or product data.

Overall, the design ensures clean referential integrity and efficient transactional storage.
