
--Creacion de tablas
create table usuarios (
id serial primary key,
nombre varchar,
direccion text,
email varchar,
fecha_registro date,
estado varchar (50)
);


create table tarjetas (
id serial primary key,
numero_tarjeta integer,
fecha_expiracion date,
cvv varchar(10),
tipo_tarjeta varchar(50)
);


create table productos (
id serial primary key,
codigo_producto varchar(30),
nombre varchar(60),
categoria varchar(60),
porcentaje_impuesto decimal,
precio decimal
);

create table pagos (
id serial primary key,
codigo_pago varchar(50),
fecha date,
estado varchar(13),
monto decimal,
producto_id integer,
tarjeta_id integer,
usuario_id integer,
foreign key (producto_id) references productos(id),
foreign key (tarjeta_id) references tarjetas(id),
foreign key (usuario_id) references usuarios(id)
);


create table comprobantes_pago (
id serial primary key,
detalle_xml xml,
detalle_json jsonb
);



--primera pregunta
create or replace function obtener_pagos_de_un_usuario(usuario_id integer, fecha date)
returns table (codigo_pago varchar, nombre_producto varchar, monto decimal)
as $$
begin
    return query
    select 
        p.codigo_pago,
        pr.nombre as nombre_producto,
        p.monto
    from pagos p
    join productos pr on p.producto_id = pr.id
    where p.usuario_id = usuario_id and p.fecha = fecha;
end;
$$ language plpgsql;


create or replace function obtener_tarjetas_del_usuario(usuario_id integer)
returns table (nombre_usuario varchar, email varchar, numero_tarjeta integer, cvv varchar, tipo_tarjeta varchar)
as $$
begin
    return query
    select 
        u.nombre as nombre_usuario,
        u.email,
        t.numero_tarjeta,
        t.cvv,
        t.tipo_tarjeta
    from pagos p
    join tarjetas t on p.tarjeta_id = t.id
    join usuarios u on p.usuario_id = u.id
    where p.usuario_id = usuario_id and p.monto > 1000;
end;
$$ language plpgsql;



-- 2 pregunta
create or replace function obtener_tarjetas_detalle_user(usuario_id integer)
returns varchar
as $$
declare
    tarjeta_record RECORD;
    resultado varchar := '';
begin
    for tarjeta_record in 
        select t.numero_tarjeta, t.fecha_expiracion, u.nombre, u.email
        from tarjetas t
        join usuarios u on t.usuario_id = u.id
        Where u.id = usuario_id
    loop
        resultado := resultado || 
            tarjeta_record.numero_tarjeta || ',' || 
            tarjeta_record.fecha_expiracion || ',' || 
            tarjeta_record.nombre || ',' || 
            tarjeta_record.email || ';';
    end loop;
    return resultado;
end;
$$ language plpgsql;


create or replace function obtener_pagos_menor_value(fecha date)
returns varchar as $$
DECLARE
    pago_record RECORD;
    resultado varchar := '';
begin
    for pago_record in 
        select p.monto, p.estado, p.nombre_producto, p.porcentaje_impuesto, 
        u.nombre as usuario, u.direccion, u.email
        from pagos p
        join usuarios u on p.usuario_id = u.id
        where p.monto < 1000 and p.fecha_pago > fecha
    loop
        resultado := resultado || 
            pago_record.monto || ',' || 
            pago_record.estado || ',' || 
            pago_record.nombre_producto || ',' || 
            pago_record.porcentaje_impuesto || ',' || 
            pago_record.usuario || ',' || 
            pago_record.direccion || ',' || 
            pago_record.email || ';';
    end loop;
    return resultado;
end;
$$ language plpgsql;




create or replace function validaciones_producto()
returns trigger as $$

begin
	if NEW.precio > 0 then
		raise exception 'el precio debe ser mayo a cero';
	else if NEW.precio < 20000 then
		raise notice 'el precio del producto debe ser mayor ';
	else 
		raise notice 'producto creado con exito';
	end if;
	return NEW;
end
$$ language plpgsql;


create or replace trigger validaciones_producto
before create on productos
for each row 
execute function validaciones_producto();




create or replace function trigger_xml()
as $$

begin
	
	
end;
$$ language plpgsql;



create or replace trigger trigger_xml 
after create on pagos
for each row 
execute function trigger_xml();



--cuarta Pregunta secuencias


create sequence seq_codigo_producto
start with 5
increment by 5;


--el codigo del producto lo cree tipo varchar pero asumiendo que fuera entero
create sequence seq_code_pago
start with 1
increment by 100;


create or replace function info_xml(comprobante_id INT)
returns xml
as $$
begin
    rerun xmlcomment(
        'Comprobante de Pago' ||
        xmlforest(
            (select id from comprobantes_pago WHERE id = comprobante_id) as "is",
            (select to_char(fecha, 'YYYY-MM-DD') from comprobantes_pago where id = comprobante_id) as "FechaPago",
            (select monto from comprobantes_pago where id = comprobante_id) as "Monto",
            (select detalles from comprobantes_pago where id = comprobante_id) as "Detalles"
        )
    );
end;
$$ language plpgsql;



create or replace function info_json(comprobante_id INT)
returns json
as $$
begin
    return json_build_object(
        'id', (select id FROM comprobantes_pago WHERE id = comprobante_id),
        'FechaPago', (select to_char(fecha, 'YYYY-MM-DD') from comprobantes_pago where id = comprobante_id),
        'Monto', (selecct monto from comprobantes_pago where id = comprobante_id),
        'Detalles', (select detalles from comprobantes_pago where id = comprobante_id)
    );
end;
$$ language plpgsql;




