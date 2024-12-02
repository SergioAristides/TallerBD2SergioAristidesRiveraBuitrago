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
public class CrudDetallePedido {
        private static MongoCollection<Document> coleccion = ConexionMongoDb.conectar().getCollection("detalle_pedidos");

    // Crear un detalle de pedido
    public static void crearDetallePedido(String pedidoId, String productoId, int cantidad) {
        Document detalle = new Document("pedidoId", pedidoId)
                            .append("productoId", productoId)
                            .append("cantidad", cantidad);
        coleccion.insertOne(detalle);
        System.out.println("Detalle de pedido insertado: " + detalle.toJson());
    }

    // Leer detalles de pedido
    public static void leerDetallesPedidos() {
        coleccion.find().forEach(detalle -> System.out.println(detalle.toJson()));
    }

    // Actualizar detalle de pedido
    public static void actualizarDetallePedido(String pedidoId, String productoId, int nuevaCantidad) {
        coleccion.updateOne(new Document("pedidoId", pedidoId).append("productoId", productoId),
                            new Document("$set", new Document("cantidad", nuevaCantidad)));
        System.out.println("Detalle de pedido actualizado");
    }

    // Eliminar detalle de pedido
    public static void eliminarDetallePedido(String pedidoId, String productoId) {
        coleccion.deleteOne(new Document("pedidoId", pedidoId).append("productoId", productoId));
        System.out.println("Detalle de pedido eliminado");
    }
    
        public static void obtenerPedidosConProducto010() {
        // Consulta para buscar el producto "producto010"
        Document filtro = new Document("productoId", "producto010");
        MongoCursor<Document> cursor = coleccion.find(filtro).iterator();
        System.out.println("Pedidos con el producto 'producto010':");
        while (cursor.hasNext()) {
            System.out.println(cursor.next().toJson());
        }
    }
}
