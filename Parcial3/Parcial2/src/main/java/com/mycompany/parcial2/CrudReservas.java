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
public class CrudReservas {
    

    private static MongoCollection<Document> coleccion = ConexionMongoDb.conectar().getCollection("reservas");

    public static void crearReserva(Reserva reserva) {
        Document reservaDoc = new Document("_id", reserva.getId())
                .append("cliente", new Document("nombre", reserva.getCliente().getNombre())
                        .append("correo", reserva.getCliente().getCorreo())
                        .append("telefono", reserva.getCliente().getTelefono())
                        .append("direccion", reserva.getCliente().getDireccion()))
                .append("habitacion", new Document("tipo", reserva.getHabitacion().getTipo())
                        .append("numero", reserva.getHabitacion().getNumero())
                        .append("precio_noche", reserva.getHabitacion().getPrecioNoche())
                        .append("capacidad", reserva.getHabitacion().getCapacidad())
                        .append("descripcion", reserva.getHabitacion().getDescripcion()))
                .append("fecha_entrada", reserva.getFechaEntrada())
                .append("fecha_salida", reserva.getFechaSalida())
                .append("total", reserva.getTotal())
                .append("estado_pago", reserva.getEstadoPago())
                .append("metodo_pago", reserva.getMetodoPago())
                .append("fecha_reserva", reserva.getFechaReserva());
        coleccion.insertOne(reservaDoc);
        System.out.println("Reserva insertada: " + reservaDoc.toJson());
    }

    public static void leerReservas() {
        coleccion.find().forEach(reserva -> System.out.println(reserva.toJson()));
    }

    public static void actualizarReserva(String idReserva, String campo, Object nuevoValor) {
        coleccion.updateOne(new Document("_id", idReserva), new Document("$set", new Document(campo, nuevoValor)));
        System.out.println("reserva actualizada con id = " + idReserva);
    }

    public static void eliminarReserva(String idReserva) {
        coleccion.deleteOne(new Document("_id", idReserva));
        System.out.println("Reserva eliminada con id : " + idReserva);
    }
    
    public static void obtenerHabitacionesDeTipo(String tipoHabitacion) {
    Document filtro = new Document("habitacion.tipo", tipoHabitacion);
    MongoCursor<Document> cursor = coleccion.find(filtro).iterator();

    System.out.println("habitaciones reservadas de tipo " + tipoHabitacion +":");
    while (cursor.hasNext()) {
        Document reserva = cursor.next();
        System.out.println(reserva.toJson());
    }
}
    
    public static void obtenerReservasConPrecioNocheMayorA(double precio) {
    Document filtro = new Document("habitacion.precio_noche", new Document("$gt", precio));
    MongoCursor<Document> cursor = coleccion.find(filtro).iterator();

    System.out.println("Reservas de habitaciones con precio por noche mayor a $" + precio + ":");
    while (cursor.hasNext()) {
        Document reserva = cursor.next();
        System.out.println(reserva.toJson());
    }
}


    
}
