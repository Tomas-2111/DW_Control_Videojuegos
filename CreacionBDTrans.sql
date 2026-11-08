-- 1. CREACION DE LA BASE DE DATOS TRANSACCIONAL
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'BD_Control_Videojuegos')
BEGIN
    CREATE DATABASE BD_Control_Videojuegos;
END
GO

USE BD_Control_Videojuegos;
GO

-- CREACION DE TABLAS TRANSACCIONALES
CREATE TABLE Cliente (
    ID_Cliente VARCHAR(30) PRIMARY KEY, 
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Correo VARCHAR(150) NOT NULL,
    Telefono VARCHAR(20) NULL,
    Fecha_Registro DATETIME DEFAULT GETDATE()
);

CREATE TABLE Equipo (
    ID_Equipo INT IDENTITY(1,1) PRIMARY KEY,
    Tipo_Dispositivo VARCHAR(50) NOT NULL,
    Modelo VARCHAR(100) NOT NULL,
    Numero_Serie VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Tecnico (
    ID_Tecnico VARCHAR(30) PRIMARY KEY, 
    Nombre VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Correo VARCHAR(150) NOT NULL,
    Telefono VARCHAR(20) NULL,
    Fecha_Ingreso DATE NOT NULL,
    Posicion VARCHAR(50) NOT NULL
);

CREATE TABLE Repuesto (
    ID_Repuesto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Repuesto VARCHAR(100) NOT NULL,
    Costo_Unitario DECIMAL(10,2) NOT NULL,
    Stock_Actual INT NOT NULL
);

CREATE TABLE Ticket (
    ID_Ticket INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente VARCHAR(30) NOT NULL,   
    ID_Equipo INT NOT NULL,
    ID_Tecnico VARCHAR(30) NOT NULL,   
    Fecha_Ingreso DATETIME NOT NULL,
    Fecha_Cierre DATETIME NULL,
    Estado_Ticket VARCHAR(30) NOT NULL, 
    Monto_Total DECIMAL(10,2) NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Equipo) REFERENCES Equipo(ID_Equipo),
    FOREIGN KEY (ID_Tecnico) REFERENCES Tecnico(ID_Tecnico)
);

CREATE TABLE Diagnostico (
    ID_Diagnostico INT IDENTITY(1,1) PRIMARY KEY,
    ID_Ticket INT NOT NULL,
    Categoria_Falla VARCHAR(100) NOT NULL,
    Detalle_Falla VARCHAR(MAX) NOT NULL,
    Mantenimiento_Preventivo BIT DEFAULT 0, 
    FOREIGN KEY (ID_Ticket) REFERENCES Ticket(ID_Ticket)
);

CREATE TABLE Ticket_Repuesto (
    ID_Ticket INT NOT NULL,
    ID_Repuesto INT NOT NULL,
    Cantidad INT NOT NULL,
    Costo_Aplicado DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ID_Ticket, ID_Repuesto),
    FOREIGN KEY (ID_Ticket) REFERENCES Ticket(ID_Ticket),
    FOREIGN KEY (ID_Repuesto) REFERENCES Repuesto(ID_Repuesto)
);
GO



-- Clientes
INSERT INTO Cliente (ID_Cliente, Nombre, Apellido, Correo, Telefono, Fecha_Registro) VALUES
('111111111', 'Carlos', 'Mora', 'cmora@gmail.com', '8888-1111', '2026-01-10'),
('222222222', 'Mar�a', 'Rojas', 'mrojas@outlook.com', '8777-2222', '2026-01-15'),
('333333333', 'Andr�s', 'S�nchez', 'asanchez@gmail.com', '8666-3333', '2026-02-01'),
('444444444', 'Laura', 'G�mez', 'lgomez@yahoo.com', '8555-4444', '2026-02-10'),
('PAS998877', 'David', 'Chaves', 'dchaves@gmail.com', '8444-5555', '2026-02-20');

-- Equipos
INSERT INTO Equipo (Tipo_Dispositivo, Modelo, Numero_Serie) VALUES
('Consola', 'PlayStation 5', 'PS5-99881122'),
('Consola', 'Xbox Series X', 'XBX-33445566'),
('Control', 'DualSense PS5', 'DS5-11223344'),
('Consola', 'PlayStation 4 Pro', 'PS4-55667788'),
('Consola', 'Nintendo Switch OLED', 'NSW-77889900');

-- Tecnicos
INSERT INTO Tecnico (ID_Tecnico, Nombre, Apellidos, Correo, Telefono, Fecha_Ingreso, Posicion) VALUES
('155555555', 'Kendall', 'Briones', 'kbriones@taller.com', '7000-1111', '2025-05-01', 'T�cnico L�der'),
('266666666', 'Jos�', 'Fonseca', 'jfonseca@taller.com', '7000-2222', '2025-06-01', 'T�cnico Especialista');

-- Repuestos
INSERT INTO Repuesto (Nombre_Repuesto, Costo_Unitario, Stock_Actual) VALUES
('Pasta T�rmica Arctic MX-4', 3500.00, 15),
('Puerto HDMI PS5', 8500.00, 8),
('M�dulo An�logo Joystick PS5/Xbox', 2500.00, 20),
('Fuente de Poder PS4 Pro', 22000.00, 4),
('Ventilador Interno PS5', 12000.00, 5);

-- Tickets 
INSERT INTO Ticket (ID_Cliente, ID_Equipo, ID_Tecnico, Fecha_Ingreso, Fecha_Cierre, Estado_Ticket, Monto_Total) VALUES
('111111111', 1, '155555555', '2026-03-01 09:00:00', '2026-03-01 14:30:00', 'Finalizado', 25000.00),
('222222222', 3, '266666666', '2026-03-02 10:15:00', '2026-03-02 12:00:00', 'Finalizado', 12000.00),
('333333333', 2, '155555555', '2026-03-03 11:00:00', '2026-03-04 16:00:00', 'Finalizado', 35000.00),
('444444444', 4, '266666666', '2026-03-05 08:30:00', NULL, 'En Proceso', NULL),
('PAS998877', 5, '155555555', '2026-03-05 13:00:00', NULL, 'Pendiente', NULL);

-- Diagnosticos
INSERT INTO Diagnostico (ID_Ticket, Categoria_Falla, Detalle_Falla, Mantenimiento_Preventivo) VALUES
(1, 'Sobrecalentamiento', 'Acumulaci�n severa de polvo y pasta t�rmica seca', 1),
(2, 'Drift en Joystick', 'Falla de lectura centrada en an�logo izquierdo', 0),
(3, 'Puerto HDMI', 'Pines doblados en conector de salida de video', 0),
(4, 'Encendido', 'Consola se apaga a los 3 segundos de encender', 0),
(5, 'Lectora / Cartuchos', 'No reconoce cartuchos de juego', 0);

-- Detalle de Repuestos consumidos por Ticket
INSERT INTO Ticket_Repuesto (ID_Ticket, ID_Repuesto, Cantidad, Costo_Aplicado) VALUES
(1, 1, 1, 3500.00),
(2, 3, 1, 2500.00),
(3, 2, 1, 8500.00);
GO