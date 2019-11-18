OPTIONS (SKIP=1)
LOAD DATA
INFILE '/home/jav/Documents/encuestas.csv'
TRUNCATE
INTO TABLE 
fields terminated by ";"
TRAILING NULLCOLS
(
    encuesta,
    pregunta,
    respuesta,
    correcta,
    pais "REPLACE(:pais, CHR(13), '')"
)