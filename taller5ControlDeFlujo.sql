
alter table facturas
alter column fecha type date using (fecha::date);


CREATE OR REPLACE PROCEDURE crear_stock()
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_stock INTEGER := 0;
    v_stock_actual INTEGER;
    v_nombre_producto VARCHAR;
BEGIN

    FOR v_nombre_producto, v_stock_actual IN 
        (SELECT nombre, stock FROM productos)
    LOOP 
        RAISE NOTICE 'El nombre del producto es: %', v_nombre_producto;
        RAISE NOTICE 'El stock actual es: %', v_stock_actual;
        v_total_stock := v_total_stock + v_stock_actual;
    END LOOP;

    RAISE NOTICE 'El stock total es: %', v_total_stock;
END;
$$;


call crear_stock();

/*creacion de la tabla auditoria*/


select * from facturas;
create table auditorias(
	id SERIAL primary key,
	fecha_inicio date,
	fecha_final date,
	factura_id integer,
	pedido_estado varchar,
	foreign key (factura_id) references facturas(id)
);

INSERT INTO auditorias (fecha_inicio, fecha_final, factura_id, pedido_estado) 
VALUES 
('2023-01-01', '2023-01-05', 31, 'entregado'),
('2023-02-01', '2023-02-10', 32, 'en_proceso'),
('2023-03-05', '2023-03-15', 34, 'cancelado'),
('2023-04-10', '2023-04-20', 35, 'entregado'),
('2023-05-01', '2023-05-05', 36, 'en_proceso'),
('2023-06-01', '2023-06-10', 32, 'entregado');






CREATE OR REPLACE PROCEDURE cambiar_estado(p_fecha_inicio INTEGER, p_fecha_fin VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_factura INTEGER;
    v_fecha DATE;
    v_cantidad INTEGER;
    v_valor_total NUMERIC;
    v_pedido_estado VARCHAR(30);
    v_id_cliente INTEGER;
    v_producto_id INTEGER;
BEGIN
    FOR v_id_factura, v_fecha, v_cantidad, v_valor_total, v_pedido_estado, v_id_cliente, v_producto_id IN
        (SELECT id_factura, fecha, cantidad, valor_total, pedido_estado, id_cliente, producto_id 
         FROM facturas)
    LOOP
        IF v_fecha >= to_date(p_fecha_inicio::TEXT, 'YYYYMMDD') AND v_fecha <= to_date(p_fecha_fin, 'YYYYMMDD') THEN

            INSERT INTO auditoria (id_factura, fecha, cantidad, valor_total, pedido_estado, id_cliente, producto_id)
            VALUES (v_id_factura, v_fecha, v_cantidad, v_valor_total, v_pedido_estado, v_id_cliente, v_producto_id);

            UPDATE facturas 
            SET pedido_estado = 'Auditoría'
            WHERE id = v_id_factura;
        END IF;
    END LOOP;
END;
$$;

	


CREATE OR REPLACE PROCEDURE simular_ventas_mes()
AS $$
DECLARE
    v_dia INTEGER := 1;
    v_identificacion VARCHAR;
    v_cantidad INTEGER;
BEGIN
    WHILE v_dia <= 30 LOOP
        FOR cliente IN (SELECT identificacion FROM clientes) LOOP
            v_cantidad := FLOOR(1 + RANDOM() * 10);

            INSERT INTO facturas (fecha, cliente_id, cantidad)
            VALUES (CURRENT_DATE + INTERVAL '1 day' * (v_dia - 1), cliente.identificacion, v_cantidad);
        END LOOP;

        v_dia := v_dia + 1;
    END loop;
END;
$$ LANGUAGE plpgsql;




