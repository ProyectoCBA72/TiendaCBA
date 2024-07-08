// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/CardsPedidosClase.dart';
import 'package:tienda_app/constantsDesign.dart';

// Clase que representa una tarjeta de pedidos del usuario en el dashboard.
class CardPedidoUsuario extends StatelessWidget {
  const CardPedidoUsuario({
    super.key,
    required this.info,
  });

  // Información del pedido para mostrar en la tarjeta.
  final PedidoCardClase info;

  @override
  Widget build(BuildContext context) {
    // Retorna un contenedor que muestra la información del pedido.
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: Color(0xFFFF2F0F2),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.asset(
                  info.svgSrc!,
                  colorFilter: ColorFilter.mode(
                      info.color ?? Colors.black, BlendMode.srcIn),
                ),
              ),
              // Icono de más opciones.
              const Icon(
                Icons.more_vert,
                color: primaryColor,
              ),
            ],
          ),
          // Título del pedido.
          Flexible(
            child: Text(
              info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Línea de progreso
          ProgressLine(
            color: info.color,
            percentage: info.percentage,
          ),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: primaryColor),
              ),
              Text(
                info.totalReservas!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: primaryColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Widget que muestra una línea de progreso con un color y porcentaje dado.
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    this.color = primaryColor,
    required this.percentage,
  });

  // Color de la línea de progreso.
  final Color? color;
  // Porcentaje completado de la línea de progreso.
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    // Retorna una pila de contenedores que representan la línea de progreso.
    return Stack(
      children: [
        // Fondo de la línea de progreso.
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        // Contenedor de progreso actual.
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
