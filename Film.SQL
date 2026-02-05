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
SELECT * FROM film;
Select * FROM rezisoor;

drop table rezisoor;

Insert into film(filmNimetus, rezisoorID, pikkus, v_aasta)
Values(Jurassic world, 4, 120, 1987)
