OPTIONS (SKIP=1)
LOAD DATA
INFILE '/home/jav/Documents/datos.csv'
TRUNCATE
INTO TABLE Temporal
fields terminated by ","
TRAILING NULLCOLS
(
    invento,
    inventor,
    profesional_asignado,
    jefe_area,
    fecha_contratacion,
    salario,
    comision,
    area_investigacion,
    ranking,
    anio_invento,
    pais_invento,
    pais_inventor, 
    region,
    capital,
    poblacion, 
    area,
    frontera,
    norte,
    sur,
    este,
    oeste "REPLACE(:precio_unitario, CHR(13), '')"
)