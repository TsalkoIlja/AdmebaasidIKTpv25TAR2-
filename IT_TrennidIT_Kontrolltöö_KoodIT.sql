CREATE DATABASE TrennidIT;
GO

USE TrennidIT;
GO

-- Treener
CREATE TABLE Treener (
    treener_id INT PRIMARY KEY IDENTITY(1,1),
    nimi VARCHAR(50) NOT NULL,
    kontakt VARCHAR(20)
);

INSERT INTO Treener (nimi, kontakt) VALUES
('Marko', '111'),
('Anna', '222'),
('Jaan', '333'),
('Mari', '444'),
('Kert', '555');

-- Trenn
CREATE TABLE Trenn (
    trenn_id INT PRIMARY KEY IDENTITY(1,1),
    nimetus VARCHAR(50) NOT NULL,
    kirjeldus VARCHAR(200),
    toimumisaeg VARCHAR(20),
    koht VARCHAR(50),
    raskusaste VARCHAR(20),
    treener_id INT,
    FOREIGN KEY (treener_id) REFERENCES Treener(treener_id)
);

INSERT INTO Trenn (nimetus, kirjeldus, toimumisaeg, koht, raskusaste, treener_id) VALUES
('Jooga', 'Rahulik trenn', '01.01.2024', 'Saali A', 'Kerge', 1),
('Box', 'Tugevam trenn', '02.01.2024', 'Saali B', 'Keskmine', 2),
('Pilates', 'Kerge trenn', '03.01.2024', 'Saali C', 'Kerge', 3),
('CrossFit', 'Raske trenn', '04.01.2024', 'Saali D', 'Raske', 4),
('Zumba', 'Tantsuline trenn', '05.01.2024', 'Saali E', 'Keskmine', 5);

-- Osaleja
CREATE TABLE Osaleja (
    osaleja_id INT PRIMARY KEY IDENTITY(1,1),
    nimi VARCHAR(50) NOT NULL,
    vanus INT,
    sugu CHAR(1),
    telefon VARCHAR(20)
);

INSERT INTO Osaleja (nimi, vanus, sugu, telefon) VALUES
('Maria', 25, 'N', '100'),
('Ilja', 30, 'M', '200'),
('Anna', 19, 'N', '300'),
('Markus', 40, 'M', '400'),
('Katrin', 33, 'N', '500');

-- Registreerimine
CREATE TABLE Registreerimine (
    reg_id INT PRIMARY KEY IDENTITY(1,1),
    trenn_id INT,
    osaleja_id INT,
    kuupaev VARCHAR(20),
    staatus VARCHAR(20),
    FOREIGN KEY (trenn_id) REFERENCES Trenn(trenn_id),
    FOREIGN KEY (osaleja_id) REFERENCES Osaleja(osaleja_id)
);

INSERT INTO Registreerimine (trenn_id, osaleja_id, kuupaev, staatus) VALUES
(1, 1, '05.01.2024', 'Kinnitatud'),
(2, 2, '06.01.2024', 'Ootel'),
(3, 3, '07.01.2024', 'Kinnitatud'),
(4, 4, '08.01.2024', 'Tühistatud'),
(5, 5, '09.01.2024', 'Kinnitatud');

-- Lisatabel (nõutud ülesanne)
CREATE TABLE Varustus (
    varustus_id INT PRIMARY KEY IDENTITY(1,1),
    nimetus VARCHAR(50),
    kogus INT,
    trenn_id INT,
    FOREIGN KEY (trenn_id) REFERENCES Trenn(trenn_id)
);

INSERT INTO Varustus (nimetus, kogus, trenn_id) VALUES
('Matid', 20, 1),
('Köied', 10, 4),
('Pallid', 12, 5),
('Kummid', 15, 3),
('Kettad', 30, 4);

-- Protseduur 1
CREATE PROCEDURE lisaOsaleja
@nimi VARCHAR(50),
@vanus INT,
@sugu CHAR(1),
@telefon VARCHAR(20)
AS
BEGIN
    INSERT INTO Osaleja (nimi, vanus, sugu, telefon)
    VALUES (@nimi, @vanus, @sugu, @telefon);

    SELECT * FROM Osaleja;
END;
GO

-- Protseduur 2
CREATE PROCEDURE otsiTrenn
@raskus VARCHAR(20)
AS
BEGIN
    SELECT * FROM Trenn
    WHERE raskusaste = @raskus;
END;
GO

-- Protseduur 3
CREATE PROCEDURE naitaRegistreerimisi
@osaleja_id INT
AS
BEGIN
    SELECT r.reg_id, t.nimetus, r.kuupaev, r.staatus
    FROM Registreerimine r
    JOIN Trenn t ON r.trenn_id = t.trenn_id
    WHERE r.osaleja_id = @osaleja_id;
END;
GO

-- Kontroll
SELECT * FROM Treener;
SELECT * FROM Trenn;
SELECT * FROM Osaleja;
SELECT * FROM Registreerimine;
SELECT * FROM Varustus;
