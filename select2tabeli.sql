--SELECT laused 2 tabelite põhjal
CREATE DATABASE ILJATSALKO;
USE  ILJATSALKO;
CREATE TABLE uudised(
uudisID int primary key identity(1,1),
uudisedPealkiri varchar (50),
kuupäev date,
kirjeldus TEXT,
ajakirjanikID int)
;

CREATE TABLE ajakirjanik(
ajakirjanikID int primary key identity(1,1),
nimi varchar(50),
telefon varchar(13));

ALTER TABLE uudised ADD CONSTRAINT fk_ajakirjanik
FOREIGN KEY (ajakirjanikID) REFERENCES ajakirjanik (ajakirjanikID);

INSERT INTO ajakirjanik(nimi, telefon)
Values ('Lev', '5825668'), ('Anton', '5697563'), ('Vitali', '5321678');
select * from ajakirjanik;

INSERT INTO uudised(uudisedPealkiri, kuupäev, ajakirjanikID)
values ('Homme on ises töö päev', '2025-03-12', 1),
('Täna on andmebaaside tund', '2025-03-12', 1),
('Täna on vihmane ilm', '2025-03-12', 2);

--alias-nimed kasutamine 
Select u.uudisedPealkiri, u.kirjeldus FROM uudised as u;
--u - alias-nimi uudised tabelile
SELECT * FROM uudised, ajakirjanik; --ei ole õige päring!
--uudiste tabeli kirjedb korrustatakse teise tabeli kirjaga

--õige päring
SELECT * FROM uudised, ajakirjanik
WHERE uudised.ajakirjanikID=ajakirjanik.ajakirjanikID;

--sama päring alias-nimedega
Select * from  uudised as u; ajakirjanik as a
WHERE u.ajakirjanikID=a.ajakirjanikID;

--lihtsustame päringu
SELECT u.uudisedPealkiri, a.nimi  as autor
FROM uudised as u, ajakirjanik as a
WHERE u.ajakirjanikID=a.ajakirjanikID;

--*lõikepilt tulemust
--INNER JOIN - sisemine ühendamine
SELECT u.uudisedPealkiri, a.nimi  as autor
FROM uudised as u INNER JOIN ajakirjanik as a
ON u.ajakirjanikID=a.ajakirjanikID;

--*lõikepilt tulemust

--LEFT JOIN - vasak väline ühendus
SELECT  a.nimi  as autor, u.uudisedPealkiri
FROM ajakirjanik as a LEFT JOIN  uudised as u
ON u.ajakirjanikID=a.ajakirjanikID;

--RIGHT JOIN -parem väline ühendus 
SELECT  a.nimi  as autor, u.uudisedPealkiri
FROM ajakirjanik as a RIGHT JOIN  uudised as u
ON u.ajakirjanikID=a.ajakirjanikID;

--cross join -korritab kõik read 2 tabelist omavahel
SELECT  a.nimi  as autor, u.uudisedPealkiri
FROM ajakirjanik as a cross join  uudised as u;

--3.tabel
CREATE TABLE ajaleht(
ajalehtID int primary key identity(1,1),
ajalehtNimetus varchar(50));
INSERT ajaleht(ajalehtNimetus)
Values ('Postimmees'), ('Delfi');

ALTER TABLE uudised ADD ajalehtID int;
ALTER TABLE uudised ADD constraint fk_ajaleht
FOREIGN KEY (ajalehtID) references ajaleht(ajalehtID);

UPDATE uudised SET ajalehtID=
SELECT * FROM ajaleht;
Select * from uudised;

SELECT u.uudisedPealkiri, a.nimi  as autor, aj.ajalehtNimetus
FROM uudised as u, ajakirjanik as a, ajaleht as aj
WHERE u.ajakirjanikID=a.ajakirjanikID
AND u.ajalehtID=a.ajalehtID;

--sama INNER JOIN'iga
SELECT u.uudisedPealkiri, a.nimi  as autor, aj.ajalehtNimetus
FROM (uudised as u INNER JOIN ajakirjanik as a
ON u.ajakirjanikID=a.ajakirjanikID
AND u.ajalehtID=a.ajalehtID;
