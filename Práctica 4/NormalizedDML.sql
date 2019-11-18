DROP TABLE TEMPORAL;
DROP TABLE ZONA_PADRE;
DROP TABLE ZONA;
DROP TABLE TIPO_ZONA;
DROP TABLE CARACTERISTICA;
DROP TABLE CARACTERISTICA_ELECCION;
DROP TABLE SEXO;
DROP TABLE RAZA;
DROP TABLE PARTIDO_POLITICO;
DROP TABLE ELECCION_ZONA;
DROP TABLE ELECCION;

CREATE TABLE TEMPORAL (
    nombre_eleccion VARCHAR2(256), 
    anio_eleccion INTEGER,
    pais VARCHAR2(256),
    region VARCHAR2(256),
    departamento VARCHAR2(256),
    municipio VARCHAR2(256),
    partido VARCHAR2(256),
    nombre_partido VARCHAR2(256),
    sexo VARCHAR2(256),
    raza VARCHAR2(256),
    analfabetos INTEGER,
    alfabetos INTEGER,
    primaria INTEGER, 
    nivel_medio INTEGER,
    universitarios INTEGER
);

CREATE TABLE TIPO_ZONA (
    id_tipo_zona INTEGER NOT NULL UNIQUE,
    nombre VARCHAR2(32) PRIMARY KEY
);

CREATE TABLE ZONA (
    id_zona INTEGER GENERATED ALWAYS AS IDENTITY UNIQUE,
    nombre VARCHAR2(128) NOT NULL,
    tipo INTEGER NOT NULL,
    CONSTRAINT zona_pk PRIMARY KEY (nombre, tipo),
    CONSTRAINT tipo_fk FOREIGN KEY (tipo) REFERENCES TIPO_ZONA (id_tipo_zona)
);

CREATE TABLE ZONA_PADRE (
    id_zonarel INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_padre INTEGER NOT NULL,
    id_hijo INTEGER NOT NULL,
    id_relpadre INTEGER NULL,
    CONSTRAINT zpadre_fk FOREIGN KEY (id_padre) REFERENCES ZONA (id_zona),
    CONSTRAINT zhijo_fk FOREIGN KEY (id_hijo) REFERENCES ZONA (id_zona),
    CONSTRAINT zz_fk FOREIGN KEY (id_relpadre) REFERENCES ZONA_PADRE (id_zonarel),
    CONSTRAINT zp_unq UNIQUE (id_padre, id_hijo, id_relpadre)
);

CREATE TABLE ELECCION (
    nombre_eleccion VARCHAR2(128) NOT NULL,
    anio_eleccion INTEGER NOT NULL,
    id_eleccion INTEGER GENERATED ALWAYS AS IDENTITY UNIQUE,
    CONSTRAINT eleccion_pk PRIMARY KEY (nombre_eleccion, anio_eleccion)
);

CREATE TABLE ELECCION_ZONA (
    id_eleccion_zona INTEGER GENERATED ALWAYS AS IDENTITY UNIQUE,
    id_eleccion INTEGER NOT NULL, 
    id_zonarel INTEGER NOT NULL,
    CONSTRAINT ez_pk PRIMARY KEY (id_eleccion, id_zonarel),
    CONSTRAINT ee_fk FOREIGN KEY (id_eleccion) REFERENCES ELECCION (id_eleccion),
    CONSTRAINT ez_fk FOREIGN KEY (id_zonarel) REFERENCES ZONA_PADRE (id_zonarel)
);

CREATE TABLE PARTIDO_POLITICO (
    id_partido INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    siglas VARCHAR2(32) NOT NULL, 
    nombre VARCHAR2(128) NOT NULL
);

CREATE TABLE RAZA (
    id_raza INTEGER GENERATED ALWAYS AS IDENTITY UNIQUE,
    nombre VARCHAR2(64) NOT NULL PRIMARY KEY
);

CREATE TABLE SEXO (
    id_sexo INTEGER GENERATED ALWAYS AS IDENTITY UNIQUE, 
    nombre VARCHAR2(32) NOT NULL PRIMARY KEY
);

CREATE TABLE CARACTERISTICA (
    id_caracteristica INTEGER NOT NULL UNIQUE,
    nombre_caracteristica VARCHAR2(32) PRIMARY KEY
);

CREATE TABLE CARACTERISTICA_ELECCION (
    sexo INTEGER NOT NULL,
    raza INTEGER NOT NULL,
    id_eleccion_zona INTEGER NOT NULL, 
    id_partido INTEGER NOT NULL,
    id_caracteristica INTEGER NOT NULL, 
    cantidad INTEGER NOT NULL,
    CONSTRAINT caracteristica_pk PRIMARY KEY (sexo, raza, id_eleccion_zona, id_partido, id_caracteristica),
    CONSTRAINT ce_sexofk FOREIGN KEY (sexo) REFERENCES SEXO (id_sexo),
    CONSTRAINT ce_razafk FOREIGN KEY (raza) REFERENCES RAZA (id_raza),
    CONSTRAINT ce_eleccionfk FOREIGN KEY (id_eleccion_zona) REFERENCES ELECCION_ZONA (id_eleccion_zona),
    CONSTRAINT ce_partidofk FOREIGN KEY (id_partido) REFERENCES PARTIDO_POLITICO (id_partido),
    CONSTRAINT ce_carfk FOREIGN KEY (id_caracteristica) REFERENCES CARACTERISTICA (id_caracteristica)
);
