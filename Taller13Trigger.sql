create table empleado (
	identificacion int primary key,
	salario numeric,
	edad int,
	correo varchar(100)
);

create table nomina (
id Serial primary key,
fecha date,
total_ingresos numeric,
total_deducciones numeric,
total_neto numeric,
empleado_id int ,
foreign key (empleado_id) references empleado(identificacion)
);

create table detalle_nomina(
id Serial primary key,
concepto varchar(60),
tipo varchar(100),
valor int,
nomina_id int,
foreign key (nomina_id) references nomina(id)

);

CREATE TABLE auditoria_empleado (
    id SERIAL PRIMARY KEY,             
    empleado_identificacion int NOT NULL,       
    campo_modificado varchar(100),      
    valor_anterior varchar(255),        
    valor_nuevo varchar(255),          
    fecha_modificacion timestamp,      
    usuario_modificacion varchar(100),  
    accion varchar(20),               
    FOREIGN KEY (empleado_identificacion) REFERENCES empleado(identificacion)
);


ALTER TABLE auditoria_empleado
ADD COLUMN concepto varchar(255);


create or replace function no_supera_presupuesto()
returns trigger as $$
declare
	salario_empleado numeric;
begin 
	select salario into salario_empleado 
    from empleado 
    where identificacion = new.empleado_id;
	
	new.total_ingresos := salario_empleado;


	if new.total_ingresos - new.total_deducciones > 12000000 then
		raise exception 'el salario no puede ser mayor a 12 millones';
	else
		new.total_neto := new.total_ingresos - new.total_deducciones;
	end if;
	return new;
	
end;
$$ language plpgsql;



create trigger presupuesto
before insert or update on nomina
for each row
execute function no_supera_presupuesto();



insert into empleado (identificacion, salario,edad,correo) values
	(1002608919,15000000,23,'sberbio5@gmail.com'),
	(1007654565,4500000,23,'lamuel6@gmail.com'),
	(1002356891,65000000,23,'mijol8@gmail.com');

select * from empleado;
select * from nomina;


insert into nomina(fecha, total_deducciones, empleado_id) 
values ('2024-10-02', 1000000, 1007654565); 
		

insert into empleado (identificacion, salario,edad,correo) values
	(108765436,5800000,28,'JuanLuis3@gmail.com');

create or replace function detalleNomina()
returns trigger as $$

begin
	--salario base
	insert into detalle_nomina(concepto,tipo,valor,nomina_id)
	values('salario Base','Ingreso',NEW.total_ingresos - 700000,NEW.id);
	--horas extras
	insert into detalle_nomina(concepto,tipo,valor,nomina_id)
	values('Horas extra','Ingreso',700000,NEW.id);

    -- Ingresar el detalle de 'Aporte a Seguridad Social'
    insert into detalle_nomina (concepto, tipo, valor, nomina_id)
    values ('Aporte a Seguridad Social', 'Deducción', 500000, NEW.id);

    -- Ingresar el detalle de 'Retención de Impuestos'
    insert into detalle_nomina (concepto, tipo, valor, nomina_id)
    values ('Retención de Impuestos', 'Deducción', 500000, NEW.id);
	
	RETURN NEW;

	
end
$$ language plpgsql;


create or replace trigger insertDetalleNomina
after insert on nomina
for each row
execute function detalleNomina();


insert into empleado (identificacion, salario,edad,correo) values
	(108765436,5800000,28,'JuanLuis3@gmail.com');

insert into nomina(fecha, total_deducciones, empleado_id) 
values ('2024-10-02', 1000000, 108765436); 


select * from empleado;
select * from nomina;
select * from detalle_nomina;



create or replace function updateSalario()
returns trigger as $$

begin
	if NEW.salario >= 12000000 then
		raise exception 'el salario no puede ser mayor a 12 millones';
	else 
		raise notice 'salario actaulizado con exito';
	end if;
	return NEW;
end
$$ language plpgsql;


create or replace trigger salaryUpdate
before update on empleado
for each row 
execute function updateSalario();


update empleado set salario = 5800000 where identificacion = 1007654565;



create or replace function updateAuditoriaEmpleado()
returns trigger as $$

declare
	campoModificado varchar(100);
	concepto varchar(50);
begin
	
	if new.salario <> old.salario then
		campoModificado :='Salario';
		
		if new.salario > old.salario then
			concepto:= 'Aumento';
		else
			concepto := 'Disminución';
		end if;
		insert into auditoria_empleado(empleado_identificacion,campo_modificado,valor_anterior,valor_nuevo,fecha_modificacion,usuario_modificacion,accion,concepto)
		values(NEW.identificacion, campoModificado, OLD.salario::varchar, NEW.salario::varchar, CURRENT_TIMESTAMP, 'gerencia', 'UPDATE', concepto);
		
		raise notice 'auditoria empleado agregada';
	end if;
	return new;
end
$$ language plpgsql;


create or replace trigger updateEmpAudi
after update on empleado
for each row 
execute function updateAuditoriaEmpleado();

select * from empleado;

update empleado set salario = 6000000 where identificacion =108765436;

select * from auditoria_empleado ;