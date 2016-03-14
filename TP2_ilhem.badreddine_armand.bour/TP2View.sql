/*
 * Business Intelligence
 * Armand BOUR - Ilhem BADREDDIN
 *
 * TP02
 * Implémentation et alimantation
 */
DROP MATERIALIZED VIEW view_produit;
DROP MATERIALIZED VIEW view_temps;
DROP MATERIALIZED VIEW view_client;
DROP MATERIALIZED VIEW view_emplacement;
DROP MATERIALIZED VIEW view_vente;
DROP DIMENSION view_produit_dim;
DROP DIMENSION view_client_dim;
DROP DIMENSION view_temps_dim;
DROP DIMENSION view_emplacement_dim;


/* La vue de la dimension client */
COLUMN id_client HEADING id_client Format 9999
COLUMN age HEADING age FORMAT 999
COLUMN tranche_age HEADING tranche_age FORMAT a10
COLUMN sexe HEADING sexe FORMAT a5
CREATE materialized VIEW  view_client
REFRESH FORCE ON DEMAND AS
SELECT num AS id_client, 
FLOOR((MONTHS_BETWEEN(SYSDATE,date_nais)/12)) AS age,
CASE 
	WHEN FLOOR((MONTHS_BETWEEN(SYSDATE,date_nais)/12))  < 30 THEN '<30' 
	WHEN FLOOR((MONTHS_BETWEEN(SYSDATE,date_nais)/12)) between 30 and 45 THEN '30-45ans'
	WHEN FLOOR((MONTHS_BETWEEN(SYSDATE,date_nais)/12)) between 46 and 60 THEN '45-60ans'
	WHEN FLOOR((MONTHS_BETWEEN(SYSDATE,date_nais)/12)) > 60 THEN '>60ans'
END AS tranche_age,
sexe AS sexe
FROM client;



/* La vue de la dimension produit */
COLUMN id_produit HEADING id_produit Format 9999
COLUMN designation HEADING designation FORMAT a50
COLUMN categorie HEADING categorie FORMAT a50
COLUMN sous_categorie HEADING sous_categorie FORMAT a200
CREATE materialized VIEW  view_produit
REFRESH FORCE ON DEMAND AS
SELECT num AS id_produit, 
substr(designation,1,instr(designation,'.',1,1)-1) AS designation,
CASE
	WHEN instr(designation,'.',1,2) = 0 THEN substr(designation,instr(designation,'.',1,1)+1,length(designation)-instr(designation,'.',1,1))
	ELSE substr(designation,instr(designation,'.',1,1)+1,instr(designation,'.',1,2)-instr(designation,'.',1,1)-1)
END AS categorie,
CASE
	WHEN instr(designation,'.',1,2) = 0 THEN NULL
	ELSE substr(designation,instr(designation,'.',1,2)+1, length(designation) - instr(designation,'.',1,2)+1)
END AS sous_categorie
FROM produit;

/* La vue de la dimension temps */
COLUMN id_temps HEADING id_temps Format 9999
COLUMN annee HEADING annee FORMAT 9999
COLUMN mois HEADING semaine FORMAT a12
COLUMN semaine HEADING semaine FORMAT 99
COLUMN jours HEADING jour FORMAT 999
CREATE materialized VIEW  view_temps
REFRESH FORCE ON DEMAND AS
SELECT num AS id_temps, 
TO_Number(TO_CHAR(date_etabli, 'DDD')) AS jour, 
TO_Number(TO_CHAR(date_etabli, 'IW')) AS semaine, 
TO_CHAR(date_etabli, 'IW') AS mois,
TO_Number(TO_CHAR(date_etabli, 'YYYY')) AS annee
FROM facture;


/* La vue de la dimension emplacement */
COLUMN id_emplacement HEADING id_emplacement FORMAT a300
COLUMN ville HEADING ville FORMAT a50
COLUMN pays HEADING pays FORMAT a50
CREATE materialized VIEW  view_emplacement
REFRESH FORCE ON DEMAND AS
SELECT adresse AS id_emplacement, 
substr(adresse, instr(adresse,',',1,2)+1,instr(adresse,',',1,3)-instr(adresse,',',1,2)-1) as ville, 
substr(adresse, instr(adresse,',',1,3)+1,length(adresse)-instr(adresse,',',1,3)) as pays
FROM client;

/* La vue de la dimension ventes ERREUR RESOLU*/
COLUMN id_client HEADING id_client Format 9999
COLUMN id_produit HEADING id_produit FORMAT 9999
COLUMN id_emplacement HEADING id_emplacement FORMAT a300
COLUMN id_temps HEADING id_temps FORMAT 9999
COLUMN qte_produits HEADING qte_produits FORMAT 9999999
COLUMN prix_produit HEADING prix_produit FORMAT 9999999
COLUMN remise HEADING remise FORMAT 9999
CREATE MATERIALIZED VIEW  view_vente
REFRESH FORCE ON DEMAND AS
SELECT id_client AS id_client, 
       id_produit AS id_produit, 
       adresse AS id_emplacement, 
       id_temps AS id_temps,
       qte AS qte_produits, 
       prix AS prix_produit, 
       remise AS remise      
FROM   client c, 
       view_client vc, 
       view_produit p, 
       facture f,
       ligne_facture lf,
       view_emplacement ve,
       view_temps t, 
       prix_date pd
WHERE f.client = vc.id_client
AND lf.facture = f.num
AND lf.produit = p.id_produit
AND ve.id_emplacement = adresse
AND c.num = vc.id_client
AND t.id_temps = f.num
AND lf.id_prix = pd.num;


/* Cle primaire */
ALTER MATERIALIZED VIEW view_vente ADD CONSTRAINT primary_key_vente PRIMARY KEY (id_client) disable;
ALTER MATERIALIZED VIEW view_client ADD CONSTRAINT primary_key_client PRIMARY KEY (id_client) disable;
ALTER MATERIALIZED VIEW view_produit ADD CONSTRAINT primary_key_produit PRIMARY KEY (id_produit) disable;
ALTER MATERIALIZED VIEW view_temps ADD CONSTRAINT primary_key_temps PRIMARY KEY (id_temps) disable;
ALTER MATERIALIZED VIEW view_emplacement ADD CONSTRAINT primary_key_emplacement PRIMARY KEY (id_emplacement) disable;

/* cle etrangère */
ALTER MATERIALIZED VIEW view_client ADD CONSTRAINT foreign_key_clientVente FOREIGN KEY (id_client) REFERENCES view_client(id_client) disable;
ALTER MATERIALIZED VIEW view_produit ADD CONSTRAINT foreign_key_produitVente FOREIGN KEY (id_produit) REFERENCES view_produit(id_produit) disable;
ALTER MATERIALIZED VIEW view_temps ADD CONSTRAINT foreign_key_tempsVente FOREIGN KEY (id_temps) REFERENCES view_temps(id_temps) disable;
ALTER MATERIALIZED VIEW view_emplacement ADD CONSTRAINT foreign_key_emplacementVente FOREIGN KEY (id_emplacement) REFERENCES view_emplacement(id_emplacement) disable;

/*Dimensions*/

/*Dimension client*/
CREATE DIMENSION view_client_dim
LEVEL age IS (view_client.age)
LEVEL tranche_age IS (view_client.tranche_age)
HIERARCHY PROD_ROLLUP (age CHILD OF tranche_age);

/*Dimension produit*/
CREATE DIMENSION view_produit_dim
LEVEL designation IS (view_produit.designation)
LEVEL categorie IS (view_produit.categorie)
LEVEL sous_categorie IS (view_produit.sous_categorie)
HIERARCHY PROD_ROLLUP (sous_categorie CHILD OF categorie CHILD OF designation);

/*Dimension Temps*/
CREATE DIMENSION view_temps_dim
LEVEL jour IS (view_temps.jour)
LEVEL semaine IS (view_temps.semaine)
LEVEL annee IS (view_temps.annee)
HIERARCHY PROD_ROLLUP (jour CHILD OF semaine CHILD OF annee);

/*Dimension emplacement*/
CREATE DIMENSION view_emplacement_dim
LEVEL ville IS (view_emplacement.ville)
LEVEL pays IS (view_emplacement.pays)
HIERARCHY PROD_ROLLUP (ville CHILD OF pays);