/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package taller11queryinvocation;

/**
 *
 * @author Sergi
 */
public class Taller11QueryInvocation {

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
        
        Generic oracleGeneric = new Generic(
                "oracle.jdbc.driver.OracleDriver",
                "jdbc:oracle:thin:@localhost:1521:xe", 
                "system", 
                "s1234" 
        );    
        generic.getEmployeePayroll("123123123");
        generic.GetTotalByContract();
        
         java.util.Date startDate = new java.util.Date();
        java.util.Date endDate = new java.util.Date(); 
        oracleGeneric.generateAudit(startDate, endDate); 
        oracleGeneric.simulateSalesMonth(); //
    }
    
    
        
            
}
