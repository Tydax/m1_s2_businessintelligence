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

-- Question 3
SELECT  annee,
        category,
        pname
FROM (
    SELECT  annee,
            category,
            pname,
            RANK() OVER (PARTITION BY annee, category ORDER BY SUM(qte * pu) DESC) AS rang
    FROM ventes v   NATURAL JOIN temps
                    NATURAL JOIN produits
                    INNER JOIN clients c ON (c.cl_id = v.cid)
    GROUP BY annee, category, pname
)
WHERE rang = 1;

-- Question 4
SELECT  annee,
        category,
        SUM(qte * pu) AS ca_total
FROM ventes v   NATURAL JOIN temps
                NATURAL JOIN produits
                INNER JOIN clients c ON (c.cl_id = v.cid)
HAVING GROUPING_ID(annee, category) < 2
GROUP BY CUBE (annee, category);

/* Il est possible d'utiliser juste un ROLLUP, mais les lignes d'agrégation pour chaque année
ne s'affichent pas en premier. */

-- Question 5
SELECT  annee,
        mois,
        SUM(qte * pu) AS ca_total,
        pname
FROM ventes v   NATURAL JOIN temps
                NATURAL JOIN produits
                INNER JOIN clients c ON (c.cl_id = v.cid)
WHERE category = 'Condiments'
GROUP BY annee, mois, pname;
