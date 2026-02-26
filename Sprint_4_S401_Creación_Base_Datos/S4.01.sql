#Creación de la base de datos que lleva por nombre new_transactions#

CREATE DATABASE new_transactions;

USE new_transactions;


#Creación de las tablas de dimensiones#

#Creación de la tabla users#

CREATE TABLE IF NOT EXISTS users (
	id INT,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);


DESC users;

#Creación de la tabla companies#

CREATE TABLE IF NOT EXISTS companies (
        company_id VARCHAR(15),
        company_name VARCHAR(150),
        phone VARCHAR(50),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );
    
    
DESC companies;

#Creación de la tabla credit_cards#

CREATE TABLE IF NOT EXISTS credit_cards(
	id VARCHAR(15),
    user_id INT,               #aquí pongo un INT porque tiene que ser el mismo tipo de dato que en la tabla users para poder establecer la relación FK#
	iban VARCHAR(50),
	pan VARCHAR (25),
	pin VARCHAR(4),
	cvv VARCHAR(4),                   #en este tipo de dato uso un VARCHAR(4) para no tener problemas si empezase por 0#
	track1 VARCHAR(150),
    track2 VARCHAR(150),
	expiring_date VARCHAR(100)    
);

#Posteriormente tengo que añadir#
#FOREIGN KEY (user_id) REFERENCES users(id) #aquí indico que user_id es una FK y que está relacionada con la tabla users#


DESC credit_cards;


#Creación de la tabla products#

CREATE TABLE IF NOT EXISTS products (
	id INT,
    product_name VARCHAR(150),
    price VARCHAR(20),        #en este caso al llevar un símbolo $ lo dejamos como texto por ahora#
    colour VARCHAR(20),
    weight DECIMAL(4,1),
    warehouse_id VARCHAR(10)
);

DESC products;


#Creación de la tabla de hechos, transactions#

CREATE TABLE IF NOT EXISTS transactions (
	id VARCHAR(255),
    card_id VARCHAR(15),
    business_id VARCHAR(15),
    timestamp VARCHAR(25),
    amount VARCHAR(50),
    declined VARCHAR(10),
    product_ids VARCHAR(25),
    user_id VARCHAR(25),
    lat VARCHAR(50),
    longitude VARCHAR(50)         #FOREIGN KEY (card_id) REFERENCES credit_cards(id)
                                  #FOREIGN KEY (business_id) REFERENCES companies(company_id)
                                  #FOREIGN KEY (user_id) REFERENCES users(id)
);
    
DESC transactions;


#Una vez creadas las tablas tenemos que cargar los datos, para ello primero
#tenemos que activar el código SQL que permite el upload

SET GLOBAL local_infile = 1;


#Al activar este comando podemos utilizar LOAD DATA LOCAL#

#Compruebo que está activado con este comando#

SHOW GLOBAL VARIABLES LIKE 'local_infile';


#Ahora podemos empezar a cargar los datos utilizando LOAD DATA LOCAL#

LOAD DATA LOCAL INFILE '/Users/josemanuelromerogarcia/Desktop/Especialización_Data_Analyst/Sprint_4/american_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#(id, name, surname, phone, email, birth_date, country, city, postal_code, address)#

#Siguiendo estos pasos no consigo cargar la tabla. Sale error 2068#

#Sigo las instrucciones para averiguar en qué carpeta se puede copiar#

SHOW VARIABLES LIKE 'secure_file_priv';

SELECT VERSION();

#Tras tocar la conexión y añadir OPT_LOCAL_INFILE=1 en advance, consigo cargar los datos de american_users#

#Procedo a cargar los datos de european_users en la misma tabla users


LOAD DATA LOCAL INFILE '/Users/josemanuelromerogarcia/Desktop/Especialización_Data_Analyst/Sprint_4/european_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#Comprobación de la tabla users#

SELECT *
FROM users;

#Procedo a cargar los datos de companies#

LOAD DATA LOCAL INFILE '/Users/josemanuelromerogarcia/Desktop/Especialización_Data_Analyst/Sprint_4/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT *
FROM companies;

#Cargo los datos en la tabla products#

LOAD DATA LOCAL INFILE '/Users/josemanuelromerogarcia/Desktop/Especialización_Data_Analyst/Sprint_4/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT *
FROM products;

#Cargo los datos en la tabla credit_cards#

LOAD DATA LOCAL INFILE '/Users/josemanuelromerogarcia/Desktop/Especialización_Data_Analyst/Sprint_4/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT *
FROM credit_cards;


#Cargo los datos en la tabla transactions#

LOAD DATA LOCAL INFILE '/Users/josemanuelromerogarcia/Desktop/Especialización_Data_Analyst/Sprint_4/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'            #Para cargar estos datos tengo que varíar la ',' por ';'#
LINES TERMINATED BY '\n'            #Tambien quito '"' porque en estos datos no hay#
IGNORE 1 LINES;


SELECT *
FROM transactions;

#Establecimiento de relaciones entre tablas y cambios de tipo de dato#


#Cambios en la tabla users#

DESC users;

ALTER TABLE users
ADD PRIMARY KEY (id);

ALTER TABLE users
MODIFY COLUMN phone VARCHAR(25);

ALTER TABLE users
MODIFY COLUMN email VARCHAR(255);

ALTER TABLE users
MODIFY COLUMN birth_date VARCHAR(15);

ALTER TABLE users
MODIFY COLUMN country VARCHAR(100);

ALTER TABLE users
MODIFY COLUMN postal_code VARCHAR(20);

DESC users;

#Cambios de PK y tipos de datos en la tabla companies#

ALTER TABLE companies
ADD PRIMARY KEY (company_id);

ALTER TABLE companies
MODIFY COLUMN phone VARCHAR(25);

ALTER TABLE companies
MODIFY COLUMN email VARCHAR(255);

DESC companies;

#Realizo los cambios en la tabla credit_cards, primero la PK y la FK y luego los cambios de tipo de valor#

ALTER TABLE credit_cards
ADD PRIMARY KEY (id);

ALTER TABLE credit_cards
ADD CONSTRAINT fk_credit_cards
FOREIGN KEY (user_id)
REFERENCES users(id);

ALTER TABLE credit_cards
MODIFY COLUMN pin CHAR(4);

ALTER TABLE credit_cards
MODIFY COLUMN cvv CHAR(4);

ALTER TABLE credit_cards
MODIFY COLUMN expiring_date VARCHAR(8);

DESC credit_cards;

#Hago los cambios en la tabla products, determinando la PK y cambiando algunos tipos de datos#


ALTER TABLE products
ADD PRIMARY KEY (id);

ALTER TABLE products
MODIFY COLUMN colour CHAR(7);

DESC products;

#De momento no hago más cambios en la tabla products#

#Hago los cambios en la tabla transactions que tiene como PK a id y tiene varias FK con las otras tablas#
# La tabla transactions es mi tabla de hechos#

ALTER TABLE transactions
ADD PRIMARY KEY (id);

ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_credit_cards
FOREIGN KEY (card_id)
REFERENCES credit_cards(id);      #los dos campos tiene el mismo tipo de dato VARCHAR(15)#


ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_companies
FOREIGN KEY (business_id)
REFERENCES companies(company_id); 

ALTER TABLE transactions
MODIFY COLUMN user_id INT;


ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_users
FOREIGN KEY (user_id)
REFERENCES users(id); 

#La FK que relaciona la tabla transactions con la tabla products no la establezco de momento#

ALTER TABLE transactions
MODIFY COLUMN timestamp TIMESTAMP;

ALTER TABLE transactions
MODIFY COLUMN amount DECIMAL(10,2);

ALTER TABLE transactions
MODIFY COLUMN declined BOOLEAN;

DESC transactions;

#Una vez realizadas todas estas operaciones puede empezar con el ejercicio 1#

#Al revisar el modelo de la base de datos veo que no es un modelo de estrella, por lo cual decido eliminar la relación
#entre las tablas users y la credit_cards

ALTER TABLE credit_cards
DROP FOREIGN KEY fk_credit_cards;

#ejercicio_1 usuarios con más de 80 transacciones utilizando 2 tablas como mínimo, utilizar subconsulta#

SELECT	u.name AS name,
		u.surname AS surname,
        u.id
FROM users u
WHERE u.id IN (SELECT t.user_id
			   FROM transactions t
               WHERE t.declined = 0
               GROUP BY t.user_id
               HAVING COUNT(DISTINCT(t.id)) > 80
               )
ORDER BY u.id;

#Ejercicio 2 muestra la media de amount por IBAN de las targetas de crédito#
#de la compañía Donec Ltd, utilitza por lo menos 2 tablas#

SELECT ROUND(AVG(t.amount),2) AS Cantidad_media, 
		cc.iban AS Número_Iban, 
        cc.id  AS Identificador_targeta, 
        c.company_name AS Compañía
FROM credit_cards cc
JOIN transactions t ON t.card_id = cc.id
JOIN companies c ON c.company_id = t.business_id
WHERE c.company_name = 'Donec Ltd' AND t.declined = 0
GROUP BY cc.iban, cc.id, c.company_name
ORDER BY AVG(t.amount) DESC;
			
            
# Nivel 2

#Ejercicio_1 Crear una tabla que refleje el estado de las targetas y que muestre como inactivas
# aquellas targetas con las tres últimas transacciones declinadas

CREATE TABLE IF NOT EXISTS status_cards (
	card_id VARCHAR(15),
    status VARCHAR(25)
    );


#necesito crear una CTE para realizar el ejercicio

INSERT INTO status_cards (card_id, status) #esto lo agrego al final del proceso cuando ya esta todo creado para no repetir código
                                           #entonces procedo a hacer el INSERT INTO
WITH last_transactions AS (
    SELECT 
        card_id,
        declined,
        ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS rn
    FROM transactions
)       #con esto consigo que me empiece a contar cada vez que cambia la targeta y me ordena por fecha según la última

SELECT 
    card_id,
    CASE 
        WHEN SUM(declined) = 3 THEN 'targeta inactiva'   #Para determinar si la targeta está activa
        ELSE 'targeta activa'                             # o inactiva hago un CASE
    END AS status
FROM last_transactions
WHERE rn <= 3
GROUP BY card_id;

# cantidad de targetas activas

SELECT COUNT(*)
FROM status_cards
WHERE status = 'targeta activa';


ALTER TABLE status_cards
ADD PRIMARY KEY (card_id);

ALTER TABLE status_cards
ADD CONSTRAINT fk_status_cards_credit_cards
FOREIGN KEY (card_id)
REFERENCES credit_cards(id);


# Nivel 3

# Creación de una tabla puente

CREATE TABLE IF NOT EXISTS products_transactions (
    transaction_id VARCHAR(255),
    product_id INT,
    PRIMARY KEY (product_id, transaction_id),     # en el caso de una tabla de transición la PK es la combinación de las dos
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id)
);
    

INSERT INTO products_transactions (transaction_id, product_id)
SELECT 
    t.id,
    jt.product_id
FROM transactions t
JOIN JSON_TABLE(
    CONCAT('[', t.product_ids, ']'),    #convierte "3,5,8" en "[3,5,8]"
    "$[*]" COLUMNS(
        product_id INT PATH "$"         #cada elemento del array como fila
    )
) AS jt;

# Ejercicio_1. Necesito saber cuántas veces se ha vendido cada producto.

SELECT pt.product_id, p.product_name, COUNT(pt.transaction_id) AS num_ventas
FROM products_transactions pt
JOIN transactions t ON t.id = pt.transaction_id
JOIN products p ON p.id = pt.product_id
WHERE t.declined = 0
GROUP BY p.product_name, pt.product_id
ORDER BY num_ventas DESC;






                
				



    