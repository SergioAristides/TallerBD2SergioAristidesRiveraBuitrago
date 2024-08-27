BEGIN;

    INSERT INTO productos (codigo, nombre, stock, valor_unitario) VALUES
    ('200DFA', 'regla verde', 1000, 2000),
    ('300DFA', 'pc asus Vivo Book', 30, 2500000),
    ('400DFA', 'pc Lenovo', 40, 3500000);

    INSERT INTO clientes (nombre, identificacion, edad, correo) VALUES
    ('Sergio Aristides', 1002608919, 20, 'sergioa.riverab@autonoma.edu.co'),
    ('Manuela Bermudez', 1002607898, 25, 'manuelaB.riverab@autonoma.edu.co'),
    ('Mafe Ramirez', 1002607656, 28, 'mafeR.riverab@autonoma.edu.co');

    INSERT INTO pedidos (fecha, cantidad, valor_total, id_cliente, id_producto) VALUES
    ('2024-09-27', 500, 1000000, 2, 3), 
    ('2024-09-27', 10, 1000000, 2, 2),  
    ('2024-10-27', 1, 1000000, 3, 3);    

    SAVEPOINT punto_de_restauracion;

    UPDATE productos SET stock = 900 WHERE codigo = '200DFA';
    UPDATE productos SET valor_unitario = 2600000 WHERE codigo = '300DFA';

    UPDATE clientes SET edad = 21 WHERE identificacion = 1002608919;
    UPDATE clientes SET correo = 'manuelaB.nuevo@autonoma.edu.co' WHERE identificacion = 1002607898;
    
    UPDATE pedidos SET cantidad = 550 WHERE id_cliente = 2 AND id_producto = 3;
    UPDATE pedidos SET valor_total = 1100000 WHERE id_cliente = 3 AND id_producto = 3;

    DELETE FROM productos WHERE codigo = '400DFA';
    DELETE FROM clientes WHERE identificacion = 1002607656;
    DELETE FROM pedidos WHERE id_cliente = 3 AND id_producto = 3;

    ROLLBACK TO SAVEPOINT punto_de_restauracion;

COMMIT;

SELECT * FROM productos;
SELECT * FROM clientes;
SELECT * FROM pedidos;
