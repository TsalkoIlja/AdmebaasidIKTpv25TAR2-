CREATE DATABASE loomadVarjupaik;
USE loomadVarjupaik;

-- tabel Boks
CREATE TABLE boks(
    boks_id INT PRIMARY KEY identity(1,1),
    nimetus VARCHAR(30),
    asukoht VARCHAR(50),
    mahutavus INT
);

-- tabel Vabatahtlik
CREATE TABLE vabatahtlik(
    vabatahtlik_id INT PRIMARY KEY identity(1,1),
    nimi VARCHAR(50),
    kontakt VARCHAR(30)
);

-- tabel Loom
CREATE TABLE loom(
    loom_id INT PRIMARY KEY identity(1,1),
    liik VARCHAR(30),
    tõug VARCHAR(30),
    sugu CHAR(1),
    saabumise_kuupäev DATE,
    boks_id INT,
    FOREIGN KEY (boks_id) REFERENCES boks(boks_id)
);

-- tabel Koristus
CREATE TABLE koristus(
    koristus_id INT PRIMARY KEY identity(1,1),
    loom_id INT,
    vabatahtlik_id INT,
    kuupäev DATE,
    kestus INT,
    FOREIGN KEY (loom_id) REFERENCES loom(loom_id),
    FOREIGN KEY (vabatahtlik_id) REFERENCES vabatahtlik(vabatahtlik_id)
);

-- minu lisatabel: Toit
CREATE TABLE toit(
    toit_id INT PRIMARY KEY identity(1,1),
    nimetus VARCHAR(50),
    kogus INT,
    loom_id INT,
    FOREIGN KEY (loom_id) REFERENCES loom(loom_id)
);

-- andmete lisamine boks
INSERT INTO boks(nimetus, asukoht, mahutavus)
VALUES ('Boks A', 'Vasak tiib', 3),
       ('Boks B', 'Parem tiib', 2),
       ('Boks C', 'Keskmine ala', 4),
       ('Boks D', 'Tagumine ruum', 1),
       ('Boks E', 'Uksest paremal', 2);

-- vabatahtlikud
INSERT INTO vabatahtlik(nimi, kontakt)
VALUES ('Mari', '555-111'),
       ('Jaan', '555-222'),
       ('Kertu', '555-333'),
       ('Mark', '555-444'),
       ('Anna', '555-555');

-- loomad
INSERT INTO loom(liik, tõug, sugu, saabumise_kuupäev, boks_id)
VALUES ('Koer', 'Labrador', 'M', '2024-01-05', 1),
       ('Kass', 'Maine Coon', 'N', '2024-01-10', 2),
       ('Koer', 'Husky', 'M', '2024-01-12', 3),
       ('Kass', 'Siiam', 'N', '2024-01-15', 4),
       ('Jänes', 'Valge', 'M', '2024-01-20', 5);

-- koristused
INSERT INTO koristus(loom_id, vabatahtlik_id, kuupäev, kestus)
VALUES (1, 1, '2024-02-01', 30),
       (2, 2, '2024-02-02', 25),
       (3, 3, '2024-02-03', 40),
       (4, 4, '2024-02-04', 20),
       (5, 5, '2024-02-05', 15);

-- toit
INSERT INTO toit(nimetus, kogus, loom_id)
VALUES ('Koeratoit', 5, 1),
       ('Kassitoit', 3, 2),
       ('Koeratoit', 4, 3),
       ('Kassitoit', 2, 4),
       ('Jänesetoit', 1, 5);

SELECT * FROM loom;
SELECT * FROM boks;
SELECT * FROM vabatahtlik;
SELECT * FROM koristus;
SELECT * FROM toit;

-- protseduur 1: lisa loom
CREATE PROCEDURE lisaLoom
@liik VARCHAR(30),
@tõug VARCHAR(30),
@sugu CHAR(1),
@kuup DATE,
@boks INT
AS
BEGIN
    INSERT INTO loom(liik, tõug, sugu, saabumise_kuupäev, boks_id)
    VALUES (@liik, @tõug, @sugu, @kuup, @boks);

    SELECT * FROM loom;
END;

-- protseduur 2: otsi loomi soo järgi
CREATE PROCEDURE otsiSugu
@s CHAR(1)
AS
BEGIN
    SELECT * FROM loom WHERE sugu = @s;
END;

-- protseduur 3: näita koristusi looma järgi
CREATE PROCEDURE koristusedLoomaJargi
@id INT
AS
BEGIN
    SELECT k.koristus_id, k.kuupäev, k.kestus, v.nimi
    FROM koristus k
    JOIN vabatahtlik v ON k.vabatahtlik_id = v.vabatahtlik_id
    WHERE k.loom_id = @id;
END;

-- kutsed
EXEC lisaLoom 'Koer', 'Mops', 'M', '2024-02-10', 1;
EXEC otsiSugu 'N';
EXEC koristusedLoomaJargi 2;
