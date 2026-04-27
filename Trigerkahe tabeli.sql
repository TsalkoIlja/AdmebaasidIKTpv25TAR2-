CREATE DATABASE SQLTrigerid;
use SQLTrigerid;

--tabel linnad
Create Table linnad(
linnId int primary key identity(1,1),
linnanimi varchar(50) unique,
rahvaarv int not null)
;

--tabel logi
Create Table logi(
id int primary key identity(1,1),
kuupaev datetime,
andmed TEXT,
kasutaja varchar(25));

--tabel maakonnad
 Create Table maakonnad(
 maakondId int primary key identity(1,1),
 maakondNimi varchar(25) unique);

  --foreign key tabelis linnad
  Alter Table linnad ADD maakondId int;
  Select * From linnad;
  Alter Table linnad ADD CONSTRAINT fk_maakond
  FOREIGN KEY(maakondId) REFERENCES maakonnad(maakondId);
--täidame tabelit
--maakonnad
INSERT INTO maakonnad
VALUES ('Harjumaa'), ('Pärnumaa'), ('Virumaa');

Select * from maakonnad;
INSERT INTO linnad (linnanimi, rahvaarv, maakondId)
Values ('Tallnn', 600000, 1), ('Rakvere', 150000, 3);

Select * From linnad, maakonnad 
WHERE linnad.maakondId=maakonnad.maakondId; 

Select * From linnad inner join maakonnad 
ON linnad.maakondId=maakonnad.maakondId;


--INSERT Triger, mis jälgib kaks seostatud tabelit
Create Trigger linnaLisamine
ON linnad
FOR INSERT 
AS
INSERT INTO logi(kuupaev, andmed, kasutaja)
SELECT
getdate(),
CONCAT ('lisatud linn', inserted.linnanimi, ', ', inserted.rahvaarv, ', ', m.maakondNimi),
SYSTEM_USER
From inserted INNER JOIN maakonnad m
ON inserted.maakondId=m.maakondId;

DROP TRIGGER linnaLisamine;

--kontrollimiseks tuleb lisada uuss linn tabelsse linnad
Insert INTO linnad (linnanimi, rahvaarv, maakondId)
VALUES ('Pärnu', 100000, 2);
SELECT * From linnad;
SELECT * FROM logi;

--triger mis jälgib andmete kustutamine seotud tabelite põhjal
Create Trigger linnaKustutamine
ON linnad
FOR DELETE 
AS
INSERT INTO logi(kuupaev, andmed, kasutaja)
SELECT
getdate(),
CONCAT ('kustutatud linn: ',deleted.linnanimi, ', ', deleted.rahvaarv, ', ', m.maakondNimi),
SYSTEM_USER
From deleted INNER JOIN maakonnad m
ON deleted.maakondId=m.maakondId;


--Kontroll
delete from linnad WHERE linnId=1;
SELECT * From linnad;
SELECT * From logi;

--trigger, mis jälgib andmete uuendamine kahes tabelis
Create Trigger linnaUuendamine
ON linnad
FOR UPDATE 
AS
INSERT INTO logi(kuupaev, andmed, kasutaja)
SELECT
getdate(),
CONCAT ('vane linna andmed: ',deleted.linnanimi, ', ', deleted.rahvaarv, ', ', m1.maakondNimi, 
'uue linna andmed: ',inserted.linnanimi, ', ', inserted.rahvaarv, ', ', m2.maakondNimi),
SYSTEM_USER
from deleted
INNER JOIN inserted ON deleted.linnId=inserted.linnId
INNER JOIN maakonnad m1 ON deleted.maakondId=m1.maakondId
INNER JOIN maakonnad m2 ON deleted.maakondId=m2.maakondId;



--kontrollimiseks uuenadame linna andmed
SELECT * FROM linnad
SELECT * FROM maakonnad 
UPDATE linnad SET maakondId=1 WHERE linnId=5;

SELECT * FROM linnad;
SELECT * FROM logi;



