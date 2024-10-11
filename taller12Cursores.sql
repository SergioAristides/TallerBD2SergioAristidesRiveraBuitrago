
create table envios (
id Serial primary key,
fecha_envio date,
destino varchar(100),
observacion varchar(100),
estado varchar(100),
CONSTRAINT estado_valido CHECK (estado IN ('Pendiente', 'En ruta', 'Entregado'))

);

CREATE OR REPLACE FUNCTION poblar_bd()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO envios(fecha_envio, destino, observacion, estado)
        VALUES (
			clock_timestamp() - (random() * 10)::int * interval '1 day',            
			'destino' || i,
            'observacion' || i, 
            (ARRAY['Pendiente', 'En ruta', 'Entregado'])[FLOOR(RANDOM() * 3 + 1)::INT]     
        );
    END LOOP;
END;
$$;

select poblar_bd();

select * from envios;
TRUNCATE TABLE envios;


create or replace procedure primera_fase_envio()
language plpgsql
as $$
declare
    envio record;
    cur cursor for select id, observacion, estado from envios where estado = 'Pendiente';
begin
    open cur;
    
    loop
        fetch cur into envio;
        exit when not found;

        update envios
        set observacion = 'primera etapa del envio', estado = 'En ruta'
        where id = envio.id;
    end loop;

    close cur;
end;
$$;


create or replace procedure ultima_fase_envio()
language plpgsql
as $$
declare
    envio record;
    cur cursor for select id, estado, fecha_envio from envios where estado = 'En ruta' and (current_date - fecha_envio) > 5;
begin
    open cur;

    loop
        fetch cur into envio;
        exit when not found;

        update envios
        set observacion = 'envio realizado satisfactoriamente', estado = 'Entregado'
        where id = envio.id;
    end loop;

    close cur;
end;
$$;


call primera_fase_envio();

call ultima_fase_envio();

select * from envios;


