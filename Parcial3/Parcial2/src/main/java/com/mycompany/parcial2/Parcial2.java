/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */
package com.mycompany.parcial2;

/**
 *
 * @author Sergi
 */
public class Parcial2 {

    public static void main(String[] args) {
        
        //primera pregunta
        CrudProductos.crearProducto("Laptop", 1200.50);
        CrudProductos.crearProducto("Mouse", 25.99);
        CrudProductos.leerProductos();
        CrudProductos.actualizarProducto("Mouse", 30.99);
        CrudProductos.leerProductos();
        CrudProductos.eliminarProducto("Mouse");
        CrudProductos.leerProductos();

        CrudPedidos.crearPedido("Sergio Aristides", "2024-12-02","enviado",60.87);
        CrudPedidos.crearPedido("Valentina lopez", "2024-12-03","enviado",88.87);
        CrudPedidos.leerPedidos();
        CrudPedidos.actualizarPedido("Santiago", "2024-12-04");
        CrudPedidos.leerPedidos();
        CrudPedidos.eliminarPedido("Mariana");
        CrudPedidos.leerPedidos();

        CrudDetallePedido.crearDetallePedido("1", "Laptop", 2);
        CrudDetallePedido.crearDetallePedido("1", "Mouse", 1);
        CrudDetallePedido.leerDetallesPedidos();
        CrudDetallePedido.actualizarDetallePedido("1", "Laptop", 3);
        CrudDetallePedido.leerDetallesPedidos();
        CrudDetallePedido.eliminarDetallePedido("1", "Mouse");

        CrudDetallePedido.leerDetallesPedidos();
       //primera pregunta
       
       //Segunda pregunta
        CrudProductos.obtenerProductosConPrecioMayorA20();
        CrudPedidos.obtenerPedidosConTotalMayorA100();
        CrudDetallePedido.obtenerPedidosConProducto010();
       //Segunda pregunta


       //Tercera pregunta
        Cliente cliente = new Cliente("Carlitos", "carlos@gmail.com", "307864732",
                "calle 14  76-56 ");

        Habitacion habitacion = new Habitacion("doble", 101, 200.00, 2,
                "habitacion doble matrimonial para dos personas.");

        Reserva reserva = new Reserva("reserva001", cliente, habitacion,
                "2024-12-10", "2024-12-11",
                740.00, "Pagado", "Tarjeta de Credito", "2024-11-30");

        CrudReservas.crearReserva(reserva);

        CrudReservas.leerReservas();

        CrudReservas.actualizarReserva("reserva001", "estado_pago", "Pendiente");

        CrudReservas.eliminarReserva("reserva001");
        
        //Tercera pregunta

        
        //Cuarta pregunta
        CrudReservas.obtenerReservasConPrecioNocheMayorA(100);
        CrudReservas.obtenerHabitacionesDeTipo("doble");
        //Cuarta pregunta



    }
}
