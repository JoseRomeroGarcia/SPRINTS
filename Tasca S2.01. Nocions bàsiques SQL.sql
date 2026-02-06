#Nivell_1
#Llistat dels països que estan generant vendes.#

SELECT DISTINCT(c.country)
FROM company c
JOIN transaction t ON t.company_id = c.id
WHERE t.declined = 0;

#Des de quants països es generen les vendes.#

SELECT COUNT(DISTINCT(c.country)) AS num_paises
FROM company c
JOIN transaction t ON t.company_id = c.id
WHERE t.declined = 0;

#Identifica la companyia amb la mitjana més gran de vendes.#

SELECT c.company_name, ROUND(AVG(t.amount), 2) AS vendes_mitjana
FROM company c
JOIN transaction t ON t.company_id = c.id
WHERE t.declined = 0
GROUP BY c.company_name
ORDER BY vendes_mitjana DESC LIMIT 1;


#Mostra totes les transaccions realitzades per empreses d'Alemanya.#

SELECT t.id
FROM transaction t
WHERE t.declined = 0 AND t.company_id IN (SELECT c.id
                                          FROM company c
                                          WHERE c.country = 'Germany');
                     
#Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.#

SELECT c.company_name
FROM company c
WHERE c.id IN (SELECT t.company_id
               FROM transaction t
               WHERE  t. declined = 0 AND t.amount > (SELECT AVG(t.amount)
								                      FROM transaction t
                                                      WHERE t.declined = 0
								                      )
			 );


#Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.#

SELECT c.company_name
FROM company c
WHERE c.id NOT IN (SELECT t.company_id
			       FROM transaction t
                   WHERE t.declined = 0)
ORDER BY c.company_name;


#Nivell_2
#Exercici-1#
#Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes.#
#Mostra la data de cada transacció juntament amb el total de les vendes.#

SELECT	SUM(t.amount) AS sum_ingresos, 
		DATE(timestamp) AS fecha
FROM transaction t
WHERE t.declined = 0
GROUP BY fecha 
ORDER BY fecha DESC 
LIMIT 5;

#Exercici_2#
#Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.#

SELECT	ROUND(AVG(t.amount), 2) AS mitj_vendes, 
		c.country
FROM transaction t
jOIN company  c ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.country
ORDER BY mitj_vendes DESC;

#Exercici_3#
#llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia, "Non Institute"#
#Mostra el llistat aplicant JOIN i subconsultes.#

SELECT t.*
FROM transaction t
JOIN company c ON c.id = t.company_id
WHERE t.declined = 0 AND c.country = (SELECT c.country
                                      FROM company c
                                      WHERE c.company_name = "Non Institute");
                 
#Mostra el llistat aplicant solament subconsultes.#

SELECT t.*
FROM transaction t
WHERE t.declined = 0 AND t.company_id IN (SELECT c.id
                                          FROM company c
                                          WHERE c.country IN (SELECT c.country
                                                              FROM company c
															 WHERE c.company_name = "Non Institute")
					                     );


#Nivell_3
#Exercici_1#
#Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un# 
#valor comprès entre 350 i 400 euros i en alguna d'aquestes dates: #
#29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.#


SELECT	c.company_name, 
		c.phone, 
        t.amount, 
        DATE(t.timestamp) AS fecha
FROM company c
JOIN transaction t ON t.company_id = c.id
WHERE t.declined = 0 AND DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
AND t.amount BETWEEN 350 and 400
ORDER BY t.amount DESC;

#Exercici_2#
#quantitat de transaccions que realitzen les empreses,on especifiquis si tenen més de 400 transaccions o menys.#

SELECT	COUNT(t.id) AS num_trans, 
		c.company_name,
CASE
    WHEN COUNT(t.id) > 400 THEN 'The quantity of transactions is greater than 400'
    ELSE 'The quantity of transactions is under 400'
END
FROM transaction t
JOIN company c ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.company_name 
ORDER BY num_trans DESC;







