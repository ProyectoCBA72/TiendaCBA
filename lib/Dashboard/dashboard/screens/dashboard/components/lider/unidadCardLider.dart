// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/Models/unidadProduccionModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class UnidadCardLider extends StatelessWidget {
  final UnidadProduccionModel undProduccion;

  const UnidadCardLider({
    super.key,
    required this.undProduccion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Ancho de la tarjeta
      margin: const EdgeInsets.symmetric(horizontal: 10.0), // Margen horizontal
      child: Card(
        elevation: 5, // Elevación de la tarjeta para dar sombra
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Borde redondeado
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Padding interior
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // Permite desplazamiento vertical
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Color de fondo blanco
                    borderRadius:
                        BorderRadius.circular(50), // Borde redondeado circular
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(
                            0.3), // Sombra con color primario y opacidad
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        50), // Borde redondeado de la imagen
                    child: Image.network(
                      undProduccion.logo, // URL de la imagen
                      height: 100, // Altura de la imagen
                      width: 100, // Anchura de la imagen
                      fit: BoxFit.fill, // Ajuste de la imagen
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Espacio vertical
                Text(
                  undProduccion.nombre, // Nombre de la unidad de producción
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // Texto en negrita
                    fontSize: 16, // Tamaño de fuente
                    fontFamily: 'Calibri-Bold', // Fuente específica
                  ),
                ),
                const SizedBox(height: 10), // Espacio vertical
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centra los elementos en la fila
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20), // Borde redondeado
                        boxShadow: const [
                          BoxShadow(
                            color: primaryColor, // Color de la sombra
                            offset:
                                Offset(2.0, 2.0), // Desplazamiento de la sombra
                            blurRadius: 3.0, // Radio de desenfoque
                            spreadRadius: 1.0, // Radio de expansión
                          ),
                          BoxShadow(
                            color: primaryColor, // Color de la sombra
                            offset:
                                Offset(0.0, 0.0), // Desplazamiento de la sombra
                            blurRadius: 0.0, // Radio de desenfoque
                            spreadRadius: 0.0, // Radio de expansión
                          ),
                        ],
                        color: Colors.white, // Color de fondo
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit,
                            size: 25, color: primaryColor), // Icono de edición
                        onPressed: () {
                          // Acción al presionar el botón de editar
                        },
                      ),
                    ),
                    const SizedBox(width: defaultPadding), // Espacio horizontal
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20), // Borde redondeado
                        boxShadow: const [
                          BoxShadow(
                            color: primaryColor, // Color de la sombra
                            offset:
                                Offset(2.0, 2.0), // Desplazamiento de la sombra
                            blurRadius: 3.0, // Radio de desenfoque
                            spreadRadius: 1.0, // Radio de expansión
                          ),
                          BoxShadow(
                            color: primaryColor, // Color de la sombra
                            offset:
                                Offset(0.0, 0.0), // Desplazamiento de la sombra
                            blurRadius: 0.0, // Radio de desenfoque
                            spreadRadius: 0.0, // Radio de expansión
                          ),
                        ],
                        color: Colors.white, // Color de fondo
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete,
                            size: 25,
                            color: primaryColor), // Icono de eliminación
                        onPressed: () {
                          // Acción al presionar el botón de eliminar
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
    );
  }
}
