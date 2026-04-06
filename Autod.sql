CREATE DATABASE Autod;
USE Autod;


--Varv
CREATE TABLE Varv(
varvID INT PRIMARY KEY identity(1,1),
varv varchar(50) UNIQUE,
);

Insert into Varv(varv)
Values ('valge'),
('punane'),
('sinine');


SELECT * FROM Varv;

	   
--Autod 
CREATE TABLE Autod(
autoID INT PRIMARY KEY identity(1,1),
automark varchar(50),
automudell varchar(50),
varvID INT,
autonumber varchar(20),
kaqukast varchar(10),
kliimaseade varchar(10),
hind INT,
FOREIGN KEY (varvID) REFERENCES Varv(varvID)
);

INSERT INTO Autod(automark, automudell, varvID, autonumber, kaqukast, kliimaseade, hind)
VALUES ('BMW', 'CX-5', 1, '123 DDD', 'A', 'True', 12000),
('BMW', 'CX-3', 1, '145 PPP', 'A', 'False', 125689),
('Mazda', '3', 2, '155 IYU', 'M', 'True', 120000),
('Mazda', '6', 3, '145 FFF', 'A', 'True', 123876),
('Mazda', 'CX-6', 1, '155 GGG', 'M', 'True', 12564),
('BMW', 'CX-5', 1, '125 TRE', 'A', 'False', 45678);

SELECT * FROM Autod;