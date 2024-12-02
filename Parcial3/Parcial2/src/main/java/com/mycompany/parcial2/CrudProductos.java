/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.parcial2;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import org.bson.Document;

/**
 *
 * @author Sergi
 */
public class CrudProductos {

    private static MongoCollection<Document> coleccion = ConexionMongoDb.conectar().getCollection("productos");

    public static void crearProducto(String nombre, double precio) {
        Document producto = new Document("nombre", nombre).append("precio", precio);
        coleccion.insertOne(producto);
        System.out.println("producto insertado: " + producto.toJson());
    }

    public static void leerProductos() {
        coleccion.find().forEach(producto -> System.out.println(producto.toJson()));
    }

    public static void actualizarProducto(String nombre, double nuevoPrecio) {
        coleccion.updateOne(new Document("nombre", nombre),
                new Document("$set", new Document("precio", nuevoPrecio)));
        System.out.println("Producto actualizado");
    }

    public static void eliminarProducto(String nombre) {
        coleccion.deleteOne(new Document("nombre", nombre));
        System.out.println("Producto eliminado");
    }

    public static void obtenerProductosConPrecioMayorA20() {
        Document filtro = new Document("precio", new Document("$gt", 20));
        MongoCursor<Document> cursor = coleccion.find(filtro).iterator();
        System.out.println("productos con precio mayor a 20 dolares:");
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
    }

}
