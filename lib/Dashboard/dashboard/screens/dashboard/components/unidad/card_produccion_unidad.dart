// ignore_for_file: use_full_hex_values_for_flutter_colors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/CardsProduccionClase.dart';
import 'package:tienda_app/constantsDesign.dart';

// Widget que representa una tarjeta de producción para una unidad específica.
class CardProduccionUnidad extends StatelessWidget {
  const CardProduccionUnidad({
    super.key,
    required this.info,
  });

  final ProduccionCardClase info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
          defaultPadding), // Padding interior de la tarjeta
      decoration: const BoxDecoration(
        color: Color(0xFFFF2F0F2), // Color de fondo de la tarjeta (rosa)
        borderRadius:
            BorderRadius.all(Radius.circular(10)), // Bordes redondeados
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
                  color: info.color!.withOpacity(
                      0.1), // Color de fondo del contenedor del ícono
                  borderRadius: const BorderRadius.all(
                      Radius.circular(10)), // Bordes redondeados del contenedor
                ),
                child: SvgPicture.asset(
                  info.svgSrc!, // Ruta del archivo SVG
                  colorFilter: ColorFilter.mode(info.color ?? Colors.black,
                      BlendMode.srcIn), // Filtro de color del ícono SVG
                ),
              ),
              const Icon(
                Icons.more_vert,
                color: primaryColor,
              ), // Icono de opciones verticales
            ],
          ),
          Flexible(
            child: Text(
              info.title!, // Título de la tarjeta
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Línea de progreso dentro de la tarjeta
          ProgressLine(
            color: info.color, // Color del indicador de progreso
            percentage: info.percentage, // Porcentaje de progreso
          ),
          // Fila inferior de la tarjeta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:", // Etiqueta de texto para el total
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: primaryColor), // Estilo de texto con color primario
              ),
              Text(
                info.totalReservas!, // Total de reservas mostrado
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: primaryColor), // Estilo de texto con color primario
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Widget que representa una línea de progreso dentro de la tarjeta de producción.
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color; // Color de la línea de progreso
  final int? percentage; // Porcentaje de progreso

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo de la línea de progreso
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1), // Color del fondo con opacidad
            borderRadius: const BorderRadius.all(
                Radius.circular(10)), // Bordes redondeados
          ),
        ),
        // Línea de progreso actual
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth *
                (percentage! / 100), // Ancho proporcional al porcentaje
            height: 5,
            decoration: BoxDecoration(
              color: color, // Color de la línea de progreso
              borderRadius: const BorderRadius.all(
                  Radius.circular(10)), // Bordes redondeados
            ),
          ),
        ),
      ],
    );
  }
}
