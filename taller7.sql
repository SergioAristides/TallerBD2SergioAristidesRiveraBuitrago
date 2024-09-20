create table clientes (
	id number not null primary key,
	nombre text,
	edad number,
	correo text
);

create table productos (
	codigo number not null primary key,
	nombre text,
	stock number,
	valor_unitario numeric
);

create table facturas (
	id number not null primary key,
	fecha date,
	cantidad number,
	valor_total number,
	pedido_estado text,
	producto_id number,
	cliente_id number,
	foreign key (producto_id) references productos(codigo),
	foreign key (cliente_id) references clientes(id)
);

insert into clientes (nombre, id, edad, correo) values ('carlos', 1, 30, 'carlos@gmail.com');
insert into clientes (nombre, id, edad, correo) values ('laura', 2, 25, 'laura@gmail.com');
insert into clientes (nombre, id, edad, correo) values ('miguel', 3, 35, 'miguel@gmail.com');

insert into productos (nombre, codigo, stock, valor_unitario) values ('leche', 1, 10, 5000);
insert into productos (nombre, codigo, stock, valor_unitario) values ('pan', 2, 15, 2500);
insert into productos (nombre, codigo, stock, valor_unitario) values ('queso', 3, 20, 12000);

insert into facturas (id, cantidad, valor_total, pedido_estado, producto_id, cliente_id) values (1, 2, 10000, 'entregado', 1, 1);
insert into facturas (id, cantidad, valor_total, pedido_estado, producto_id, cliente_id) values (2, 5, 12500, 'bloqueado', 2, 3);
insert into facturas (id, cantidad, valor_total, pedido_estado, producto_id, cliente_id) values (3, 1, 12000, 'pendiente', 3, 2);

create or replace procedure verificar_stock(
	p_producto_id in number,
	p_cantidad_compra in number)
is 
	v_producto_stock number;
begin
	select stock into v_producto_stock from productos where codigo = p_producto_id;
	
	if v_producto_stock >= p_cantidad_compra then
		dbms_output.put_line('si existe suficiente stock');
	else
		dbms_output.put_line('no existe suficiente stock');
	end if;
end;

call verificar_stock(1, 3);
