// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/CardsPedidosClase.dart';
import 'package:tienda_app/constantsDesign.dart';

// Diseño de la card del conteo de las reservas las cuales estaran ubicadas en la parte superior de los dashboard

/// Widget para mostrar una tarjeta de pedidos líder en el dashboard.
///
/// Muestra información sobre el liderazgo de pedidos, incluyendo el ícono,
/// el título, la línea de progreso y el total de reservas.
class CardPedidoLider extends StatelessWidget {
  const CardPedidoLider({
    super.key,
    required this.info,
  });

  final PedidoCardClase info;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(defaultPadding), // Espaciado interno constante para el contenedor
      decoration: const BoxDecoration(
        color: Color(0xFFFF2F0F2), // Color de fondo constante
        borderRadius: BorderRadius.all(Radius.circular(10)), // Borde redondeado constante
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75), // Espaciado interno para el ícono
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1), // Color de fondo con opacidad
                  borderRadius: const BorderRadius.all(Radius.circular(10)), // Borde redondeado constante
                ),
                child: SvgPicture.asset(
                  info.svgSrc!, // SVG del ícono
                  colorFilter: ColorFilter.mode(
                      info.color ?? Colors.black, BlendMode.srcIn), // Filtro de color para el ícono
                ),
              ),
              const Icon(Icons.more_vert, color: primaryColor,), // Ícono de menú desplegable constante
            ],
          ),
          Flexible(
            child: Text(
              info.title!, // Título dinámico
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ProgressLine(
            color: info.color, // Color de la línea de progreso
            percentage: info.percentage, // Porcentaje de la línea de progreso
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:", // Texto estático
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: primaryColor), // Estilo de texto con color primario
              ),
              Text(
                info.totalReservas!, // Total de reservas dinámico
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: primaryColor), // Estilo de texto con color primario
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// Widget que muestra una línea de progreso con un color específico y un porcentaje dado.
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    this.color = primaryColor, // Color por defecto para la línea de progreso
    required this.percentage, // Porcentaje requerido para la línea de progreso
  });

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity, // Ancho total del contenedor
          height: 5, // Altura constante de la línea de progreso
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1), // Color de fondo con opacidad
            borderRadius: const BorderRadius.all(Radius.circular(10)), // Borde redondeado constante
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100), // Ancho proporcional al porcentaje
            height: 5, // Altura constante de la línea de progreso
            decoration: BoxDecoration(
              color: color, // Color de la línea de progreso
              borderRadius: const BorderRadius.all(Radius.circular(10)), // Borde redondeado constante
            ),
          ),
        ),
      ],
    );
  }
}

