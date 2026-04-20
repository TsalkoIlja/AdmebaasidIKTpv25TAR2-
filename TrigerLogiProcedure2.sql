CREATE DATABASE IljaTriger;
use IljaTriger;

--tabel product
CREATE TABLE product(
product_id INT IDENTITY(1,1) PRIMARY KEY,
product_name VARCHAR(255),
brand_id INT,
category_id INT,
model_year INT,
list_price DECIMAL(10,2)
);

--tabel product_audits
--Tabel mis fiktseerib trigeeri töö
CREATE TABLE product_audits(
change_id INT IDENTITY(1,1) PRIMARY KEY,
product_id INT NOT NULL,
product_name VARCHAR(255) NOT NULL,
brand_id INT NOT NULL,
category_id INT NOT NULL,
model_year INT NOT NULL,
list_price DECIMAL(10,2) NOT NULL,
updated_at DATETIME NOT NULL,
operation CHAR(3) NOT NULL,
CHECK(operation='INS' OR operation='DEL')
);

--INSERT, DELETE Trigger
CREATE TRIGGER productAudit
ON product
AFTER INSERT, DELETE
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO product_audits(
product_id,
product_name,
brand_id,
category_id,
model_year,
list_price,
updated_at,
operation
)
SELECT
i.product_id,
i.product_name,
i.brand_id,
i.category_id,
i.model_year,
i.list_price,
GETDATE(),
'INS'
FROM inserted i

UNION ALL

SELECT
d.product_id,
d.product_name,
d.brand_id,
d.category_id,
d.model_year,
d.list_price,
GETDATE(),
'DEL'
FROM deleted d;
END;

--Kontroll INSERT
INSERT INTO product(product_name,brand_id,category_id,model_year,list_price)
VALUES('Test product',1,1,2024,599);

SELECT * FROM product;
SELECT * FROM product_audits;

--Kontroll DELETE
DELETE FROM product WHERE product_id=1;

SELECT * FROM product;
SELECT * FROM product_audits;

--Proceduuri loomine
CREATE PROCEDURE uspProductList
AS
BEGIN
    SELECT product_name, list_price
    FROM production.products
    ORDER BY product_name;
END;
EXEC uspProductList;

DROP PROCEDURE uspProductList;

EXEC uspProductList;

ALTER PROCEDURE uspProductList
AS
BEGIN
    SELECT 
        product_name, 
        list_price
    FROM product
    ORDER BY list_price;
END;

--Protseduuri loomine
CREATE PROCEDURE uspAddProduct
    @product_name VARCHAR(255),
    @brand_id INT,
    @category_id INT,
    @model_year INT,
    @list_price DECIMAL(10,2)
AS
BEGIN
    INSERT INTO product(
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price
    )
    VALUES(
        @product_name,
        @brand_id,
        @category_id,
        @model_year,
        @list_price
    );

    SELECT 'Product added successfully' AS message;
END;
EXEC uspAddProduct
    @product_name = 'New Product',
    @brand_id = 1,
    @category_id = 2,
    @model_year = 2024,
    @list_price = 799;


	GRANT SELECT 
ON product TO Ilja;
SELECT * FROM product;

GRANT INSERT, DELETE
ON product TO Ilja;

GRANT SELECT, INSERT, UPDATE, DELETE
ON product TO Ilja;

INSERT INTO product(product_name, brand_id, category_id, model_year, list_price)
VALUES
('Mountain Bike X1', 1, 1, 2022, 899.00),
('Road Bike Pro', 2, 1, 2023, 1299.00),
('City Bike Comfort', 3, 2, 2021, 499.00),
('Electric Bike E‑200', 4, 3, 2024, 1899.00),
('Kids Bike Mini', 5, 4, 2020, 199.00),
('Hybrid Bike H‑500', 2, 2, 2023, 799.00),
('Test product 1', 1, 1, 2024, 599.00),
('Test product 2', 1, 2, 2018, 599.00);

Select * From product;

GRANT SELECT 
ON product TO IljaTest;
SELECT * FROM product;

GRANT INSERT, DELETE
ON product TO IljaTest;

GRANT SELECT, INSERT, UPDATE, DELETE
ON product TO IljaTest;