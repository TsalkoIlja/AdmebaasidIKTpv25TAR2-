CREATE DATABASE trennidIT;
USE trennidIT;

CREATE TABLE Treener(
treener_id INT PRIMARY KEY IDENTITY(1,1),
nimi VARCHAR(50) NOT NULL,
kontakt VARCHAR(20) UNIQUE NOT NULL
);
INSERT INTO Treener (nimi, kontakt)
VALUES ('Marko Saar', '5551411'),
('Aneli Saura', '5261566');

CREATE TABLE Trenn(
trenn_id INT PRIMARY KEY IDENTITY(1,1),
nimetus VARCHAR(50) NOT NULL,
kirjeldus VARCHAR(200),
toimumisaeg DATETIME NOT NULL,
koht VARCHAR(50) NOT NULL,
treener_id INT,
raskusaste VARCHAR(20) CHECK (raskusaste IN ('Kerge', 'Keskmine', 'Raske')),
FOREIGN KEY (treener_id) REFERENCES Treener(treener_id) 
);
INSERT INTO Trenn (nimetus, kirjeldus, toimumisaeg, koht, raskusaste, treener_id) VALUES
('Jooga', 'Rahulik treening', '2024', 'Saali A', 'Kerge', 1),
('Box', 'Tugevus treening', '2025', 'Saali B', 'Keskmine', 1);

CREATE TABLE Osaleja(
osaleja_id INT PRIMARY KEY IDENTITY(1,1),
nimi VARCHAR(50) NOT NULL,
vanus INT CHECK (vanus>= 5 AND vanus <=100),
sugu CHAR(1) CHECK (sugu IN('M', 'N')),
telefon VARCHAR(20) UNIQUE 
);
INSERT INTO Osaleja (nimi, vanus, sugu, telefon) VALUES
('Maria Ivanova', 25, 'N', '5550001'),
('Ilja Tsalko', 30, 'M', '5540011');

CREATE TABLE Registreerimine(
reg_id INT PRIMARY KEY IDENTITY(1,1),
trenn_id INT NOT NULL,
osaleja_id INT NOT NULL,
kuupäev DATE,
staatus VARCHAR(20) CHECK (staatus IN ('Kinnitatud', 'Ootel', 'Tühistatud')),
FOREIGN KEY (trenn_id) REFERENCES Trenn(trenn_id),
FOREIGN KEY (osaleja_id) REFERENCES Osaleja(osaleja_id)
);
INSERT INTO Registreerimine (trenn_id, osaleja_id, staatus) VALUES
(2, 25, 'Kinnitatud'),
(4, 30, 'Ootel');

CREATE PROCEDURE lisaOsaleja
@nimi VARCHAR(50),
@vanus INT,
@sugu CHAR(1),
@telefon VARCHAR(20)
AS
BEGIN
INSERT INTO Osaleja (nimi, vanus, sugu, telefon)
VALUES (@nimi), @vanus, @sugu, @telefon);

SELECT * From Osaleja;
END;
GO

CREATE PROCEDURE otsiTrenn
@raskus VARCHAR(20)
AS
BEGIN
SELECT * FROM Trenn
WHERE raskusaste = @raskus;
END;
GO

SELECT * FROM Osaleja;
SELECT * FROM Registreerimine;
SELECT * FROM Treener;
SELECT * FROM Trenn;

