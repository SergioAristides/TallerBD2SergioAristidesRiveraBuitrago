create table facturas(
	id serial primary key,
	fecha varchar(100),
	cantidad integer,
	valor_total numeric(10,2),
	pedido_estado varchar(30),
	id_cliente integer,
	producto_id Integer,
	foreign key (id_cliente) references clientes (id),
	foreign key (producto_id) references productos(id)
);


select * from clientes;

CREATE OR REPLACE PROCEDURE verificar_stock(p_producto_id INTEGER, p_cantidad INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    stockP INTEGER;
BEGIN
    IF EXISTS (SELECT 1 FROM productos WHERE id = p_producto_id) THEN 
        SELECT stock INTO stockP FROM productos WHERE id = p_producto_id;
        
        IF stockP >= p_cantidad THEN 
            RAISE NOTICE 'Si existe la cantidad de productos';
        ELSE
            RAISE NOTICE 'No existe la cantidad de productos';
        END IF;
    ELSE
        RAISE NOTICE 'El producto no existe';
    END IF;
END;
$$;


call verificar_stock(3,15);

select * from productos;
select * from clientes;
select * from pedidos;
select * from facturas;


insert into facturas (fecha,cantidad,valor_total,pedido_estado,id_cliente,producto_id)
values("8/26/2024",1,35000,"Entregado",3,2),
	  ("8/26/2024",5,1000000,"Pendiente",19,19),
	  ("8/26/2024",6,800000,"Bloqueado",20,20),
	  ("8/26/2024",1,150000,"Entregado",21,21),
	  ("8/26/2024",2,100000,"Pendiente",2,2),
	  ("8/26/2024",1,50000,"Bloqueado",3,19);
	 
CREATE OR REPLACE PROCEDURE cambiar_estado(p_factura_id INTEGER, p_change VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    current_estado VARCHAR(30);
BEGIN
    IF EXISTS (SELECT 1 FROM facturas WHERE id = p_factura_id) THEN 
        SELECT pedido_estado INTO current_estado FROM facturas WHERE id = p_factura_id;
        
        UPDATE facturas
        SET pedido_estado = p_change
        WHERE id = p_factura_id;

        RAISE NOTICE 'Estado cambiado de % a %', current_estado, p_change;
    ELSE
        RAISE NOTICE 'La factura con ID % no existe', p_factura_id;
    END IF;
END;
$$;


	 
