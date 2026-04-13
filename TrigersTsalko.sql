CREATE DATABASE SQLTrigerid;
use SQLTrigerid;

--tabel linnad
Create Table linnad(
linnId int primary key identity(1,1),
linnanimi varchar(50) unique,
rahvaarv int not null);

--tabel logi
Create Table logi(
Id int primary key identity(1,1),
kuupaev datetime,
andmed TEXT);

--INSERT Triger
Create Trigger linnaLisamine
ON linnad
FOR INSERT 
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
getdate(), inserted.linnanimi
From inserted;

--kontrollimiseks tuleb lisada uuss linn tabelsse linnad
Insert INTO linnad (linnanimi, rahvaarv)
VALUES ('Keila', 600000);
SELECT * From linnad;
SELECT * FROM logi;

--kustutame triger
drop Trigger linnaLisamine;

Create Trigger linnaLisamine
ON linnad
FOR INSERT 
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
getdate(), 
CONCAT ('lisatud linn:', inserted.linnanimi, 
'rahvaarv:', inserted.rahvaarv, 'id:', inserted.linnId)
From inserted;

-- DELETE TRIGGER
Create Trigger linnaKustutamine
ON linnad
FOR DELETE
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
getdate(), 
CONCAT ('kustutatud linn:', deleted.linnanimi, 
'rahvaarv:', deleted.rahvaarv, 'id:', deleted.linnId)
From deleted;

delete from linnad WHERE linnId=1;
SELECT * From linnad;
SELECT * From logi;

--UPDATE TRIGGER
Create Trigger linnaUuendamine
ON linnad
FOR UPDATE
AS
INSERT INTO logi(kuupaev, andmed)
SELECT
getdate(), 
CONCAT ('vana linn:', d.linnanimi, 
'rahvaarv:', d.rahvaarv, 'id:', d.linnId,
 'uued linna andmed:', i.linnanimi, 
'rahvaarv:', i.rahvaarv, 'id:', i.linnId)
From deleted d INNER JOIN inserted i
ON d.linnId=i.linnId;

--kontrollimiseks uuenadame linna andmed
SELECT * FROM linnad;
UPDATE linnad SET linnanimi='Tapa uss', rahvaarv=25
WHERE linnId=2;
SELECT * FROM linnad;
SELECT * FROM logi;

-- lisame kasutajaNimi logi tabelisse
ALTER TABLE logi ADD kasutaja varchar(40);

