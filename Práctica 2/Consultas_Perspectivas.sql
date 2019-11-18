-- Datos de una tarjeta dado el nombre de una obra
Select O.artista, O.titulo, EXTRACT(YEAR from O.fecha_creacion), O.precio_solicitado,
T.nombre, M.nombre, E.nombre, O.anchura, O.altura, O.profundidad from OBRA O 
    inner join TIPO T on O.tipo = T.codigo_tipo
    inner join ESTILO E on O.estilo = E.codigo_estilo
    inner join MEDIO M on O.medio = M.codigo_medio
        where titulo = 'inserte el titulo';

-- Reporte de Ventas por a;o
Select O.titulo, O.precio_venta, V.nombre, C.nombre, F.fecha_compra 
    from COMPRA_VENTA F
    inner join OBRA O on O.compra_venta = F.numero_factura
    inner join VENDEDOR V on O.vendedor = V.codigo_vendedor
    inner join CLIENTE C on F.cliente = C.codigo_cliente 
    group by EXTRACT(YEAR from F.fecha_compra);    
        --where EXTRACT(YEAR from F.fecha_compra) = 'inserte a;o aqui';

-- Reporte de las compras por cliente
Select O.titulo, O.precio_venta, C.nombre
    from COMPRA_VENTA F 
    inner join OBRA O on O.compra_venta = F.numero_factura
    inner join CLIENTE C on F.cliente = C.codigo_cliente
    group by C.codigo_cliente;
    --    where C.nombre = 'inserte el nombre aqui';

-- Reporte de las ventas generadas por artista
Select titulo, precio_venta from OBRA where vendida = 1 group by artista;

-- Reporte de materiales que mas se utilizan
Select M.nombre, COUNT(M.nombre) as ocurrencias from OBRA O inner join MEDIO M on O.medio = M.codigo_medio group by M.nombre order by ocurrencias desc; 

-- Segun el numero de factura obtener los datos necesarios para generar el documento
Select O.titulo, O.precio_venta, F.fecha_compra, F.numero_factura, C.nombre, V.nombre 
    from OBRA O inner join COMPRA_VENTA F on O.compra_venta = F.numero_factura
    inner join CLIENTE C on F.cliente = C.codigo_cliente
    inner join VENDEDOR V on O.vendedor = F.codigo_vendedor
    where numero_factura = 'inserte el numero de factura aqui';