CREATE DATABASE TsalkoTrigger;
use TsalkoTrigger;
CREATE TABLE auto (
    autoID INT PRIMARY KEY IDENTITY(1,1),
    autor VARCHAR(50),
    omanik VARCHAR(50),
    mark VARCHAR(50)
);

CREATE TABLE logi (
    id INT PRIMARY KEY IDENTITY(1,1),
    kuupaev DATETIME,
    andmed TEXT,
    kasutaja VARCHAR(40)
);

--INSERT TRIGGER
Create Trigger autoLisamine
ON auto
FOR INSERT
AS
INSERT INTO logi(kuupaev, andmed, kasutaja)
SELECT
getdate(),
CONCAT('lisatud auto:', inserted.autor,' omanik:', 
inserted.omanik,
' mark:', inserted.mark,' id:', inserted.autoID),
SYSTEM_USER
From inserted;

--Kontroll
INSERT INTO auto (autor, omanik, mark)
VALUES ('Duster', 'Ilja', 'M10');
SELECT * FROM auto;
SELECT * FROM logi;

--DELETE TRIGGER
Create Trigger autoKustutamine
ON auto
FOR DELETE
AS
INSERT INTO logi(kuupaev, andmed, kasutaja)
SELECT
getdate(),
CONCAT('kustutatud auto:', deleted.autor,' omanik:', 
deleted.omanik,' mark:',
deleted.mark,' id:', deleted.autoID),
SYSTEM_USER
From deleted;

--Kontroll
DELETE FROM auto WHERE autoID=1;
SELECT * FROM logi;

--UPDATE TRIGGER
Create Trigger autoUuendamine
ON auto
FOR UPDATE
AS
INSERT INTO logi(kuupaev, andmed, kasutaja)
SELECT
getdate(),
CONCAT('vana auto:', d.autor,' omanik:', 
d.omanik,' mark:', 
d.mark,' id:', 
d.autoID, ' uued auto andmed:', i.autor,' omanik:',
i.omanik,' mark:', i.mark,' id:', i.autoID),
SYSTEM_USER
From deleted d INNER JOIN inserted i
ON d.autoID=i.autoID;

--Kontroll 
UPDATE auto
SET mark='M5 Competition'
WHERE autoID=1;

SELECT * FROM logi;