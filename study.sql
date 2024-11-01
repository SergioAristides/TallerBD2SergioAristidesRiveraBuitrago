CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    cargo VARCHAR(50),
    salario DECIMAL(10, 2),
    departamento VARCHAR(50)
);




create or replace function obtener_empleacdo_por_departamento(departamento_in varchar)
returns table (id int, nombre varchar, cargo varchar, salario decimal, departamento varchar)
as $$
begin
    return query
    select * from empleados where departamento = departamento_in;

    return query 
    select id,nombre,cargo,salario,departamento
    from empleados
    where departamento = departamento_in;

end;
$$ language plpgsql;

select * from obtener_empleacdo_por_departamento('Ventas');

create or replace function suma_salarios_por_departamento(departamento_in varchar)
returns table(departamento varchar, total_salario decimal)
as $$

begin
    return query
    select departamento, sum(salario) as total_salario
    from empleados
    where departamento = departamento_in
    group by departamento;

end;
$$ language plpgsql;

select * from suma_salarios_por_departamento('Ventas');

create or replace function empleados_con_salario_mayor_a(salario_in decimal)
returns table(id int, nombre varchar, cargo varchar, salario decimal, departamento varchar)
as $$

begin
    return query
    select id,nombre,cargo,salario
    from empleados
    where salario > salario_in;

end;
$$ language plpgsql

select * from suma_salarios_por_departamento(1000);

create o replace function reporte_salario_por_cargos()
returns table(cargo varchar,cantidad_emp integer, total_salario decimal)
as $$

begin
    return query
    select cargo, count(*) as cantidad_emp,avg(salario) as total_salario
    from empleados
    group by cargo;

end;
$$ language plpgsql;

select * from reporte_salario_por_cargos();


CREATE TABLE proyectos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    departamento VARCHAR(50)
);



create or replace function empleados_y_proyectos()
returns table(empleado_nombre varchar, cargo varchar, salario decimal,proyecto_nombre varchar)
as $$
begin
    return query 
    select e.nombre, e.cargo, e.salario, p.nombre as proyecto_nombre
    from empleados e
    inner join proyectos p on e.departamento = p.departamento;

end;
$$ language plpgsql;

select * from empleados_y_proyectos();


CREATE OR REPLACE FUNCTION obtener_total_pagos_mes(mes INT)
RETURNS DECIMAL AS $$
BEGIN
    RETURN (SELECT SUM(monto) FROM pagos WHERE EXTRACT(MONTH FROM fecha) = mes);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION obtener_informacion_cliente(cliente_id INT)
RETURNS JSON AS $$
BEGIN
    RETURN (SELECT json_build_object(
                'id', id,
                'nombre', nombre,
                'email', email,
                'saldo', saldo
            )
            FROM clientes WHERE id = cliente_id);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION obtener_inventario_xml()
RETURNS XML AS $$
BEGIN
    RETURN (SELECT xmlagg(
                xmlelement(name "producto",
                    xmlelement(name "id", id),
                    xmlelement(name "nombre", nombre),
                    xmlelement(name "precio", precio)
                )
            ) FROM productos);
END;
$$ LANGUAGE plpgsql;



package javataller10;

import java.math.BigDecimal;
import java.sql.*;
import org.json.JSONObject;
import org.w3c.dom.Document;
import javax.xml.parsers.DocumentBuilderFactory;

public class Generic {

    private String forName;
    private String url;
    private String user;
    private String password;

    public Generic(String forName, String url, String user, String password) {
        this.forName = forName;
        this.url = url;
        this.user = user;
        this.password = password;
    }

    // Llamada a la función que retorna un valor simple
    public void getMonthlyPaymentTotal(int month) {
        try {
            Class.forName(this.forName);
            Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

            CallableStatement stmt = conn.prepareCall("{? = call obtener_total_pagos_mes(?)}");
            stmt.registerOutParameter(1, Types.DECIMAL);
            stmt.setInt(2, month);
            stmt.execute();

            BigDecimal total = stmt.getBigDecimal(1);
            System.out.println("Total Pagado en el Mes: " + total);

            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Llamada a la función que retorna JSON
    public void getClientInfoJson(int clientId) {
        try {
            Class.forName(this.forName);
            Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

            CallableStatement stmt = conn.prepareCall("{? = call obtener_informacion_cliente(?)}");
            stmt.registerOutParameter(1, Types.OTHER);
            stmt.setInt(2, clientId);
            stmt.execute();

            String jsonResult = stmt.getString(1);
            JSONObject jsonObject = new JSONObject(jsonResult);
            System.out.println("Cliente Info: " + jsonObject.toString(2));

            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Llamada a la función que retorna XML
    public void getInventoryXml() {
        try {
            Class.forName(this.forName);
            Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

            CallableStatement stmt = conn.prepareCall("{? = call obtener_inventario_xml()}");
            stmt.registerOutParameter(1, Types.SQLXML);
            stmt.execute();

            SQLXML xmlResult = stmt.getSQLXML(1);
            Document xmlDoc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(xmlResult.getBinaryStream());
            System.out.println("Inventario XML: " + xmlDoc.getDocumentElement().getTextContent());

            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Llamada a procedimiento que retorna ResultSet
    public void getMonthlyTransactions(int month) {
        try {
            Class.forName(this.forName);
            Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

            CallableStatement stmt = conn.prepareCall("{ call obtener_transacciones(?) }");
            stmt.setInt(1, month);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                int clienteId = rs.getInt("cliente_id");
                BigDecimal monto = rs.getBigDecimal("monto");
                Date fecha = rs.getDate("fecha");
                System.out.println("ID: " + id + ", Cliente ID: " + clienteId + ", Monto: " + monto + ", Fecha: " + fecha);
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
