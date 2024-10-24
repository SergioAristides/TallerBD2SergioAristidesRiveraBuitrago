create table factura (
	id serial primary key,
    codigo varchar(65),
    punto_de_venta varchar (70),
    descripcion jsonb
);



insert into factura (codigo,punto_de_venta, descripcion)
values ('ABC001',
		'PDV-001', 
        '{
          "cliente": {
            "nombre": "Sergio Rivera",
            "identificacion": "1002608978",
            "direccion": "Carrera 2 #54-76"
          },
          "factura": {
            "codigo_factura": "F001",
            "total_descuento": 0.2,
            "total_factura": 53.00
          },
          "productos": [
            {
              "cantidad": 2,
              "valor": 50.00,
              "producto": {
                "nombre": "Camiseta",
                "descripcion": "Camiseta deportiva negra diadora sport",
                "precio": 25.00,
                "categorias": ["sport", "hombre","deporte"]
              }
            },
            {
              "cantidad": 1,
              "valor": 16.25,
              "producto": {
                "nombre": "pesas",
                "descripcion": "pesas azules marca sporter ",
                "precio": 16.25,
                "categorias": ["deporte","gimnasio","interior"]
              }
            }
          ]
        }'::jsonb
);


select * from factura;

/*1*/

create or replace procedure insertar_factura(
p_codigo varchar,
p_punto_de_venta varchar,
p_descripcion jsonb
)

language plpgsql as
$$

declare
	total_factura decimal;
	total_descuento decimal;

begin
	total_factura := (p_descripcion->'factura'->>'total_factura')::decimal;
	total_descuento := (p_descripcion->'factura'->>'total_descuento')::decimal;

	if total_factura > 10000 then
		raise exception 'El total de la factura no puede exceder los US$10,000 total actual: US$%.2f',total_factura;
	end if;

	if total_descuento > 0.5 then
		raise exception 'El descuento maximo permitido es del 50%% y el descuento actual es de %.2f%%', total_descuento * 100;
	end if;

	insert into factura(codigo,punto_de_venta,descripcion)
	values(p_codigo,p_punto_de_venta,p_descripcion);
end;
$$;


--Probando insertar factura
call insertar_factura(
    'ABC002',
    'PDV-002',
    '{
        "cliente": {
            "nombre": "Juan Pérez",
            "identificacion": "1002608979",
            "direccion": "Calle 3 #45-67"
        },
        "factura": {
            "codigo_factura": "F002",
            "total_descuento": 0.1,
            "total_factura": 2000.00
        },
        "productos": [
            {
                "cantidad": 1,
                "valor": 1000.00,
                "producto": {
                    "nombre": "Bicicleta",
                    "descripcion": "Bicicleta de montaña",
                    "precio": 1000.00,
                    "categorias": ["deporte", "exterior"]
                }
            },
            {
                "cantidad": 1,
                "valor": 1000.00,
                "producto": {
                    "nombre": "Casco",
                    "descripcion": "Casco de bicicleta",
                    "precio": 1000.00,
                    "categorias": ["deporte", "protección"]
                }
            }
        ]
    }'::jsonb
);


--insertar algo invalido que supere el descuento y el total de la factura para probar si todo esta bien
/*
call insertar_factura(
    'ABC003',
    'PDV-003',
    '{
        "cliente": {
            "nombre": "Pedro ramirez",
            "identificacion": "1002608980",
            "direccion": "Carrera 8 #12-34"
        },
        "factura": {
            "codigo_factura": "F003",
            "total_descuento": 0.6,
            "total_factura": 12000.00
        },
        "productos": [
            {
                "cantidad": 1,
                "valor": 6000.00,
                "producto": {
                    "nombre": "Laptop",
                    "descripcion": "Laptop de alta gama",
                    "precio": 6000.00,
                    "categorias": ["tecnología", "electrónica"]
                }
            },
            {
                "cantidad": 1,
                "valor": 6000.00,
                "producto": {
                    "nombre": "Smartphone",
                    "descripcion": "Teléfono móvil de última generación",
                    "precio": 6000.00,
                    "categorias": ["tecnología", "móviles"]
                }
            }
        ]
    }'::jsonb
);
*/
create or replace procedure actualizar_factura(
p_codigo varchar,
p_descripcion jsonb
)
language plpgsql as
$$
begin 
	update factura set descripcion = p_descripcion
	where codigo = p_codigo;
end;
$$;

--probando actualizar la factura

/*2*/
call actualizar_factura(
    'ABC002',
    '{
        "cliente": {
            "nombre": "Juan Pérez",
            "identificacion": "1002608979",
            "direccion": "Calle 3 #45-67"
        },
        "factura": {
            "codigo_factura": "F002",
            "total_descuento": 0.2,
            "total_factura": 1800.00
        },
        "productos": [
            {
                "cantidad": 1,
                "valor": 1000.00,
                "producto": {
                    "nombre": "Bicicleta",
                    "descripcion": "Bicicleta de montaña de super en duro",
                    "precio": 1000.00,
                    "categorias": ["deporte", "exterior"]
                }
            },
            {
                "cantidad": 1,
                "valor": 800.00,
                "producto": {
                    "nombre": "Casco",
                    "descripcion": "Casco de bicicleta negro mate",
                    "precio": 800.00,
                    "categorias": ["deporte", "protección"]
                }
            }
        ]
    }'::jsonb
);



select* from factura;

/*3*/

create or replace function nombre_cliente_id(
p_identificacion varchar
)returns varchar 
language plpgsql as
$$
declare
	nombre varchar;
begin
	select descripcion->'cliente'->>'nombre' into nombre
	from factura where descripcion->'cliente'->>'identificacion'= p_identificacion;

	return nombre;
	
end;
$$;


select nombre_cliente_id('1002608979');

select* from factura;

/*4*/

create or replace function informacion_especifica_factura()
returns table (
    f_cliente text,
    f_identificacion text,
    f_codigo varchar(65),
    f_total_descuento numeric,
    f_total_factura numeric
)
language plpgsql as
$$
begin	
	return query
	select 
	    descripcion->'cliente'->>'nombre' as f_cliente,
	    descripcion->'cliente'->>'identificacion' as f_identificacion,
	    codigo as f_codigo,
	    (descripcion->'factura'->>'total_descuento')::numeric as f_total_descuento,
	    (descripcion->'factura'->>'total_factura')::numeric as f_total_factura
    from factura;
end;
$$;


select * from informacion_especifica_factura();



/*5*/

--este devuelve solo un json
create or replace function obtener_productos_code_factura(

p_codigo varchar
)returns jsonb as 
$$

begin 
	return (select descripcion->'productos'
	from factura where codigo =p_codigo);
end;
$$ language plpgsql;


select obtener_productos_code_factura('ABC001');

--este devuelve campos especificados
create or replace function obtener_productos_tabla_factura(
    p_codigo varchar
) returns table (
    cantidad integer,
    valor decimal,
    nombre varchar,
    descripcion varchar,
    precio decimal,
    categorias text[] 
) as 
$$
begin 
    return query
    select 
        (producto->>'cantidad')::integer as cantidad,
        (producto->>'valor')::decimal as valor,
        (producto->'producto'->>'nombre')::varchar as nombre,  
        (producto->'producto'->>'descripcion')::varchar as descripcion,  
        (producto->'producto'->>'precio')::decimal as precio,
        array(select jsonb_array_elements_text(producto->'producto'->'categorias')) as categorias 
    from 
        factura f,  
        jsonb_array_elements(f.descripcion->'productos') as producto  
    where 
        f.codigo = p_codigo;  
end;
$$ language plpgsql;




select * from obtener_productos_tabla_factura('ABC001');