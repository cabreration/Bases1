--reporte 1
SELECT * FROM (SELECT DISTINCT E.nombre_eleccion eleccion, E.anio_eleccion anio, P.nombre pais, PP.nombre partido, ROUND(SUM(C.cantidad) OVER(PARTITION BY E.anio_eleccion, P.nombre, PP.nombre) / SUM(C.cantidad) OVER(PARTITION BY P.nombre), 6) porcentaje 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ELECCION E ON EC.id_eleccion = E.id_eleccion
INNER JOIN PARTIDO_POLITICO PP ON C.id_partido = PP.id_partido
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
WHERE P.tipo = 1 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) AND E.anio_eleccion = 2005
ORDER BY porcentaje DESC) WHERE ROWNUM <= 1
UNION
SELECT * FROM (SELECT DISTINCT E.nombre_eleccion eleccion, E.anio_eleccion anio, P.nombre pais, PP.nombre partido, ROUND(SUM(C.cantidad) OVER(PARTITION BY E.anio_eleccion, P.nombre, PP.nombre) / SUM(C.cantidad) OVER(PARTITION BY P.nombre), 6) porcentaje 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ELECCION E ON EC.id_eleccion = E.id_eleccion
INNER JOIN PARTIDO_POLITICO PP ON C.id_partido = PP.id_partido
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
WHERE P.tipo = 1 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) AND E.anio_eleccion = 2001
ORDER BY porcentaje DESC) WHERE ROWNUM <= 1;

--reporte 2
SELECT DISTINCT P.nombre pais, D.nombre departamento, SUM(C.cantidad) OVER(PARTITION BY D.nombre, P.nombre) total, ROUND(SUM(C.cantidad) OVER(PARTITION BY D.nombre, P.nombre) / SUM(C.cantidad) OVER(PARTITION BY P.nombre), 6) porcentaje 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA D ON MD.id_padre = D.id_zona
WHERE P.tipo = 1 AND D.tipo = 3 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) AND C.sexo = 2
ORDER BY pais DESC;

--reporte 3
SELECT L.pais, L.partido, L.cuenta FROM (SELECT T.pais pais, T.partido partido, T.cuenta cuenta, MAX(T.cuenta) OVER(PARTITION BY T.pais) alto FROM (SELECT DISTINCT S.pais pais, S.partido partido, Count(S.partido) OVER (PARTITION BY S.partido) cuenta FROM (SELECT F.pais, F.region, F.departamento, F.municipio, F.partido, F.votos, MAX(F.votos) OVER(PARTITION BY F.pais, F.region, F.departamento, F.municipio) alto
FROM(SELECT DISTINCT P.nombre pais, R.nombre region, D.nombre departamento, M.nombre municipio, PP.nombre partido, SUM(C.cantidad) OVER(PARTITION BY M.nombre, D.nombre, R.nombre, P.nombre, PP.nombre) votos 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN PARTIDO_POLITICO PP ON C.id_partido = PP.id_partido
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA R ON RP.id_hijo = R.id_zona
INNER JOIN ZONA D ON MD.id_padre = D.id_zona
INNER JOIN ZONA M ON MD.id_hijo = M.id_zona
WHERE P.tipo = 1 AND R.tipo = 2 AND D.tipo = 3 AND M.tipo = 4 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2)
ORDER BY municipio, votos DESC) F) S
WHERE S.votos = S.alto) T) L
WHERE L.cuenta = L.alto;

--reporte 4
SELECT I.pais, I.region FROM (SELECT DISTINCT P.nombre pais, R.nombre region, Z.nombre, SUM(C.cantidad) votos
FROM CARACTERISTICA_ELECCION C 
INNER JOIN RAZA Z ON C.raza = Z.id_raza
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA R ON DR.id_padre = R.id_zona
WHERE P.tipo = 1 AND R.tipo = 2 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) AND Z.id_raza = 2
GROUP BY Z.nombre, P.nombre, R.nombre) I
INNER JOIN 
(SELECT DISTINCT P.nombre pais, R.nombre region, Z.nombre, SUM(C.cantidad) votos
FROM CARACTERISTICA_ELECCION C 
INNER JOIN RAZA Z ON C.raza = Z.id_raza
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA R ON DR.id_padre = R.id_zona
WHERE P.tipo = 1 AND R.tipo = 2 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) AND Z.id_raza = 1
GROUP BY Z.nombre, P.nombre, R.nombre) G ON I.pais = G.pais AND I.region = G.region
INNER JOIN 
(SELECT DISTINCT P.nombre pais, R.nombre region, Z.nombre, SUM(C.cantidad) votos
FROM CARACTERISTICA_ELECCION C 
INNER JOIN RAZA Z ON C.raza = Z.id_raza
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA R ON DR.id_padre = R.id_zona
WHERE P.tipo = 1 AND R.tipo = 2 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) AND Z.id_raza = 3
GROUP BY Z.nombre, P.nombre, R.nombre) L ON I.pais = L.pais AND L.region = I.region
WHERE I.votos > G.votos AND I.votos > L.votos
ORDER BY I.pais, I.region; 

--reporte 5
SELECT M.pais, M.departamento, ROUND(M.mujeres/T.total,6), ROUND(H.hombres/T.total,6) FROM (SELECT DISTINCT P.nombre pais, D.nombre departamento, SUM(C.cantidad) OVER(PARTITION BY D.nombre) mujeres 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA D ON MD.id_padre = D.id_zona
WHERE P.tipo = 1 AND D.tipo = 3 AND C.id_caracteristica = 5 AND C.sexo = 2) M
INNER JOIN 
(SELECT DISTINCT P.nombre pais, D.nombre departamento, SUM(C.cantidad) OVER(PARTITION BY D.nombre) hombres 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA D ON MD.id_padre = D.id_zona
WHERE P.tipo = 1 AND D.tipo = 3 AND C.id_caracteristica = 5 AND C.sexo = 1) H
ON H.pais = M.pais and H.departamento = M.departamento
INNER JOIN 
(SELECT DISTINCT P.nombre pais, D.nombre departamento, SUM(C.cantidad) OVER(PARTITION BY D.nombre) total 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA D ON MD.id_padre = D.id_zona
WHERE P.tipo = 1 AND D.tipo = 3 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2)) T
ON M.pais = T.pais AND M.departamento = T.departamento
WHERE M.mujeres/T.total > H.hombres/T.total
ORDER BY M.pais, M.departamento;

--reporte 6
SELECT L.pais, L.region, ROUND((L.votos/L.cuenta),6) FROM (SELECT DISTINCT F.pais pais, F.region region, F.votos votos, COUNT(*) OVER (PARTITION BY F.pais, F.region) cuenta FROM (SELECT DISTINCT P.nombre pais, R.nombre region, D.nombre departamento, SUM(C.cantidad) OVER(PARTITION BY R.nombre, P.nombre) votos 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA R ON RP.id_hijo = R.id_zona
INNER JOIN ZONA D ON MD.id_padre = D.id_zona
WHERE P.tipo = 1 AND R.tipo = 2 AND D.tipo = 3 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) 
ORDER BY pais DESC) F) L;

--reporte 7 --> incompleta
SELECT DISTINCT P.nombre pais, M.nombre municipio, PP.nombre, SUM(C.cantidad) OVER(PARTITION BY M.nombre, PP.nombre) votos 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN PARTIDO_POLITICO PP ON C.id_partido = PP.id_partido
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA M ON MD.id_hijo = M.id_zona
WHERE P.tipo = 1 AND M.tipo = 4 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) AND P.nombre = 'Nicaragua'
ORDER BY municipio, votos DESC;

--reporte 8
SELECT DISTINCT P.nombre pais, CC.nombre_caracteristica, SUM(C.cantidad)
FROM CARACTERISTICA_ELECCION C 
INNER JOIN CARACTERISTICA CC ON C.id_caracteristica = CC.id_caracteristica
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
WHERE P.tipo = 1 AND (C.id_caracteristica = 3 OR C.id_caracteristica = 4 OR C.id_caracteristica = 5)
GROUP BY P.nombre, CC.nombre_caracteristica 
ORDER BY pais DESC;

--reporte 9
SELECT DISTINCT P.nombre pais, Z.nombre, 
ROUND (SUM(C.cantidad) OVER(PARTITION BY Z.nombre, P.nombre) /
SUM(C.cantidad) OVER(PARTITION BY P.nombre), 6) porcentaje
FROM CARACTERISTICA_ELECCION C 
INNER JOIN RAZA Z ON C.raza = Z.id_raza
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
WHERE P.tipo = 1 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) 
ORDER BY pais DESC;

--reporte 10
SELECT F.pais FROM (SELECT DISTINCT T.pais pais, (MAX(T.votos) OVER(PARTITION BY T.pais) - MIN(T.votos) OVER(PARTITION BY T.pais)) dif FROM (SELECT DISTINCT P.nombre pais, PP.nombre partido, ROUND(SUM(C.cantidad) OVER(PARTITION BY P.nombre, PP.nombre)/SUM(C.cantidad) OVER(PARTITION BY P.nombre),6) votos 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN PARTIDO_POLITICO PP ON C.id_partido = PP.id_partido
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
WHERE P.tipo = 1 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2)
ORDER BY pais, votos DESC) T
ORDER BY dif ASC) F WHERE ROWNUM <= 1;

--reporte 11
SELECT * FROM (SELECT total, ROUND(total/SUM(C.cantidad) OVER(),6) porcentaje FROM (SELECT DISTINCT SUM(C.cantidad) total
FROM CARACTERISTICA_ELECCION C 
WHERE C.id_caracteristica = 2 AND C.sexo = 2 AND C.raza = 2),
CARACTERISTICA_ELECCION C
WHERE C.id_caracteristica = 1 OR C.id_caracteristica = 2) WHERE ROWNUM <= 1;

--reporte 12
SELECT pais FROM (SELECT U.pais pais, (U.analfabetas/D.total) mayor FROM (SELECT DISTINCT P.nombre pais, SUM(C.cantidad) OVER(PARTITION BY P.nombre) analfabetas
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
WHERE P.tipo = 1 AND C.id_caracteristica = 1) U
INNER JOIN 
(SELECT DISTINCT P.nombre pais, SUM(C.cantidad) OVER(PARTITION BY P.nombre) total
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
WHERE P.tipo = 1 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2)) D
ON D.pais = U.pais
ORDER BY mayor DESC) WHERE ROWNUM <= 1;

--reporte 13
SELECT U.departamento, U.total FROM (SELECT DISTINCT D.nombre departamento, SUM(C.cantidad) OVER(PARTITION BY D.nombre) total 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA D ON MD.id_padre = D.id_zona
WHERE P.tipo = 1 AND D.tipo = 3 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) AND P.nombre = 'GUATEMALA') U,
(SELECT DISTINCT D.nombre departamento, SUM(C.cantidad) OVER(PARTITION BY D.nombre) total 
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA P ON RP.id_padre = P.id_zona
INNER JOIN ZONA D ON MD.id_padre = D.id_zona
WHERE P.tipo = 1 AND D.tipo = 3 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2) AND P.nombre = 'GUATEMALA' AND D.nombre = 'Guatemala') D
WHERE U.total > D.total
ORDER BY U.total DESC; 

--reporte 14
SELECT DISTINCT SUBSTR(M.nombre, 0, 1) letra, SUM(C.cantidad)
FROM CARACTERISTICA_ELECCION C 
INNER JOIN ELECCION_ZONA EC ON C.id_eleccion_zona = EC.id_eleccion_zona
INNER JOIN ZONA_PADRE MD ON EC.id_zonarel = MD.id_zonarel
INNER JOIN ZONA_PADRE DR ON MD.id_relpadre = DR.id_zonarel
INNER JOIN ZONA_PADRE RP ON DR.id_relpadre = RP.id_zonarel
INNER JOIN ZONA M ON MD.id_hijo = M.id_zona
WHERE M.tipo = 4 AND (C.id_caracteristica = 1 OR C.id_caracteristica = 2)
GROUP BY SUBSTR(M.nombre, 0, 1) 
ORDER BY letra ASC;

