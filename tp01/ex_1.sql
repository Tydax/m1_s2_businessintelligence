/*
 * Business Intelligence
 * Armand BOUR - Ilhem BADREDDIN
 *
 * TP01
 * Exercice 1
 *
 */

-- a
SELECT  deptno,
        ename,
        sal,
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS "RANG"
FROM emp
WHERE deptno IN(10, 30)
ORDER BY deptno, sal DESC;

-- b
SELECT  deptno,
        ename,
        sal,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS "RANG"
FROM emp
WHERE deptno IN(10, 30)
ORDER BY deptno, sal DESC;

-- c
SELECT DISTINCT deptno,
        sal,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS "RANG"
FROM emp
WHERE deptno IN(10, 20)
ORDER BY deptno, sal DESC;

-- d
SELECT job,
       SUM(sal) AS "TOT_SAL_JOB"
FROM emp
GROUP BY job;

SELECT DISTINCT job,
       SUM(sal) OVER (PARTITION BY job) AS "TOT_SAL_JOB"
FROM emp;

-- e
/* GROUP BY permet de grouper l'ensemble de données sur une colonne, suite à quoi il est possible d'utiliser
 * des fonctions d'aggrégations.
 *
 * PARTITION BY ne groupe pas l'ensemble de données, elle permet de faire appel à une fonction d'aggrégation tout
 * en ayant les informations d'une requête classique en se limitant à une unique fonction.
 * Il est donc possible de faire appel à des fonctions d'aggrégation sur différents groupes via le PARTITION BY
 * ce qui n'est pas le cas du GROUP BY.
 */

-- f
SELECT deptno,
       job,
       SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno, job)
ORDER BY deptno, job;

-- g
SELECT NVL(TO_CHAR(deptno), 'TousDep') AS "DEPTNO",
       NVL(job, 'TousEmployés') AS "JOB",
       SUM(sal) 
FROM emp
GROUP BY ROLLUP (deptno, job)
ORDER BY deptno, job;

SELECT DECODE(GROUPING(deptno), 0, TO_CHAR(deptno), 1, 'TousDep') AS "DEPTNO",
       DECODE(GROUPING(job), 0, job, 1, 'TousEmployes') AS "JOB",
       SUM(sal) 
FROM emp
GROUP BY ROLLUP (deptno, job)
ORDER BY deptno, job DESC;

