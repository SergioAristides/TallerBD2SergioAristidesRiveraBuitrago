create table tipo_contrato (
    id serial primary key,
    descripcion varchar(100) not null,
    cargo varchar(100) not null,
    salario_total decimal(10, 2) not null
);

create table empleados (
    id serial primary key,
    nombre varchar(100) not null,
    identificacion varchar(50) unique not null,
    tipo_contrato_id int,
    foreign key (tipo_contrato_id) references tipo_contrato(id)
);


create table conceptos (
    id serial primary key,
    codigo varchar(20) not null,
    nombre varchar(50) not null,
    porcentaje decimal(5, 2) not null,
    salario numeric not null,
    horas_extras int ,
    prestaciones numeric,
    impuestos numeric
);

create table nomina (
    id serial primary key,
    mes int not null,
    ano int not null,
    fecha_pago date not null,
    total_devengado decimal(10, 2) not null,
    total_deducciones decimal(10, 2) not null,
    total decimal(10, 2) not null,
    cliente_id int not null,
    
    foreign key (cliente_id) references empleados(id)
);

create table detalles_nomina (
    id serial primary key,
    concepto_id int not null,
    valor decimal(10, 2) not null,
    nomina_id int not null,
    foreign key (concepto_id) references conceptos(id),
    foreign key (nomina_id) references nomina(id)
);


insert into tipo_contrato (descripcion, cargo, salario_total) values
('contrato a termino fijo', 'asistente administrativo', 1500000),
('contrato a termino indefinido', 'desarrollador', 3000000),
('contrato de prestación de servicios', 'consultor', 2500000),
('contrato de aprendizaje', 'aprendiz', 800000),
('contrato temporal', 'auxiliar de bodega', 1200000),
('contrato a termino fijo', 'vendedor', 1400000),
('contrato a termino indefinido', 'gerente', 5000000),
('contrato de prestación de servicios', 'diseñador gráfico', 2200000),
('contrato de aprendizaje', 'técnico de mantenimiento', 900000),
('contrato temporal', 'recepcionista', 1100000);

select * from tipo_contrato;
insert into empleados (nombre, identificacion, tipo_contrato_id) values
('juan perez', '123456789', 1),
('ana gomez', '987654321', 2),
('luis martinez', '123123123', 3),
('maria lopez', '321321321', 4),
('pedro torres', '456456456', 5),
('laura sanchez', '654654654', 6),
('jorge ramirez', '789789789', 7),
('clara ortiz', '159753258', 8),
('diego cuervo', '753159456', 9),
('isabella calvo', '951852753', 10);

select * from empleados;
insert into nomina (mes, ano, fecha_pago, total_devengado, total_deducciones, total, cliente_id) values
(1, 2024, '2024-01-15', 15000000, 3000000, 12000000, 1),
(2, 2024, '2024-02-15', 15500000, 3100000, 12400000, 2),
(3, 2024, '2024-03-15', 16000000, 3200000, 12800000, 3),
(4, 2024, '2024-04-15', 16200000, 3250000, 12950000, 4),
(5, 2024, '2024-05-15', 16500000, 3300000, 13200000, 5);
    salario numeric not null,
    horas_extras int ,
    prestaciones numeric,
    impuestos numeric
insert into conceptos (codigo, nombre, porcentaje,salario,horas_extras,prestaciones,impuestos) values
('salario', 'salario', 100),
('horas_extras', 'horas extras', 50),
('prestaciones', 'prestaciones', 12),
('impuestos', 'impuestos', 8),
('bono', 'bono de desempeño', 10),
('comisiones', 'comisiones', 15),
('vacaciones', 'vacaciones', 5),
('prima', 'prima de servicios', 15),
('cesantias', 'cesantías', 10),
('intereses_cesantias', 'intereses de cesantías', 1),
('auxilio_transporte', 'auxilio de transporte', 7),
('indemnizacion', 'indemnización', 20),
('seguro', 'seguro de salud', 4),
('ahorros', 'ahorros voluntarios', 3),
('otros', 'otros conceptos', 6);

insert into detalles_nomina (concepto_id, valor, nomina_id) values
(1, 12000000, 1),
(2, 2000000, 1),
(3, 300000, 1),
(4, 960000, 1),
(1, 12300000, 2),
(2, 2100000, 2),
(3, 310000, 2),
(4, 980000, 2),
(1, 12500000, 3),
(2, 2200000, 3),
(3, 320000, 3),
(4, 1000000, 3),
(1, 12650000, 4),
(2, 2250000, 4),
(3, 330000, 4),
(4, 1010000, 4),
(1, 12700000, 5),
(2, 2300000, 5),
(3, 340000, 5),
(4, 1020000, 5);



create or replace function crear_contrato(
    descripcion_in varchar(100),
    cargo_in varchar(100),
    salario_total_in decimal(10, 2)
) 
returns table(id integer, descripcion varchar, cargo varchar, salario_total decimal) as $$
begin
    if exists (select 1 from tipo_contrato where tipo_contrato.cargo = cargo_in) then
        raise exception 'El cargo % ya existe. Debe ser único.', cargo_in;
    else
        insert into tipo_contrato (descripcion, cargo, salario_total)
        values (descripcion_in, cargo_in, salario_total_in);
    end if;
    
    return query select * from tipo_contrato;
end;
$$ language plpgsql;


create or replace function crear_empleado(
    nombre_in varchar(100),
    identificacion_in varchar(50),
    tipo_contrato_id_in int
) 
returns table(id integer, nombre varchar, identificacion varchar, tipo_contrato_id int) as $$
begin

    if exists (select 1 from empleados where empleados.identificacion = identificacion_in) then
        raise exception 'El empleado con identificación % ya existe.', identificacion_in;
    else

        insert into empleados (nombre, identificacion, tipo_contrato_id)
        values (nombre_in, identificacion_in, tipo_contrato_id_in);

    end if;
    
    return query select * from empleados;
end;
$$ language plpgsql;


select * from crear_contrato('contrato a término indefinido', 'ingeniero de datos', 3500000);

select * from crear_empleado('laura torres', '9988776655', 3);



