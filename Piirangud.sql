CREATE DATABASE iktpv25;
use iktpv25;
CREATE TABLE City(
ID int NOT NULL,
cityName varchar(30));
SELECT * FROM City;

--PK lisamine
ALTER TABLE City
ADD CONSTRAINT pk_ID PRIMARY KEY(ID); 
--Unique lisamine
ALTER TABLE City
ADD CONSTRAINT cityName_inique UNIQUE (cityName);
--andmete lisamine
INSERT INTO City(ID, cityName)
Values(2, 'Tartu');

select * from city;

CREATE TABLE Country(
ID int NOT NULL primary key identity (1,1),
countryName varchar(30),
Capital int);



--FK lisamine
ALTER TABLE Country
ADD CONSTRAINT fk_city FOREIGN KEY(Capital)
REFERENCES City(ID); 
INSERT INTO Country(countryName, Capital)
VALUES ('Eesti', 1);

select * from country;
SELECT * FROM City;

--näitab süsteemne info tabelist;
EXEC sp_help coutry;
