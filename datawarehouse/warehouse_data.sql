USE fleximart_dw;

/******************************
 INSERTS FOR dim_date (30 days)
******************************/
INSERT INTO dim_date VALUES
(20240101,'2024-01-01','Monday',1,1,'January','Q1',2024,FALSE),
(20240102,'2024-01-02','Tuesday',2,1,'January','Q1',2024,FALSE),
(20240103,'2024-01-03','Wednesday',3,1,'January','Q1',2024,FALSE),
(20240104,'2024-01-04','Thursday',4,1,'January','Q1',2024,FALSE),
(20240105,'2024-01-05','Friday',5,1,'January','Q1',2024,FALSE),
(20240106,'2024-01-06','Saturday',6,1,'January','Q1',2024,TRUE),
(20240107,'2024-01-07','Sunday',7,1,'January','Q1',2024,TRUE),
(20240108,'2024-01-08','Monday',8,1,'January','Q1',2024,FALSE),
(20240109,'2024-01-09','Tuesday',9,1,'January','Q1',2024,FALSE),
(20240110,'2024-01-10','Wednesday',10,1,'January','Q1',2024,FALSE),
(20240111,'2024-01-11','Thursday',11,1,'January','Q1',2024,FALSE),
(20240112,'2024-01-12','Friday',12,1,'January','Q1',2024,FALSE),
(20240113,'2024-01-13','Saturday',13,1,'January','Q1',2024,TRUE),
(20240114,'2024-01-14','Sunday',14,1,'January','Q1',2024,TRUE),
(20240115,'2024-01-15','Monday',15,1,'January','Q1',2024,FALSE),
(20240116,'2024-01-16','Tuesday',16,1,'January','Q1',2024,FALSE),
(20240117,'2024-01-17','Wednesday',17,1,'January','Q1',2024,FALSE),
(20240118,'2024-01-18','Thursday',18,1,'January','Q1',2024,FALSE),
(20240119,'2024-01-19','Friday',19,1,'January','Q1',2024,FALSE),
(20240120,'2024-01-20','Saturday',20,1,'January','Q1',2024,TRUE),
(20240121,'2024-01-21','Sunday',21,1,'January','Q1',2024,TRUE),
(20240122,'2024-01-22','Monday',22,1,'January','Q1',2024,FALSE),
(20240123,'2024-01-23','Tuesday',23,1,'January','Q1',2024,FALSE),
(20240124,'2024-01-24','Wednesday',24,1,'January','Q1',2024,FALSE),
(20240125,'2024-01-25','Thursday',25,1,'January','Q1',2024,FALSE),
(20240126,'2024-01-26','Friday',26,1,'January','Q1',2024,FALSE),
(20240127,'2024-01-27','Saturday',27,1,'January','Q1',2024,TRUE),
(20240128,'2024-01-28','Sunday',28,1,'January','Q1',2024,TRUE),
(20240129,'2024-01-29','Monday',29,1,'January','Q1',2024,FALSE),
(20240130,'2024-01-30','Tuesday',30,1,'January','Q1',2024,FALSE);

/******************************
 INSERTS FOR dim_product (15 rows)
******************************/
INSERT INTO dim_product(product_id,product_name,category,subcategory,unit_price) VALUES
('ELEC001','Samsung TV 50"','Electronics','Television',45000),
('ELEC002','iPhone 13','Electronics','Mobile',68000),
('ELEC003','Dell Laptop','Electronics','Laptop',55000),
('ELEC004','Sony Headphones','Electronics','Audio',12000),
('ELEC005','Canon DSLR','Electronics','Camera',75000),

('HOME001','Mixer Grinder','Home Appliances','Kitchen',3500),
('HOME002','Air Cooler','Home Appliances','Cooling',9000),
('HOME003','Water Purifier','Home Appliances','Filter',12000),
('HOME004','Washing Machine','Home Appliances','Laundry',28000),
('HOME005','Vacuum Cleaner','Home Appliances','Cleaning',8000),

('FASH001','Men T-Shirt','Fashion','Clothing',600),
('FASH002','Women Jacket','Fashion','Clothing',2500),
('FASH003','Sports Shoes','Fashion','Footwear',4000),
('FASH004','Wrist Watch','Fashion','Accessories',3500),
('FASH005','Handbag','Fashion','Accessories',3000);

/******************************
 INSERTS FOR dim_customer (12 rows)
******************************/
INSERT INTO dim_customer(customer_id,customer_name,city,state,customer_segment) VALUES
('C001','Amit Shah','Mumbai','Maharashtra','Retail'),
('C002','Sana Khan','Pune','Maharashtra','Corporate'),
('C003','John Mathew','Delhi','Delhi','Retail'),
('C004','Meera Kapoor','Delhi','Delhi','Retail'),
('C005','Krish Gupta','Bangalore','Karnataka','Retail'),
('C006','Neha Singh','Bangalore','Karnataka','Corporate'),
('C007','Vikas Rao','Hyderabad','Telangana','Retail'),
('C008','Suhana Pandey','Kolkata','West Bengal','Corporate'),
('C009','Raj Verma','Kolkata','West Bengal','Retail'),
('C010','Shantanu Roy','Mumbai','Maharashtra','Corporate'),
('C011','Priya Das','Delhi','Delhi','Retail'),
('C012','Dev Mishra','Hyderabad','Telangana','Retail');

/******************************
 INSERTS FOR fact_sales (40 rows)
 - Weekends: higher quantities
******************************/
INSERT INTO fact_sales(date_key,product_key,customer_key,quantity_sold,unit_price,discount_amount,total_amount) VALUES
-- 10 Jan Sales
(20240101,1,1,1,45000,0,45000),
(20240101,3,3,2,55000,5000,105000),
(20240102,2,4,1,68000,0,68000),
(20240102,7,8,3,9000,500,26500),

-- Weekend boosts
(20240106,1,9,2,45000,0,90000),
(20240106,11,6,5,600,0,3000),
(20240107,3,5,3,55000,2000,161000),
(20240107,4,4,2,12000,0,24000),

-- First week
(20240103,10,3,1,8000,0,8000),
(20240103,12,1,4,2500,0,10000),
(20240104,14,12,3,3500,100,10400),
(20240104,8,7,1,12000,0,12000),
(20240105,6,11,2,3500,0,7000),

-- More weekend
(20240113,5,2,1,75000,5000,70000),
(20240113,8,8,2,12000,500,23500),
(20240114,1,12,3,45000,0,135000),
(20240114,15,7,4,3000,0,12000),

-- Random mid month
(20240110,2,10,1,68000,1000,67000),
(20240110,9,9,1,28000,3000,25000),
(20240111,3,6,1,55000,0,55000),
(20240111,4,5,2,12000,500,23500),
(20240112,1,4,1,45000,0,45000),

-- 20th weekend boost again
(20240120,2,1,3,68000,3000,201000),
(20240120,6,3,4,3500,0,14000),
(20240121,5,8,1,75000,0,75000),
(20240121,14,2,3,3500,0,10500),

-- End month
(20240122,3,5,1,55000,0,55000),
(20240123,8,4,2,12000,2000,22000),
(20240124,9,9,1,28000,0,28000),
(20240125,10,6,5,8000,1000,39000),

-- Last weekend rush
(20240127,11,1,6,600,0,3600),
(20240127,3,12,2,55000,5000,105000),
(20240128,5,2,1,75000,3000,72000),
(20240128,15,7,5,3000,500,14500),

-- Final closing week
(20240129,4,3,2,12000,0,24000),
(20240129,9,9,1,28000,0,28000),
(20240130,13,10,3,4000,0,12000),
(20240130,1,11,2,45000,1000,89000);
