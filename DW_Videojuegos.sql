-- 1. CREACION DE LA BASE DE DATOS DEL DW
IF  EXISTS (SELECT * FROM sys.databases WHERE name = 'DW_Videojuegos')
BEGIN
    CREATE DATABASE DW_Videojuegos;
END
GO

USE DW_Videojuegos;
GO


-- ==========================================
-- 2. TABLAS DE DIMENSIONES 
-- ==========================================

CREATE TABLE D_Tiempo (
    Id_Fecha INT PRIMARY KEY, 
    Anio INT  NULL,
    Mes INT NULL,
    Nombre_Mes VARCHAR(20) NULL
);

CREATE TABLE D_Cliente (
    Id_Cliente INT IDENTITY(1,1) PRIMARY KEY,
    Cedula_Pasaporte VARCHAR(50) NULL,     
    Nombre_Cliente VARCHAR(100) NULL,       
    Correo VARCHAR(100) NULL,               
    Telefono VARCHAR(20) NULL,              
    Fecha_Registro DATETIME NULL            
);

CREATE TABLE D_Equipo (
    Id_Equipo INT IDENTITY(1,1) PRIMARY KEY,
    Id_Equipo_NK INT NULL,
    Tipo_Dispositivo VARCHAR(50) NULL,
    Modelo VARCHAR(100) NULL,
    Numero_Serie VARCHAR(100) NULL
);

CREATE TABLE D_Tecnico (
    Id_Tecnico INT IDENTITY(1,1) PRIMARY KEY,
    Cedula_Tecnico VARCHAR(30) NULL,
    Nombre_Tecnico VARCHAR(200) NULL,
    Correo VARCHAR(150) NULL,
    Telefono VARCHAR(20) NULL,
    Puesto VARCHAR(50) NULL
);

CREATE TABLE D_Diagnostico (
    Id_Diagnostico INT IDENTITY(1,1) PRIMARY KEY,
    Id_Diagnostico_NK INT NULL,
    Categoria_Falla VARCHAR(100) NULL,
    Es_Mantenimiento_Preventivo VARCHAR(2) NULL
);

CREATE TABLE D_Repuesto (
    Id_Repuesto INT IDENTITY(1,1) PRIMARY KEY,
    Id_Repuesto_NK INT NULL,
    Nombre_Repuesto VARCHAR(100) NULL,
    Costo_Unitario DECIMAL(10,2) NULL
);

CREATE TABLE D_Proveedor (
    Id_Proveedor INT IDENTITY(1,1) PRIMARY KEY,
    Id_Proveedor_NK VARCHAR(150) NULL,
    Nombre_Empresa VARCHAR(150) NULL,
    Contacto VARCHAR(100) NULL,
    Correo VARCHAR(150) NULL,
    Telefono VARCHAR(20) NULL
);
GO

-- ==========================================
-- 3. TABLAS DE HECHOS (Todas las metricas y atributos opcionales en NULL)
-- ==========================================

CREATE TABLE H_Servicios (
    Id_Servicio INT IDENTITY(1,1) PRIMARY KEY,
    Id_Fecha_Ingreso INT  NULL,
    Id_Fecha_Cierre INT NULL,
    Id_Cliente INT  NULL,
    Id_Equipo INT  NULL,
    Id_Tecnico INT  NULL,
    Id_Diagnostico INT  NULL,
    Id_Ticket_NK INT  NULL,
    Estado_Ticket VARCHAR(30) NULL,
    Tiempo_Atencion_Horas DECIMAL(8,2) NULL,
    Monto_Ingreso DECIMAL(10,2) NULL,
    Costo_Repuestos_Total DECIMAL(10,2) NULL,
    Utilidad_Estimada DECIMAL(10,2) NULL,
    FOREIGN KEY (Id_Fecha_Ingreso) REFERENCES D_Tiempo(Id_Fecha),
    FOREIGN KEY (Id_Fecha_Cierre) REFERENCES D_Tiempo(Id_Fecha),
    FOREIGN KEY (Id_Cliente) REFERENCES D_Cliente(Id_Cliente),
    FOREIGN KEY (Id_Equipo) REFERENCES D_Equipo(Id_Equipo),
    FOREIGN KEY (Id_Tecnico) REFERENCES D_Tecnico(Id_Tecnico),
    FOREIGN KEY (Id_Diagnostico) REFERENCES D_Diagnostico(Id_Diagnostico)
);

CREATE TABLE H_Consumo_Repuestos (
    Id_Consumo INT IDENTITY(1,1) PRIMARY KEY,
    Id_Fecha INT  NULL,
    Id_Equipo INT  NULL,
    Id_Repuesto INT  NULL,
    Id_Ticket INT  NULL,
    Cantidad_Consumida INT NULL,
    Costo_Total_Consumo DECIMAL(10,2) NULL,
    FOREIGN KEY (Id_Fecha) REFERENCES D_Tiempo(Id_Fecha),
    FOREIGN KEY (Id_Equipo) REFERENCES D_Equipo(Id_Equipo),
    FOREIGN KEY (Id_Repuesto) REFERENCES D_Repuesto(Id_Repuesto)
);

CREATE TABLE H_Compras (
    Id_Compra INT IDENTITY(1,1) PRIMARY KEY,
    Id_Fecha INT  NULL,
    Id_Proveedor INT  NULL,
    Id_Repuesto INT  NULL,
    Cantidad_Comprada INT NULL,
    Monto_Total_Compra DECIMAL(10,2) NULL,
    FOREIGN KEY (Id_Fecha) REFERENCES D_Tiempo(Id_Fecha),
    FOREIGN KEY (Id_Proveedor) REFERENCES D_Proveedor(Id_Proveedor),
    FOREIGN KEY (Id_Repuesto) REFERENCES D_Repuesto(Id_Repuesto)
);
GO

-- ==========================================
-- 4. POBLADO DE TIEMPO
-- ==========================================

DECLARE @Mes INT = 1;
WHILE @Mes <= 12
BEGIN
    INSERT INTO D_Tiempo (Id_Fecha, Anio, Mes, Nombre_Mes)
    VALUES (
        2026 * 100 + @Mes, 
        2026,
        @Mes,
        DATENAME(MONTH, DATEFROMPARTS(2026, @Mes, 1))
    );
    SET @Mes = @Mes + 1;
END;
GO

SELECT * FROM D_Tiempo;