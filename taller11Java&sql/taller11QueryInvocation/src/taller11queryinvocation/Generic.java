/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package taller11queryinvocation;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

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

    //llamar CREATE OR REPLACE FUNCTION obtener_query_nomina_empleado(empleado_id INT)
public void getEmployeePayroll(String empleadoIdentificacion) {
    try {
        Class.forName(this.forName);
        Connection conn = DriverManager.getConnection(this.url, this.user, this.password);
        
        // Cambiar a usar un VARCHAR en la llamada
        CallableStatement stmt = conn.prepareCall("{ call query.obtener_nomina_empleado(?) }");
        stmt.setString(1, empleadoIdentificacion);  // Pasar el ID como String
        
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            String nombre = rs.getString("nombre");
            int mes = rs.getInt("mes");
            int año = rs.getInt("año");
            Date fechaPago = rs.getDate("fecha_pago");
            BigDecimal totalDevengado = rs.getBigDecimal("total_devengado");
            BigDecimal totalDeducciones = rs.getBigDecimal("total_deducciones");
            BigDecimal total = rs.getBigDecimal("total");
            
            System.out.println("Nombre: " + nombre + ", Mes: " + mes + ", Año: " + año + 
                ", Fecha de Pago: " + fechaPago + ", Total Devengado: " + totalDevengado + 
                ", Total Deducciones: " + totalDeducciones + ", Total: " + total);
        }
        
        System.out.println("|-------------------------------------------------------|");
        rs.close();
        stmt.close();
        conn.close();
        
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    }
}


public void GetTotalByContract() {
    try {
        Class.forName(this.forName);

        Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

        CallableStatement stmt = conn.prepareCall("{ call query.obtener_total_por_contrato() }");

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            String descripcion = rs.getString("descripcion");
            BigDecimal totalNomina = rs.getBigDecimal("total_nomina");

            System.out.println("Descripción: " + descripcion + ", Total Nómina: " + totalNomina);
        }

        // Cerrar los recursos
        rs.close();
        stmt.close();
        conn.close();

    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    }
}



public void generateAudit(java.util.Date start, java.util.Date end) {
        try {
            Class.forName(this.forName);
            try (Connection conn = DriverManager.getConnection(this.url, this.user, this.password);
                 CallableStatement stmt = conn.prepareCall("call generar_auditoria(?, ?)")) {
                
                // Convertir java.util.Date a java.sql.Date
                stmt.setDate(1, new Date(start.getTime()));
                stmt.setDate(2, new Date(end.getTime()));
                
                stmt.execute();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public void simulateSalesMonth() {
        try {
            Class.forName(this.forName);
            try (Connection conn = DriverManager.getConnection(this.url, this.user, this.password);
                 CallableStatement stmt = conn.prepareCall("call simular_ventas_mes()")) {
                
                stmt.execute();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }




}
