--consulta 1
Select * from (SELECT P.nombre as nombre, P.telefono as telefono, O.numero_transaccion as transaccion,
SUM(T.precio_unitario*D.cantidad) as Valor
FROM CLIENTE_PROVEEDOR P
INNER JOIN COMPRA_VENTA O ON P.codigo = O.cliente_proveedor
INNER JOIN DETALLE_COMPRAVENTA D ON O.codigo_compania = D.codigo_compania and O.cliente_proveedor = D.cliente_proveedor
INNER JOIN PRODUCTO T ON T.codigo_producto = D.codigo_producto
WHERE P.tipo = 'P'
GROUP BY O.numero_transaccion, P.nombre, P.telefono
Order by Valor desc) where rownum <= 1;

-- consulta 2
Select * from (SELECT P.codigo as numero, P.nombre as nombre,
SUM(D.cantidad) as total
FROM CLIENTE_PROVEEDOR P
INNER JOIN DETALLE_COMPRAVENTA D ON P.codigo = D.cliente_proveedor
WHERE P.tipo = 'C'
GROUP BY P.codigo, P.nombre
Order by total desc) where rownum <= 1;

-- consulta 3
SELECT * FROM (SELECT FIRST_VALUE(direccion) OVER() AS primer_direccion, FIRST_VALUE(postal) OVER() as primer_cp, FIRST_VALUE(ciudad) OVER() as primer_ciudad, FIRST_VALUE(region) OVER() as primer_region, FIRST_VALUE(cuenta) OVER() as primer_cuenta, LAST_VALUE(direccion) OVER() as ultima_direccion, LAST_VALUE(postal) OVER() as ultimo_cp, LAST_VALUE(ciudad) OVER() as ultima_ciudad, LAST_VALUE(region) OVER() as ultima_region, LAST_VALUE(cuenta) OVER() as ultima_cuenta FROM (SELECT P.nombre, P.direccion as direccion, P.codigo_postal as postal, T.nombre as ciudad, U.nombre as region, COUNT(C.cliente_proveedor) as cuenta
FROM CLIENTE_PROVEEDOR P
INNER JOIN TERRITORIO T ON P.codigo_ciudad = T.codigo_territorio
INNER JOIN TERRITORIO U ON T.region = U.codigo_territorio
INNER JOIN COMPRA_VENTA C ON C.cliente_proveedor = P.codigo
WHERE P.tipo = 'P'
GROUP BY P.nombre, P.direccion, P.codigo_postal, T.nombre, U.nombre
ORDER BY cuenta desc)) WHERE ROWNUM <= 1;

-- consulta 4
SELECT * FROM (SELECT DISTINCT P.codigo codigo, P.nombre nombre_cliente, COUNT(D.cliente_proveedor) OVER (partition by P.codigo, P.nombre) cuenta, SUM(D.cantidad*R.precio_unitario) OVER(partition by P.codigo) total
FROM CLIENTE_PROVEEDOR P
INNER JOIN DETALLE_COMPRAVENTA D ON P.codigo = D.cliente_proveedor
INNER JOIN PRODUCTO R ON R.codigo_producto = D.codigo_producto
INNER JOIN CATEGORIA G ON G.codigo_categoria = R.codigo_categoria
WHERE P.tipo = 'C' and G.nombre = 'Cheese'
ORDER BY cuenta DESC) WHERE ROWNUM <= 5;

-- consulta 5
SELECT mes, nombre, total FROM (SELECT P.codigo as codigo, EXTRACT(MONTH from P.fecha_registro) mes, P.nombre as nombre, SUM(D.cantidad*T.precio_unitario) as total 
FROM CLIENTE_PROVEEDOR P
INNER JOIN DETALLE_COMPRAVENTA D ON D.cliente_proveedor = P.codigo
INNER JOIN PRODUCTO T ON T.codigo_producto = D.codigo_producto
where P.tipo = 'C'
GROUP BY P.codigo, EXTRACT(MONTH from P.fecha_registro), P.nombre
ORDER BY total DESC);

-- consulta 6
SELECT * FROM (SELECT FIRST_VALUE(nombre) OVER() mas_vendida, FIRST_VALUE(total) OVER() max_total, LAST_VALUE(nombre) OVER() menos_vendida, LAST_VALUE(total) OVER() min_total
FROM (SELECT G.nombre nombre, SUM(D.cantidad*T.precio_unitario) total
FROM CATEGORIA G
INNER JOIN PRODUCTO T ON T.codigo_categoria = G.codigo_categoria
INNER JOIN DETALLE_COMPRAVENTA D ON D.codigo_producto = T.codigo_producto
INNER JOIN COMPRA_VENTA C ON C.cliente_proveedor = D.cliente_proveedor and C.codigo_compania = D.codigo_compania
WHERE C.tipo = 'O'
GROUP BY G.nombre
ORDER BY total desc)) WHERE ROWNUM <= 1;

-- consulta 7
SELECT * FROM (SELECT P.nombre nombre, SUM(D.cantidad*T.precio_unitario) total
FROM CLIENTE_PROVEEDOR P
INNER JOIN DETALLE_COMPRAVENTA D ON D.cliente_proveedor = P.codigo
INNER JOIN PRODUCTO T ON T.codigo_producto = D.codigo_producto
INNER JOIN CATEGORIA G ON T.codigo_categoria = G.codigo_categoria
WHERE P.tipo = 'P' and G.nombre = 'Fresh Vegetables'
GROUP BY P.nombre
ORDER BY total DESC) 
WHERE ROWNUM <= 5; 

-- consulta 8
SELECT * FROM (SELECT FIRST_VALUE(nombre) OVER() as max_nombre, FIRST_VALUE(direccion) OVER() AS max_direccion, FIRST_VALUE(postal) OVER() as max_cp, FIRST_VALUE(ciudad) OVER() as max_ciudad, FIRST_VALUE(region) OVER() as max_region, FIRST_VALUE(total) OVER() as max_total, LAST_VALUE(nombre) OVER() as min_nombre, LAST_VALUE(direccion) OVER() as min_direccion, LAST_VALUE(postal) OVER() as min_cp, LAST_VALUE(ciudad) OVER() as min_ciudad, LAST_VALUE(region) OVER() as min_region, LAST_VALUE(total) OVER() as min_total FROM (SELECT P.nombre nombre, P.direccion as direccion, P.codigo_postal as postal, T.nombre as ciudad, U.nombre as region, SUM(D.cantidad*R.precio_unitario) as total
FROM CLIENTE_PROVEEDOR P
INNER JOIN TERRITORIO T ON P.codigo_ciudad = T.codigo_territorio
INNER JOIN TERRITORIO U ON T.region = U.codigo_territorio
INNER JOIN DETALLE_COMPRAVENTA D ON D.cliente_proveedor = P.codigo
INNER JOIN PRODUCTO R ON R.codigo_producto = D.codigo_producto
WHERE P.tipo = 'C'
GROUP BY P.nombre, P.direccion, P.codigo_postal, T.nombre, U.nombre
ORDER BY total desc)) WHERE ROWNUM <= 1;

-- consulta 9
SELECT * FROM (SELECT P.nombre, P.telefono, C.numero_transaccion, SUM(D.cantidad*T.precio_unitario) total, SUM(D.cantidad) cant
FROM CLIENTE_PROVEEDOR P
INNER JOIN COMPRA_VENTA C ON P.codigo = C.cliente_proveedor
INNER JOIN DETALLE_COMPRAVENTA D ON D.cliente_proveedor = C.cliente_proveedor and D.codigo_compania = C.codigo_compania
INNER JOIN PRODUCTO T ON D.codigo_producto = T.codigo_producto
GROUP BY P.nombre, P.telefono, C.numero_transaccion
ORDER BY SUM(D.cantidad) ASC)
WHERE cant = (SELECT MIN(cantidad) FROM (SELECT SUM(D.cantidad) cantidad
FROM COMPRA_VENTA C 
INNER JOIN DETALLE_COMPRAVENTA D ON D.cliente_proveedor = C.cliente_proveedor and D.codigo_compania = C.codigo_compania
GROUP BY C.numero_transaccion));

-- consulta 10
SELECT * FROM (SELECT P.nombre nombre, SUM(D.cantidad) total
FROM CLIENTE_PROVEEDOR P
INNER JOIN DETALLE_COMPRAVENTA D ON D.cliente_proveedor = P.codigo
INNER JOIN PRODUCTO T ON T.codigo_producto = D.codigo_producto
INNER JOIN CATEGORIA G ON T.codigo_categoria = G.codigo_categoria
WHERE P.tipo = 'C' and G.nombre = 'Seafood'
GROUP BY P.nombre
ORDER BY total DESC) 
WHERE ROWNUM <= 10; 

-- consulta 11
SELECT ROUND(((COUNT(P.nombre)/99)*100), 2) porcentaje, U.nombre 
FROM CLIENTE_PROVEEDOR P
INNER JOIN TERRITORIO T ON P.codigo_ciudad = T.codigo_territorio
INNER JOIN TERRITORIO U ON T.region = U.codigo_territorio
WHERE P.tipo = 'C'
GROUP BY U.nombre
ORDER BY porcentaje DESC;

-- consulta 12
SELECT T.nombre, SUM(D.cantidad) cuenta
FROM TERRITORIO T
INNER JOIN CLIENTE_PROVEEDOR P ON T.codigo_territorio = P.codigo_ciudad
INNER JOIN DETALLE_COMPRAVENTA D ON P.codigo = D.cliente_proveedor
INNER JOIN PRODUCTO R ON R.codigo_producto = D.codigo_producto
INNER JOIN CATEGORIA G ON R.codigo_categoria = G.codigo_categoria
WHERE R.nombre = 'Tortillas' and G.nombre = 'Refrigerated Items'
AND P.tipo = 'C'
GROUP BY T.nombre
ORDER BY cuenta DESC;

-- consulta 13
SELECT COUNT(P.nombre) cuenta, SUBSTR(U.nombre, 0, 1) letra
FROM CLIENTE_PROVEEDOR P
INNER JOIN TERRITORIO T ON P.codigo_ciudad = T.codigo_territorio
INNER JOIN TERRITORIO U ON T.region = U.codigo_territorio
WHERE P.tipo = 'C'
GROUP BY SUBSTR(U.nombre, 0, 1)
ORDER BY letra ASC;

-- consulta 14 
SELECT distinct T.nombre ciudad, G.nombre categoria, ROUND(((SUM(D.cantidad) OVER(partition by T.nombre, G.nombre))/(SUM(D.cantidad) OVER(partition by T.nombre)))*100, 2) porcentaje
FROM TERRITORIO T
INNER JOIN CLIENTE_PROVEEDOR P ON P.codigo_ciudad = T.codigo_territorio
INNER JOIN COMPRA_VENTA C ON C.cliente_proveedor = P.codigo
INNER JOIN DETALLE_COMPRAVENTA D ON D.codigo_compania = C.codigo_compania and D.cliente_proveedor = C.cliente_proveedor
INNER JOIN PRODUCTO R ON D.codigo_producto = R.codigo_producto
INNER JOIN CATEGORIA G ON R.codigo_categoria = G.codigo_categoria
WHERE P.tipo = 'P'
ORDER BY T.nombre ASC;

-- consulta 15
SELECT * FROM (SELECT P.codigo as codigo, P.nombre as nombre, SUM(D.cantidad*T.precio_unitario) as total 
FROM CLIENTE_PROVEEDOR P
INNER JOIN DETALLE_COMPRAVENTA D ON D.cliente_proveedor = P.codigo
INNER JOIN PRODUCTO T ON T.codigo_producto = D.codigo_producto
where P.tipo = 'C'
GROUP BY P.codigo, P.nombre
ORDER BY total DESC)
WHERE total > (SELECT AVG(cant) FROM (SELECT SUM(D.cantidad*R.precio_unitario) cant FROM TERRITORIO T
INNER JOIN CLIENTE_PROVEEDOR P ON P.codigo_ciudad = T.codigo_territorio
INNER JOIN COMPRA_VENTA C ON C.cliente_proveedor = P.codigo
INNER JOIN DETALLE_COMPRAVENTA D ON D.cliente_proveedor = C.cliente_proveedor
and D.codigo_compania = C.codigo_compania
INNER JOIN PRODUCTO R ON D.codigo_producto = R.codigo_producto
WHERE P.tipo = 'C' AND T.nombre = 'Frankfort'
GROUP BY C.numero_transaccion));