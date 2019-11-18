--reporte1
SELECT DISTINCT E.tema, Count(*) over (partition by E.tema) FROM ENCUESTA E
INNER JOIN PREGUNTA P ON P.codigo_encuesta = E.codigo_encuesta
INNER JOIN RESPUESTA R ON R.codigo_pregunta = P.codigo_pregunta
INNER JOIN PAIS_RESPUESTA PR ON PR.codigo_respuesta = R.codigo_respuesta
INNER JOIN PAIS C ON PR.codigo_pais = C.codigo_pais;

--reporte2
SELECT DISTINCT P.pais FROM (SELECT P.nombre pais, P.codigo_pais codigo FROM PAIS P 
LEFT JOIN INVENTOR I ON P.codigo_pais = I.codigo_pais
WHERE I.codigo_pais IS NULL) P
LEFT JOIN FRONTERA F ON P.codigo = F.codigo_pais 
WHERE F.codigo_pais IS NOT NULL ORDER BY P.pais;

--reporte3
SELECT nombre, salario, comision, 
CASE WHEN salario > comision THEN salario
ELSE comision
END mayor FROM PROFESIONAL;

--reporte 4
SELECT P.nombre, P.poblacion FROM PAIS P
LEFT JOIN FRONTERA F ON P.codigo_pais = F.codigo_pais
WHERE F.codigo_pais IS NULL AND P.area > (SELECT area from pais where nombre = 'Japon');

--reporte 5
SELECT nombre FROM INVENTO WHERE codigo_profesional IN (SELECT codigo_profesional FROM AREA_PROFESIONAL WHERE codigo_area = (SELECT A.codigo_area area FROM AREA_INVESTIGACION A
INNER JOIN AREA_PROFESIONAL AP ON AP.codigo_area = A.codigo_area
INNER JOIN PROFESIONAL P ON P.codigo_profesional = AP.codigo_profesional
WHERE P.nombre = 'JAMES CLERK'));

--reporte 6
SELECT F.pais, F.cuenta FROM (SELECT P.nombre pais, Count(*) cuenta FROM INVENTO I INNER JOIN PAIS P
ON I.codigo_pais = P.codigo_pais
GROUP BY P.nombre
HAVING COUNT(*) > 3) F
ORDER BY CUENTA DESC;

--reporte 7
SELECT nombre, area FROM PAIS where area > (SELECT DISTINCT SUM(P.area) OVER (PARTITION BY R.codigo_region) FROM PAIS P INNER JOIN REGION R
ON P.codigo_region = R.codigo_region  WHERE R.nombre = 'Centro America');

--reporte 8
SELECT DISTINCT P.nombre, COUNT(*) OVER(PARTITION BY P.nombre) CANTIDAD FROM PROFESIONAL P
INNER JOIN INVENTO I ON I.codigo_profesional = P.codigo_profesional;

--reporte 9
SELECT F.nombre, F.suma FROM (SELECT DISTINCT A.nombre nombre, SUM(P.salario) OVER (PARTITION BY A.nombre) suma FROM AREA_INVESTIGACION A
INNER JOIN AREA_PROFESIONAL AP ON AP.codigo_area = A.codigo_area
INNER JOIN PROFESIONAL P ON AP.codigo_profesional = P.codigo_profesional) F
WHERE F.suma > (SELECT DISTINCT SUM(P.salario) OVER (PARTITION BY A.nombre) suma FROM AREA_INVESTIGACION A
INNER JOIN AREA_PROFESIONAL AP ON AP.codigo_area = A.codigo_area
INNER JOIN PROFESIONAL P ON AP.codigo_profesional = P.codigo_profesional where A.nombre = 'optica') ORDER BY F.suma DESC;

--reporte 10
SELECT nombre FROM INVENTO WHERE anio_creacion = (SELECT I.anio_creacion anio
FROM INVENTO_INVENTOR II INNER JOIN INVENTOR IT ON IT.codigo_inventor = II.codigo_inventor INNER JOIN INVENTO I ON II.numero_patente = I.numero_patente 
WHERE IT.nombre = 'Benz');

--reporte 11
SELECT IT.nombre, I.nombre FROM INVENTO_INVENTOR II
INNER JOIN INVENTOR IT ON IT.codigo_inventor = II.codigo_inventor
INNER JOIN INVENTO I ON I.numero_patente = II.numero_patente
WHERE I.nombre LIKE '%Maquina%';

--reporte 12


--reporte 13
SELECT IT.nombre, I.nombre, I.anio_creacion FROM INVENTO_INVENTOR II
INNER JOIN INVENTOR IT ON IT.codigo_inventor = II.codigo_inventor
INNER JOIN INVENTO I ON I.numero_patente = II.numero_patente
WHERE I.anio_creacion < 1800 OR I.anio_creacion >= 1900;

--reporte 14
SELECT P.nombre pais, COUNT(P.nombre) inventos FROM PAIS P INNER JOIN INVENTO I
ON I.codigo_pais = P.codigo_pais 
GROUP BY P.NOMBRE
ORDER BY P.nombre;

--reporte 15
SELECT L.area, L.maximo, L.minimo FROM (SELECT DISTINCT A.nombre area, MAX(P.salario) OVER (PARTITION BY A.nombre) maximo, 
MIN(P.salario) OVER(PARTITION BY A.nombre) minimo FROM PROFESIONAL P
INNER JOIN AREA_PROFESIONAL F ON F.codigo_profesional = P.codigo_profesional
INNER JOIN AREA_INVESTIGACION A ON A.codigo_area = F.codigo_area) L
WHERE L.minimo > 1000;

--reporte 16
SELECT P.nombre, A.nombre FROM (SELECT nombre nombre, codigo_area area FROM AREA_INVESTIGACION WHERE codigo_area NOT IN (SELECT P.codigo_area FROM (SELECT IT.codigo_inventor inventor, I.numero_patente patente, I.codigo_profesional pro FROM
INVENTO_INVENTOR II INNER JOIN INVENTOR IT
ON IT.codigo_inventor = II.codigo_inventor
INNER JOIN INVENTO I ON II.numero_patente = I.numero_patente
WHERE IT.nombre = 'Pasteur') S
INNER JOIN AREA_PROFESIONAL P ON S.pro = P.codigo_profesional)) A
INNER JOIN PROFESIONAL P ON P.jefe_area = A.area;

SELECT nombre FROM PROFESIONAL WHERE jefe_area NOT IN (SELECT DISTINCT codigo_area FROM AREA_PROFESIONAL WHERE codigo_profesional IN (SELECT codigo_profesional FROM AREA_PROFESIONAL WHERE codigo_area IN (SELECT P.codigo_area FROM (SELECT IT.codigo_inventor inventor, I.numero_patente patente, I.codigo_profesional pro FROM
INVENTO_INVENTOR II INNER JOIN INVENTOR IT
ON IT.codigo_inventor = II.codigo_inventor
INNER JOIN INVENTO I ON II.numero_patente = I.numero_patente
WHERE IT.nombre = 'Pasteur') S
INNER JOIN AREA_PROFESIONAL P ON S.pro = P.codigo_profesional))) AND jefe_area IS NOT NULL;

--reporte 17
SELECT nombre, poblacion FROM PAIS
WHERE poblacion > (SELECT DISTINCT SUM(P.poblacion) OVER(PARTITION BY R.codigo_region)
FROM PAIS P INNER JOIN REGION R ON P.codigo_region = R.codigo_region 
WHERE R.nombre = 'Sur America');

--reporte 18

--reporte 19
SELECT DISTINCT P.nombre, F.nombre FROM PAIS P INNER JOIN FRONTERA PF
ON PF.codigo_pais = P.codigo_pais INNER JOIN PAIS F
ON PF.codigo_frontera = F.codigo_pais
ORDER BY P.nombre, F.nombre DESC;

--reporte 20
SELECT S.pais, S.area FROM (SELECT DISTINCT P.nombre pais, P.area area, COUNT(*) OVER(PARTITION BY P.nombre) cuenta FROM PAIS P
INNER JOIN (SELECT DISTINCT codigo_pais, codigo_frontera FROM FRONTERA)
F ON F.codigo_pais = P.codigo_pais ORDER BY P.nombre) S
WHERE S.cuenta > 7 ORDER BY S.area DESC;



