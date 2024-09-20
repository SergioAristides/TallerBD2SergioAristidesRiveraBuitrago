create table clientes(
    id serial primary key,
    nombre text not null,
    correo text unique not null,
    direccion text,
    telefono integer
);

create table servicios(
    codigo text primary key,
    tipo text,
    monto numeric,
    cuota numeric,
    intereses numeric,
    valor_total numeric,
    cliente_id integer,
    foreign key (cliente_id) references clientes(id)
);

create table pagos (
    codigo_transaccion text primary key,
    fecha_pago date,
    total numeric,
    estado text,
    servicio_codigo text,
    foreign key (servicio_codigo) references servicios(codigo)
);

create or replace procedure poblar_base_datos()
language plpgsql
as $$
declare 
    contador_clientes integer;
    contador_servicios integer;
    cliente_actual integer;
    servicio_codigo_actual text;
begin
    contador_clientes := 1;
    while contador_clientes <= 50 loop
        insert into clientes (nombre, correo, direccion, telefono)
        values (
            'usuario_' || contador_clientes, 
            'usuario' || contador_clientes || '@dominio.com', 
            'direccion_' || contador_clientes, 
            300000000 + contador_clientes 
        ) returning id into cliente_actual;

        contador_servicios := 1;
        while contador_servicios <= 3 loop
            servicio_codigo_actual := 'cod_' || cliente_actual || contador_servicios;
            if contador_servicios = 1 then
                insert into servicios (codigo, tipo, monto, cuota, intereses, valor_total, cliente_id)
                values (
                    servicio_codigo_actual,
                    'agua',
                    round(random() * 5000 + 1000),
                    round(random() * 100 + 50),
                    round(random() * 100, 2),
                    round(random() * 6000 + 500),
                    cliente_actual
                );
                insert into pagos (codigo_transaccion, fecha_pago, total, estado, servicio_codigo)
                values (
                    'trans_' || cliente_actual || contador_servicios,
                    current_date,
                    round(random() * 1000 + 500),
                    'realizado',
                    servicio_codigo_actual
                );
            else
                insert into servicios (codigo, tipo, monto, cuota, intereses, valor_total, cliente_id)
                values (
                    servicio_codigo_actual,
                    case when contador_servicios = 2 then 'luz' else 'gas' end,
                    round(random() * 5000 + 1000),
                    round(random() * 100 + 50),
                    round(random() * 100, 2),
                    round(random() * 6000 + 500),
                    cliente_actual
                );
            end if;
            contador_servicios := contador_servicios + 1;
        end loop;
        contador_clientes := contador_clientes + 1;
    end loop;
end;
$$;

call poblar_base_datos();

create or replace function total_pago_cliente_mes(p_cliente_id integer, p_mes integer)
returns numeric as
$$
declare 
    v_total_pago numeric := 0;
    v_fecha_mes integer;
    v_pago_total numeric;
begin
    for v_fecha_mes, v_pago_total in 
        select extract(month from fecha_pago), total 
        from pagos 
        join servicios on pagos.servicio_codigo = servicios.codigo 
        where servicios.cliente_id = p_cliente_id loop
        if v_fecha_mes = p_mes then
            v_total_pago := v_total_pago + v_pago_total;
        end if;
    end loop;

    return v_total_pago;
end;
$$
language plpgsql;

select total_pago_cliente_mes(18, 12);
