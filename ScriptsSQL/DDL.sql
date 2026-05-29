-- DDL - POWER-PHONE
DROP DATABASE IF EXISTS power_phone;
CREATE DATABASE power_phone CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE power_phone;

CREATE TABLE Cargo (
    idCargo INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    nivel TINYINT NOT NULL DEFAULT 1,
    activo TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE Usuario (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    idCargo INT NOT NULL,
    nombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    passwordHash VARBINARY(255) NOT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    ultimoAcceso DATETIME NULL,
    FOREIGN KEY (idCargo) REFERENCES Cargo(idCargo) ON UPDATE CASCADE
);

CREATE TABLE Empleado (
    idEmpleado INT AUTO_INCREMENT PRIMARY KEY,
    idCargo INT NOT NULL,
    idUsuario INT NULL UNIQUE,
    dni VARCHAR(15) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    sexo CHAR(1) NOT NULL,
    fechaNac DATE NULL,
    telefono VARCHAR(20) NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT ck_sexo CHECK (sexo IN ('M', 'F')),
    FOREIGN KEY (idCargo) REFERENCES Cargo(idCargo) ON UPDATE CASCADE,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario) ON UPDATE CASCADE
);

CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(15) NOT NULL UNIQUE,
    apellidos VARCHAR(100) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    fechaReg DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Proveedor (
    idProveedor INT AUTO_INCREMENT PRIMARY KEY,
    ruc VARCHAR(20) NOT NULL UNIQUE,
    razonSocial VARCHAR(200) NOT NULL,
    contacto VARCHAR(100) NULL,
    email VARCHAR(100) NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE Categoria (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

CREATE TABLE Producto (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    idCategoria INT NOT NULL,
    idProveedor INT NULL,
    nombre VARCHAR(100) NOT NULL,
    marca VARCHAR(50) NULL,
    descripcion TEXT NULL,
    stock INT NOT NULL DEFAULT 0,
    stockMinimo INT NOT NULL DEFAULT 5,
    precioCompra DECIMAL(10,4) NOT NULL DEFAULT 0,
    precioVenta DECIMAL(10,4) NOT NULL DEFAULT 0,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria) ON UPDATE CASCADE,
    FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor) ON UPDATE CASCADE
);

CREATE TABLE Precios (
    idProducto INT NOT NULL,
    fecha_desde DATETIME NOT NULL,
    precio_prod DECIMAL(10,4) NOT NULL,
    PRIMARY KEY (idProducto, fecha_desde),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto) ON UPDATE CASCADE
);

CREATE TABLE Compra (
    idCompra INT AUTO_INCREMENT PRIMARY KEY,
    idEmpleado INT NOT NULL,
    idCliente INT NOT NULL,
    serie VARCHAR(10) NOT NULL DEFAULT '001',
    nroDocumento VARCHAR(20) NOT NULL,
    tipoDocumento ENUM('Factura','Boleta','Nota de Venta') NOT NULL,
    fechaCompra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    igv DECIMAL(4,2) NOT NULL DEFAULT 0.15,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    totalCompra DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    estado ENUM('Activa','Anulada') NOT NULL DEFAULT 'Activa',
    CONSTRAINT uk_factura_compra UNIQUE (serie, nroDocumento),
    FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

CREATE TABLE DetalleCompra (
    idDetalleCompra INT AUTO_INCREMENT PRIMARY KEY,
    idCompra INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precioUnitario DECIMAL(10,4) NOT NULL,
    subtotalLinea DECIMAL(10,4) GENERATED ALWAYS AS (cantidad * precioUnitario) STORED,
    FOREIGN KEY (idCompra) REFERENCES Compra(idCompra) ON DELETE RESTRICT,
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto) ON DELETE RESTRICT
);

CREATE TABLE Reclamo (
    idReclamo INT AUTO_INCREMENT PRIMARY KEY,
    idCompra INT NOT NULL,
    idEmpleadoGestion INT NULL,
    descripcion TEXT NOT NULL,
    estado ENUM('Pendiente','En Proceso','Resuelto','Rechazado') NOT NULL DEFAULT 'Pendiente',
    fechaReclamo DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fechaResolucion DATETIME NULL,
    descripcionResol TEXT NULL,
    FOREIGN KEY (idCompra) REFERENCES Compra(idCompra),
    FOREIGN KEY (idEmpleadoGestion) REFERENCES Empleado(idEmpleado)
);

DELIMITER $$
CREATE TRIGGER trg_historial_precio_venta
AFTER UPDATE ON Producto FOR EACH ROW
BEGIN
    IF NEW.precioVenta <> OLD.precioVenta THEN
        INSERT INTO Precios (idProducto, fecha_desde, precio_prod)
        VALUES (NEW.idProducto, NOW(), NEW.precioVenta);
    END IF;
END$$

CREATE TRIGGER trg_descontar_stock_compra
AFTER INSERT ON DetalleCompra FOR EACH ROW
BEGIN
    UPDATE Producto
    SET stock = stock - NEW.cantidad
    WHERE idProducto = NEW.idProducto;
END$$
DELIMITER ;
