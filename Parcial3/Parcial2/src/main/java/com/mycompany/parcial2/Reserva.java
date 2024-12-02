/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.parcial2;

/**
 *
 * @author Sergi
 */
public class Reserva {

    private String id;
    private Cliente cliente;
    private Habitacion habitacion;
    private String fechaEntrada;
    private String fechaSalida;
    private double total;
    private String estadoPago;
    private String metodoPago;
    private String fechaReserva;

    public Reserva(String id, Cliente cliente, Habitacion habitacion, String fechaEntrada, String fechaSalida,
            double total, String estadoPago, String metodoPago, String fechaReserva) {
        this.id = id;
        this.cliente = cliente;
        this.habitacion = habitacion;
        this.fechaEntrada = fechaEntrada;
        this.fechaSalida = fechaSalida;
        this.total = total;
        this.estadoPago = estadoPago;
        this.metodoPago = metodoPago;
        this.fechaReserva = fechaReserva;
    }

    public String getId() {
        return id;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public Habitacion getHabitacion() {
        return habitacion;
    }

    public String getFechaEntrada() {
        return fechaEntrada;
    }

    public String getFechaSalida() {
        return fechaSalida;
    }

    public double getTotal() {
        return total;
    }

    public String getEstadoPago() {
        return estadoPago;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public String getFechaReserva() {
        return fechaReserva;
    }
}
