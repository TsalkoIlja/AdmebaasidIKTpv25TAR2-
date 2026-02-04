CREATE DATABASE tsalkoTAR1;
use tsalkoTAR1;

--tabeli loomine 
CREATE TABLE tootaja(
tootajaID int PRIMARY KEY identity (1,1),
eesnimi varchar(30),
perenimi varchar(30),
synniaeg date,
koormus decimal (5,2),
elukoht TEXT,
abielus bit
);
--tabeli kustutamine
drop table tootaja;
--tabeli kuvamine
select * from tootaja;

--andmete lisamine tabelisse
INSERT INTO  tootaja(eesnimi, perenimi, synniaeg)
VALUES ('Mark', 'Päev', '2022-10-13'),
('Ilja', 'Päev', '2020-10-13');