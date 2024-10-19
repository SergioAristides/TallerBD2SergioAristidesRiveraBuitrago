/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package taller15xml;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.*;


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

public void saveBook(String isbn, String title, int authorId, int year, int stock, boolean isLent, String state) {
    try {
        Class.forName(this.forName);
        Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

        CallableStatement stmt = conn.prepareCall(" call xmlt.guardar_libro(?, ?, ?, ?, ?, ?, ?)");
        stmt.setString(1, isbn);
        stmt.setString(2, title);
        stmt.setInt(3, authorId);
        stmt.setInt(4, year);
        stmt.setInt(5, stock);
        stmt.setBoolean(6, isLent);
        stmt.setString(7, state);

        stmt.execute(); 
        stmt.close();
        conn.close();

        System.out.println("Libro guardado exitosamente");
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    }
}

    public void updateBook(String isbn, String title, int authorId, int year, int stock, boolean isLent, String state) {
        try {
            Class.forName(this.forName);
            Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

            CallableStatement stmt = conn.prepareCall("call xmlt.actualizar_libro(?, ?, ?, ?, ?, ?, ?)");
            stmt.setString(1, isbn);
            stmt.setString(2, title);
            stmt.setInt(3, authorId);
            stmt.setInt(4, year);
            stmt.setInt(5, stock);
            stmt.setBoolean(6, isLent);
            stmt.setString(7, state);

            stmt.execute();
            stmt.close();
            conn.close();
            
            System.out.println("Libro actualizado con exito");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

public void getAuthorByIsbn(String isbn) {
    try {
        Class.forName(this.forName); 
        Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

        String sql = "SELECT xmlt.obtener_autor_libro_por_isbne(?)";
        PreparedStatement stmt = conn.prepareStatement(sql);

        stmt.setString(1, isbn);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            SQLXML sqlxml = rs.getSQLXML(1);
            String authorXml = sqlxml.getString();
            System.out.println("Autor del libro con ISBN " + isbn + ": \n" + authorXml);
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    }
}
public void getBooksByYear(int year) {
    try {
        // Cargar el driver JDBC
        Class.forName(this.forName);
        Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

        String sql = "SELECT * FROM xmlt.obtener_libro_por_anios(?)";
        PreparedStatement stmt = conn.prepareStatement(sql);

        stmt.setInt(1, year);

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            SQLXML sqlxml = rs.getSQLXML(1);  
            String bookXml = sqlxml.getString();
            System.out.println("Libro: \n" + bookXml);
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    }
}


    public void getAuthorByTitle(String title) {
 try {
        Class.forName(this.forName); 
        Connection conn = DriverManager.getConnection(this.url, this.user, this.password);

        String sql = "SELECT xmlt.obtener_autor_libro_por_titulo(?)";
        PreparedStatement stmt = conn.prepareStatement(sql);

        stmt.setString(1, title);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            SQLXML sqlxml = rs.getSQLXML(1);
            String authorXml = sqlxml.getString();
            System.out.println("Autor del libro con Titulo " + title + ": \n" + authorXml);
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    }
}
    
}
