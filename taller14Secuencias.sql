create table factura (
    id serial primary key,
    codigo int not null,
    cliente varchar(50),
    producto varchar(50),
    descuento decimal(5, 2),
    valor_total decimal(10, 2),
    numero_fe int
);

create sequence seq_codigo_factura
start with 1
increment by 1;

create sequence seq_numero_fe
start with 100
increment by 100;


create or replace procedure poblar_bd()
language plpgsql
as $$
begin
    for i in 1..10 loop
        insert into factura (codigo, cliente, producto, descuento, valor_total, numero_fe)
        values (
            nextval('seq_codigo_factura'),
            'cliente_' || i,
            'producto_' || i,
            round(cast(random() * 10 as numeric), 2),
            round(cast(random() * 1000 + 100 as numeric), 2),
            nextval('seq_numero_fe')
        );
    end loop;
end;
$$;

call poblar_bd();

select * from factura;
