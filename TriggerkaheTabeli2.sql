CREATE DATABASE коллекциябиблиотеки;

use коллекциябиблиотеки;

Create table books (

    book_id INT,

    title VARCHAR(255),

    author VARCHAR(255),

    year INT,

    price DECIMAL(10,2)

);

Create table raamatud_logi (

    logi_id INT,

    kuupaev DATETIME,

    operatsioon VARCHAR(10),

    kasutaja VARCHAR(100)

);

--uus Tabel
CREATE TABLE zanr (
    zanr_id INT PRIMARY KEY IDENTITY(1,1),
    zanr_nimi VARCHAR(50) UNIQUE
);

ALTER TABLE books
ADD zanr_id INT;

ALTER TABLE books
ADD CONSTRAINT fk_books_zanr
FOREIGN KEY (zanr_id) REFERENCES zanr(zanr_id);

INSERT INTO zanr
VALUES ('Fantasy'), ('Classic'), ('Drama'), ('Sci-Fi'), ('Adventure');

ALTER TABLE raamatud_logi
ADD andmed TEXT;

CREATE TRIGGER raamatLisamine
ON books
FOR INSERT
AS
INSERT INTO raamatud_logi (kuupaev, operatsioon, kasutaja, andmed)
SELECT
    GETDATE(),
    'INS',
    SYSTEM_USER,
    CONCAT(
        'lisatud raamat: ',
        inserted.title, ', ',
        inserted.author, ', ',
        z.zanr_nimi, ', hind ', inserted.price
    )
FROM inserted
LEFT JOIN zanr z ON inserted.zanr_id = z.zanr_id;
--Kontroll
INSERT INTO books (book_id, title, author, year, price, zanr_id)
VALUES (10, 'Insert Kontroll Book', 'Autor A', 2020, 9.99, 2);

SELECT * FROM books;
SELECT * FROM raamatud_logi;



CREATE TRIGGER raamatKustutamine
ON books
FOR DELETE
AS
INSERT INTO raamatud_logi (kuupaev, operatsioon, kasutaja, andmed)
SELECT
    GETDATE(),
    'DEL',
    SYSTEM_USER,
    CONCAT(
        'kustutatud raamat: ',
        deleted.title, ', ',
        deleted.author, ', ',
        z.zanr_nimi, ', hind ', deleted.price
    )
FROM deleted
LEFT JOIN zanr z ON deleted.zanr_id = z.zanr_id;
GO

INSERT INTO books (book_id, title, author, year, price, zanr_id)
VALUES (11, 'Delete Kontroll Book', 'Autor B', 2019, 7.50, 3);


DELETE FROM books WHERE book_id = 11;



SELECT * FROM books;
SELECT * FROM raamatud_logi;

CREATE TRIGGER raamatUuendamine
ON books
FOR UPDATE
AS
INSERT INTO raamatud_logi (kuupaev, operatsioon, kasutaja, andmed)
SELECT
    GETDATE(),
    'UPD',
    SYSTEM_USER,
    CONCAT(
        'vana raamat: ',
        deleted.title, ', ', deleted.author, ', ',
        z1.zanr_nimi, ', hind ', deleted.price,
        ' | uus raamat: ',
        inserted.title, ', ', inserted.author, ', ',
        z2.zanr_nimi, ', hind ', inserted.price
    )
FROM deleted
INNER JOIN inserted ON deleted.book_id = inserted.book_id
LEFT JOIN zanr z1 ON deleted.zanr_id = z1.zanr_id
LEFT JOIN zanr z2 ON inserted.zanr_id = z2.zanr_id;


INSERT INTO books (book_id, title, author, year, price, zanr_id)
VALUES (5, 'Test Update Book', 'Author X', 2001, 10.00, 1);

UPDATE books
SET zanr_id = 4, price = 12.50
WHERE book_id = 5;

SELECT * FROM books;
SELECT * FROM raamatud_logi;