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

--Quesion 6
SELECT  t.annee,
        c.cl_name,
        p.category,
        SUM(v.qte * v.pu) AS ca_total
FROM temps t, 
     clients c, 
     produits p, 
     ventes v
WHERE p.pid = v.pid AND t.tid = v.tid AND c.cl_id = v.cid 
GROUP BY grouping sets ((p.category,t.annee), (c.cl_name, t.annee));

--Question 7
SELECT p.category,
       SUM(v.qte) AS QTE_VENDUE_2010,
       NTILE(3) OVER(ORDER BY sum(v.qte) DESC) as TIERS
FROM produits p, ventes v, temps t
WHERE p.pid = v.pid AND t.tid = v.tid AND t.annee = 2010
GROUP BY p.category;

--Question 8
SELECT p.category,
       t.mois,
       SUM(v.qte) AS QTE_5_JOURS
FROM produits p, ventes v, temps t
WHERE p.pid = v.pid AND t.tid = v.tid AND t.annee = 2010 AND t.jour <= 5
GROUP BY  grouping sets (p.category, (t.mois, t.jour))
order by t.mois ASC;