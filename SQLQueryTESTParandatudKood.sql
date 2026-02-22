CREATE DATABASE Tsalko1;
GO
use Tsalko1;
GO

--TABEL LUGEJA
Create table lugeja(
lugeja_id int primary key identity(1,1),
name varchar(30) UNIQUE,
kontakt varchar(100),              
registreeritud date DEFAULT GETDATE()   
);
INSERT INTO lugeja(name, kontakt)
VALUES 
('Mari', '5567785'),
('Jaan', '5561111'),
('Kati', '5562222'),
('Peeter', '5563333'),
('Liisa', '5564444');

SELECT * FROM lugeja;

--TABEL ZANR
CREATE TABLE zanr(
zanrID int PRIMARY KEY identity (1,1),
zanrNimetus varchar(50) UNIQUE NOT NULL,
kirjeldus varchar(200)
);
INSERT INTO zanr(zanrNimetus, kirjeldus)
VALUES 
('seiklus', 'on põnev roman'),
('romaan', 'armastuslugu'),
('ulme', 'teaduslik fantaasia'),
('krimi', 'kriminaallugu'),
('laste', 'lasteraamat');

SELECT * FROM zanr;

--TABEL RAAMAT
CREATE TABLE raamat(
raamatu_id int not null primary key identity(1,1),
pealkiri varchar(50) UNIQUE NOT NULL,
zanr_id int NOT NULL,
hind decimal(6,2) CHECK (hind > 0),  
isbn varchar(20) UNIQUE,

CONSTRAINT fk_zanr
FOREIGN KEY (zanr_id) REFERENCES zanr(zanrID)   
);
INSERT INTO raamat
(pealkiri, zanr_id, hind, isbn)
VALUES 
('Sipsik', 1, 20, '111'),
('Kevade', 2, 15, '222'),
('Tulnukas', 3, 25, '333'),
('Detektiiv', 4, 18, '444'),
('Naksitrallid', 5, 22, '555');

SELECT * FROM raamat;

--TABEL LAENUTUS
CREATE TABLE laenutus(
laenutus_id int primary key identity(1,1),
raamatu_id int NOT NULL,
lugeja_id int NOT NULL,
kogus int CHECK (kogus > 0),
uhik varchar(10) DEFAULT 'tk',
laenutuse_kuupaev date DEFAULT GETDATE(),

CONSTRAINT fk_raamat
FOREIGN KEY (raamatu_id) REFERENCES raamat(raamatu_id),

CONSTRAINT fk_lugeja
FOREIGN KEY (lugeja_id) REFERENCES lugeja(lugeja_id)
);
INSERT INTO laenutus(raamatu_id, lugeja_id, kogus)
VALUES
(1,1,1),
(2,2,1),
(3,3,2),
(4,4,1),
(5,5,1);

SELECT * FROM laenutus;
GO

--3 STORED PROCEDURES

-- 1. Lisa uus lugeja

CREATE PROCEDURE lisaLugeja
@nimi VARCHAR(30),
@kontakt VARCHAR(100)
AS
BEGIN
INSERT INTO lugeja (name, kontakt)  
VALUES (@nimi, @kontakt);

SELECT * FROM lugeja;
END;
GO

-- Вызов
EXEC lisaLugeja 'Liisa', 'liisa@email.com';
GO


-- 2. Kustuta raamat
CREATE PROCEDURE kustutaRaamat
@id int
AS
BEGIN
DELETE FROM raamat
WHERE raamatu_id = @id;

SELECT * FROM raamat;
END;
GO


-- 3. Otsi raamat esimese tähe järgi
CREATE PROCEDURE otsiRaamat
@taht char(1)
AS
BEGIN
SELECT * FROM raamat
WHERE pealkiri LIKE @taht + '%';
END;
GO


-- TEST
EXEC lisaLugeja 'Test', '999999';
EXEC otsiRaamat 'S';