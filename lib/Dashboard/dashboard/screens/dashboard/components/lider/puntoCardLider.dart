// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Widget que representa una tarjeta de un punto de venta en la interfaz del lider.
///
/// Esta clase extiende [StatefulWidget] y tiene un parámetro obligatorio:
/// [puntoVenta] que representa la información del punto de venta.
class CardPuntoLider extends StatefulWidget {
  /// Información del punto de venta.
  final PuntoVentaModel puntoVenta;

  /// Constructor del widget [CardPuntoLider].
  ///
  /// El parámetro [puntoVenta] es obligatorio y representa la información del punto de venta.
  const CardPuntoLider({
    super.key,
    required this.puntoVenta,
  });

  @override
  // ignore: library_private_types_in_public_api
  State<CardPuntoLider> createState() => _CardPuntoLiderState();
}

/// Estado de la clase `CardPuntoLider`.
/// Esta clase se encarga de construir el widget de la tarjeta de un punto de venta.
class _CardPuntoLiderState extends State<CardPuntoLider> {
  @override
  Widget build(BuildContext context) {
    final puntoVenta = widget
        .puntoVenta; // Se obtiene el punto de venta desde el widget padre.
    return Container(
      width: 250, // Ancho de la tarjeta
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color:
                Colors.grey.withOpacity(0.5), // Color de la sombra con opacidad
            spreadRadius: 2, // Radio de expansión de la sombra
            blurRadius: 5, // Radio de desenfoque de la sombra
            offset: const Offset(0, 2), // Posición de la sombra
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Dirección del scroll
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Alineación horizontal
          children: [
            // Nombre del punto de venta
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 13,
                bottom: 8,
              ),
              child: Text(
                puntoVenta.nombre,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Calibri-Bold',
                ),
              ),
            ),
            // Ubicación del punto de venta
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Icon(
                      Icons.location_on,
                      size: 30,
                      color: botonOscuro, // Color del icono
                    ),
                  ),
                  const SizedBox(
                    width: 15, // Espacio entre el icono y el texto
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Alineación horizontal dentro de la columna
                      children: [
                        const Text(
                          "Ubicacioón: ", // Etiqueta de ubicación
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            fontFamily: 'Calibri-Bold',
                          ),
                        ),
                        Text(
                          puntoVenta.ubicacion, // Valor de la ubicación
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                            fontFamily: 'Calibri-Bold',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Estado del punto de venta
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Icon(
                      puntoVenta.estado
                          ? Icons
                              .check_circle_outline // Icono para estado activo
                          : Icons.cancel_outlined, // Icono para estado inactivo
                      size: 30,
                      color: botonOscuro, // Color del icono
                    ),
                  ),
                  const SizedBox(
                    width: 15, // Espacio entre el icono y el texto
                  ),
                  const Text(
                    "Estado: ", // Etiqueta de estado
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Calibri-Bold',
                    ),
                  ),
                  Text(
                    puntoVenta.estado
                        ? "Activo"
                        : "Inactivo", // Valor del estado
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontFamily: 'Calibri-Bold',
                    ),
                  ),
                ],
              ),
            ),
            // Botones de editar y eliminar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Alineación horizontal de los botones
                children: [
                  // Botón de editar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          20), // Bordes redondeados del contenedor
                      boxShadow: const [
                        BoxShadow(
                          color: primaryColor, // Color de la sombra
                          offset: Offset(
                            2.0,
                            2.0,
                          ),
                          blurRadius: 3.0,
                          spreadRadius: 1.0,
                        ), //BoxShadow
                        BoxShadow(
                          color: primaryColor,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                      ],
                      color: Colors.white, // Color de fondo del contenedor
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit,
                          size: 25, color: primaryColor), // Icono del botón
                      onPressed: () {
                        // Acción al presionar el botón de editar
                      },
                    ),
                  ),
                  const SizedBox(
                    width: defaultPadding, // Espacio entre los botones
                  ),
                  // Botón de eliminar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          20), // Bordes redondeados del contenedor
                      boxShadow: const [
                        BoxShadow(
                          color: primaryColor, // Color de la sombra
                          offset: Offset(
                            2.0,
                            2.0,
                          ),
                          blurRadius: 3.0,
                          spreadRadius: 1.0,
                        ), //BoxShadow
                        BoxShadow(
                          color: primaryColor,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                      ],
                      color: Colors.white, // Color de fondo del contenedor
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete,
                          size: 25, color: primaryColor), // Icono del botón
                      onPressed: () {
                        // Acción al presionar el botón de eliminar
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
