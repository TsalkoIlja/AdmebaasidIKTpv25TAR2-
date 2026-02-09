CREATE DATABASE veebipoodTsalko;
USE veebipoodTsalko;
--tabel Categories
CREATE TABLE categories(
categories_id int PRIMARY KEY identity(1,1),
category_name varchar(30) unique);

INSERT INTO categories(category_name)
VALUES ('T-särk'), ('mantel'), ('pusa'), ('pintsak');
SELECT * FROM categories;
--tabel products
CREATE TABLE products(
product_id int  PRIMARY KEY identity(1,1),
product_name varchar(50) NOT NULL,
brand_id int,
category_id int,
FOREIGN KEY (category_id) references categories(categories_id),
model_year int,
list_price decimal (7,2));
--tabel brands


CREATE TABLE brands (
brand_id int  PRIMARY KEY identity(1,1),
brand_name varchar(30) unique);


ALTER TABLE ADD CONSTRAINT fk_brand
FOREIGN KEY (brand_id) references brand(brand_id);

--tabel stack -- kaks primary key
CREATE TABLE stacks(
store_id int,
product_id int,
quantity int,
PRIMARY KEY (store_id, product_id),
foreign key (product_id) references products(product_id)
);

-- table customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    phone CHAR(15),
    email VARCHAR(50) UNIQUE,
    street VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code CHAR(5)
);

FOREIGN KEY (staff_id) REFERENCES staffs(staff_id));


--tabel orders 
SELECT * FROM orders;

CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price DECIMAL(7,2),
    discount INT,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

ALTER TABLE stocks
ADD CONSTRAINT fk_store
FOREIGN KEY (store_id) REFERENCES stores(store_id);

SELECT * FROM order_items;









--DROP TABLE stacks;





--INSERT into brands
INSERT into products (
product_name, brand_id, category_id, model_year, list_price)
VALUES
('logoga T-särk',..., 1, 2020, 25,50);


SELECT * FROM brands;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM stocks;

