
SELECT * FROM AADRESS;

ALTER TABLE AADRESS DROP COLUMN riik;

INSERT INTO ELAMINE (isik_ID, aadress_ID, alates) VALUES (1, 1, '2026-06-04');

SELECT * FROM ELAMINE;


SELECT * FROM ISIK;
INSERT INTO ISIK (eesnimi, perenimi, isikukood, sugu) 
VALUES ('Juhan', 'Juurikas', '39504044321', 'Mees');

UPDATE ISIK SET perenimi = 'Juurikas-Kask' WHERE isikukood = '39504044321';

--Попытка добавить данные в AADRESS (Ожидается ошибка: INSERT permission was denied)
INSERT INTO AADRESS (riik, linn, tanav) VALUES ('Lätí', 'Riia', 'Brivibas iela');

--Пользователю isikNimi запрещено ИЗМЕНЯТЬ адреса.
UPDATE AADRESS SET linn = 'Tallinn Vana' WHERE aadress_ID = 1;

--Пользователю isikNimi запрещено УДАЛЯТЬ данные (DELETE).
DELETE FROM ISIK WHERE isikukood = '39504044321';

--Попытка удаления колонки или изменения структуры (Ожидается ошибка: ALTER TABLE permission denied)
ALTER TABLE ISIK DROP COLUMN sugu;