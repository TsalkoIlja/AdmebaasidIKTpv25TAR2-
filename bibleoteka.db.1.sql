-- Andmebaasi loomine
CREATE DATABASE biblioteka_db1;

USE biblioteka_db1;


-- 1. Žanrite tabel (Sõnastik)
CREATE TABLE zanr (
    zanr_id INT PRIMARY KEY IDENTITY(1,1),
    zanr_nimi VARCHAR(50) UNIQUE
);

-- 2. Raamatute tabel
CREATE TABLE books (
    book_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(255),
    author VARCHAR(255),
    year INT,
    price DECIMAL(10,2)
);

-- 3. Logi tabel (Toimingute ajalugu)
CREATE TABLE raamatud_logi (
    logi_id INT PRIMARY KEY IDENTITY(1,1),
    kuupaev DATETIME, 
    operatsioon VARCHAR(10),
    kasutaja VARCHAR(100),
    andmed VARCHAR(8000)
);

-- Seoste loomine tabelite vahel (Välisvõti)
ALTER TABLE books ADD zanr_id INT;

ALTER TABLE books ADD CONSTRAINT fk_books_zanr
FOREIGN KEY (zanr_id) REFERENCES zanr(zanr_id);

-- Tabelite täitmine algandmetega
INSERT INTO zanr (zanr_nimi)
VALUES ('Fantaasia'), ('Klassika'), ('Draama'), ('Ulme'), ('Seiklus');

-- Testandmete sisestamine raamatute tabelisse
INSERT INTO books (title, author, year, price, zanr_id)
VALUES ('Kevade', 'Oskar Luts', 1912, 20.00, 2), 
       ('SQL Meistriklass', 'Andres Kask', 2024, 35.00, 1);


-- TRIGERID


-- 1. INSERT triger: jälgib uue raamatu lisamist
CREATE TRIGGER raamatLisamine
ON books
FOR INSERT
AS
BEGIN
    INSERT INTO raamatud_logi (kuupaev, operatsioon, kasutaja, andmed)
    SELECT 
        GETDATE(), -- Lisame kellaaja siin, kuna tabelis pole DEFAULT väärtust
        'INSERT', 
        SYSTEM_USER, 
        CONCAT('lisatud raamat: ', i.title, ', ', i.author, ', ', z.zanr_nimi)
    FROM inserted i
    INNER JOIN zanr z ON i.zanr_id = z.zanr_id;
END;
GO

-- 1. Testime lisamist
INSERT INTO books (title, author, year, price, zanr_id)
VALUES ('Uus Teos', 'Ilja', 2026, 15.50, 4)

-- 2. DELETE triger: jälgib raamatu kustutamist
CREATE TRIGGER raamatKustutamine
ON books
FOR DELETE
AS
BEGIN
    INSERT INTO raamatud_logi (kuupaev, operatsioon, kasutaja, andmed)
    SELECT 
        GETDATE(),
        'DELETE', 
        SYSTEM_USER, 
        CONCAT('kustutatud raamat: ', d.title, ', ', d.author, ', ', z.zanr_nimi)
    FROM deleted d
    INNER JOIN zanr z ON d.zanr_id = z.zanr_id;
END;
GO

-- 2. Testime kustutamist
DELETE FROM books WHERE book_id = 2;

-- 3. UPDATE triger: jälgib andmete muutmist
CREATE TRIGGER raamatUuendamine
ON books
FOR UPDATE
AS
BEGIN
    INSERT INTO raamatud_logi (kuupaev, operatsioon, kasutaja, andmed)
    SELECT 
        GETDATE(),
        'UPDATE', 
        SYSTEM_USER, 
        CONCAT('vana raamatu andmed: ', d.title, ', ', d.author, ', ', z1.zanr_nimi, 
               ' | uue raamatu andmed: ', i.title, ', ', i.author, ', ', z2.zanr_nimi)
    FROM deleted d
    INNER JOIN inserted i ON d.book_id = i.book_id
    INNER JOIN zanr z1 ON d.zanr_id = z1.zanr_id
    INNER JOIN zanr z2 ON i.zanr_id = z2.zanr_id;
END;
GO

-- 3. Testime muutmist
UPDATE books SET title = 'Muudetud Pealkiri' WHERE book_id = 1;


-- Tulemuste vaatamine
SELECT * FROM books;
SELECT * FROM raamatud_logi;



GRANT SELECT, INSERT, UPDATE, DELETE ON books TO Raamatupidaja;
GRANT SELECT ON zanr TO Raamatupidaja;
DENY SELECT ON raamatud_logi TO Raamatupidaja;