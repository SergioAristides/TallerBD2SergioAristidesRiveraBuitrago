create table clientes (
    cliente_id serial primary key,
    nombre varchar(100),
    identificacion varchar(20),
    edad int,
    correo varchar(100)
);

create table productos (
    producto_id serial primary key,
    codigo varchar(50),
    nombre varchar(100),
    stock int,
    valor_unitario decimal(10, 2)
);

create table facturas (
    factura_id serial primary key,
    fecha date,
    cantidad int,
    valor_total decimal(10, 2),
    pedido_estado varchar(20) check (pedido_estado in ('pendiente', 'bloqueado', 'entregado')),
    producto_id int references productos(producto_id),
    cliente_id int references clientes(cliente_id)
);

create table auditoria (
    auditoria_id serial primary key,
    fecha_inicio date,
    fecha_final date,
    factura_id int references facturas(factura_id),
    pedido_estado varchar(20)
);


select * from auditoria;
select * from clientes;
select * from productos;
select * from facturas;


create or replace procedure generar_auditoria(fecha_inicio date, fecha_final date)
language plpgsql
as $$
declare
    factura record; 
begin
   
    for factura in
        select factura_id, pedido_estado
        from facturas
        where fecha between fecha_inicio and fecha_final
    loop
   
        insert into auditoria (fecha_inicio, fecha_final, factura_id, pedido_estado)
        values (fecha_inicio, fecha_final, factura.factura_id, factura.pedido_estado);
    end loop;
end;
$$;



create or replace procedure simular_ventas_mes()
language plpgsql
as $$
declare
    dia integer := 1;
    cliente record;
    cantidad integer;
    producto_id integer;
    valor_total numeric;
    total_dias integer := 30;
begin
    loop
        exit when dia > total_dias;
        
        for cliente in
            select * from clientes
        loop
            select codigo into producto_id
            from productos
            order by random() limit 1;

            select floor(random() * 10 + 1)::int into cantidad;

            select cantidad * valor_unitario into valor_total
            from productos
            where codigo = producto_id;

            insert into facturas (fecha, cantidad, valor_total, pedido_estado, producto_id, cliente_id)
            values (current_date + (dia - 1), cantidad, valor_total, 'pendiente', producto_id, cliente.identificacion);
        end loop;
        
        dia := dia + 1;
    end loop;
end;
$$;

