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

-- VIEW: ainult kassid

CREATE VIEW kassid AS
SELECT * FROM loom
WHERE nimi LIKE 'Kass%';

SELECT * FROM kassid;


-- VIEW: lapsed alla 16 (2026 seisuga)


CREATE VIEW LapsedAlla16 AS
SELECT nimi,
       (2026 - synniaasta) AS Vanus
FROM laps
WHERE synniaasta >= 2010;  -- 2026 - 16 = 2010

SELECT * FROM LapsedAlla16;


-- VIEW: keskmine loomakaal


CREATE VIEW keskminekaal AS
SELECT AVG(kaal) AS keskmineKaal
FROM loom;

SELECT * FROM keskminekaal;


-- VIEW: lapsed, kellel on rohkem kui 1 loom


INSERT INTO loom (nimi, kaal, lapsID)
VALUES ('Koer Nusya', 20, 1);

CREATE VIEW LapsiKellelOnRohkemKui1Loom AS
SELECT la.nimi AS LapsNimi,
       COUNT(lo.loomID) AS CountLoom
FROM laps la
JOIN loom lo ON la.lapsID = lo.lapsID
GROUP BY la.nimi
HAVING COUNT(lo.loomID) > 1;

SELECT * FROM LapsiKellelOnRohkemKui1Loom;


-- VIEW: loomad (updateable)

CREATE VIEW loomad AS
SELECT loomID, nimi, kaal
FROM loom;

SELECT * FROM loomad;


-- KAALU SUURENDAMINE 10%


UPDATE loom
SET kaal = kaal * 1.1;   -- view kaudu ei saa, tabeli kaudu saab
