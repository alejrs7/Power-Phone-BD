USE power_phone;

INSERT INTO Cargo (descripcion, nivel) VALUES
('Administrador', 3),
('Supervisor', 2),
('Vendedor', 1);

INSERT INTO Categoria (descripcion) VALUES
('Fundas y Protectores'),
('Cargadores y Cables'),
('Audifonos y Audio'),
('Vidrios Templados'),
('Accesorios varios');

INSERT INTO Proveedor (ruc, razonSocial, contacto, email) VALUES
('1790123456001','TechImport S.A.','Ana Vega','avega@techimport.ec'),
('0990456789001','Accesorios del Sur','Luis Mora','lmora@accsur.ec'),
('1791234567001','MobileStore Cia.','Carla Ruiz','cruiz@mstore.ec');

INSERT INTO Empleado (idCargo, dni, nombres, apellidos, sexo, fechaNac, telefono) VALUES
(1, '1756789012', 'Carlos', 'Mendoza', 'M', '1988-03-15', '0991234567'),
(3, '1767890123', 'Patricia', 'Salazar', 'F', '1995-07-22', '0985678901'),
(3, '1778901234', 'Miguel', 'Torres', 'M', '1993-11-08', '0976543210'),
(2, '1789012345', 'Daniela', 'Guerrero','F', '1990-05-30', '0967890123'),
(3, '1790123456', 'Roberto', 'Paucar', 'M', '1997-01-12', '0958901234');

INSERT INTO Cliente (dni, apellidos, nombres, telefono, email) VALUES
('1701234567','Flores','Maria','0991112222','mflores@mail.com'),
('1712345678','Pacheco','Jorge','0982223333','jpacheco@mail.com'),
('1723456789','Robalino','Andrea','0973334444','arobalino@mail.com'),
('1734567890','Cando','Fernando','0964445555','fcando@mail.com'),
('1745678901','Valverde','Sandra','0955556666','svalverde@mail.com');

INSERT INTO Producto (idCategoria, idProveedor, nombre, marca, stock, stockMinimo, precioCompra, precioVenta) VALUES
(1,1,'Funda silicona iPhone 15','Generico',50,10,2.50,6.99),
(2,1,'Cable USB-C 1m certificado','Anker',30,5,3.00,8.50),
(3,2,'Audifonos inalambricos TWS','JBL',15,5,18.00,35.00),
(4,2,'Vidrio templado Samsung A54','Gorilla',40,8,1.20,4.50),
(2,1,'Cargador rapido 45W USB-C','Samsung',4,5,12.00,28.00),
(1,3,'Funda leather wallet iPhone','Mophie',20,5,8.00,19.99),
(5,3,'Soporte auto ventosa universal','Baseus',35,8,3.50,9.99),
(3,2,'Audifono in-ear deportivo','Jabra',12,5,22.00,45.00);

INSERT INTO Compra (idEmpleado, idCliente, serie, nroDocumento, tipoDocumento, subtotal, totalCompra) VALUES
(2,1,'001','0000001','Factura',22.48,25.85),
(3,2,'001','0000002','Nota de Venta',35.00,40.25),
(2,3,'001','0000003','Factura',74.97,86.22),
(5,4,'001','0000004','Factura',13.50,15.53),
(3,5,'001','0000005','Factura',43.50,50.03);

INSERT INTO DetalleCompra (idCompra, idProducto, cantidad, precioUnitario) VALUES
(1,1,2,6.99),
(1,2,1,8.50),
(2,3,1,35.00),
(3,5,2,28.00),
(3,4,1,4.50),
(3,2,1,8.50),
(4,4,3,4.50),
(5,3,1,35.00),
(5,2,1,8.50);
