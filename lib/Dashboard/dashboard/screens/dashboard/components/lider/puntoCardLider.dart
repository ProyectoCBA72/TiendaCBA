// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class CardPuntoLider extends StatefulWidget {
  final PuntoVentaModel puntoVenta;
  const CardPuntoLider({
    super.key,
    required this.puntoVenta,
  });


  @override
  State<CardPuntoLider> createState() => _CardPuntoLiderState();
}

class _CardPuntoLiderState extends State<CardPuntoLider> {
  @override
  Widget build(BuildContext context) {
    final puntoVenta = widget.puntoVenta;
    return Container(
      width: 250, // Ancho de la tarjeta
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                      color: botonOscuro,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ubicacion: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          fontFamily: 'Calibri-Bold',
                        ),
                      ),
                      Text(
                        puntoVenta.ubicacion,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontFamily: 'Calibri-Bold',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      size: 30,
                      color: botonOscuro,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    "Estado: ",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Calibri-Bold',
                    ),
                  ),
                   Text(
                    puntoVenta.estado ? "Activo" : "Inactivo",
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontFamily: 'Calibri-Bold',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: primaryColor,
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
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.edit, size: 25, color: primaryColor),
                      onPressed: () {
                        // Acción al presionar el botón de editar
                      },
                    ),
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: primaryColor,
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
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete,
                          size: 25, color: primaryColor),
                      onPressed: () {
                        // Acción al presionar el botón de editar
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
