import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/anuncioCardPunto.dart';
import 'package:tienda_app/Models/anuncioModel.dart';
import 'package:tienda_app/Models/imagenAnuncioModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista donde se llamaran las cards superiores de conteo de reservas y las organiza que se adapten a todos los dispositivos

class CardsAnuncioPunto extends StatelessWidget {
  final UsuarioModel usuario;
  const CardsAnuncioPunto({
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
        if (Responsive.isMobile(context))
          const SizedBox(
            height: defaultPadding,
          ),
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
        SizedBox(
          height: 300,
          child: FutureBuilder(
            future: futureData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Ocurrio un error: ${snapshot.error} '),
                );
              } else {
                List<AnuncioModel> allAnuncios = snapshot.data![0];
                List<ImagenAnuncioModel> allImagesAnuncios = snapshot.data![1];
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
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allAnuncios.length,
                    itemBuilder: (context, index) {
                      if (allAnuncios[index].usuario.sede == usuario.sede) {
                        AnuncioModel anuncio = allAnuncios[index];
                        List<String> imagesAnuncio = allImagesAnuncios
                            .where((imagen) => imagen.anuncio.id == anuncio.id)
                            .map((imagen) => imagen.imagen)
                            .toList();

                        return AnuncioCardPunto(
                          images: imagesAnuncio,
                          anuncio: anuncio,
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'No hay anuncios para mostrar en esta sede',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
