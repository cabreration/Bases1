INSERT INTO TIPO_ZONA(id_tipo_zona, nombre) VALUES (1, 'pais');
INSERT INTO TIPO_ZONA(id_tipo_zona, nombre) VALUES (2, 'region');
INSERT INTO TIPO_ZONA(id_tipo_zona, nombre) VALUES (3, 'departamento');
INSERT INTO TIPO_ZONA(id_tipo_zona, nombre) VALUES (4, 'municipio');

--carga de paises
INSERT INTO ZONA(nombre, tipo) 
SELECT DISTINCT pais, 1 FROM TEMPORAL 
ORDER BY pais ASC;

--carga de regiones
INSERT INTO ZONA(nombre, tipo) 
SELECT DISTINCT region, 2 FROM TEMPORAL 
ORDER BY region ASC;

--carga de departamentos
INSERT INTO ZONA(nombre, tipo) 
SELECT DISTINCT departamento, 3 FROM TEMPORAL 
ORDER BY departamento ASC;

--carga de municipios
INSERT INTO ZONA(nombre, tipo) 
SELECT DISTINCT municipio, 4 FROM TEMPORAL 
ORDER BY municipio ASC;

--relacion entre pais y region
INSERT INTO ZONA_PADRE(id_padre, id_hijo)
SELECT DISTINCT P.id_zona, R.id_zona FROM TEMPORAL T
INNER JOIN ZONA P ON P.nombre = T.pais
INNER JOIN ZONA R ON R.nombre = T.region
WHERE P.tipo = 1 AND R.tipo = 2;

--relacion entre region y departamento
INSERT INTO ZONA_PADRE(id_padre, id_hijo, id_relpadre)
SELECT DISTINCT R.id_zona, D.id_zona, ZP.id_zonarel FROM TEMPORAL T
INNER JOIN ZONA D ON D.nombre = T.departamento
INNER JOIN ZONA R ON R.nombre = T.region
INNER JOIN ZONA P ON P.nombre = T.pais
INNER JOIN ZONA_PADRE ZP ON ZP.id_padre = P.id_zona AND ZP.id_hijo = R.id_zona
WHERE D.tipo = 3 AND R.tipo = 2 AND P.tipo = 1;

--relacion entre municipio y departamento
INSERT INTO ZONA_PADRE(id_padre, id_hijo, id_relpadre)
SELECT DISTINCT D.id_zona, M.id_zona, DR.id_zonarel FROM TEMPORAL T
INNER JOIN ZONA M ON M.nombre = T.municipio
INNER JOIN ZONA D ON D.nombre = T.departamento
INNER JOIN ZONA R ON R.nombre = T.region
INNER JOIN ZONA P ON P.nombre = T.pais
INNER JOIN ZONA_PADRE DR ON DR.id_padre = R.id_zona AND DR.id_hijo = D.id_zona
INNER JOIN ZONA_PADRE RP ON RP.id_zonarel = DR.id_relpadre AND P.id_zona = RP.id_padre
WHERE M.tipo = 4 AND D.tipo = 3 AND R.tipo = 2 AND P.tipo = 1;

--carga de elecciones
INSERT INTO ELECCION(nombre_eleccion, anio_eleccion)
SELECT DISTINCT nombre_eleccion, anio_eleccion FROM TEMPORAL
ORDER BY anio_eleccion ASC;

--relacion entre eleccion y su zona
INSERT INTO ELECCION_ZONA(id_eleccion, id_zonarel) 
SELECT DISTINCT E.id_eleccion, MD.id_zonarel FROM TEMPORAL T
INNER JOIN ELECCION E ON E.nombre_eleccion = T.nombre_eleccion AND E.anio_eleccion = T.anio_eleccion
INNER JOIN ZONA M ON M.nombre = T.municipio 
INNER JOIN ZONA D ON D.nombre = T.departamento
INNER JOIN ZONA R ON R.nombre = T.region 
INNER JOIN ZONA P ON P.nombre = T.pais
INNER JOIN ZONA_PADRE MD ON MD.id_padre = D.id_zona AND MD.id_hijo = M.id_zona
INNER JOIN ZONA_PADRE DR ON DR.id_zonarel = MD.id_relpadre AND DR.id_padre = R.id_zona
INNER JOIN ZONA_PADRE RP ON RP.id_zonarel = DR.id_relpadre AND RP.id_padre = P.id_zona
WHERE M.tipo = 4 AND D.tipo = 3 AND R.tipo = 2 AND P.tipo = 1;

--carga de partidos politicas
INSERT INTO PARTIDO_POLITICO(siglas, nombre)
SELECT DISTINCT partido, nombre_partido
FROM TEMPORAL
ORDER BY nombre_partido ASC;

--carga de razas
INSERT INTO RAZA(nombre)
SELECT DISTINCT raza 
FROM TEMPORAL 
ORDER BY RAZA ASC;

--carga de sexos
INSERT INTO SEXO(nombre)
SELECT DISTINCT sexo
FROM TEMPORAL 
ORDER BY SEXO ASC;

INSERT INTO CARACTERISTICA(id_caracteristica, nombre_caracteristica) VALUES (1, 'alfabetos');
INSERT INTO CARACTERISTICA(id_caracteristica, nombre_caracteristica) VALUES (2, 'analfabetos');
INSERT INTO CARACTERISTICA(id_caracteristica, nombre_caracteristica) VALUES (3, 'primaria');
INSERT INTO CARACTERISTICA(id_caracteristica, nombre_caracteristica) VALUES (4, 'nivel medio');
INSERT INTO CARACTERISTICA(id_caracteristica, nombre_caracteristica) VALUES (5, 'universitarios');

--carga de caracteristicas: ANALFABETOS
INSERT INTO CARACTERISTICA_ELECCION(sexo, raza, id_partido, id_eleccion_zona, id_caracteristica, cantidad)
SELECT S.id_sexo, Z.id_raza, PP.id_partido, EZ.id_eleccion_zona, 1, T.analfabetos
FROM TEMPORAL T INNER JOIN SEXO S ON T.sexo = S.nombre
INNER JOIN RAZA Z ON T.raza = Z.nombre
INNER JOIN PARTIDO_POLITICO PP ON T.partido = PP.siglas
INNER JOIN ZONA M ON M.nombre = T.municipio 
INNER JOIN ZONA D ON D.nombre = T.departamento
INNER JOIN ZONA R ON R.nombre = T.region 
INNER JOIN ZONA P ON P.nombre = T.pais
INNER JOIN ZONA_PADRE MR ON MR.id_padre = D.id_zona AND MR.id_hijo = M.id_zona
INNER JOIN ZONA_PADRE DR ON DR.id_zonarel = MR.id_relpadre AND DR.id_padre = R.id_zona
INNER JOIN ZONA_PADRE RP ON RP.id_zonarel = DR.id_relpadre AND RP.id_padre = P.id_zona
INNER JOIN ELECCION E ON E.nombre_eleccion = T.nombre_eleccion AND E.anio_eleccion = T.anio_eleccion
INNER JOIN ELECCION_ZONA EZ ON E.id_eleccion = EZ.id_eleccion AND MR.id_zonarel = EZ.id_zonarel
WHERE M.tipo = 4 AND D.tipo = 3 AND R.tipo = 2 AND P.tipo = 1;

--carga de caracteristicas: ALFABETOS
INSERT INTO CARACTERISTICA_ELECCION(sexo, raza, id_partido, id_eleccion_zona, id_caracteristica, cantidad)
SELECT S.id_sexo, Z.id_raza, PP.id_partido, EZ.id_eleccion_zona, 2, T.alfabetos
FROM TEMPORAL T INNER JOIN SEXO S ON T.sexo = S.nombre
INNER JOIN RAZA Z ON T.raza = Z.nombre
INNER JOIN PARTIDO_POLITICO PP ON T.partido = PP.siglas
INNER JOIN ZONA M ON M.nombre = T.municipio 
INNER JOIN ZONA D ON D.nombre = T.departamento
INNER JOIN ZONA R ON R.nombre = T.region 
INNER JOIN ZONA P ON P.nombre = T.pais
INNER JOIN ZONA_PADRE MR ON MR.id_padre = D.id_zona AND MR.id_hijo = M.id_zona
INNER JOIN ZONA_PADRE DR ON DR.id_zonarel = MR.id_relpadre AND DR.id_padre = R.id_zona
INNER JOIN ZONA_PADRE RP ON RP.id_zonarel = DR.id_relpadre AND RP.id_padre = P.id_zona
INNER JOIN ELECCION E ON E.nombre_eleccion = T.nombre_eleccion AND E.anio_eleccion = T.anio_eleccion
INNER JOIN ELECCION_ZONA EZ ON E.id_eleccion = EZ.id_eleccion AND MR.id_zonarel = EZ.id_zonarel
WHERE M.tipo = 4 AND D.tipo = 3 AND R.tipo = 2 AND P.tipo = 1;

--carga de caracteristicas: PRIMARIA
INSERT INTO CARACTERISTICA_ELECCION(sexo, raza, id_partido, id_eleccion_zona, id_caracteristica, cantidad)
SELECT S.id_sexo, Z.id_raza, PP.id_partido, EZ.id_eleccion_zona, 3, T.primaria
FROM TEMPORAL T INNER JOIN SEXO S ON T.sexo = S.nombre
INNER JOIN RAZA Z ON T.raza = Z.nombre
INNER JOIN PARTIDO_POLITICO PP ON T.partido = PP.siglas
INNER JOIN ZONA M ON M.nombre = T.municipio 
INNER JOIN ZONA D ON D.nombre = T.departamento
INNER JOIN ZONA R ON R.nombre = T.region 
INNER JOIN ZONA P ON P.nombre = T.pais
INNER JOIN ZONA_PADRE MR ON MR.id_padre = D.id_zona AND MR.id_hijo = M.id_zona
INNER JOIN ZONA_PADRE DR ON DR.id_zonarel = MR.id_relpadre AND DR.id_padre = R.id_zona
INNER JOIN ZONA_PADRE RP ON RP.id_zonarel = DR.id_relpadre AND RP.id_padre = P.id_zona
INNER JOIN ELECCION E ON E.nombre_eleccion = T.nombre_eleccion AND E.anio_eleccion = T.anio_eleccion
INNER JOIN ELECCION_ZONA EZ ON E.id_eleccion = EZ.id_eleccion AND MR.id_zonarel = EZ.id_zonarel
WHERE M.tipo = 4 AND D.tipo = 3 AND R.tipo = 2 AND P.tipo = 1;

--carga de caracteristicas: NIVEL MEDIO
INSERT INTO CARACTERISTICA_ELECCION(sexo, raza, id_partido, id_eleccion_zona, id_caracteristica, cantidad)
SELECT S.id_sexo, Z.id_raza, PP.id_partido, EZ.id_eleccion_zona, 4, T.nivel_medio
FROM TEMPORAL T INNER JOIN SEXO S ON T.sexo = S.nombre
INNER JOIN RAZA Z ON T.raza = Z.nombre
INNER JOIN PARTIDO_POLITICO PP ON T.partido = PP.siglas
INNER JOIN ZONA M ON M.nombre = T.municipio 
INNER JOIN ZONA D ON D.nombre = T.departamento
INNER JOIN ZONA R ON R.nombre = T.region 
INNER JOIN ZONA P ON P.nombre = T.pais
INNER JOIN ZONA_PADRE MR ON MR.id_padre = D.id_zona AND MR.id_hijo = M.id_zona
INNER JOIN ZONA_PADRE DR ON DR.id_zonarel = MR.id_relpadre AND DR.id_padre = R.id_zona
INNER JOIN ZONA_PADRE RP ON RP.id_zonarel = DR.id_relpadre AND RP.id_padre = P.id_zona
INNER JOIN ELECCION E ON E.nombre_eleccion = T.nombre_eleccion AND E.anio_eleccion = T.anio_eleccion
INNER JOIN ELECCION_ZONA EZ ON E.id_eleccion = EZ.id_eleccion AND MR.id_zonarel = EZ.id_zonarel
WHERE M.tipo = 4 AND D.tipo = 3 AND R.tipo = 2 AND P.tipo = 1;

--carga de caracteristicas: UNIVERSITARIOS
INSERT INTO CARACTERISTICA_ELECCION(sexo, raza, id_partido, id_eleccion_zona, id_caracteristica, cantidad)
SELECT S.id_sexo, Z.id_raza, PP.id_partido, EZ.id_eleccion_zona, 5, T.universitarios
FROM TEMPORAL T INNER JOIN SEXO S ON T.sexo = S.nombre
INNER JOIN RAZA Z ON T.raza = Z.nombre
INNER JOIN PARTIDO_POLITICO PP ON T.partido = PP.siglas
INNER JOIN ZONA M ON M.nombre = T.municipio 
INNER JOIN ZONA D ON D.nombre = T.departamento
INNER JOIN ZONA R ON R.nombre = T.region 
INNER JOIN ZONA P ON P.nombre = T.pais
INNER JOIN ZONA_PADRE MR ON MR.id_padre = D.id_zona AND MR.id_hijo = M.id_zona
INNER JOIN ZONA_PADRE DR ON DR.id_zonarel = MR.id_relpadre AND DR.id_padre = R.id_zona
INNER JOIN ZONA_PADRE RP ON RP.id_zonarel = DR.id_relpadre AND RP.id_padre = P.id_zona
INNER JOIN ELECCION E ON E.nombre_eleccion = T.nombre_eleccion AND E.anio_eleccion = T.anio_eleccion
INNER JOIN ELECCION_ZONA EZ ON E.id_eleccion = EZ.id_eleccion AND MR.id_zonarel = EZ.id_zonarel
WHERE M.tipo = 4 AND D.tipo = 3 AND R.tipo = 2 AND P.tipo = 1;
