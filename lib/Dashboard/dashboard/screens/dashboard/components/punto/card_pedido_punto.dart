// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/CardsPedidosClase.dart';
import 'package:tienda_app/constantsDesign.dart';

// Diseño de la tarjeta para mostrar el conteo de pedidos en la parte superior del dashboard

class CardPedidoPunto extends StatelessWidget {
  const CardPedidoPunto({
    super.key,
    required this.info,
  });

  final PedidoCardClase info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
          defaultPadding), // Padding interior de la tarjeta
      decoration: const BoxDecoration(
        color: Color(0xFFFF2F0F2), // Color de fondo de la tarjeta
        borderRadius: BorderRadius.all(
            Radius.circular(10)), // Borde redondeado de la tarjeta
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Fila superior de la tarjeta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Contenedor para el ícono SVG
              Container(
                padding: const EdgeInsets.all(
                    defaultPadding * 0.75), // Padding del contenedor del ícono
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1), // Color del ícono
                  borderRadius: const BorderRadius.all(Radius.circular(
                      10)), // Borde redondeado del contenedor del ícono
                ),
                child: SvgPicture.asset(
                  info.svgSrc!, // Ruta del archivo SVG del ícono
                  colorFilter: ColorFilter.mode(info.color ?? Colors.black,
                      BlendMode.srcIn), // Filtro de color del ícono
                ),
              ),
              // Icono de más opciones
              const Icon(
                Icons.more_vert,
                color: primaryColor, // Color del icono de más opciones
              ),
            ],
          ),
          // Título de la tarjeta
          Flexible(
            child: Text(
              info.title!, // Título de la tarjeta
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Línea de progreso
          ProgressLine(
            color: info.color, // Color de la línea de progreso
            percentage: info.percentage, // Porcentaje de progreso
          ),
          // Fila inferior con el total de pedidos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Texto "Total:"
              Text(
                "Total:",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: primaryColor), // Estilo del texto "Total:"
              ),
              // Valor del total de pedidos
              Text(
                info.totalPedidos!, // Valor del total de pedidos
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color:
                        primaryColor), // Estilo del valor del total de pedidos
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Widget para dibujar la línea de progreso
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    this.color =
        primaryColor, // Color de la línea de progreso (por defecto primaryColor)
    required this.percentage, // Porcentaje de progreso (requerido)
  });

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenedor base de la línea de fondo
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1), // Color de fondo de la línea
            borderRadius:
                const BorderRadius.all(Radius.circular(10)), // Borde redondeado
          ),
        ),
        // Contenedor de la línea de progreso
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth *
                (percentage! / 100), // Ancho proporcional al porcentaje
            height: 5,
            decoration: BoxDecoration(
              color: color, // Color de la línea de progreso
              borderRadius: const BorderRadius.all(
                  Radius.circular(10)), // Borde redondeado
            ),
          ),
        ),
      ],
    );
  }
}
