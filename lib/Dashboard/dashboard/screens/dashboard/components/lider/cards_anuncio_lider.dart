import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/anuncioCardLider.dart';
import 'package:tienda_app/Models/anuncioModel.dart';
import 'package:tienda_app/Models/imagenAnuncioModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista que muestra las tarjetas de anuncios, adaptándose a diferentes dispositivos.
class CardsAnuncioLider extends StatelessWidget {
  final UsuarioModel usuario;
  const CardsAnuncioLider({
    super.key,
    required this.usuario,
  });

  Future<List<dynamic>> futureData() async {
    return Future.wait([getAnuncios(), getImagenesAnuncio()]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Encabezado de las tarjetas de anuncios
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Anuncios",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontFamily: 'Calibri-Bold'),
            ),
            // Botón "Añadir Anuncio" visible solo en dispositivos no móviles
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
                          'Añadir Anuncio',
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
        // Botón "Añadir Anuncio" visible solo en dispositivos móviles
        if (Responsive.isMobile(context))
          Center(
            child: Container(
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
                        'Añadir Anuncio',
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
          ),
        // Espacio adicional antes del listado de tarjetas de anuncios
        const SizedBox(height: defaultPadding),
        // Contenedor que muestra las tarjetas de anuncios
        SizedBox(
          height: 300,
          child: FutureBuilder(
            future: futureData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Indicador de carga mientras se espera la respuesta
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // Mensaje de error si ocurre un problema al cargar datos
                return Center(
                  child: Text(
                    'Ocurrió un error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                // Construcción de las tarjetas de anuncios
                List<AnuncioModel> allAnuncios = snapshot.data![0];
                List<ImagenAnuncioModel> allImagesAnuncios = snapshot.data![1];
                if (allAnuncios.isEmpty) {
                  // Mensaje si no hay anuncios para mostrar
                  return const Center(
                    child: Text(
                      'No hay anuncios',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  // Filtrar anuncios por sede del usuario autenticado
                  List<AnuncioModel> anuncioSede = allAnuncios
                      .where((anuncio) => anuncio.usuario.sede == usuario.sede)
                      .toList();

                  if (anuncioSede.isNotEmpty) {
                    // Mostrar listado de tarjetas de anuncios
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: anuncioSede.length,
                      itemBuilder: (context, index) {
                        AnuncioModel anuncio = anuncioSede[index];
                        List<String> imagesAnuncio = allImagesAnuncios
                            .where((imagen) => imagen.anuncio.id == anuncio.id)
                            .map((imagen) => imagen.imagen)
                            .toList();

                        return AnuncioCardLider(
                          images: imagesAnuncio,
                          anuncio: anuncio,
                        );
                      },
                    );
                  } else {
                    // Mensaje si no hay anuncios para la sede del usuario
                    return const Center(
                      child: Text(
                        'No hay anuncios para mostrar en esta sede',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
