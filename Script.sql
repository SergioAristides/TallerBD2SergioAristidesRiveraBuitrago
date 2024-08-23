

CREATE TABLE clientes 
(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    identificacion INT,
    edad INT,
    correo VARCHAR(100)
);



CREATE TABLE productos
(
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(80),
    nombre VARCHAR(100),
    stock INT,
    valor_unitario DECIMAL(10,2)
);

CREATE TABLE pedidos
(
    id SERIAL PRIMARY KEY,
    fecha VARCHAR(80),
    cantidad INT,
    valor_total DECIMAL(10,2),
    id_cliente INT,
    id_producto INT,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id),
    FOREIGN KEY (id_producto) REFERENCES Productos(id)
);


BEGIN;

INSERT INTO clientes (nombre, identificacion, edad, correo)	
VALUES ('Sergio Rivera', 1002608919, 20, 'sriverabuitrago4@gmail.com'),
       ('Andres Camilo', 10274222, 18, 'camilo@gmail.com'),
       ('Maria Hernandez', 101028282, 23, 'maria@gmail.com');

UPDATE clientes 
SET edad = 24 
WHERE nombre = 'Andres Camilo';

UPDATE clientes 
SET correo = 'sergioa.riverab@autonoma.edu.co' 
WHERE nombre = 'Sergio Rivera';

INSERT INTO productos (codigo, nombre, stock, valor_unitario)
VALUES ('100260', 'papas margarita', 10, 3600),
       ('D10023', 'coca cola 600 ml', 80, 4500),
       ('D10056', 'bolso de cuero', 16, 200000);

UPDATE productos 
SET stock = 20 
WHERE codigo = '100260'; 

UPDATE productos 
SET codigo = '1023FG' 
WHERE codigo = 'D10023';

INSERT INTO pedidos (fecha, cantidad, valor_total, id_cliente, id_producto)
VALUES ('2024-08-23', 5, 18000, 1, 1),
       ('2024-07-23', 3, 13500, 2, 2),
       ('2024-10-23', 2, 400000, 1, 3);

UPDATE pedidos 
SET fecha = '2024-08-28' 
WHERE id_cliente = 1 AND id_producto = 1; 

UPDATE pedidos 
SET valor_total = 14000  
WHERE id_cliente = 2 AND id_producto = 2;

DELETE FROM pedidos 
WHERE id_cliente = 1;

DELETE FROM productos 
WHERE codigo = '100260'; 

DELETE FROM clientes 
WHERE identificacion = 1002608919;  

COMMIT;







