OPTIONS (SKIP=1)
LOAD DATA
INFILE '/home/jav/Documents/datos.csv'
TRUNCATE
INTO TABLE Temporal
fields terminated by ","
(
    nombre_eleccion,
    anio_eleccion,
    pais,
    region,
    departamento,
    municipio,
    partido,
    nombre_partido,
    sexo,
    raza,
    analfabetos,
    alfabetos,
    primaria,
    nivel_medio,
    universitarios "REPLACE(:precio_unitario, CHR(13), '')"
)