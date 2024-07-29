import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/sedeCardLider.dart';
import 'package:tienda_app/Models/imagenSedeModel.dart';
import 'package:tienda_app/Models/sedeModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista que muestra las tarjetas de sedes, adaptándose a diferentes dispositivos.
class CardsSedeLider extends StatelessWidget {
  const CardsSedeLider({
    super.key,
  });

  // Método para obtener datos de sedes y sus imágenes
  Future<List<dynamic>> fetchData() {
    return Future.wait([getSedes(), getImagenSedes()]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Encabezado de las tarjetas de sedes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sedes",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontFamily: 'Calibri-Bold'),
            ),
            // Botón "Añadir Sede" visible solo en dispositivos no móviles
            if (!Responsive.isMobile(context))
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      botonClaro, // Verde más claro
                      botonOscuro, // Verde más oscuro
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: botonSombra, // Sombra en tono verde claro
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'Añadir Sede',
                          style: TextStyle(
                            color: background1,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Calibri-Bold',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Espacio adicional en dispositivos móviles
        if (Responsive.isMobile(context))
          const SizedBox(height: defaultPadding),
        // Botón "Añadir Sede" visible solo en dispositivos móviles
        if (Responsive.isMobile(context))
          Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  botonClaro, // Verde más claro
                  botonOscuro, // Verde más oscuro
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: botonSombra, // Sombra en tono verde claro
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'Añadir Sede',
                      style: TextStyle(
                        color: background1,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Calibri-Bold',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Espacio adicional antes del listado de tarjetas de sedes
        const SizedBox(height: defaultPadding),
        // Contenedor que muestra las tarjetas de sedes
        SizedBox(
          height: 300,
          child: FutureBuilder(
            future: fetchData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Indicador de carga mientras se espera la respuesta
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // Mensaje de error si ocurre un problema al cargar datos
                return Text(
                  'Error al cargar sedes: ${snapshot.error}',
                  textAlign: TextAlign.center,
                );
              } else if (snapshot.data == null) {
                // Mensaje si no se encontraron datos de sedes
                return const Text(
                  'No se encontraron sedes',
                  textAlign: TextAlign.center,
                );
              } else {
                // Procesamiento de datos y construcción de las tarjetas de sedes
                List<SedeModel> sedes = snapshot.data![0];
                List<ImagenSedeModel> allImagesSedes = snapshot.data![1];

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sedes.length,
                  itemBuilder: (context, index) {
                    SedeModel sede = sedes[index];
                    // Filtrado de imágenes por sede y construcción de tarjeta de sede
                    List<String> images = allImagesSedes
                        .where((imagen) => imagen.sede.id == sede.id)
                        .map((imagen) => imagen.imagen)
                        .toList();
                    return SedeCardLider(
                      sede: sede,
                      images: images,
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
