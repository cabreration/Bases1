CREATE TABLE Temporal(
    invento VARCHAR2(128) NULL,
    inventor VARCHAR2(128) NULL,
    profesional_asignado VARCHAR2(128) NULL,
    jefe_area VARCHAR2(128) NULL,
    fecha_contratacion VARCHAR2(64) NULL,
    salario INTEGER NULL,
    comision INTEGER NULL,
    area_investigacion VARCHAR2(128) NULL,
    ranking INTEGER NULL,
    anio_invento INTEGER NULL, 
    pais_invento VARCHAR2(128) NULL,
    pais_inventor VARCHAR2(128) NULL,
    region VARCHAR2(128) NULL,
    capital VARCHAR2(128) NULL,
    poblacion INTEGER NULL,
    area INTEGER NULL, 
    frontera VARCHAR2(128) NULL,
    norte CHAR(1) NULL,
    sur CHAR(1) NULL,
    este CHAR(1) NULL,
    oeste CHAR(1) NULL
);

CREATE TABLE TEMPORAL2(
    encuesta VARCHAR2(128),
    pregunta VARCHAR2(1024),
    respuesta VARCHAR2(128),
    correcta VARCHAR2(10) DEFAULT 'Si',
    pais VARCHAR2(128)
);

CREATE TABLE REGION (
    codigo_region INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(128) NOT NULL,
    region_padre INTEGER NULL,
    CONSTRAINT region_pk PRIMARY KEY (codigo_region),
    CONSTRAINT region_rfk FOREIGN KEY (region_padre) REFERENCES REGION (codigo_region) 
);

CREATE TABLE PAIS (
    codigo_pais INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(128) NOT NULL,
    area INTEGER NOT NULL,
    poblacion INTEGER NOT NULL,
    capital VARCHAR2(128) NOT NULL,
    codigo_region INTEGER NOT NULL,
    CONSTRAINT pais_pk PRIMARY KEY (codigo_pais),
    CONSTRAINT region_fk FOREIGN KEY (codigo_region) REFERENCES REGION (codigo_region)
);

CREATE TABLE FRONTERA (
    codigo_pais INTEGER NOT NULL,
    codigo_frontera INTEGER NOT NULL,
    neso CHAR(1) NOT NULL,
    CONSTRAINT frontera_pk PRIMARY KEY (codigo_pais, codigo_frontera, neso),
    CONSTRAINT pais_ffk FOREIGN KEY (codigo_pais) REFERENCES PAIS (codigo_pais),
    CONSTRAINT frontera_ffk FOREIGN KEY (codigo_frontera) REFERENCES PAIS (codigo_pais)
);

CREATE TABLE AREA_INVESTIGACION(
    codigo_area INTEGER GENERATED ALWAYS AS IDENTITY, 
    nombre VARCHAR2(128) NOT NULL, 
    rango INTEGER NOT NULL,
    CHECK (rango < 11 and rango >= 1),
    CONSTRAINT ainv_pk PRIMARY KEY (codigo_area)
);

CREATE TABLE PROFESIONAL (
    codigo_profesional INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(128) NOT NULL, 
    salario INTEGER NOT NULL,
    comision INTEGER NULL,
    fecha_inicio_labores VARCHAR2(128) NOT NULL,
    jefe_general CHAR(1) DEFAULT 0,
    jefe_area INTEGER NULL,
    CHECK (jefe_general in (0, 1)),
    CONSTRAINT profesional_pk PRIMARY KEY (codigo_profesional),
    CONSTRAINT prof_fk FOREIGN KEY (jefe_area) REFERENCES AREA_INVESTIGACION(codigo_area)
);

CREATE TABLE INVENTO (
    numero_patente INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(256) NOT NULL,
    codigo_pais INTEGER NOT NULL,
    codigo_profesional INTEGER NOT NULL,
    anio_creacion INTEGER NOT NULL,
    CONSTRAINT invento_pk PRIMARY KEY (numero_patente),
    CONSTRAINT pais_ifk FOREIGN KEY (codigo_pais) REFERENCES PAIS (codigo_pais),
    CONSTRAINT pro_ifk FOREIGN KEY (codigo_profesional) REFERENCES PROFESIONAL(codigo_profesional)
);

CREATE TABLE INVENTOR (
    codigo_inventor INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(128) NOT NULL,
    codigo_pais INTEGER NOT NULL,
    CONSTRAINT inventor_pk PRIMARY KEY (codigo_inventor),
    CONSTRAINT pais_torfk FOREIGN KEY (codigo_pais) REFERENCES PAIS (codigo_pais)
);

CREATE TABLE INVENTO_INVENTOR (
    numero_patente INTEGER NOT NULL,
    codigo_inventor INTEGER NOT NULL,
    CONSTRAINT invento_inventor_pk PRIMARY KEY (numero_patente, codigo_inventor),
    CONSTRAINT iento_fk FOREIGN KEY (numero_patente) REFERENCES INVENTO (numero_patente),
    CONSTRAINT itor_fk FOREIGN KEY (codigo_inventor) REFERENCES INVENTOR (codigo_inventor)
);

CREATE TABLE AREA_PROFESIONAL (
    codigo_profesional INTEGER NOT NULL, 
    codigo_area INTEGER NOT NULL,
    CONSTRAINT apro_pk PRIMARY KEY (codigo_profesional, codigo_area),
    CONSTRAINT pro_aprofk FOREIGN KEY (codigo_profesional) REFERENCES PROFESIONAL (codigo_profesional),
    CONSTRAINT ar_aprofk FOREIGN KEY (codigo_area) REFERENCES AREA_INVESTIGACION (codigo_area)
);

CREATE TABLE ENCUESTA (
    codigo_encuesta INTEGER GENERATED ALWAYS AS IDENTITY,
    tema VARCHAR2(1024) NOT NULL, 
    CONSTRAINT encuesta_pk PRIMARY KEY (codigo_encuesta) 
);

CREATE TABLE PREGUNTA (
    codigo_pregunta INTEGER GENERATED ALWAYS AS IDENTITY,
    descripcion VARCHAR2(2048) NOT NULL,
    codigo_encuesta INTEGER NOT NULL,
    CONSTRAINT pregunta_pk PRIMARY KEY (codigo_pregunta),
    CONSTRAINT pre_encfk FOREIGN KEY (codigo_encuesta) REFERENCES ENCUESTA (codigo_encuesta)
);

CREATE TABLE RESPUESTA (
    codigo_respuesta INTEGER GENERATED ALWAYS AS IDENTITY,
    valor VARCHAR2(2048),
    correcta VARCHAR2(10) DEFAULT 1, 
    codigo_pregunta INTEGER NOT NULL,
    CONSTRAINT respuesta_pk PRIMARY KEY (codigo_respuesta),
    CONSTRAINT resp_prefk FOREIGN KEY (codigo_pregunta) REFERENCES PREGUNTA(codigo_pregunta)
);

CREATE TABLE PAIS_RESPUESTA (
    codigo_respuesta INTEGER NOT NULL, 
    codigo_pais INTEGER NOT NULL,
    CONSTRAINT pres_pk PRIMARY KEY (codigo_respuesta, codigo_pais),
    CONSTRAINT pres_resfk FOREIGN KEY (codigo_respuesta) REFERENCES RESPUESTA (codigo_respuesta),
    CONSTRAINT pres_pafk FOREIGN KEY (codigo_pais) REFERENCES PAIS (codigo_pais)
);
