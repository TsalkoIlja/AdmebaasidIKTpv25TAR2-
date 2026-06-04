CREATE DATABASE Tsalko;
use Tsalko;

-- 1. Tabelite loomine
CREATE TABLE ISIK (
    isik_ID INT PRIMARY KEY IDENTITY(1,1),
    eesnimi VARCHAR(50),
    perenimi VARCHAR(50),
    isikukood VARCHAR(11),
    sugu VARCHAR(10)
);

CREATE TABLE AADRESS (
    aadress_ID INT PRIMARY KEY IDENTITY(1,1),
    riik VARCHAR(50),
    linn VARCHAR(50),
    tanav VARCHAR(100),
    maja VARCHAR(10),
    korter VARCHAR(10),
    postiindeks VARCHAR(5)
);

CREATE TABLE ELAMINE (
    elamine_ID INT PRIMARY KEY IDENTITY(1,1),
    isik_ID INT,
    aadress_ID INT,
    alates DATE,
    kuni DATE,
    kommentaar VARCHAR(MAX)
);

-- 2. Tabelite omavaheline seostamine (Välisvõtmed)
ALTER TABLE ELAMINE ADD FOREIGN KEY (isik_ID) REFERENCES ISIK(isik_ID);
ALTER TABLE ELAMINE ADD FOREIGN KEY (aadress_ID) REFERENCES AADRESS(aadress_ID);

-- 3. Kasutaja loomine ja õiguste määramine
CREATE LOGIN isikNimi WITH PASSWORD = '12345!';
CREATE USER isikNimi FOR LOGIN isikNimi;
GO

-- Õiguste jagamine vastavalt ülesandele
GRANT SELECT, INSERT, UPDATE ON ELAMINE TO isikNimi;
GRANT SELECT, INSERT, UPDATE ON ISIK TO isikNimi;
GRANT SELECT ON AADRESS TO isikNimi;



-- 5. Koosta tabel logi (Puhas struktuur, täpselt 4 veergu, ilma DEFAULT piiranguteta)
CREATE TABLE logi (
    id INT IDENTITY(1,1) PRIMARY KEY,
    kasutaja VARCHAR(100),       -- Täidetakse trigeri seest väärtusega SYSTEM_USER
    kuupaev DATETIME,            -- Täidetakse trigeri seest väärtusega GETDATE()
    sisestatudAndmed VARCHAR(MAX) -- Sündmuse kirjeldus
);




-- 6. Loo triger, mis jälgib andmete uuendamist (UPDATE) tabelis Elamine
CREATE TRIGGER trg_Elamine_Uuenda
ON ELAMINE
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- SYSTEM_USER ja GETDATE() on kirjutatud otse trigeri INSERT käsule
    INSERT INTO logi (kasutaja, kuupaev, sisestatudAndmed)
    VALUES (SYSTEM_USER, GETDATE(), 'Uuendamine: Tabelis ELAMINE muudeti andmeid.');
END;
GO

-- 7. Loo triger, mis jälgib andmete lisamist (INSERT) tabelis Elamine
CREATE TRIGGER trg_Elamine_Lisa
ON ELAMINE
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- SYSTEM_USER ja GETDATE() on kirjutatud otse trigeri INSERT käsule
    INSERT INTO logi (kasutaja, kuupaev, sisestatudAndmed)
    VALUES (SYSTEM_USER, GETDATE(), 'Lisamine: Tabelisse ELAMINE lisati uus kirje.');
END;
GO

-- Ettevalmistus (Admin lisab aadressi, kuna isikNimi-l pole sinna INSERT õigust)
INSERT INTO AADRESS (riik, linn, tanav) VALUES ('Eesti', 'Tallinn', 'Tehnika tn');
GO

SELECT * FROM AADRESS;

-- Muudame äsja loodud kirjet (Käivitub triger trg_Elamine_Uuenda)
UPDATE ELAMINE SET kommentaar = 'Muudetud isikNimi sessioonis' WHERE elamine_ID = 1;
GO

SELECT * FROM ELAMINE;

SELECT * FROM logi;


-- Protseduur 1: Uue isiku lisamine
CREATE PROCEDURE LisaUusIsik
    @Eesnimi VARCHAR(50),
    @Perenimi VARCHAR(50),
    @Isikukood VARCHAR(11),
    @Sugu VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO ISIK (eesnimi, perenimi, isikukood, sugu)
    VALUES (@Eesnimi, @Perenimi, @Isikukood, @Sugu);
END;
GO

EXEC LisaUusIsik 'Mari', 'Mänd', '49905051234', 'Naine';

SELECT * FROM ISIK;

-- Protseduur 2: Uue aadressi kiire lisamine
CREATE PROCEDURE LisaUusAadress
    @Riik VARCHAR(50),
    @Linn VARCHAR(50),
    @Tanav VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AADRESS (riik, linn, tanav)
    VALUES (@Riik, @Linn, @Tanav);
END;
GO

EXEC LisaUusAadress 'Eesti', 'Tartu', 'Riia mnt';

SELECT * FROM AADRESS;

-- Protseduur 3: Elamise lõpukuupäeva salvestamine kirje ID põhjal
CREATE PROCEDURE MaaraElamiseLopp
    @ElamineID INT,
    @LoppKuupaev DATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ELAMINE
    SET kuni = @LoppKuupaev
    WHERE elamine_ID = @ElamineID;
END;
GO


EXEC MaaraElamiseLopp @ElamineID = 1, @LoppKuupaev = '2026-12-31';
GO

SELECT * FROM ELAMINE;

-- Vaade 1: Isikud koos elukoha aadressi andmetega (Seob kokku 3 tabelit)
CREATE VIEW Vaade_IsikuElukoht AS
SELECT i.eesnimi, i.perenimi, a.linn, a.tanav, e.alates, e.kuni
FROM ISIK i
INNER JOIN ELAMINE e ON i.isik_ID = e.isik_ID
INNER JOIN AADRESS a ON e.aadress_ID = a.aadress_ID;
GO

SELECT * FROM Vaade_IsikuElukoht;

-- Vaade 2: Ainult hetkel kehtivad ja aktiivsed elamised (kuni kuupäev on tühi või tulevikus)
CREATE VIEW Vaade_AktiivsedElamised AS
SELECT i.eesnimi, i.perenimi, e.alates, e.kommentaar
FROM ISIK i
INNER JOIN ELAMINE e ON i.isik_ID = e.isik_ID
WHERE e.kuni IS NULL OR e.kuni > GETDATE();
GO

SELECT * FROM Vaade_AktiivsedElamised;

-- Vaade 3: Elamiste arvulise statistika ülevaade linnade lõikes
CREATE VIEW Vaade_LinnadeStatistika AS
SELECT a.linn, COUNT(e.elamine_ID) AS ElamisteArv
FROM AADRESS a
INNER JOIN ELAMINE e ON a.aadress_ID = e.aadress_ID
GROUP BY a.linn;
GO

SELECT * FROM Vaade_LinnadeStatistika;
GO

--Loominguline element: Kasutajate turvalisuse ja süsteemiaktiivsuse auditi vaade
CREATE VIEW Vaade_KasutajateAktiivsuseAudit AS
SELECT kasutaja, 
       COUNT(id) AS TehtudMuudatusteArv,
       MAX(kuupaev) AS ViimaseTegevuseAeg
FROM logi
GROUP BY kasutaja;
GO

-- Vaate kontroll:
SELECT * FROM Vaade_KasutajateAktiivsuseAudit;
GO
