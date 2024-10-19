/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package taller15xml;

/**
 *
 * @author Sergi
 */
public class Taller15XML {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        
         Generic db = new Generic(
                "org.postgresql.Driver", 
                "jdbc:postgresql://localhost:5432/postgres", 
                "postgres", 
                "1234");

        db.saveBook("123B123456", "El moje que vendio su ferrari 2", 2, 2008, 60, false, "disponible");
        db.updateBook("123B123456", "El moje que vendio su ferrari 2", 2, 2007, 59, false, "disponible");
        db.getAuthorByIsbn("123B123456");
        db.getBooksByYear(1988);
        db.getAuthorByTitle("El monje que vendio su ferrari 1");
    }
    
}
