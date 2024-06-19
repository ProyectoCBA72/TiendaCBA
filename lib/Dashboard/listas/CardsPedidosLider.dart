// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';

class PedidoLider {
  final String? svgSrc, title, totalReservas;
  final int? percentage;
  final Color? color;

  PedidoLider({
    this.svgSrc,
    this.title,
    this.totalReservas,
    this.percentage,
    this.color,
  });
}

List demoPedidoLider = [
  PedidoLider(
    title: "Pedidos",
    svgSrc: "assets/icons/pedido.svg",
    totalReservas: "13",
    color: primaryColor,
    percentage: 13,
  ),
  PedidoLider(
    title: "Entregados",
    svgSrc: "assets/icons/check.svg",
    totalReservas: "6",
    color: Colors.green,
    percentage: 6,
  ),
  PedidoLider(
    title: "Cancelados",
    svgSrc: "assets/icons/cancel.svg",
    totalReservas: "4",
    color: Colors.red,
    percentage: 4,
  ),
  PedidoLider(
    title: "Pendientes",
    svgSrc: "assets/icons/pendiente.svg",
    totalReservas: "3",
    color: const Color(0xFF007EE5),
    percentage: 3,
  ),
];
