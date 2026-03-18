Create database Tsalkoview;
use Tsalkoview;

CREATE TABLE laps(
    lapsID INT NOT NULL PRIMARY KEY Identity,
    nimi VARCHAR(40) NOT NULL,
    pikkus SMALLINT,
    synniaasta INT NULL,
    synnilinn VARCHAR(15)
);

INSERT INTO laps(nimi, pikkus, synniaasta, synnilinn)
Values ('Matvei', 150, 2005, 'Tallinn'),
('andrei', 155, 2006, 'Tallinn'),
('Ilja', 160, 2007, 'Tallinn'),
('Maks ', 145, 2015, 'Tallinn'),
('Damian', 150, 2005, 'Tartu');

CREATE TABLE loom(
    loomID INT NOT NULL PRIMARY KEY Identity,
    nimi VARCHAR(40) NOT NULL,
    kaal SMALLINT,
    lapsID INT,
    FOREIGN KEY (lapsID) REFERENCES laps(lapsID)
);

INSERT INTO loom(nimi, kaal, lapsID)
VALUES  ('koer Musa', 5, 1), ('Kass Muu', 5, 1),
('hamster Test', 1, 2), ('Jänes Lill', 2, 2);

SELECT * FROM loom;
SELECT * FROM laps;
--select lause 2 seotud tabelite põhjal 
SELECT * FROM laps INNER JOIN loom
ON laps.lapsID=loom.lapsID;
--kitsaim variant
SELECT  l.nimi, lm.nimi  FROM laps l INNER JOIN loom lm
ON l.lapsID=lm.lapsID;

--salvestame päring view abil
CREATE VIEW sisestatud_lapsiloomad AS
SELECT  l.nimi as lapsNimi, lm.nimi  as loomNimi
FROM laps l INNER JOIN loom lm
ON l.lapsID=lm.lapsID;

--kasutame salvestatud view
SELECT * FROM sisestatud_lapsiloomad;
--21.
CREATE VIEW lapsedIlmaLoomata AS
SELECT lp.nimi AS lapsenimi, 
       l.nimi AS loomanimi, 
       l.kaal, 
       lp.synnilinn
FROM laps AS lp LEFT JOIN loom AS l
ON l.lapsID = lp.lapsID;
----kasutame salvestatud view
Select * from lapsedIlmaLoomata;
Select lapsenimi, loomanimi from lapsedIlmaLoomata;

CREATE TABLE varjupaik(
    varjupaikID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    koht VARCHAR(50) NOT NULL,
    firma VARCHAR(30)
);

ALTER TABLE loom 
ADD varjupaikID INT;

ALTER TABLE loom 
ADD CONSTRAINT fk_varjupaik
FOREIGN KEY (varjupaikID) REFERENCES varjupaik(varjupaikID);

INSERT INTO varjupaik(koht, firma)
VALUES ('Paljassaare', 'Varjupaikade MTÜ');


UPDATE loom 
SET varjupaikID = 1;

--loome view/ mi kasutab 3 tabeli
CREATE VIEW lapseloomadVarjupaigas AS
SELECT lp.nimi AS lapsenimi, 
       l.nimi AS loomanimi, 
       v.koht
FROM laps AS lp, loom AS l, varjupaik AS v
WHERE l.lapsID = lp.lapsID 
AND l.varjupaikID = v.varjupaikID;
--kasutame salvestatud view
Select * from lapseloomadVarjupaigas;
--dbo - database object

--Tee view, kus on ainult kassid
CREATE VIEW kassid AS
SELECT * from loom
WHERE nimi like 'kass%';

select * from kassid;
--Tee view, kus on lapsed alla 16 aastat
CREATE VIEW LapsedAlla16 AS
SELECT nimi, synniaasta (2026 synniaasta) AS Vanus FROM Laps
WHERE synniaasta >=2008;

SELECT * FROM LapsedAlla16;

--view mis arvutab keskmine loomakaal
create view keskminekaal AS
select AVG(kaal) as keskmineKaal from loom;
Select * from keskminekaal;

-- Loome vaate, mis näitab lapsi, kellel on rohkem kui 1 loom
INSERT INTO loom (nimi, kaal, lapsID)
VALUES
('Koer Nusya', 20, 1);

CREATE view LapsiKellelOnRohkemKui1Loom as
SELECT la.nimi as LapsNimi, Count(lo.nimi) as CountLoom
FROM laps la INNER JOIN loom lo
ON la.lapsID=lo.lapsID
WHERE Count(lo.nimi) > 1
GROUP BY la.nimi;

CREATE VIEW loomad AS
SELECT nimi, kaal from loom;

select * from loom;
SELECT * FROM loomad;
-- suurendame kaal 10% võrra
UPDATE loomad SET kaal =kaal*2;