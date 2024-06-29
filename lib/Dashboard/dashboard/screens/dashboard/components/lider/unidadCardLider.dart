// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';

class UnidadCardLider extends StatelessWidget {
  const UnidadCardLider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        color: primaryColor
                            .withOpacity(0.3), // Color y opacidad de la sombra
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      "https://static.vecteezy.com/system/resources/previews/004/182/846/original/meat-products-flat-design-long-shadow-glyph-icon-chicken-leg-beef-steak-and-sausage-grocery-store-bbq-items-silhouette-illustration-vector.jpg",
                      height: 100,
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Carnicos",
                  style: TextStyle(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
