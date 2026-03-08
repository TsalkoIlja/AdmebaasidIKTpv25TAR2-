CREATE DATABASE trennidIT_uus2;
USE trennidIT_uus2;

---------------------------------------------------------
-- Treener
---------------------------------------------------------
CREATE TABLE treener(
    treener_id INT PRIMARY KEY identity(1,1),
    nimi VARCHAR(50),
    kontakt VARCHAR(30)
);

INSERT INTO treener(nimi, kontakt)
VALUES ('Marko', '555-111'),
       ('Anna', '555-222'),
       ('Jaan', '555-333'),
       ('Mari', '555-444'),
       ('Kert', '555-555');

SELECT * FROM treener;

---------------------------------------------------------
-- Trenn
---------------------------------------------------------
CREATE TABLE trenn(
    trenn_id INT PRIMARY KEY identity(1,1),
    nimetus VARCHAR(50),
    tüüp VARCHAR(30),
    raskustase VARCHAR(20),
    treener_id INT,
    FOREIGN KEY (treener_id) REFERENCES treener(treener_id)
);

INSERT INTO trenn(nimetus, tüüp, raskustase, treener_id)
VALUES ('Jooga', 'Rahulik', 'Kerge', 1),
       ('Box', 'Võitlus', 'Keskmine', 2),
       ('Pilates', 'Venitus', 'Kerge', 3),
       ('CrossFit', 'Jõud', 'Raske', 4),
       ('Zumba', 'Tants', 'Keskmine', 5);

SELECT * FROM trenn;

---------------------------------------------------------
-- Osaleja
---------------------------------------------------------
CREATE TABLE osaleja(
    osaleja_id INT PRIMARY KEY identity(1,1),
    nimi VARCHAR(50),
    vanus INT,
    telefon VARCHAR(20)
);

INSERT INTO osaleja(nimi, vanus, telefon)
VALUES ('Maria', 25, '111'),
       ('Ilja', 30, '222'),
       ('Anna', 19, '333'),
       ('Markus', 40, '444'),
       ('Katrin', 33, '555');

SELECT * FROM osaleja;

---------------------------------------------------------
-- Registreerimine
---------------------------------------------------------
CREATE TABLE registreerimine(
    reg_id INT PRIMARY KEY identity(1,1),
    trenn_id INT,
    osaleja_id INT,
    kuupäev DATE,
    staatus VARCHAR(20),
    FOREIGN KEY (trenn_id) REFERENCES trenn(trenn_id),
    FOREIGN KEY (osaleja_id) REFERENCES osaleja(osaleja_id)
);

INSERT INTO registreerimine(trenn_id, osaleja_id, kuupäev, staatus)
VALUES (1, 1, '2024-01-05', 'Kinnitatud'),
       (2, 2, '2024-01-06', 'Ootel'),
       (3, 3, '2024-01-07', 'Kinnitatud'),
       (4, 4, '2024-01-08', 'Tühistatud'),
       (5, 5, '2024-01-09', 'Kinnitatud');

SELECT * FROM registreerimine;

---------------------------------------------------------
-- Minu lisatabel: Saal
---------------------------------------------------------
CREATE TABLE saal(
    saal_id INT PRIMARY KEY identity(1,1),
    nimetus VARCHAR(50),
    mahutavus INT,
    trenn_id INT,
    FOREIGN KEY (trenn_id) REFERENCES trenn(trenn_id)
);

INSERT INTO saal(nimetus, mahutavus, trenn_id)
VALUES ('Suur saal', 30, 1),
       ('Võitlussaal', 20, 2),
       ('Pilates ruum', 15, 3),
       ('CrossFit hall', 25, 4),
       ('Tantsusaal', 40, 5);

SELECT * FROM saal;

---------------------------------------------------------
-- ПРОЦЕДУРЫ
---------------------------------------------------------

-- 1) lisa osaleja
CREATE PROCEDURE lisaOsaleja
@nimi VARCHAR(50),
@vanus INT,
@telefon VARCHAR(20)
AS
BEGIN
    INSERT INTO osaleja(nimi, vanus, telefon)
    VALUES (@nimi, @vanus, @telefon);

    SELECT * FROM osaleja;
END;

-- 2) otsi trenn raskustaseme järgi
CREATE PROCEDURE otsiTrenn
@tase VARCHAR(20)
AS
BEGIN
    SELECT * FROM trenn
    WHERE raskustase = @tase;
END;

-- 3) näita registreerimisi osaleja järgi
CREATE PROCEDURE naitaReg
@osaleja INT
AS
BEGIN
    SELECT r.reg_id, t.nimetus, r.kuupäev, r.staatus
    FROM registreerimine r
    JOIN trenn t ON r.trenn_id = t.trenn_id
    WHERE r.osaleja_id = @osaleja;
END;

---------------------------------------------------------
-- kutsed
---------------------------------------------------------
EXEC lisaOsaleja 'Test', 20, '999';
EXEC otsiTrenn 'Kerge';
EXEC naitaReg 1;


