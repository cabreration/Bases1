OPTIONS (SKIP=1)
LOAD DATA
INFILE '/home/jav/Documents/DataCenterData.csv'
TRUNCATE
INTO TABLE Carga
fields terminated by ";"
(
    nombre_compania,
    contacto_compania,
    correo_compania,
    telefono_compania,
    tipo,
    nombre,
    correo,
    telefono,
    fecha_registro date "dd/mm/yyyy",
    direccion,
    ciudad,
    codigo_postal,
    region,
    producto,
    categoria_producto,
    cantidad,
    precio_unitario "REPLACE(:precio_unitario, CHR(13), '')"
)
