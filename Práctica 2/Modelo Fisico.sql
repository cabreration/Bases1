CREATE TABLE ARTISTA(
	nombre VARCHAR2(96),
	conocido CHAR(1) NOT NULL,
	CHECK (conocido in (0, 1)), 
	CONSTRAINT propietario_pk PRIMARY KEY (nombre)
);

CREATE TABLE TIPO_EXPOSICION(
	codigo_tipoE INTEGER GENERATED ALWAYS AS IDENTITY, -- implementada de forma autoincremental
	nombre VARCHAR2(96) NOT NULL,
	CONSTRAINT tipoE_pk PRIMARY KEY (codigo_tipoE)
);

CREATE TABLE EXPOSICION(
	codigo_exposicion INTEGER GENERATED ALWAYS AS IDENTITY, --implementada de forma autoincremental
	tema VARCHAR2(96),
	fecha_inicio DATE NOT NULL,
	tipo_exposicion INTEGER NOT NULL,
	artista VARCHAR2(96),
	CONSTRAINT exposicion_pk PRIMARY KEY (codigo_exposicion),
	CONSTRAINT tipoE_fk FOREIGN KEY (tipo_exposicion) REFERENCES TIPO_EXPOSICION (codigo_tipoE),
	CONSTRAINT artista_fk FOREIGN KEY (artista) REFERENCES ARTISTA (nombre)
);

CREATE TABLE MEDIO_PUBLICIDAD(
	codigo_medioP INTEGER GENERATED ALWAYS AS IDENTITY, --autoincremental
	nombre VARCHAR2(96) NOT NULL, 
	telefono VARCHAR2 NOT NULL, 
	correo_eletronico VARCHAR2(96) NOT NULL,
	tarifa_regular NUMBER NOT NULL,
	CONSTRAINT medio_publicidadPK PRIMARY KEY (codigo_medioP)
);

CREATE TABLE PUBLICIDAD_EXPOSICION(
	medio_publicidad INTEGER, 
	exposicion INTEGER,
	CONSTRAINT medioP_fk FOREIGN KEY (medio_publicidad) REFERENCES MEDIO_PUBLICIDAD (codigo_medioP),
	CONSTRAINT exposicionP_fk FOREIGN KEY (exposicion) REFERENCES EXPOSICION (codigo_exposicion),
	CONSTRAINT publicidad_pk PRIMARY KEY (medio_publicidad, exposicion)
);

CREATE TABLE MEDIO(
	codigo_medio INTEGER,
	nombre VARCHAR2(96) NOT NULL,
	CONSTRAINT medio_pk PRIMARY KEY (codigo_medio)
);

CREATE TABLE ESTILO(
	codigo_estilo INTEGER,
	nombre VARCHAR2(96) NOT NULL,
	CONSTRAINT estilo_pk PRIMARY KEY (codigo_estilo)
);

CREATE TABLE TIPO(
	codigo_tipo INTEGER,
	nombre VARCHAR2(96) NOT NULL,
	CONSTRAINT tipo_pk PRIMARY KEY (codigo_tipo)
);

CREATE TABLE CLIENTE(
	codigo_cliente INTEGER GENERATED ALWAYS AS IDENTITY,
	nombre VARCHAR2(96) NOT NULL,
	correo_electronico VARCHAR2(96) NOT NULL,
	direccion VARCHAR2(96) NOT NULL,
	telefono VARCHAR2(96) NOT NULL,
	CONSTRAINT cliente_pk PRIMARY KEY (codigo_cliente)
);

CREATE TABLE VENDEDOR(
	codigo_vendedor INTEGER, 
	nombre VARCHAR2(96) NOT NULL,
	CONSTRAINT vendedor_pk PRIMARY KEY (codigo_vendedor)
);

CREATE TABLE COMPRA_VENTA(
	numero_factura INTEGER,
	fecha_compra DATE NOT NULL,
	cliente INTEGER NOT NULL,
	CONSTRAINT compraVenta_pk PRIMARY KEY (numero_factura),
	CONSTRAINT cliente_fk FOREIGN KEY (cliente) REFERENCES CLIENTE (codigo_cliente)
);

CREATE TABLE OBRA(
	titulo VARCHAR2(96),
	fecha_creacion DATE NOT NULL,
	fecha_ingreso DATE NOT NULL,
	precio_solicitado NUMBER NOT NULL,
	precio_venta NUMBER,
	vendida CHAR(1),
	aprobada CHAR(1),
	anchura NUMBER NOT NULL,
	altura NUMBER NOT NULL,
	profundidad NUMBER,
	artista VARCHAR2(96) NOT NULL,
	medio INTEGER NOT NULL,
	estilo INTEGER NOT NULL,
	tipo INTEGER NOT NULL,
	compra_venta INTEGER,
	propietario INTEGER,
	vendedor INTEGER,
	exposicion INTEGER,
	CHECK (vendida in (0, 1)),
	CHECK (aprobada in (0, 1)),
	CONSTRAINT artista_fk FOREIGN KEY (artista) REFERENCES ARTISTA (nombre),
	CONSTRAINT medio_fk FOREIGN KEY (medio) REFERENCES MEDIO (codigo_medio),
	CONSTRAINT estilo_fk FOREIGN KEY (estilo) REFERENCES ESTILO (codigo_estilo),
	CONSTRAINT tipo_fk FOREIGN KEY (tipo) REFERENCES TIPO (codigo_tipo),
	CONSTRAINT compraVenta_fk FOREIGN KEY (compra_venta) REFERENCES COMPRA_VENTA (numero_factura),
	CONSTRAINT obra_pk PRIMARY KEY (titulo, artista),
	CONSTRAINT propietario_fk FOREIGN KEY (propietario) REFERENCES CLIENTE (codigo_cliente),
	CONSTRAINT vendedor_fk FOREIGN KEY (vendedor) REFERENCES VENDEDOR (codigo_vendedor),
	CONSTRAINT exposicionO_fk FOREIGN KEY (exposicion) REFERENCES EXPOSICION (codigo_exposicion)
);

CREATE TABLE MEDIO_CLIENTE(
	medio INTEGER,
	cliente INTEGER,
	CONSTRAINT medioC_fk FOREIGN KEY (medio) REFERENCES MEDIO (codigo_medio),
	CONSTRAINT clienteM_fk FOREIGN KEY (cliente) REFERENCES CLIENTE (codigo_cliente),
	CONSTRAINT medio_cliente_pk PRIMARY KEY (medio, cliente)
);

CREATE TABLE ESTILO_CLIENTE(
	estilo INTEGER,
	cliente INTEGER,
	CONSTRAINT estiloC_fk FOREIGN KEY (estilo) REFERENCES ESTILO (codigo_estilo),
	CONSTRAINT clienteE_fk FOREIGN KEY (cliente) REFERENCES CLIENTE (codigo_cliente),
	CONSTRAINT estilo_cliente_pk PRIMARY KEY (estilo, cliente)
);

CREATE TABLE TIPO_CLIENTE(
	tipo INTEGER,
	cliente INTEGER,
	CONSTRAINT tipoC_fk FOREIGN KEY (tipo) REFERENCES TIPO (codigo_tipo),
	CONSTRAINT clienteT_fk FOREIGN KEY (cliente) REFERENCES CLIENTE (codigo_cliente),
	CONSTRAINT tipo_cliente_pk PRIMARY KEY (tipo, cliente)
);