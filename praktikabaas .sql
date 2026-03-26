CREATE DATABASE IljaTsalko;
use IljaTsalko;
CREATE TABLE firma(
    firmaID INT NOT NULL PRIMARY KEY Identity (1,1),
    firmanimi VARCHAR(50),
    aadress VARCHAR(100),
    telefon VARCHAR(20)
);

INSERT INTO firma (firmanimi, aadress, telefon) VALUES
('TechLine', 'Pärnu mnt 10', '55512345'),
('DataHub', 'Tartu mnt 55', '55567890'),
('AlphaSoft', 'Narva mnt 3', '55598765'),
('BalticCode', 'Suur-Ameerika 12', '55511122'),
('ArendusPlus', 'Endla 45', '55522233')

Select * From firma;

CREATE TABLE praktikajuhendaja(
    praktikajuhendajaID INT NOT NULL PRIMARY KEY identity (1,1),
    eesnimi VARCHAR(30),
    perekonnanimi VARCHAR(30),
    synniaeg DATE,
    telefon VARCHAR(20)
);

INSERT INTO praktikajuhendaja (eesnimi, perekonnanimi, synniaeg, telefon) VALUES
('Marek', 'Tamm', '1985-09-12', '55544411'),
('Katrin', 'Kask', '1990-03-22', '55544422'),
('Andres', 'Mets', '1978-11-05', '55544433'),
('Liisa', 'Põld', '1988-07-19', '55544444'),
('Ilja', 'Vaher', '2009-10-30', '55544455');

Select * From praktikajuhendaja;

CREATE TABLE praktikabaas(
    praktikabaasID INT NOT NULL PRIMARY KEY Identity (1,1),
    firmaID INT,
    praktikatingimused VARCHAR(100),
    arvutiprogramm VARCHAR(50),
    juhendajaID INT,
    FOREIGN KEY (firmaID) REFERENCES firma(firmaID),
    FOREIGN KEY (juhendajaID) REFERENCES praktikajuhendaja(praktikajuhendajaID)
);

INSERT INTO praktikabaas (firmaID, praktikatingimused, arvutiprogramm, juhendajaID) VALUES
(1, 'Kontoritöö', 'Excel', 1),
(1, 'IT tugi', 'HelpDesk', 2),
(2, 'Arendus', 'Visual Studio', 3),
(3, 'Testimine', 'Jira', 4),
(4, 'Andmeanalüüs', 'Power BI', 5),
(5, 'Arendus', 'IntelliJ', 1),
(3, 'Kontoritöö', 'Office', 2),
(2, 'IT tugi', 'ServiceDesk', 4);

Select * From praktikabaas;

--Firmad, mille nimes sisaldub „a“
SELECT * FROM firma
WHERE firmanimi LIKE '%a%';

--Andmed kahest tabelist + sorteerimine
SELECT *
FROM praktikabaas
JOIN firma ON firma.firmaID = praktikabaas.firmaID
ORDER BY firmanimi;

--Mitu korda iga firma on praktikabaas
SELECT firmanimi, COUNT(praktikabaasID) AS kogus
FROM praktikabaas
JOIN firma ON firma.firmaID = praktikabaas.firmaID
GROUP BY firmanimi;

--Sügisel sündinud juhendajad
SELECT *
FROM praktikajuhendaja
WHERE MONTH(synniaeg) = 9 
   OR MONTH(synniaeg) = 10 
   OR MONTH(synniaeg) = 11;

   SELECT *
FROM praktikajuhendaja
WHERE MONTH(synniaeg) IN (9, 10, 11);

--Juhendaja praktikakohtade arv
SELECT eesnimi, perekonnanimi, COUNT(praktikabaasID) AS kohtade_arv
FROM praktikajuhendaja
LEFT JOIN praktikabaas ON praktikajuhendaja.praktikajuhendajaID = praktikabaas.juhendajaID
GROUP BY eesnimi, perekonnanimi;

--Lisa veerg palk
ALTER TABLE praktikajuhendaja
ADD palk DECIMAL(8,2);

Select * From praktikajuhendaja;

--Täida palgad
UPDATE praktikajuhendaja SET palk = 1800 WHERE praktikajuhendajaID = 1;
UPDATE praktikajuhendaja SET palk = 1500 WHERE praktikajuhendajaID = 2;
UPDATE praktikajuhendaja SET palk = 2200 WHERE praktikajuhendajaID = 3;
UPDATE praktikajuhendaja SET palk = 1700 WHERE praktikajuhendajaID = 4;
UPDATE praktikajuhendaja SET palk = 2000 WHERE praktikajuhendajaID = 5;

Select * From praktikajuhendaja;

--Keskmine palk
SELECT AVG(palk) AS keskmine_palk
FROM praktikajuhendaja;

--Kogupalk
SELECT SUM(palk) AS kogupalk
FROM praktikajuhendaja;

--Minu enda päring (näide)
SELECT firma.firmanimi, praktikabaas.arvutiprogramm
FROM praktikabaas
JOIN firma ON firma.firmaID = praktikabaas.firmaID
WHERE arvutiprogramm = 'Excel';

--VIEW-de loomine
--Firma praktikakohtade arv (põhineb päringul 3)
CREATE VIEW vw_firma_praktikakohad AS
SELECT firmanimi, COUNT(praktikabaasID) AS kogus
FROM praktikabaas
JOIN firma ON firma.firmaID = praktikabaas.firmaID
GROUP BY firmanimi;

--Sügisel sündinud juhendajad

CREATE VIEW vw_sugisel_sundinud AS
SELECT *
FROM praktikajuhendaja
WHERE MONTH(synniaeg) IN (9, 10, 11);

--Kontroll:
SELECT * FROM vw_firma_praktikakohad;
SELECT * FROM vw_sugisel_sundinud;

--6. Protseduurid
--6.1 Protseduur: lisa uus firma

CREATE PROCEDURE lisaFirma
    @firmanimi VARCHAR(50),
    @aadress VARCHAR(100),
    @telefon VARCHAR(20)
AS
BEGIN
    INSERT INTO firma (firmanimi, aadress, telefon)
    VALUES (@firmanimi, @aadress, @telefon);

    SELECT * FROM firma;
END;
GO

Select * From firma;

--Protseduur: lisa uus veerg tabelisse praktikajuhendaja
--SQL Server lubab ALTER TABLE otse protseduuris — seega see töötab:
DROP PROCEDURE IF EXISTS lisaVeergPalk;
GO
CREATE PROCEDURE lisaVeergPalk
AS
BEGIN
    IF NOT EXISTS (
        SELECT *
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'praktikajuhendaja'
          AND COLUMN_NAME = 'palk'
    )
    BEGIN
        ALTER TABLE praktikajuhendaja
        ADD palk DECIMAL(8,2);
        PRINT 'Veerg palk lisatud.';
    END
    ELSE
    BEGIN
        PRINT 'Veerg palk on juba olemas.';
    END
END;
GO

EXEC lisaVeergPalk;
GO

--Protseduur: juhendajate keskmise palga arvutamine
CREATE PROCEDURE juhendajateKeskminePalk
AS
BEGIN
    SELECT AVG(palk) AS keskmine_palk
    FROM praktikajuhendaja;
END;
GO
EXEC juhendajateKeskminePalk;
GO
