create table usuarios (
    id serial not null primary key,
    nombre varchar,
    identificacion numeric not null unique,
    edad integer,
    correo varchar
);

create table facturas (
    id serial not null primary key,
    fecha date,
    producto varchar not null,
    cantidad integer,
    valor_unitario numeric,
    valor_total numeric,
    usuario_id integer,
    foreign key (usuario_id) references usuarios(id)
);

create or replace procedure poblar_bdd()
language plpgsql
as $$
declare 
    contador_clientes integer;
    contador_facturas integer;
    cliente_actual integer;
begin
    contador_clientes := 1;
    while contador_clientes <= 50 loop
        insert into usuarios (nombre, identificacion) 
        values (
            'usuario_' || contador_clientes, 
            1000 + contador_clientes  -- Ejemplo de identificación única
        ) returning id into cliente_actual;

        contador_facturas := 1;
        while contador_facturas <= 3 loop
            if contador_facturas = 1 then
                insert into facturas (producto, cantidad, valor_unitario, valor_total, usuario_id) 
                values (
                    'Laptop_' || cliente_actual,
                    round(random() * 10 + 1),  -- Cantidad aleatoria entre 1 y 10
                    round(random() * 5000 + 1000),  -- Valor unitario aleatorio
                    round(random() * 6000 + 500),  -- Valor total aleatorio
                    cliente_actual
                );
            else
                insert into facturas (producto, cantidad, valor_unitario, valor_total, usuario_id) 
                values (
                    'producto_' || cliente_actual || '_' || contador_facturas,
                    round(random() * 10 + 1),
                    round(random() * 5000 + 1000),
                    round(random() * 6000 + 500),
                    cliente_actual
                );
            end if;
            contador_facturas := contador_facturas + 1;
        end loop;
        contador_clientes := contador_clientes + 1;
    end loop;
end;
$$;

call poblar_bdd();


create or replace procedure prueba_identificacion_unica()
language plpgsql
as $$
declare 
begin
    insert into usuarios (nombre, identificacion) values('Manuel', 23);
exception
    when unique_violation then
        rollback;
        raise notice 'usuario con esa identificacion ya existe';
end;
$$;

call prueba_identificacion_unica();

create or replace procedure prueba_cliente_debe_existir()
language plpgsql
as $$
declare 
begin
    insert into facturas (producto, usuario_id) values('PC lenovo', 23);
    insert into facturas (producto, usuario_id) values('Mouse Asus', 21); 
exception
    when foreign_key_violation then
        rollback;
        raise notice 'usuario con esa identificacion no existe';
end;
$$;

call prueba_cliente_debe_existir();

create or replace procedure prueba_producto_vacio()
language plpgsql
as $$
declare 
begin
    insert into facturas (producto, usuario_id) values(null, 20);
exception
    when others then
        rollback;
        raise notice 'producto no puede ser null';
end;
$$;

call prueba_producto_vacio();
