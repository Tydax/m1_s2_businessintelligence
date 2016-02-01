/*
 * Business Intelligence
 * Armand BOUR - Ilhem BADREDDIN
 *
 * TP01
 * Exercice 2
 *
 */

-- Question 1
SELECT  annee,
        cl_r,
        category,
        AVG(qte * pu) AS ca_moyen
FROM    ventes v NATURAL JOIN temps
                 NATURAL JOIN produits
                 INNER JOIN clients c ON (c.cl_id = v.cid)
WHERE   annee IN(2009, 2010)
GROUP BY ROLLUP (annee, cl_r, category);

-- Question 2
SELECT  annee,
        cl_r,
        category,
        AVG(qte * pu) AS ca_moyen
FROM    ventes v NATURAL JOIN temps
                 NATURAL JOIN produits
                 INNER JOIN clients c ON (c.cl_id = v.cid)
WHERE   annee IN(2009, 2010)
GROUP BY CUBE(annee, cl_r, category);

-- Question 3 TO FINISH
SELECT  RANK() OVER (PARTITION BY annee, category ORDER BY nb DESC) AS rang,
        annee,
        category,
        pname, nb
FROM (
    SELECT SUM(qte) AS nb,
            annee,
            category,
            pname
    FROM   ventes v NATURAL JOIN temps
                    NATURAL JOIN produits
                    INNER JOIN clients c ON (c.cl_id = v.cid)
    GROUP BY annee, category, pname
) q;