CREATE DATABASE trennidIT;
GO
USE trennidIT;
GO

-- Treener
CREATE TABLE Treener (
    treener_id INT IDENTITY(1,1) PRIMARY KEY,
    nimi VARCHAR(50),
    kontakt VARCHAR(20) UNIQUE
);

INSERT INTO Treener (nimi, kontakt) VALUES
('Marko Saar', '5551411'),
('Aneli Saura', '5261566'),
('Jaan Tamm', '5552222'),
('Kertu Põld', '5553333'),
('Marek Lill', '5554444');

-- Trenn
CREATE TABLE Trenn (
    trenn_id INT IDENTITY(1,1) PRIMARY KEY,
    nimetus VARCHAR(50),
    tyyp VARCHAR(50),
    raskustase VARCHAR(20),
    treener_id INT,
    FOREIGN KEY (treener_id) REFERENCES Treener(treener_id)
);

INSERT INTO Trenn (nimetus, tyyp, raskustase, treener_id) VALUES
('Jooga', 'Venitus', 'Kerge', 1),
('Box', 'Tugevus', 'Keskmine', 1),
('Pilates', 'Tasakaal', 'Kerge', 2),
('CrossFit', 'Intensiivne', 'Raske', 3),
('Zumba', 'Tants', 'Keskmine', 4);

-- Osaleja
CREATE TABLE Osaleja (
    osaleja_id INT IDENTITY(1,1) PRIMARY KEY,
    nimi VARCHAR(50),
    vanus INT,
    telefon VARCHAR(20)
);

INSERT INTO Osaleja (nimi, vanus, telefon) VALUES
('Maria Ivanova', 25, '5550001'),
('Ilja Tsalko', 30, '5540011'),
('Anna Petrova', 19, '5551111'),
('Markus Lepp', 40, '5552221'),
('Katrin Kask', 33, '5553331');

-- Registreerimine
CREATE TABLE Registreerimine (
    reg_id INT IDENTITY(1,1) PRIMARY KEY,
    trenn_id INT,
    osaleja_id INT,
    kuupaev DATE DEFAULT GETDATE(),
    staatus VARCHAR(20),
    FOREIGN KEY (trenn_id) REFERENCES Trenn(trenn_id),
    FOREIGN KEY (osaleja_id) REFERENCES Osaleja(osaleja_id)
);

INSERT INTO Registreerimine (trenn_id, osaleja_id, staatus) VALUES
(1, 1, 'Kinnitatud'),
(2, 2, 'Ootel'),
(3, 3, 'Kinnitatud'),
(4, 4, 'Tühistatud'),
(5, 5, 'Kinnitatud');

-- Дополнительная таблица
CREATE TABLE Varustus (
    varustus_id INT IDENTITY(1,1) PRIMARY KEY,
    nimetus VARCHAR(50),
    kogus INT DEFAULT 1,
    trenn_id INT,
    FOREIGN KEY (trenn_id) REFERENCES Trenn(trenn_id)
);

INSERT INTO Varustus (nimetus, kogus, trenn_id) VALUES
('Matid', 20, 1),
('Köied', 10, 4),
('Pallid', 12, 5),
('Kummid', 15, 3),
('Kettad', 30, 4);

-- Процедуры

CREATE PROCEDURE lisaOsaleja
@nimi VARCHAR(50),
@vanus INT,
@telefon VARCHAR(20)
AS
BEGIN
    INSERT INTO Osaleja (nimi, vanus, telefon)
    VALUES (@nimi, @vanus, @telefon);

    SELECT * FROM Osaleja;
END;
GO

CREATE PROCEDURE otsiTrenn
@tase VARCHAR(20)
AS
BEGIN
    SELECT * FROM Trenn
    WHERE raskustase = @tase;
END;
GO

CREATE PROCEDURE naitaReg
@osaleja INT
AS
BEGIN
    SELECT r.reg_id, t.nimetus, r.kuupaev, r.staatus
    FROM Registreerimine r
    JOIN Trenn t ON r.trenn_id = t.trenn_id
    WHERE r.osaleja_id = @osaleja;
END;
GO

-- Просмотр
SELECT * FROM Treener;
SELECT * FROM Trenn;
SELECT * FROM Osaleja;
SELECT * FROM Registreerimine;
SELECT * FROM Varustus;
