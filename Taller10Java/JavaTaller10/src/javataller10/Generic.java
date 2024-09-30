/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javataller10;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.ResultSet;


/**
 *
 * @author Sergi
 */
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

    public void generateAudit(Date start, Date end) {
        try {
            Class.forName(this.forName);

            Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

            CallableStatement stmt = conn.prepareCall("call inventario.generar_auditoria(?, ?)");

            stmt.setDate(1, start);
            stmt.setDate(2, end);

            stmt.execute();
            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public void simulateSalesMonth() {

        try {
            Class.forName(this.forName);

            Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

            CallableStatement stmt = conn.prepareCall("call inventario.simular_ventas_mes()");

            stmt.execute();
            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

    }

    public void unpaidServicesMonth(int month) {
        try {
            Class.forName(this.forName);

            Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

            CallableStatement stmt = conn.prepareCall("{? = call taller6.servicios_no_pagados_mes(?)}");

            stmt.registerOutParameter(1, java.sql.Types.DECIMAL);

            stmt.setInt(2, month);

            stmt.execute();

            BigDecimal totalNoPagadoBigDecimal = stmt.getBigDecimal(1);
            double totalNoPagado = totalNoPagadoBigDecimal != null ? totalNoPagadoBigDecimal.doubleValue() : 0.0;
            System.out.println("Total no pagado for month " + month + ": " + totalNoPagado);

            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

    }

    public void transactionsPerMonth(int month, String identificacion) {
        try {
            Class.forName(this.forName);

            Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

            CallableStatement stmt = conn.prepareCall("{? = call taller6.transacciones_total_mes(?, ?)}");

            stmt.registerOutParameter(1, java.sql.Types.DECIMAL);

            stmt.setInt(2, month);
            stmt.setString(3, identificacion);

            stmt.execute();

            BigDecimal totalPagoBigDecimal = stmt.getBigDecimal(1);
            double totalPago = totalPagoBigDecimal != null ? totalPagoBigDecimal.doubleValue() : 0.0;
            System.out.println("Total de transacciones para el mes " + month + " con identificación " + identificacion + ": " + totalPago);

            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

public void unpaidServicesMonthQuery(int month) {
    try {
        Class.forName(this.forName);

        Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

        CallableStatement stmt = conn.prepareCall("{ call taller6.servicios_no_pagados_mes_query(?) }");
        
        stmt.setInt(1, month);

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int clienteId = rs.getInt("cliente_id");
            int servicioId = rs.getInt("servicio_id");
            BigDecimal monto = rs.getBigDecimal("monto");

            System.out.println("Cliente ID: " + clienteId + ", Servicio ID: " + servicioId + ", Monto: " + monto);
        }

        rs.close();
        stmt.close();
        conn.close();

    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    }
}


}
