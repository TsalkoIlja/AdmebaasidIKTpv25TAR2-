CREATE DATABASE filmTsalko;
use filmTsalko;
--tabeli rezisoor loomine
CREATE TABLE rezisoor(
rezisoorID int PRIMARY KEY identity (1,1),
eesnimi varchar(20),
perenimi varchar(20) UNIQUE,
synnaasta int);
Select * from rezisoor;
--tabeli täitmine
INSERT INTO rezisoor(eesnimi, perenimi,synnaasta)
VALUES ('James', 'Cameron', 1987),
('Robert', 'De Niro', 1967),
('David', 'Lunch', 1957);

--tabeli film loomine
CREATE TABLE film(
filmID int PRIMARY KEY identity (1,1),
filmNimetus varchar(100),
pikkus int,
rezisoorID int,
Select * FROM film,
Select * FROM rezisoor;

drop table rezisoor;

Insert into film (filmNimetus, rezisoorID, pikkus, v_aasta)
Values(Jurassic World, 4, 120, 1987)

--tabel zanr
CREATE TABLE zanr(
zanrID int PRIMARY KEY identity (1,1),
zanrNimetus  varchar(50) UNIQUE,
kirjeldus TEXT)

INSERT INTO zanr(zanrNimetus, kirjeldus)
VALUES ('komöödia', 'on põnev film' );
SELECT * FROM zanr;

--tabeli struktuuri muutmine - uue veergu liisamine
ALTER TABLE film ADD zanrID int;
select * from film;
--FK lisamine
ALTER TABLE film ADD CONSTRAINT fk_zanr
FOREIGN KEY (zanrID) references zanr (zanrID);
--tabeli uuendamine 
UPDATE film SET zanrID=2 WHERE filmID=2;
UPDATE film SET zanrID=1 WHERE filmID>ID;

-- tabeli tootja looomine 
CREATE TABLE tootja(
tootjaID int PRIMARY KEY identity (1,1),
tootjaNimi  varchar(50) UNIQUE,
asukoht int)
select * from tootja;



