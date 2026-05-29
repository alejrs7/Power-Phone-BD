USE power_phone;

-- Consulta 1: Productos bajo stock mínimo
SELECT idProducto, nombre, marca, stock, stockMinimo
FROM Producto
WHERE stock <= stockMinimo AND activo = 1
ORDER BY stock ASC;

-- Consulta 2: Directorio de clientes
SELECT apellidos, nombres, telefono, email
FROM Cliente
ORDER BY apellidos, nombres;

-- Consulta 3: Compras activas año 2026
SELECT nroDocumento, tipoDocumento, fechaCompra, subtotal, totalCompra
FROM Compra
WHERE estado = 'Activa' AND YEAR(fechaCompra) = 2026
ORDER BY fechaCompra DESC;

-- Consulta 4: Detalle completo de compras (5 tablas)
SELECT
    c.serie, c.nroDocumento, c.tipoDocumento, c.fechaCompra,
    CONCAT(e.nombres, ' ', e.apellidos) AS vendedor,
    CONCAT(cl.nombres, ' ', cl.apellidos) AS cliente,
    p.nombre AS producto, p.marca,
    dc.cantidad, dc.precioUnitario, dc.subtotalLinea,
    c.igv, c.totalCompra
FROM Compra c
JOIN Empleado e ON c.idEmpleado = e.idEmpleado
JOIN Cliente cl ON c.idCliente = cl.idCliente
JOIN DetalleCompra dc ON c.idCompra = dc.idCompra
JOIN Producto p ON dc.idProducto = p.idProducto
WHERE c.estado = 'Activa'
ORDER BY c.fechaCompra DESC;

-- Consulta 5: Clientes sin compras
SELECT apellidos, nombres, telefono
FROM Cliente
WHERE idCliente NOT IN (SELECT DISTINCT idCliente FROM Compra WHERE estado = 'Activa')
ORDER BY apellidos;

-- Consulta 6: KPI mensual de compras (año actual)
SET lc_time_names = 'es_ES';
SELECT
    MONTHNAME(fechaCompra) AS mes,
    COUNT(idCompra) AS num_compras,
    SUM(subtotal) AS subtotal_acumulado,
    SUM(totalCompra) AS monto_invertido,
    AVG(totalCompra) AS compra_promedio,
    MAX(totalCompra) AS compra_maxima
FROM Compra
WHERE estado = 'Activa' AND YEAR(fechaCompra) = YEAR(CURDATE())
GROUP BY mes, MONTH(fechaCompra)
HAVING SUM(totalCompra) > 0
ORDER BY MONTH(fechaCompra) ASC;
