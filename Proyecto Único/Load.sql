--regiones
INSERT INTO REGION(nombre) SELECT DISTINCT region FROM Temporal;

--paises
INSERT INTO PAIS(nombre, area, poblacion, capital, codigo_region) SELECT DISTINCT T.pais_inventor, T.area, T.poblacion, T.capital, R.codigo_region FROM Temporal T
INNER JOIN REGION R ON T.region = R.nombre;

INSERT INTO PAIS(nombre, area, poblacion, capital, codigo_region) 
VALUES ('Belgica', 30528, 11409077, 'Bruselas', 14);

--paises y sus fronteras
INSERT INTO FRONTERA(codigo_pais, codigo_frontera, neso) SELECT DISTINCT P.codigo_pais, F.codigo_pais, 
CASE WHEN norte IS NOT NULL THEN 'N'
WHEN sur IS NOT null THEN 'S'
WHEN este IS NOT NULL THEN 'E'
ELSE 'O'
END DIR FROM TEMPORAL T
INNER JOIN PAIS P ON T.pais_inventor = P.nombre
INNER JOIN PAIS F ON T.frontera = F.nombre WHERE frontera IS NOT NULL;

--carga de areas de investigacion
INSERT INTO AREA_INVESTIGACION(nombre, rango) SELECT DISTINCT area_investigacion, ranking FROM TEMPORAL WHERE area_investigacion IS NOT NULL;

--carga de profesionales que no son el mero cabezon
INSERT INTO PROFESIONAL(nombre, salario, fecha_inicio_labores, comision, jefe_area) SELECT DISTINCT T.profesional_asignado, T.salario, T.fecha_contratacion, T.comision, A.codigo_area  FROM TEMPORAL T LEFT JOIN AREA_INVESTIGACION A
ON T.jefe_area = A.nombre
WHERE (jefe_area IS NULL OR jefe_area != 'TODAS') AND profesional_asignado IS NOT NULL;

--carga de profesionales que es el mero cabezon
INSERT INTO PROFESIONAL(nombre, salario, fecha_inicio_labores, jefe_general, comision) SELECT DISTINCT profesional_asignado, salario, fecha_contratacion, 1, comision FROM TEMPORAL 
WHERE jefe_area = 'TODAS' AND profesional_asignado IS NOT NULL;

UPDATE PROFESIONAL SET comision = 0 where comision is null;

--carga de areas profesionales
INSERT INTO AREA_PROFESIONAL(codigo_profesional, codigo_area) SELECT DISTINCT P.codigo_profesional, A.codigo_area FROM TEMPORAL T
INNER JOIN PROFESIONAL P ON T.profesional_asignado = P.nombre
INNER JOIN AREA_INVESTIGACION A ON T.area_investigacion = A.nombre
WHERE T.profesional_asignado IS NOT NULL AND T.area_investigacion IS NOT NULL;

--carga de inventos
INSERT INTO INVENTO(nombre, codigo_pais, codigo_profesional, anio_creacion) SELECT DISTINCT T.invento, P.codigo_pais, F.codigo_profesional, T.anio_invento
FROM TEMPORAL T INNER JOIN Pais P 
ON T.pais_invento = P.nombre 
INNER JOIN PROFESIONAL F ON T.profesional_asignado = F.nombre
WHERE T.invento IS NOT NULL;

--inventores
INSERT INTO INVENTOR(nombre, codigo_pais) SELECT DISTINCT REGEXP_SUBSTR(T.inventor,'[^,]+') inventor, P.codigo_pais
FROM TEMPORAL T INNER JOIN PAIS P ON T.pais_inventor = P.nombre WHERE inventor IS NOT NULL ORDER BY inventor;

INSERT INTO INVENTOR(nombre, codigo_pais) SELECT * FROM (SELECT DISTINCT REGEXP_SUBSTR(T.inventor,'[^,]+', 1, 2) inventor, P.codigo_pais
FROM TEMPORAL T INNER JOIN PAIS P ON T.pais_inventor = P.nombre WHERE T.inventor IS NOT NULL ORDER BY inventor) WHERE inventor IS NOT NULL;

INSERT INTO INVENTOR(nombre, codigo_pais) SELECT * FROM (SELECT DISTINCT REGEXP_SUBSTR(T.inventor,'[^,]+', 1, 3) inventor, P.codigo_pais
FROM TEMPORAL T INNER JOIN PAIS P ON T.pais_inventor = P.nombre WHERE T.inventor IS NOT NULL ORDER BY inventor) WHERE inventor IS NOT NULL;

--relacion entre inventos e inventores
INSERT INTO INVENTO_INVENTOR(codigo_inventor, numero_patente) SELECT N.inventor, I.numero_patente FROM (SELECT IT.codigo_inventor inventor, T.pais, T.invento invento FROM (SELECT DISTINCT REGEXP_SUBSTR(T.inventor,'[^,]+') inventor, P.codigo_pais pais, T.invento invento
FROM TEMPORAL T INNER JOIN PAIS P ON T.pais_inventor = P.nombre WHERE inventor IS NOT NULL ORDER BY inventor) T
INNER JOIN INVENTOR IT ON IT.nombre = T.inventor AND IT.codigo_pais = T.pais) N
INNER JOIN INVENTO I ON N.invento = I.nombre AND N.pais = I.codigo_pais;

INSERT INTO INVENTO_INVENTOR(codigo_inventor, numero_patente) SELECT N.inventor, I.numero_patente FROM (SELECT IT.codigo_inventor inventor, T.pais, T.invento invento FROM (SELECT DISTINCT REGEXP_SUBSTR(T.inventor,'[^,]+', 1, 2) inventor, P.codigo_pais pais, T.invento invento
FROM TEMPORAL T INNER JOIN PAIS P ON T.pais_inventor = P.nombre WHERE inventor IS NOT NULL ORDER BY inventor) T
INNER JOIN INVENTOR IT ON IT.nombre = T.inventor AND IT.codigo_pais = T.pais) N
INNER JOIN INVENTO I ON N.invento = I.nombre AND N.pais = I.codigo_pais;

INSERT INTO INVENTO_INVENTOR(codigo_inventor, numero_patente) SELECT N.inventor, I.numero_patente FROM (SELECT IT.codigo_inventor inventor, T.pais, T.invento invento FROM (SELECT DISTINCT REGEXP_SUBSTR(T.inventor,'[^,]+', 1, 3) inventor, P.codigo_pais pais, T.invento invento
FROM TEMPORAL T INNER JOIN PAIS P ON T.pais_inventor = P.nombre WHERE inventor IS NOT NULL ORDER BY inventor) T
INNER JOIN INVENTOR IT ON IT.nombre = T.inventor AND IT.codigo_pais = T.pais) N
INNER JOIN INVENTO I ON N.invento = I.nombre AND N.pais = I.codigo_pais;

--encuestas
INSERT INTO ENCUESTA(tema) SELECT DISTINCT encuesta FROM TEMPORAL2;

--preguntas
INSERT INTO PREGUNTA(descripcion, codigo_encuesta) SELECT DISTINCT T.pregunta, E.codigo_encuesta FROM TEMPORAL2 T INNER JOIN ENCUESTA E ON T.encuesta = E.tema;

--respuestas
INSERT INTO RESPUESTA(valor, correcta, codigo_pregunta) SELECT DISTINCT T.respuesta, T.correcta, P.codigo_pregunta FROM TEMPORAL2 T INNER JOIN PREGUNTA P ON T.pregunta = P.descripcion;

--relacion entre respuesta y pais
INSERT INTO PAIS_RESPUESTA(codigo_respuesta, codigo_pais) SELECT DISTINCT R.codigo_respuesta, P.codigo_pais FROM TEMPORAL2 T INNER JOIN
PAIS P ON P.nombre = T.pais INNER JOIN PREGUNTA Q 
ON Q.descripcion = T.pregunta INNER JOIN RESPUESTA R ON R.valor = T.respuesta AND R.codigo_pregunta = Q.codigo_pregunta;


