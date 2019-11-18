--carga de companias
INSERT INTO COMPANIA(nombre, contacto, correo_electronico, telefono)
Select distinct nombre_compania, contacto_compania, correo_compania, telefono_compania from Carga order by nombre_compania asc;

--carga de categorias
INSERT INTO CATEGORIA(nombre) 
SELECT distinct categoria_producto from Carga order by categoria_producto asc;

--carga de productos
INSERT INTO PRODUCTO(nombre, precio_unitario, codigo_categoria)
SELECT distinct Carga.producto, Carga.precio_unitario, Categoria.codigo_categoria
from Carga inner join Categoria on Carga.categoria_producto = Categoria.nombre
order by Carga.producto asc; 

--carga de regiones
INSERT INTO TERRITORIO(nombre, tipo) 
SELECT DISTINCT region, 'R' from Carga order by region asc;

--carga de ciudades
INSERT INTO TERRITORIO(nombre, tipo, region)
SELECT DISTINCT C.ciudad, 'C', T.codigo_territorio
FROM Carga C INNER JOIN Territorio T on C.region = T.nombre
ORDER BY C.ciudad ASC; 

--carga de clientes
INSERT INTO CLIENTE_PROVEEDOR(nombre, correo, telefono, fecha_registro, direccion, codigo_postal, tipo, codigo_ciudad)
SELECT DISTINCT C.nombre, C.correo, C.telefono, C.fecha_registro, C.direccion, C.codigo_postal, 'C', T.codigo_territorio
FROM Carga C INNER JOIN Territorio T ON C.ciudad = T.nombre
WHERE C.tipo = 'C'
ORDER BY C.nombre ASC;

--carga de proveedores
INSERT INTO CLIENTE_PROVEEDOR(nombre, correo, telefono, fecha_registro, direccion, codigo_postal, tipo, codigo_ciudad)
SELECT DISTINCT C.nombre, C.correo, C.telefono, C.fecha_registro, C.direccion, C.codigo_postal, 'P', T.codigo_territorio
FROM Carga C INNER JOIN Territorio T ON C.ciudad = T.nombre
WHERE C.tipo = 'P'
ORDER BY C.nombre ASC;

--carga de ordenes
INSERT INTO COMPRA_VENTA(codigo_compania, cliente_proveedor, tipo)
SELECT DISTINCT X.codigo_compania, Y.codigo, 'O'
FROM Carga C INNER JOIN COMPANIA X ON C.nombre_compania = X.nombre
INNER JOIN CLIENTE_PROVEEDOR Y ON C.nombre = Y.nombre
WHERE Y.tipo = 'P';

--carga de compras
INSERT INTO COMPRA_VENTA(codigo_compania, cliente_proveedor, tipo)
SELECT DISTINCT X.codigo_compania, Y.codigo, 'C'
FROM Carga C INNER JOIN COMPANIA X ON C.nombre_compania = X.nombre
INNER JOIN CLIENTE_PROVEEDOR Y ON C.nombre = Y.nombre
WHERE Y.tipo = 'C';

--carga de detalle de factura
INSERT INTO DETALLE_COMPRAVENTA(codigo_compania, cliente_proveedor, codigo_producto, cantidad) 
SELECT X.codigo_compania, Y.codigo, P.codigo_producto, SUM(C.cantidad)
FROM CARGA C INNER JOIN COMPANIA X ON C.nombre_compania = X.nombre
INNER JOIN CLIENTE_PROVEEDOR Y ON C.nombre = Y.nombre
INNER JOIN PRODUCTO P ON C.producto = P.nombre
GROUP BY (X.codigo_compania, Y.codigo, P.codigo_producto);