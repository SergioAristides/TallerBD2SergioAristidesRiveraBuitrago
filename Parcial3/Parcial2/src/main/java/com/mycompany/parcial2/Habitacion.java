/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.parcial2;

/**
 *
 * @author Sergi
 */
public class Habitacion {

    private String tipo;
    private int numero;
    private double precioNoche;
    private int capacidad;
    private String descripcion;

    public Habitacion(String tipo, int numero, double precioNoche, int capacidad, String descripcion) {
        this.tipo = tipo;
        this.numero = numero;
        this.precioNoche = precioNoche;
        this.capacidad = capacidad;
        this.descripcion = descripcion;
    }

    public String getTipo() {
        return tipo;
    }

    public int getNumero() {
        return numero;
    }

    public double getPrecioNoche() {
        return precioNoche;
    }

    public int getCapacidad() {
        return capacidad;
    }

    public String getDescripcion() {
        return descripcion;
    }
}

    
