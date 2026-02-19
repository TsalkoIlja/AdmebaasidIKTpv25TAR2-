CREATE DATABASE Tsalko1;
use Tsalko1;
--tabel lugeja
Create table lugeja(
lugeja_id int primary key identity(1,1),
name varchar(30)  UNIQUE,
kontakt TEXT,
registreeritud INT)
INSERT INTO lugeja(name, kontakt, registreeritud)
VALUES ('seiklus', '5567785', '66787' );
SELECT * FROM lugeja;


--tabel zanr

CREATE TABLE zanr(
zanrID int PRIMARY KEY identity (1,1),
zanrNimetus  varchar(50) UNIQUE,
kirjeldus TEXT)
INSERT INTO zanr(zanrNimetus, kirjeldus)
VALUES 
('seiklus', 'on põnev roman' );

SELECT * FROM zanr;

--tabel raamat
CREATE TABLE raamat(
raamatu_id int not null primary key identity(1,1),
pealkiri varchar(50) UNIQUE,
zanr_id int,
FOREIGN KEY (zanr_id) REFERENCES zanr,

hind int,
isbn int,);

INSERT INTO raamat
(pealkiri, zanr_id, hind, isbn)
VALUES 
('Sipsik', 1, 20, 3)
SELECT * FROM raamat;
SELECT * FROM zanr;
SELECT * FROM lugeja;








