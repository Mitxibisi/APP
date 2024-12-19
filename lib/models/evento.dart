import 'package:flutter/material.dart';

class Evento {
  final String titulo;
  final Color color;
  final String tipoJornada;
  final int horaInicio;
  final int minutoInicio;
  final int horaFin;
  final int minutoFin;

  Evento(
    this.titulo,
    this.color,
    this.tipoJornada, {
    this.horaInicio = 0,
    this.minutoInicio = 0,
    this.horaFin = 0,
    this.minutoFin = 0,
  });

  int get horasTrabajadas {
    if (tipoJornada == 'Partido' || tipoJornada == 'Mañana' || tipoJornada == 'Tarde') {
      final totalMinutos = (horaFin * 60 + minutoFin) - (horaInicio * 60 + minutoInicio);
      return totalMinutos >= 0 ? totalMinutos ~/ 60 : 0;
    }
    return 0;
  }
}