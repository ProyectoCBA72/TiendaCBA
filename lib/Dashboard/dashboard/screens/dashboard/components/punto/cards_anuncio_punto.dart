import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/anuncioCardPunto.dart';
import 'package:tienda_app/Models/anuncioModel.dart';
import 'package:tienda_app/Models/imagenAnuncioModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista que muestra tarjetas de anuncios organizadas para adaptarse a todos los dispositivos

class CardsAnuncioPunto extends StatelessWidget {
  final UsuarioModel usuario;
  const CardsAnuncioPunto({
    super.key,
    required this.usuario,
  });

  // Método asincrónico para obtener datos de anuncios y sus imágenes
  Future<List<dynamic>> futureData() async {
    return Future.wait([getAnuncios(), getImagenesAnuncio()]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Encabezado de la sección de anuncios
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
                      color: botonSombra, // Sombra con verde más claro
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Acción al presionar "Añadir Anuncio"
                    },
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
          const SizedBox(
            height: defaultPadding,
          ),

        // Botón "Añadir Anuncio" para dispositivos móviles
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
                    color: botonSombra, // Sombra con verde más claro
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Acción al presionar "Añadir Anuncio" en móvil
                  },
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

        // Espacio entre encabezado y lista de anuncios
        const SizedBox(height: defaultPadding),

        // Lista de anuncios
        SizedBox(
          height: 300,
          child: FutureBuilder(
            future: futureData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se espera la respuesta
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // Muestra un mensaje de error si ocurre algún problema con la carga de datos
                return Center(
                  child: Text('Ocurrió un error: ${snapshot.error}'),
                );
              } else {
                // Obtiene la lista de todos los anuncios y sus imágenes
                List<AnuncioModel> allAnuncios = snapshot.data![0];
                List<ImagenAnuncioModel> allImagesAnuncios = snapshot.data![1];

                // Verifica si no hay anuncios
                if (allAnuncios.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay anuncios',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  // Filtra los anuncios por el punto de venta del usuario autenticado
                  List<AnuncioModel> anunciosPunto = allAnuncios
                      .where((anuncio) =>
                          anuncio.usuario.puntoVenta == usuario.puntoVenta)
                      .toList();

                  // Verifica si hay anuncios para mostrar
                  if (anunciosPunto.isNotEmpty) {
                    // Construye una lista horizontal de tarjetas de anuncios
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: anunciosPunto.length,
                      itemBuilder: (context, index) {
                        AnuncioModel anuncio = anunciosPunto[index];

                        // Obtiene las imágenes asociadas al anuncio
                        List<String> imagesAnuncio = allImagesAnuncios
                            .where((imagen) => imagen.anuncio.id == anuncio.id)
                            .map((imagen) => imagen.imagen)
                            .toList();

                        // Retorna la tarjeta del anuncio
                        return AnuncioCardPunto(
                          images: imagesAnuncio,
                          anuncio: anuncio,
                        );
                      },
                    );
                  } else {
                    // Muestra un mensaje si no hay anuncios para mostrar en el punto de venta
                    return const Center(
                      child: Text(
                        'No hay anuncios para mostrar en este punto',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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

