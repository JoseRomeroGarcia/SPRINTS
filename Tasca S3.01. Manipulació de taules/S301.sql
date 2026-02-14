#Nivel 1#

#Ejercicio_1#

#Crear la tabla credit_card#

CREATE TABLE IF NOT EXISTS credit_card(
	id VARCHAR(15) PRIMARY KEY,
	iban VARCHAR(50),
	pan VARCHAR (25),
	pin VARCHAR(4),
	cvv INT,	
	expiring_date VARCHAR(100)
);

#Hago un insert de los datos de credit_card del documento datos_introducir_sprint3_credit y hago la comprobación#

SELECT *
FROM credit_card;

#Creación de la FK en la tabla Transaction (credit_card_id) para relacionarse con Credit_card#

				
ALTER TABLE transaction
ADD CONSTRAINT fk_credit_card_id
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);




#Ejercicio_2#

#Error en el número de cuenta asociado a la targeta de crédito con id CcU-2938#


SELECT iban
FROM credit_card
WHERE id = 'CcU-2938';



UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938'; 


SELECT iban
FROM credit_card
WHERE id = 'CcU-2938';



#Ejercicio_3#

#Ingresa una nueva transacción#

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);

#Tengo que insertar primero estos valores en las otras tablas#

INSERT INTO credit_card (id)
VALUES ('CcU-9999');



INSERT INTO company (id)
VALUES ('b-9999');


#Comprobación#

SELECT *
FROM transaction
WHERE credit_card_id = 'CcU-9999';




#Ejercicio_4#

#Eliminación de la columna Pan de la tabla Credit_card#

ALTER TABLE credit_card
DROP COLUMN pan;



DESC credit_card;


#NIVEL_2#

#Ejercicio_1#

#Elimina de la tabla transaction el registro ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de datos.#

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';



SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';



#Ejercicio_2#

#Creación de la view VistaMarketing#

CREATE VIEW VistaMarketing AS
SELECT	c.company_name,
		c.phone,
        c.country,
        ROUND(AVG(t.amount),2) AS media_gasto
FROM company c
JOIN transaction t ON t.company_id = c.id
GROUP BY c.id, c.company_name, c.phone, c.country
ORDER BY AVG(t.amount) DESC;


#Ejercicio_3#

#Filtrar VistaMarketing por residencia Germany#

SELECT *
FROM VistaMarketing v
WHERE v.country = 'Germany';



#NIVEL_3#

#Ejercicio_1#

#Introducción estructura tabla user#

#Cambio user(id) de char(10) a int para poder convertir transaction(user_id) en FK

ALTER TABLE user
MODIFY COLUMN id INT;



#Comprobación del cambio realizado#

DESC user;


#Creación de la FK en la tabla transaction que se relaciona con la tabla user#

ALTER TABLE transaction 
ADD CONSTRAINT fk_transaction_user_id
FOREIGN KEY (user_id) 
REFERENCES user(id); 

#Al hacerlo da error porque nos falta introducir un dato en la tabla user#

INSERT INTO user (id)
VALUES ('9999');


#Al introducir este dato ya puedo establecer relación de la FK#

#Eliminación columna website de tabla company#

ALTER TABLE company
DROP COLUMN website;

#Comprobación#

DESC company;


#Cambio de nombre de la columna email a personal_email en la tabla user#

ALTER TABLE user
RENAME COLUMN email to personal_email;

#Comprobación#

DESC user;

#Renombrar la tabla user a data_user#

RENAME TABLE user to data_user;

#Comprobación#

DESC data_user;

#Cambiar tipo de dato en la tabla credit_card_id de VARCHAR(15) a VARCHAR(20) en la taula transaction#

ALTER TABLE transaction
MODIFY COLUMN credit_card_id VARCHAR(20);

#Comprobación#

DESC transaction;

#Modificar el tipo de dato del campo id en la taula credit_card de VARCHAR(15) a VARCHAR(20)#

ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20);

#Comprobación#

DESC credit_card;

#Crear la columna fecha_actual con el tipo de dato date en la tabla credit_card#

ALTER TABLE credit_card
ADD COLUMN fecha_actual date NULL;

#Comprobación#

DESC credit_card;

#Cambio del tipo de dato en la tabla credit_card el campo expriring_date de VARCHAR(100) a VARCHAR(20)#

ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR(20);

#Comprobación#

DESC credit_card;

DESC data_user;




#Ejercicio_2#

#Creación vista InformeTecnico#

CREATE VIEW InformeTecnico AS
SELECT	t.id AS transaction_id,
		d.name AS customer_name,
        d.surname AS customer_surname,
        c_c.iban,
        c.company_name,
        c.id AS company_identity,
        d.country AS country_customer,
        c.country AS country_company,
        t.amount
FROM transaction t
JOIN data_user d ON d.id = t.user_id
JOIN credit_card c_c ON c_c.id = t.credit_card_id
JOIN company c ON c.id = t.company_id
ORDER BY t.id DESC;

SELECT *
FROM InformeTecnico;
        

