CREATE DATABASE raamatukoguIT;
USE raamatukoguIT;

-- tabel Žanr
CREATE TABLE zanr(
    zanr_id INT PRIMARY KEY identity(1,1),
    nimetus VARCHAR(50),
    kirjeldus TEXT
);

-- tabel Raamat
CREATE TABLE raamat(
    raamat_id INT PRIMARY KEY identity(1,1),
    pealkiri VARCHAR(100),
    zanr_id INT,
    hind DECIMAL(6,2),
    isbn VARCHAR(20),
    FOREIGN KEY (zanr_id) REFERENCES zanr(zanr_id)
);

-- tabel Lugeja
CREATE TABLE lugeja(
    lugeja_id INT PRIMARY KEY identity(1,1),
    nimi VARCHAR(50),
    kontakt VARCHAR(30),
    registreeritud DATE
);

-- tabel Laenutus
CREATE TABLE laenutus(
    laenutus_id INT PRIMARY KEY identity(1,1),
    raamat_id INT,
    lugeja_id INT,
    kogus INT,
    ühik VARCHAR(10),
    laenutuse_kuupäev DATE,
    FOREIGN KEY (raamat_id) REFERENCES raamat(raamat_id),
    FOREIGN KEY (lugeja_id) REFERENCES lugeja(lugeja_id)
);

-- minu lisatabel: Tagastus
CREATE TABLE tagastus(
    tagastus_id INT PRIMARY KEY identity(1,1),
    laenutus_id INT,
    kuupäev DATE,
    seisukord VARCHAR(50),
    FOREIGN KEY (laenutus_id) REFERENCES laenutus(laenutus_id)
);

-- andmete lisamine zanr
INSERT INTO zanr(nimetus, kirjeldus)
VALUES ('Ulme', 'Kosmos, tulevik, tehnoloogia'),
       ('Krimi', 'Detektiivid ja uurimised'),
       ('Fantaasia', 'Maagia ja müüdid'),
       ('Draama', 'Tõsine kirjandus'),
       ('Õudus', 'Hirmutavad lood');

-- raamatud
INSERT INTO raamat(pealkiri, zanr_id, hind, isbn)
VALUES ('Düün', 1, 19.99, 'ISBN111'),
       ('Sherlock Holmes', 2, 14.50, 'ISBN222'),
       ('Sõrmuste Isand', 3, 25.00, 'ISBN333'),
       ('Vennad Karamazovid', 4, 18.75, 'ISBN444'),
       ('IT', 5, 22.40, 'ISBN555');

-- lugejad
INSERT INTO lugeja(nimi, kontakt, registreeritud)
VALUES ('Maria', '555-111', '2024-01-01'),
       ('Ilja', '555-222', '2024-01-05'),
       ('Anna', '555-333', '2024-01-10'),
       ('Markus', '555-444', '2024-01-15'),
       ('Katrin', '555-555', '2024-01-20');

-- laenutused
INSERT INTO laenutus(raamat_id, lugeja_id, kogus, ühik, laenutuse_kuupäev)
VALUES (1, 1, 1, 'tk', '2024-02-01'),
       (2, 2, 1, 'tk', '2024-02-02'),
       (3, 3, 1, 'tk', '2024-02-03'),
       (4, 4, 1, 'tk', '2024-02-04'),
       (5, 5, 1, 'tk', '2024-02-05');

-- tagastused
INSERT INTO tagastus(laenutus_id, kuupäev, seisukord)
VALUES (1, '2024-02-10', 'Hea'),
       (2, '2024-02-12', 'Rahuldav'),
       (3, '2024-02-15', 'Hea'),
       (4, '2024-02-18', 'Väga hea'),
       (5, '2024-02-20', 'Kahjustatud');

SELECT * FROM zanr;
SELECT * FROM raamat;
SELECT * FROM lugeja;
SELECT * FROM laenutus;
SELECT * FROM tagastus;

-- protseduur 1: lisa uus raamat
CREATE PROCEDURE lisaRaamat
@pealkiri VARCHAR(100),
@zanr INT,
@hind DECIMAL(6,2),
@isbn VARCHAR(20)
AS
BEGIN
    INSERT INTO raamat(pealkiri, zanr_id, hind, isbn)
    VALUES (@pealkiri, @zanr, @hind, @isbn);

    SELECT * FROM raamat;
END;

-- protseduur 2: otsi raamat žanri järgi
CREATE PROCEDURE otsiZanr
@z INT
AS
BEGIN
    SELECT r.pealkiri, z.nimetus, r.hind
    FROM raamat r
    JOIN zanr z ON r.zanr_id = z.zanr_id
    WHERE r.zanr_id = @z;
END;

-- protseduur 3: näita laenutusi lugeja järgi
CREATE PROCEDURE laenutusedLugeja
@id INT
AS
BEGIN
    SELECT l.laenutus_id, r.pealkiri, l.laenutuse_kuupäev
    FROM laenutus l
    JOIN raamat r ON l.raamat_id = r.raamat_id
    WHERE l.lugeja_id = @id;
END;

-- kutsed
EXEC lisaRaamat 'Testiraamat', 1, 10.50, 'ISBN999';
EXEC otsiZanr 3;
EXEC laenutusedLugeja 2;
