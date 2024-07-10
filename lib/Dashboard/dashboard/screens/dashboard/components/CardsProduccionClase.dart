// ignore_for_file: file_names

import 'package:flutter/material.dart';

/// Clase que representa un objeto para construir una tarjeta de producción.
///
/// Esta clase tiene los siguientes atributos:
/// - [svgSrc]: La ruta de la imagen SVG a mostrar en la tarjeta.
/// - [title]: El título a mostrar en la tarjeta.
/// - [totalReservas]: La cantidad total de reservas en la tarjeta.
/// - [percentage]: El porcentaje que representa la cantidad de reservas.
/// - [color]: El color de la tarjeta.
class ProduccionCardClase {
  /// Ruta de la imagen SVG a mostrar en la tarjeta.
  final String? svgSrc;

  /// Título a mostrar en la tarjeta.
  final String? title;

  /// Cantidad total de reservas en la tarjeta.
  final String? totalReservas;

  /// Porcentaje que representa la cantidad de reservas.
  final int? percentage;

  /// Color de la tarjeta.
  final Color? color;

  /// Constructor para crear una instancia de [ProduccionCardClase].
  ///
  /// Los parámetros son opcionales y se pueden pasar los valores correspondientes.
  ProduccionCardClase({
    this.svgSrc,
    this.title,
    this.totalReservas,
    this.percentage,
    this.color,
  });
}
