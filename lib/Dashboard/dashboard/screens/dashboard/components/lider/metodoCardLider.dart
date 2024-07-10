// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/Models/medioPagoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Tarjeta que muestra un método de pago específico.
class MetodoCardLider extends StatelessWidget {
  final MedioPagoModel medioPago;

  /// Constructor de MetodoCardLider.
  const MetodoCardLider({
    super.key,
    required this.medioPago,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _modalSeguridad(context, medioPago);
      },
      child: Container(
        width: 200, // Ancho de la tarjeta
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          elevation: 5, // Elevación de la tarjeta
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Radio de la tarjeta
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(
                              0.3), // Color y opacidad de la sombra
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // Desplazamiento de la sombra
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                          color: primaryColor,
                          width: 100,
                          height: 100,
                          child: const Icon(
                            Icons.monetization_on,
                            color: Colors.white,
                            size: 100,
                          )),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    medioPago.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Calibri-Bold',
                    ),
                  ), // Título
                  const SizedBox(height: 10),
                  Row(
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
                          icon: const Icon(Icons.edit,
                              size: 25, color: primaryColor),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Función privada que muestra un modal de seguridad para el método de pago seleccionado.
void _modalSeguridad(BuildContext context, MedioPagoModel medioPAgo) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 250,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                // Título del modal
                Text(
                  medioPAgo.nombre,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                      color: primaryColor,
                      width: 100,
                      height: 100,
                      child: const Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                        size: 100,
                      )),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Cuerpo del modal con texto desplazable
                Expanded(
                  child: SizedBox(
                    height: 495,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Text(
                        medioPAgo.detalle,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Acciones del modal
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cerrar"))
              ],
            )
          ],
        );
      });
}
