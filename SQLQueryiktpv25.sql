create database iktpv25;
use iktpv25;
--tabeli loomine
CREATE table kasutaja(
kasutajaID int primary key Identity(1,1),
kasutajaNimi varchar(15) not null,
epost varchar(15),
parool char(10) not null);

select * from kasutaja;

Insert into kasutaja(kasutajaNimi, parool)
Values ('Ilja', 'test');
--tabeli muutmine ja uue veergu lisamine
ALTER TABLE kasutaja ADD elukoht varchar(15);


--tabeli andmete uuendamine 
UPDATE kasutaja SET elukoht= 'Tallinn';

--veeru kustutamine
ALTER TABLE kasutaja DROP COLUMN elukoht;
select * from kasutaja;

--veeru andmetüübi muutmine
ALTER TABLE kasutaja ALTER COLUMN parool varchar(50);

Insert into kasutaja(kasutajaNimi, parool)
Values ('Sabir', 'testikist');

--protseduur tabeli muutmine
CREATE procedure muudaTabeli
@tegevus varchar(15),
@tabelinimi varchar(15),
@veerunimi varchar(15),
@andmetyyp varchar(15) =null
AS
Begin
DECLARE @sqltegevus varchar(max)
SET @sqltegevus=case
when @tegevus='add' then 
concat('ALTER TABLE ', @tabelinimi, ' ADD ', @veerunimi,' ', @andmetyyp)

when @tegevus='drop' then 
concat('ALTER TABLE ', @tabelinimi, ' DROP COLUMN ', @veerunimi)
END;

END;
print @sqltegevus;
begin
EXEC (@sqltegevus);
END;
DROP procedure muudaTabeli;
--kutse
EXEC muudaTabeli @tegevus='add', @tabelinimi='kasutaja', @veerunimi='test5', @andmetyyp='int';
select * from kasutaja;

EXEC muudaTabeli @tegevus='drop', @tabelinimi='kasutaja', @veerunimi='test5';
