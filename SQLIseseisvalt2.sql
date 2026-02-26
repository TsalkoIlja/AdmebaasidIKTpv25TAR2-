CREATE DATABASE Tsalko25;
GO
USE Tsalko25;
GO

-- 1. Table Liik
CREATE TABLE Liik(
liigi_kood INT PRIMARY KEY IDENTITY(1,1),
nimetus VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Table Category
CREATE TABLE Category(
idCategory INT PRIMARY KEY IDENTITY(1,1),
Category_Name VARCHAR(50) NOT NULL UNIQUE
);

-- 3. Table Kaup
CREATE TABLE Kaup(
kauba_kood INT PRIMARY KEY IDENTITY(1,1),
nimetus VARCHAR(50) NOT NULL,
liigi_kood INT,
hind DECIMAL(10,2) CHECK (hind > 0),
CONSTRAINT fk_Kaup_Liik
FOREIGN KEY (liigi_kood)
REFERENCES Liik(liigi_kood)
);

-- 4. Table Product
CREATE TABLE Product(
idProduct INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(50) NOT NULL,
idCategory INT,
Price DECIMAL(10,2) CHECK (Price > 0),
CONSTRAINT fk_Product_Category
FOREIGN KEY (idCategory)
REFERENCES Category(idCategory)
);

-- 5. Table Customer
CREATE TABLE Customer(
idCustomer INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(50) NOT NULL,
contact VARCHAR(50)
);

-- 6. Table Müük
CREATE TABLE Muuk(
muugi_kood INT PRIMARY KEY IDENTITY(1,1),
kauba_kood INT,
ostja_kood INT,
arv INT CHECK (arv > 0),
kuupaev DATE DEFAULT GETDATE(),
CONSTRAINT fk_Muuk_Kaup FOREIGN KEY (kauba_kood) REFERENCES Kaup(kauba_kood),
CONSTRAINT fk_Muuk_Customer FOREIGN KEY (ostja_kood) REFERENCES Customer(idCustomer)
);

-- 7. Table Sale
CREATE TABLE Sale(
idSale INT PRIMARY KEY IDENTITY(1,1),
idProduct INT,
idCustomer INT,
Count_pr INT CHECK (Count_pr > 0),
Date_of_sale DATE DEFAULT GETDATE(),
CONSTRAINT fk_Sale_Product FOREIGN KEY (idProduct) REFERENCES Product(idProduct),
CONSTRAINT fk_Sale_Customer FOREIGN KEY (idCustomer) REFERENCES Customer(idCustomer)
);

-- 8. Изменяем тип столбца Name в Product
ALTER TABLE Product
ALTER COLUMN Name VARCHAR(100);

-- 9. Добавляем столбец Units в Sale
ALTER TABLE Sale
ADD Units VARCHAR(20) DEFAULT 'pcs';

-- 10. Удаляем ограничение FOREIGN KEY (пример)
ALTER TABLE Product
DROP CONSTRAINT fk_Product_Category;

DROP TABLE Muuk;
DROP TABLE Kaup;
DROP TABLE Liik;