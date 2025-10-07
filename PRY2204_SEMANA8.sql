-- =====================================================
--  Proyecto: MiniMarket Doña Marta
-- =====================================================

-- =====================================================
-- LIMPIEZA DEL ESQUEMA (DROP TABLE)
-- =====================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE DETALLE_VENTA CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE VENTA CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE MEDIO_PAGO CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE VENDEDOR CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ADMINISTRATIVO CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE EMPLEADO CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE SALUD CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE AFP CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE PRODUCTO CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE MARCA CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE CATEGORIA CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE PROVEEDOR CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE COMUNA CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE REGION CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
-- =====================================================
-- CREACIÓN DE TABLAS
-- =====================================================

CREATE TABLE REGION (
    id_region NUMBER(4) PRIMARY KEY,
    nom_region VARCHAR2(50)
);

CREATE TABLE COMUNA (
    id_comuna NUMBER(4) PRIMARY KEY,
    nom_comuna VARCHAR2(50),
    cod_region NUMBER(4),
    CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (cod_region)
        REFERENCES REGION(id_region)
);

CREATE TABLE PROVEEDOR (
    id_proveedor NUMBER(6) PRIMARY KEY,
    nombre_proveedor VARCHAR2(50),
    tel_proveedor VARCHAR2(20),
    email VARCHAR2(50),
    direccion VARCHAR2(80),
    cod_comuna NUMBER(4),
    CONSTRAINT PROVEEDOR_FK_COMUNA FOREIGN KEY (cod_comuna)
        REFERENCES COMUNA(id_comuna)
);

CREATE TABLE CATEGORIA (
    id_categoria NUMBER(4) PRIMARY KEY,
    nombre_categoria VARCHAR2(50)
);

CREATE TABLE MARCA (
    id_marca NUMBER(4) PRIMARY KEY,
    nom_marca VARCHAR2(25)
);

CREATE TABLE PRODUCTO (
    id_producto NUMBER(6) PRIMARY KEY,
    nom_producto VARCHAR2(50),
    precio_unitario NUMBER(10),
    stock_minimo NUMBER(4),
    stock_actual NUMBER(4),
    cod_marca NUMBER(4),
    cod_categoria NUMBER(4),
    cod_proveedor NUMBER(6),
    CONSTRAINT PRODUCTO_FK_MARCA FOREIGN KEY (cod_marca)
        REFERENCES MARCA(id_marca),
    CONSTRAINT PRODUCTO_FK_CATEGORIA FOREIGN KEY (cod_categoria)
        REFERENCES CATEGORIA(id_categoria),
    CONSTRAINT PRODUCTO_FK_PROVEEDOR FOREIGN KEY (cod_proveedor)
        REFERENCES PROVEEDOR(id_proveedor)
);

CREATE TABLE AFP (
    id_afp NUMBER(4) PRIMARY KEY,
    nom_afp VARCHAR2(25)
);

CREATE TABLE SALUD (
    id_salud NUMBER(4) PRIMARY KEY,
    nom_salud VARCHAR2(25)
);

CREATE TABLE EMPLEADO (
    id_empleado NUMBER(4) PRIMARY KEY,
    rut_empleado VARCHAR2(15),
    nombre_empleado VARCHAR2(25),
    apellido_paterno VARCHAR2(25),
    apellido_materno VARCHAR2(25),
    fecha_contratacion DATE,
    sueldo_base NUMBER(10),
    bono_bruto NUMBER(10),
    activo VARCHAR2(10),
    tipo_empleado VARCHAR2(20),
    cod_empleado NUMBER(4),
    cod_salud NUMBER(4),
    cod_afp NUMBER(4),
    CONSTRAINT EMPLEADO_FK_SALUD FOREIGN KEY (cod_salud)
        REFERENCES SALUD(id_salud),
    CONSTRAINT EMPLEADO_FK_AFP FOREIGN KEY (cod_afp)
        REFERENCES AFP(id_afp)
);

CREATE TABLE ADMINISTRATIVO (
    id_empleado NUMBER(4) PRIMARY KEY,
    area VARCHAR2(50),
    CONSTRAINT ADMIN_FK_EMPLEADO FOREIGN KEY (id_empleado)
        REFERENCES EMPLEADO(id_empleado)
);

CREATE TABLE VENDEDOR (
    id_empleado NUMBER(4) PRIMARY KEY,
    comision_venta NUMBER(6,2),
    CONSTRAINT VENDEDOR_FK_EMPLEADO FOREIGN KEY (id_empleado)
        REFERENCES EMPLEADO(id_empleado)
);

CREATE TABLE MEDIO_PAGO (
    id_mpag NUMBER(4) PRIMARY KEY,
    nom_mpag VARCHAR2(25)
);

CREATE TABLE VENTA (
    id_venta NUMBER(6) PRIMARY KEY,
    fecha_venta DATE,
    total_venta NUMBER(10),
    cod_mpag NUMBER(4),
    cod_empleado NUMBER(4),
    CONSTRAINT VENTA_FK_MEDIO FOREIGN KEY (cod_mpag)
        REFERENCES MEDIO_PAGO(id_mpag),
    CONSTRAINT VENTA_FK_EMPLEADO FOREIGN KEY (cod_empleado)
        REFERENCES EMPLEADO(id_empleado)
);

CREATE TABLE DETALLE_VENTA (
    id_detalle NUMBER(6) PRIMARY KEY,
    cant_vendida NUMBER(4),
    subtotal NUMBER(10),
    id_venta NUMBER(6),
    id_producto NUMBER(6),
    CONSTRAINT DET_VENTA_FK_VENTA FOREIGN KEY (id_venta)
        REFERENCES VENTA(id_venta),
    CONSTRAINT DET_VENTA_FK_PRODUCTO FOREIGN KEY (id_producto)
        REFERENCES PRODUCTO(id_producto)
);

-- =====================================================
-- POBLAMIENTO DE TABLAS
-- =====================================================

INSERT INTO REGION VALUES (1, 'Región Metropolitana');
INSERT INTO REGION VALUES (2, 'Valparaíso');
INSERT INTO REGION VALUES (3, 'Biobío');
INSERT INTO REGION VALUES (4, 'Los Lagos');

INSERT INTO SALUD VALUES (2050, 'Fonasa');
INSERT INTO SALUD VALUES (2060, 'Isapre Colmena');
INSERT INTO SALUD VALUES (2070, 'Isapre Banmédica');
INSERT INTO SALUD VALUES (2080, 'Isapre Cruz Blanca');

INSERT INTO AFP VALUES (210, 'AFP Habitat');
INSERT INTO AFP VALUES (216, 'AFP Cuprum');
INSERT INTO AFP VALUES (222, 'AFP Provida');
INSERT INTO AFP VALUES (228, 'AFP PlanVital');

INSERT INTO MEDIO_PAGO VALUES (11, 'Efectivo');
INSERT INTO MEDIO_PAGO VALUES (12, 'Tarjeta Débito');
INSERT INTO MEDIO_PAGO VALUES (13, 'Tarjeta Crédito');
INSERT INTO MEDIO_PAGO VALUES (14, 'Cheque');

INSERT INTO EMPLEADO VALUES (751, '75111111-1', 'Marcela', 'González', 'Pérez', TO_DATE('15-07-2021','DD-MM-YYYY'), 750000, 50000, 'S', 'Administrativo', NULL, 2050, 216);
INSERT INTO EMPLEADO VALUES (752, '75222222-2', 'José', 'Muñoz', 'Ramírez', TO_DATE('18-08-2021','DD-MM-YYYY'), 780000, 53000, 'S', 'Administrativo', NULL, 2060, 216);
INSERT INTO EMPLEADO VALUES (753, '75933333-3', 'Verónica', 'Soto', 'Alarcón', TO_DATE('01-05-2022','DD-MM-YYYY'), 550000, 48000, 'S', 'Vendedor', NULL, 2070, 210);
INSERT INTO EMPLEADO VALUES (754, '76544444-5', 'Luis', 'Reyes', 'Fuentes', TO_DATE('10-09-2022','DD-MM-YYYY'), 560000, 50000, 'S', 'Vendedor', NULL, 2050, 216);
INSERT INTO EMPLEADO VALUES (755, '76655555-6', 'Claudia', 'Fernández', 'Lagos', TO_DATE('01-03-2023','DD-MM-YYYY'), 600000, 48000, 'S', 'Vendedor', NULL, 2060, 216);
INSERT INTO EMPLEADO VALUES (756, '77766666-7', 'Carlos', 'Navarro', 'Vega', TO_DATE('01-05-2023','DD-MM-YYYY'), 610000, 49000, 'S', 'Vendedor', NULL, 2070, 210);
INSERT INTO EMPLEADO VALUES (757, '77788888-9', 'Diego', 'Mella', 'Contreras', TO_DATE('01-06-2023','DD-MM-YYYY'), 620000, 49600, 'S', 'Vendedor', NULL, 2080, 222);
INSERT INTO EMPLEADO VALUES (758, '77799999-0', 'Javiera', 'Pino', 'Rojas', TO_DATE('01-06-2023','DD-MM-YYYY'), 650000, 52000, 'S', 'Vendedor', NULL, 2050, 222);
INSERT INTO EMPLEADO VALUES (759, '777101010-0', 'Tomás', 'Vida', 'Espinoza', TO_DATE('01-06-2023','DD-MM-YYYY'), 530000, 45000, 'S', 'Vendedor', NULL, 2050, 222);

INSERT INTO VENTA VALUES (50512, TO_DATE('12-05-2023','DD-MM-YYYY'), 225990, 12, 751);
INSERT INTO VENTA VALUES (50533, TO_DATE('13-10-2023','DD-MM-YYYY'), 524990, 13, 757);
INSERT INTO VENTA VALUES (50567, TO_DATE('07-02-2023','DD-MM-YYYY'), 466990, 11, 759);

COMMIT;

-- =====================================================
-- CONSULTAS DE ANÁLISIS
-- =====================================================

-- 1️⃣ Ordenar empleados por sueldo base
SELECT 
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS EMPLEADO,
    sueldo_base AS SUELDO,
    ROUND(sueldo_base * 0.08, 0) AS POSIBLE_AUMENTO,
    sueldo_base + ROUND(sueldo_base * 0.08, 0) AS SUELDO_SIMULADO
FROM empleado
ORDER BY sueldo_base ASC;

-- 2️⃣ Promedio de sueldo por tipo de empleado
SELECT 
    tipo_empleado,
    ROUND(AVG(sueldo_base), 0) AS PROMEDIO_SUELDO
FROM empleado
GROUP BY tipo_empleado
ORDER BY PROMEDIO_SUELDO DESC;

-- 3️⃣ Cantidad de empleados por AFP
SELECT 
    a.nom_afp AS AFP,
    COUNT(e.id_empleado) AS CANTIDAD_EMPLEADOS
FROM empleado e
JOIN afp a ON e.cod_afp = a.id_afp
GROUP BY a.nom_afp
ORDER BY CANTIDAD_EMPLEADOS DESC;

-- 4️⃣ Cantidad de empleados por institución de salud
SELECT 
    s.nom_salud AS INSTITUCION_SALUD,
    COUNT(e.id_empleado) AS CANTIDAD_EMPLEADOS
FROM empleado e
JOIN salud s ON e.cod_salud = s.id_salud
GROUP BY s.nom_salud
ORDER BY CANTIDAD_EMPLEADOS DESC;

-- 5️⃣ Ventas con su vendedor y medio de pago
SELECT 
    v.id_venta AS CODIGO_VENTA,
    v.fecha_venta,
    v.total_venta,
    e.nombre_empleado || ' ' || e.apellido_paterno AS VENDEDOR,
    m.nom_mpag AS MEDIO_PAGO
FROM venta v
JOIN empleado e ON v.cod_empleado = e.id_empleado
JOIN medio_pago m ON v.cod_mpag = m.id_mpag
ORDER BY v.fecha_venta;

-- 6️⃣ Total de ventas por vendedor
SELECT 
    e.nombre_empleado || ' ' || e.apellido_paterno AS VENDEDOR,
    COUNT(v.id_venta) AS NUM_VENTAS,
    SUM(v.total_venta) AS TOTAL_VENDIDO
FROM empleado e
LEFT JOIN venta v ON e.id_empleado = v.cod_empleado
WHERE e.tipo_empleado = 'Vendedor'
GROUP BY e.nombre_empleado, e.apellido_paterno
ORDER BY TOTAL_VENDIDO DESC;

-- 7️⃣ Promedio de sueldo por estado (activo o no activo)
SELECT 
    activo AS ESTADO,
    ROUND(AVG(sueldo_base), 0) AS PROMEDIO_SUELDO
FROM empleado
GROUP BY activo;

-- 8️⃣ Empleados contratados desde 2023
SELECT 
    id_empleado,
    nombre_empleado,
    apellido_paterno,
    fecha_contratacion,
    sueldo_base
FROM empleado
WHERE fecha_contratacion >= TO_DATE('01-01-2023','DD-MM-YYYY')
ORDER BY fecha_contratacion;

-- 9️⃣ Empleados con su AFP y salud
SELECT 
    e.nombre_empleado || ' ' || e.apellido_paterno AS EMPLEADO,
    a.nom_afp AS AFP,
    s.nom_salud AS SALUD
FROM empleado e
JOIN afp a ON e.cod_afp = a.id_afp
JOIN salud s ON e.cod_salud = s.id_salud
ORDER BY e.nombre_empleado;

-- 🔟 Comisión simulada (5% de ventas por vendedor)
SELECT 
    e.nombre_empleado || ' ' || e.apellido_paterno AS VENDEDOR,
    SUM(v.total_venta) AS TOTAL_VENTAS,
    ROUND(SUM(v.total_venta) * 0.05, 0) AS COMISION_SIMULADA
FROM empleado e
JOIN venta v ON e.id_empleado = v.cod_empleado
WHERE e.tipo_empleado = 'Vendedor'
GROUP BY e.nombre_empleado, e.apellido_paterno
ORDER BY COMISION_SIMULADA DESC;