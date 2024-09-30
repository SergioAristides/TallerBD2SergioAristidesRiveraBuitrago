/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package javataller10;
import java.sql.Date;


/**
 *
 * @author Sergi
 */
public class JavaTaller10 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        
        Generic generic = new Generic(
                "org.postgresql.Driver", 
                "jdbc:postgresql://localhost:5432/postgres",
                "postgres", 
                "1234");
        
        Date start = Date.valueOf("2024-01-01");
        Date end = Date.valueOf("2024-09-30");
        
        generic.generateAudit(start,end);
        generic.simulateSalesMonth();
        generic.unpaidServicesMonth(9);
        generic.transactionsPerMonth(9, "id00001");
        
        //adicional retornado una Query en la funcion
        generic.unpaidServicesMonthQuery(9);
    }
    
}
