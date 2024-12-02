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
public class CrudPedidos {

    private static MongoCollection<Document> coleccion = ConexionMongoDb.conectar().getCollection("pedidos");

    public static void crearPedido(String cliente, String fecha ,String estado ,double total) {
        Document pedido = new Document("cliente", cliente).append("fecha", fecha)
                .append("estado", estado).append("total", total);
        coleccion.insertOne(pedido);
        System.out.println("Pedido insertado: " + pedido.toJson());
    }

    public static void leerPedidos() {
        coleccion.find().forEach(pedido -> System.out.println(pedido.toJson()));
    }

    public static void actualizarPedido(String cliente, String nuevaFecha) {
        coleccion.updateOne(new Document("cliente", cliente),
                new Document("$set", new Document("fecha", nuevaFecha)));
        System.out.println("Pedido actualizado");
    }

    public static void eliminarPedido(String cliente) {
        coleccion.deleteOne(new Document("cliente", cliente));
        System.out.println("Pedido eliminado");
    }

    public static void obtenerPedidosConTotalMayorA100() {
        Document filtro = new Document("total", new Document("$gt", 100));
        MongoCursor<Document> cursor = coleccion.find(filtro).iterator();
        System.out.println("Pedidos con total mayor a 100 dólares:");
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
    }

}
