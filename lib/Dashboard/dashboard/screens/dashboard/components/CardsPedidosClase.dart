// ignore_for_file: file_names

import 'package:flutter/material.dart';

/// Clase que representa un card de pedidos.
///
/// Esta clase se utiliza para almacenar información relevante sobre un card
/// de pedidos. Incluye propiedades como la ruta de la imagen SVG, el título,
/// el total de pedidos y el porcentaje de avance.
class PedidoCardClase {
  /// Ruta de la imagen SVG.
  ///
  /// Es una [String] opcional.
  final String? svgSrc;

  /// Título del card.
  ///
  /// Es una [String] opcional.
  final String? title;

  /// Total de pedidos.
  ///
  /// Es una [String] opcional.
  final String? totalPedidos;

  /// Porcentaje de avance.
  ///
  /// Es un [int] opcional.
  final int? percentage;

  /// Color del card.
  ///
  /// Es un [Color] opcional.
  final Color? color;

  /// Crea una instancia de [PedidoCardClase].
  ///
  /// Los parámetros se pueden omitir.
  PedidoCardClase({
    this.svgSrc,
    this.title,
    this.totalPedidos,
    this.percentage,
    this.color,
  });
}
