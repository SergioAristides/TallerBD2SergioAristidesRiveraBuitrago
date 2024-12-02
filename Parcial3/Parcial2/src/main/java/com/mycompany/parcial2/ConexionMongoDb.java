/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.parcial2;
import com.mongodb.ConnectionString;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;


/**
 *
 * @author Sergi
 */


public class ConexionMongoDb {
    public static MongoDatabase conectar() {
        // Usa la clase ConnectionString para definir la URI
        ConnectionString connectionString = new ConnectionString("mongodb://localhost:27017");
        // Crea el cliente usando MongoClients
        MongoClient mongoClient = MongoClients.create(connectionString);
        // Devuelve la base de datos
        return mongoClient.getDatabase("productos"); // Cambia "productos" por el nombre de tu base de datos
    }
}
