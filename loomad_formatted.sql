CREATE DATABASE loomade_andmebaas;
USE loomade_andmebaas;

-- Boks tabel
CREATE TABLE boks(
    boks_id INT PRIMARY KEY identity(1,1),
    nimetus VARCHAR(50),
    asukoht VARCHAR(50),
    mahutavus INT
);

INSERT INTO boks(nimetus, asukoht, mahutavus)
VALUES ('Boks A', '1. korrus', 3),
       ('Boks B', '1. korrus', 2),
       ('Boks C', '2. korrus', 4),
       ('Boks D', '2. korrus', 1),
       ('Boks E', '3. korrus', 5);

SELECT * FROM boks;

-- Vabatahtlik tabel
CREATE TABLE vabatahtlik(
    vabatahtlik_id INT PRIMARY KEY identity(1,1),
    nimi VARCHAR(50),
    kontakt VARCHAR(30)
);

INSERT INTO vabatahtlik(nimi, kontakt)
VALUES ('Anna', '555-111'),
       ('Markus', '555-222'),
       ('Katrin', '555-333'),
       ('Ilja', '555-444'),
       ('Maria', '555-555');

SELECT * FROM vabatahtlik;

-- Loom tabel
CREATE TABLE loom(
    loom_id INT PRIMARY KEY identity(1,1),
    nimi VARCHAR(50),
    liik VARCHAR(50),
    tõug VARCHAR(50),
    sugu VARCHAR(10),
    saabumise_kuupäev DATE,
    boks_id INT,
    FOREIGN KEY (boks_id) REFERENCES boks(boks_id)
);

INSERT INTO loom(nimi, liik, tõug, sugu, saabumise_kuupäev, boks_id)
VALUES ('Muri', 'Koer', 'Labrador', 'Isane', '2024-01-10', 1),
       ('Miisu', 'Kass', 'Siiam', 'Emane', '2024-01-12', 2),
       ('Rex', 'Koer', 'Husky', 'Isane', '2024-01-15', 3),
       ('Bella', 'Kass', 'Maine Coon', 'Emane', '2024-01-18', 4),
       ('Poku', 'Jänes', 'Valge', 'Isane', '2024-01-20', 5);

SELECT * FROM loom;

-- Koristus tabel
CREATE TABLE koristus(
    koristus_id INT PRIMARY KEY identity(1,1),
    loom_id INT,
    vabatahtlik_id INT,
    kuupäev DATE,
    kestus INT,
    FOREIGN KEY (loom_id) REFERENCES loom(loom_id),
    FOREIGN KEY (vabatahtlik_id) REFERENCES vabatahtlik(vabatahtlik_id)
);

INSERT INTO koristus(loom_id, vabatahtlik_id, kuupäev, kestus)
VALUES (1, 1, '2024-02-01', 30),
       (2, 2, '2024-02-02', 25),
       (3, 3, '2024-02-03', 40),
       (4, 4, '2024-02-04', 20),
       (5, 5, '2024-02-05', 35);

SELECT * FROM koristus;

-- Protseduur: lisa loom
CREATE PROCEDURE lisaLoom
@nimi VARCHAR(50),
@liik VARCHAR(50),
@tõug VARCHAR(50),
@sugu VARCHAR(10),
@kuupäev DATE,
@boks INT
AS
BEGIN
    INSERT INTO loom(nimi, liik, tõug, sugu, saabumise_kuupäev, boks_id)
    VALUES (@nimi, @liik, @tõug, @sugu, @kuupäev, @boks);
    SELECT * FROM loom;
END;
GO

EXEC lisaLoom 'TestLoom', 'Koer', 'Segavereline', 'Isane', '2024-03-01', 1;
GO

-- Protseduur: otsi loom liigi järgi
CREATE PROCEDURE otsiLoomLiigiJargi
@liik VARCHAR(50)
AS
BEGIN
    SELECT * FROM loom
    WHERE liik = @liik;
END;
GO

EXEC otsiLoomLiigiJargi 'Koer';
GO

-- Protseduur: näita koristusi looma järgi
CREATE PROCEDURE naitaKoristusi
@loom INT
AS
BEGIN
    SELECT k.koristus_id, l.nimi AS loom, v.nimi AS vabatahtlik, k.kuupäev, k.kestus
    FROM koristus k
    JOIN loom l ON k.loom_id = l.loom_id
    JOIN vabatahtlik v ON k.vabatahtlik_id = v.vabatahtlik_id
    WHERE k.loom_id = @loom;
END;
GO

EXEC naitaKoristusi 1;
GO
