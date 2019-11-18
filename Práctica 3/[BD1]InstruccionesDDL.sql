CREATE TABLE Carga(
    nombre_compania varchar2(128), -- done
    contacto_compania varchar2(128), -- done
    correo_compania varchar2(128), -- done
    telefono_compania varchar2(32), -- done
    tipo char(1), -- done
    nombre varchar2(128), -- done
    correo varchar2(128), -- done
    telefono varchar2(32), -- done
    fecha_registro Date, -- done
    direccion varchar2(256), -- done
    ciudad varchar2(128), -- done
    codigo_postal Number, -- done
    region varchar2(128), -- done
    producto varchar2(128), -- done
    categoria_producto varchar2(128), -- done
    cantidad integer,
    precio_unitario number -- done
);

CREATE TABLE COMPANIA(
    codigo_compania INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(128) NOT NULL,
    contacto VARCHAR2(128) NOT NULL,
    correo_electronico VARCHAR2(128) NOT NULL,
    telefono VARCHAR2(32),
    CONSTRAINT compania_pk PRIMARY KEY(codigo_compania)
);

CREATE TABLE TERRITORIO(
    codigo_territorio INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(128) NOT NULL,
    tipo char(1) NOT NULL,
    region INTEGER NULL,
    CONSTRAINT territorio_pk PRIMARY KEY(codigo_territorio),
    CONSTRAINT region_fk FOREIGN KEY (region) REFERENCES TERRITORIO (codigo_territorio)
);

CREATE TABLE CLIENTE_PROVEEDOR(
    codigo INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(128) NOT NULL,
    correo VARCHAR2(128) NOT NULL,
    telefono VARCHAR2(32) NOT NULL,
    fecha_registro DATE NOT NULL,
    direccion VARCHAR2(256) NOT NULL,
    codigo_postal NUMBER NOT NULL,
    codigo_ciudad INTEGER NOT NULL,
    tipo Char(1) NOT NULL,
    CONSTRAINT cp_pk PRIMARY KEY(codigo),
    CONSTRAINT territorio_fk FOREIGN KEY(codigo_ciudad) REFERENCES TERRITORIO(codigo_territorio)
);

CREATE TABLE CATEGORIA(
    codigo_categoria INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(128) NOT NULL,
    CONSTRAINT categoria_pk PRIMARY KEY (codigo_categoria)
);

CREATE TABLE PRODUCTO(
    codigo_producto INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(128) NOT NULL,
    precio_unitario NUMBER NOT NULL,
    codigo_categoria INTEGER NOT NULL,
    CONSTRAINT producto_pk PRIMARY KEY (codigo_producto),
    CONSTRAINT categoria_fk FOREIGN KEY (codigo_categoria) REFERENCES CATEGORIA (codigo_categoria)
);

CREATE TABLE COMPRA_VENTA(
    codigo_compania INTEGER NOT NULL,
    cliente_proveedor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    numero_transaccion INTEGER GENERATED ALWAYS AS IDENTITY UNIQUE,
    CONSTRAINT compraventa_pk PRIMARY KEY (codigo_compania, cliente_proveedor),
    CONSTRAINT cp_compania_fk FOREIGN KEY (codigo_compania) REFERENCES COMPANIA (codigo_compania),
    CONSTRAINT cp_cp_fk FOREIGN KEY (cliente_proveedor) REFERENCES CLIENTE_PROVEEDOR (codigo)
);

CREATE TABLE DETALLE_COMPRAVENTA(
    codigo_compania INTEGER NOT NULL,
    cliente_proveedor INTEGER NOT NULL,
    codigo_producto INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    CONSTRAINT detalle_pk PRIMARY KEY (codigo_compania, cliente_proveedor, codigo_producto),
    CONSTRAINT detalleproducto_fk FOREIGN KEY (codigo_producto) REFERENCES PRODUCTO (codigo_producto),
    CONSTRAINT detallefactura_fk FOREIGN KEY (codigo_compania, cliente_proveedor) REFERENCES COMPRA_VENTA (codigo_compania, cliente_proveedor)
);