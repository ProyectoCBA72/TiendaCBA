import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/sedeCardLider.dart';
import 'package:tienda_app/Models/imagenSedeModel.dart';
import 'package:tienda_app/Models/sedeModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista donde se llamaran las cards superiores de conteo de reservas y las organiza que se adapten a todos los dispositivos

class CardsSedeLider extends StatelessWidget {
  const CardsSedeLider({
    super.key,
  });

  Future<List<dynamic>> fechData() {
    return Future.wait([getSedes(), getImagenSedes()]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                      color: botonSombra, // Verde más claro para sombra
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
        if (Responsive.isMobile(context))
          const SizedBox(height: defaultPadding),
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
                  color: botonSombra, // Verde más claro para sombra
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
        const SizedBox(height: defaultPadding),
        SizedBox(
          height: 300,
          child: FutureBuilder(
            future: fechData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error al cargar sedes: ${snapshot.error}');
              } else if (snapshot.data == null) {
                return const Text('No se encontraron sedes');
              } else {
                List<SedeModel> sedes = snapshot.data![0];
                List<ImagenSedeModel> allImagesSedes = snapshot.data![1];

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sedes.length,
                  itemBuilder: (context, index) {
                    SedeModel sede = sedes[index];
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
