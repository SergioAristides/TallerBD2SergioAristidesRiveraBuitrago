create table cliente (
    id serial primary key,
    nombre varchar(100),
    identificacion varchar(20) unique,
    email varchar(100) unique,
    direccion varchar(255),
    telefono varchar(15)
);

create table servicios (
    id serial primary key,
    codigo varchar(20) unique,
    tipo varchar(50),
    monto decimal(10, 2),
    cuota int,
    intereses decimal(5, 2),
    valor_total decimal(10, 2),
    estado varchar(20),
    cliente_id int references cliente(id)
);

create table pagos (
    id serial primary key,
    codigo_transaccion varchar(20) unique,
    fecha_pago date,
    total decimal(10, 2),
    servicio_id int references servicios(id)
);





select * from pagos;
create or replace procedure poblar_bd_servicios()
language plpgsql as $$
declare
    cliente_id int;
    servicio_id int;
    i int;
begin
    for i in 1..50 loop
        insert into cliente (nombre, identificacion, email, direccion, telefono)
        values (
            'cliente ' || i,
            'id' || lpad(i::text, 5, '0'),
            'cliente' || i || '@ejemplo.com',
            'direccion ' || i,
            '300' || lpad(i::text, 7, '0')
        );
    end loop;

    for i in 1..50 loop
        cliente_id := i;
        for j in 1..3 loop
            insert into servicios (codigo, tipo, monto, cuota, intereses, valor_total, estado, cliente_id)
            values (
                'svc' || (cliente_id * 3 + j),
                'tipo ' || j,
                round(random() * 100 + 20),
                round(random() * 10 + 1),
                round(random() * 5),
                round(random() * 100 + 20),
                case when random() < 0.5 then 'pago' else 'no_pago' end,
                cliente_id
            );
        end loop;
    end loop;

    for i in 1..50 loop
        servicio_id := (select id from servicios order by random() limit 1);
        
        insert into pagos (codigo_transaccion, fecha_pago, total, servicio_id)
        values (
            'pay' || lpad(i::text, 5, '0'),
            current_date - (random() * 30)::int,
            round(random() * 50 + 10),
            servicio_id
        );
    end loop;
end;
$$;

call poblar_bd_servicios();




create or replace function transacciones_total_mes(mes int, p_identificacion varchar)
returns decimal as $$
declare
    total_pago decimal;
begin
    select sum(p.total)
    into total_pago
    from pagos p
    join servicios s on p.servicio_id = s.id
    join cliente c on s.cliente_id = c.id
    where extract(month from p.fecha_pago) = mes
      and c.identificacion = p_identificacion;

    return coalesce(total_pago, 0);
end;
$$ language plpgsql;


create or replace function servicios_no_pagados_mes(mes int)
returns decimal as $$
declare
    total_no_pagado decimal;
begin
    select sum(s.monto)
    into total_no_pagado
    from servicios s
    where s.estado = 'no_pago'
      and s.id not in (
          select p.servicio_id
          from pagos p
          where extract(month from p.fecha_pago) = mes
      );

    return coalesce(total_no_pagado, 0);
end;
$$ language plpgsql;



create or replace function servicios_no_pagados_mes_query(mes int)
returns table(cliente_id int, servicio_id int, monto decimal) as $$
begin
    return query
    select s.cliente_id, s.id as servicio_id, s.monto
    from servicios s
    where s.estado = 'no_pago'
      and s.id not in (
          select p.servicio_id
          from pagos p
          where extract(month from p.fecha_pago) = mes
      );
end;
$$ language plpgsql;


