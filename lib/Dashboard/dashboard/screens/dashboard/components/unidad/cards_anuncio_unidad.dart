import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/anuncioCardUnidad.dart';
import 'package:tienda_app/Models/anuncioModel.dart';
import 'package:tienda_app/Models/imagenAnuncioModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista que muestra las tarjetas de anuncios para una unidad de producción.
class CardsAnuncioUnidad extends StatefulWidget {
  final UsuarioModel usuario;
  const CardsAnuncioUnidad({
    super.key,
    required this.usuario,
  });

  @override
  State<CardsAnuncioUnidad> createState() => _CardsAnuncioUnidadState();
}

class _CardsAnuncioUnidadState extends State<CardsAnuncioUnidad> {
  late Future<List<dynamic>> _datosFuture;

  @override
  void initState() {
    super.initState();
    _datosFuture = _fetchData();
  }

  // Función asíncrona para obtener datos futuros de anuncios e imágenes de anuncios
  Future<List<dynamic>> _fetchData() {
    return Future.wait([
      getAnuncios(),
      getImagenesAnuncio(),
    ]);
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
            // Botón para añadir un nuevo anuncio (solo visible en versiones no móviles)
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
                      color: botonSombra, // Sombra verde claro
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
        // Espaciado adicional en dispositivos móviles
        if (Responsive.isMobile(context))
          const SizedBox(
            height: defaultPadding,
          ),
        // Botón para añadir un nuevo anuncio en dispositivos móviles
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
                    color: botonSombra, // Sombra verde claro
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
        const SizedBox(height: defaultPadding),
        // Espacio para mostrar los anuncios
        SizedBox(
          height: 300,
          child: FutureBuilder(
            future: _datosFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se espera la carga de datos
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // Muestra un mensaje si hay un error al cargar los datos
                return Center(
                  child: Text('Ocurrió un error: ${snapshot.error}'),
                );
              } else {
                // Obtener listas de todos los anuncios y todas las imágenes de anuncios
                List<AnuncioModel> allAnuncios = snapshot.data![0];
                List<ImagenAnuncioModel> allImagesAnuncios = snapshot.data![1];

                // Verificar si no hay anuncios disponibles
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
                  // Filtrar anuncios por la unidad de producción del usuario
                  List<AnuncioModel> anunciosUnidad = allAnuncios
                      .where((anuncio) =>
                          anuncio.usuario.unidadProduccion ==
                          widget.usuario.unidadProduccion)
                      .toList();

                  // Verificar si hay anuncios para mostrar
                  if (anunciosUnidad.isNotEmpty) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: anunciosUnidad.length,
                      itemBuilder: (context, index) {
                        AnuncioModel anuncio = anunciosUnidad[index];

                        // Obtener imágenes asociadas al anuncio actual
                        List<String> imagesAnuncio = allImagesAnuncios
                            .where((imagen) => imagen.anuncio.id == anuncio.id)
                            .map((imagen) => imagen.imagen)
                            .toList();

                        // Mostrar la tarjeta de anuncio individual
                        return AnuncioCardUnidad(
                          images: imagesAnuncio,
                          anuncio: anuncio,
                        );
                      },
                    );
                  } else {
                    // Mostrar mensaje si no hay anuncios para la unidad de producción
                    return const Center(
                      child: Text(
                        'No hay anuncios para mostrar en esta unidad',
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
