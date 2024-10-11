
CREATE OR REPLACE FUNCTION query.obtener_nomina_empleado(empleado_identificacion character varying)
 RETURNS TABLE(nombre character varying, mes integer, "año" integer, fecha_pago date, total_devengado numeric, total_deducciones numeric, total numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY 
    SELECT e.nombre, n.mes, n.ano, n.fecha_pago, n.total_devengado, n.total_deducciones, n.total
    FROM query.empleados e
    JOIN query.nomina n ON e.identificacion = empleado_identificacion;
END;
$function$
;

-- DROP FUNCTION query.obtener_total_por_contrato();

CREATE OR REPLACE FUNCTION query.obtener_total_por_contrato()
 RETURNS TABLE(descripcion character varying, total_nomina numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY 
    SELECT tc.descripcion, SUM(n.total) AS total_nomina
    FROM query.tipo_contrato tc
    JOIN query.empleados e ON e.tipo_contrato_id = tc.id
    JOIN query.nomina n ON e.id = n.cliente_id 
    GROUP BY tc.descripcion;
END;
$function$
;

--generar auditoria en oracle

create or replace procedure generar_auditoria (
    fecha_inicio in date,
    fecha_final in date
) 
is
begin
    for factura in (
        select factura_id, pedido_estado
        from facturas
        where fecha between fecha_inicio and fecha_final
    )
    loop
        insert into auditoria (fecha_inicio, fecha_final, factura_id, pedido_estado)
        values (fecha_inicio, fecha_final, factura.factura_id, factura.pedido_estado);
    end loop;
end generar_auditoria;
/

--simular ventas en oracle

create or replace procedure simular_ventas_mes
is
    dia            integer := 1;
    cantidad       integer;
    selected_producto_id integer;
    valor_total    number;
    total_dias     integer := 30;
begin
    loop
        exit when dia > total_dias;

        for cliente in (
            select cliente_id from clientes
        )
        loop
            select producto_id into selected_producto_id
            from productos
            order by dbms_random.value
            fetch first 1 rows only;

            select trunc(dbms_random.value(1, 11)) into cantidad from dual;

            -- calcular el valor total
            select cantidad * valor_unitario into valor_total
            from productos
            where producto_id = selected_producto_id;

            insert into facturas (fecha, cantidad, valor_total, pedido_estado, producto_id, cliente_id)
            values (sysdate + (dia - 1), cantidad, valor_total, 'pendiente', selected_producto_id, cliente.cliente_id);
        end loop;

        dia := dia + 1;
    end loop;
end simular_ventas_mes;
/
