USE biblioteka_db1;
GO

SELECT * FROM raamatud_logi;

INSERT INTO books (title, author, year, price, zanr_id)
VALUES ('Test-Raamat', 'Minu Autor', 2026, 9.99, 1);

DELETE FROM books WHERE book_id = 3;

UPDATE books SET title = 'Muudetud Pealkiri' WHERE book_id = 1;

SELECT * FROM books;

SELECT * FROM zanr;

CREATE TRIGGER test_trigger ON books FOR INSERT AS PRINT 'Test';
