-- Создание базы данных
CREATE DATABASE loomad;
GO
USE loomad;
GO

-- Таблица loom
CREATE TABLE loom (
    loom_id INT PRIMARY KEY IDENTITY(1,1),
    nimi VARCHAR(50),
    liik VARCHAR(50),
    vanus INT,
    kaal DECIMAL(5, 2)
);

-- Вставка данных в loom
INSERT INTO loom (nimi, liik, vanus, kaal)
VALUES ('Muxy', 'Kass', 3, 4.50);
INSERT INTO loom (nimi, liik, vanus, kaal)
VALUES ('Rex', 'Koer', 5, 25.00);
INSERT INTO loom (nimi, liik, vanus, kaal)
VALUES ('Fluffy', 'Jänes', 2, 2.30);
INSERT INTO loom (nimi, liik, vanus, kaal)
VALUES ('Tweety', 'Lind', 1, 0.05);
INSERT INTO loom (nimi, liik, vanus, kaal)
VALUES ('Nemo', 'Kala', 1, 0.10);

-- Таблица boks
CREATE TABLE boks (
    boks_id INT PRIMARY KEY IDENTITY(1,1),
    number INT,
    nimetus VARCHAR(50),
    suurus VARCHAR(20)
);

-- Вставка данных в boks
INSERT INTO boks (number, nimetus, suurus)
VALUES (1, 'Kassiboks', 'Väike');
INSERT INTO boks (number, nimetus, suurus)
VALUES (2, 'Koerapagas', 'Suur');
INSERT INTO boks (number, nimetus, suurus)
VALUES (3, 'Jänese puur', 'Keskmise');
INSERT INTO boks (number, nimetus, suurus)
VALUES (4, 'Linnu puur', 'Väike');
INSERT INTO boks (number, nimetus, suurus)
VALUES (5, 'Akvaarium', 'Suur');

-- Таблица koristus
CREATE TABLE koristus (
    koristus_id INT PRIMARY KEY IDENTITY(1,1),
    loom_id INT,
    boks_id INT,
    kuupäev DATE,
    FOREIGN KEY (loom_id) REFERENCES loom(loom_id),
    FOREIGN KEY (boks_id) REFERENCES boks(boks_id)
);

-- Вставка данных в koristus
INSERT INTO koristus (loom_id, boks_id, kuupäev)
VALUES (1, 1, '2024-01-15');
INSERT INTO koristus (loom_id, boks_id, kuupäev)
VALUES (2, 2, '2024-02-20');
INSERT INTO koristus (loom_id, boks_id, kuupäev)
VALUES (3, 3, '2024-03-10');
INSERT INTO koristus (loom_id, boks_id, kuupäev)
VALUES (4, 4, '2024-04-05');
INSERT INTO koristus (loom_id, boks_id, kuupäev)
VALUES (5, 5, '2024-05-12');

-- Таблица vabatahtlik
CREATE TABLE vabatahtlik (
    vabatahtlik_id INT PRIMARY KEY IDENTITY(1,1),
    nimi VARCHAR(50),
    kontakt VARCHAR(20)
);

-- Вставка данных в vabatahtlik
INSERT INTO vabatahtlik (nimi, kontakt)
VALUES ('Maria Ivanova', '5551234567');
INSERT INTO vabatahtlik (nimi, kontakt)
VALUES ('Jaan Tamm', '5559876543');
INSERT INTO vabatahtlik (nimi, kontakt)
VALUES ('Anna Petrov', '5552468135');
INSERT INTO vabatahtlik (nimi, kontakt)
VALUES ('Peeter Saar', '5553691472');
INSERT INTO vabatahtlik (nimi, kontakt)
VALUES ('Sofia Räis', '5554825936');

-- Просмотр данных
SELECT * FROM loom;
SELECT * FROM boks;
SELECT * FROM koristus;
SELECT * FROM vabatahtlik;

-- UPDATE loom
UPDATE loom 
SET vanus = 4
WHERE loom_id = 1;


-- PROCEDURE: добавление животного

CREATE PROCEDURE lisaLoom
@nimi VARCHAR(50),
@liik VARCHAR(50),
@vanus INT,
@kaal DECIMAL(5, 2)
AS
BEGIN
    INSERT INTO loom (nimi, liik, vanus, kaal) 
    VALUES (@nimi, @liik, @vanus, @kaal);

    SELECT * FROM loom;
END;
GO

-- Вызов
EXEC lisaLoom 'Bella', 'Kass', 2, 3.50;
GO


-- PROCEDURE: удаление животного по id

CREATE PROCEDURE kustutaLoom
@id INT
AS
BEGIN
    SELECT * FROM loom;
    DELETE FROM loom WHERE loom_id = @id;
    SELECT * FROM loom;
END;
GO

-- Вызов
EXEC kustutaLoom 6;
GO


-- PROCEDURE: поиск животного по первой букве

CREATE PROCEDURE otsiLoom
@taht CHAR(1)
AS
BEGIN
    SELECT * FROM loom 
    WHERE nimi LIKE @taht + '%';
END;
GO

-- Вызов
EXEC otsiLoom 'M';
GO


-- PROCEDURE: обновление животного

CREATE PROCEDURE uuendaLoom
@id INT,
@uus_nimi VARCHAR(50)
AS
BEGIN
    SELECT * FROM loom;
    UPDATE loom 
    SET nimi = @uus_nimi
    WHERE loom_id = @id;
END;
GO

-- Вызов
EXEC uuendaLoom 1, 'Muxik';
GO