import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/anuncioCardPunto.dart';
import 'package:tienda_app/Models/anuncioModel.dart';
import 'package:tienda_app/Models/imagenAnuncioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista donde se llamaran las cards superiores de conteo de reservas y las organiza que se adapten a todos los dispositivos

class CardsAnuncioPunto extends StatelessWidget {
  const CardsAnuncioPunto({
    super.key,
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
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // creamos las instancias con los datos del futuro creado en la parte superior.
                final List<AnuncioModel> anuncios = snapshot.data![0];
                final List<ImagenAnuncioModel> allImagesAnuncio =
                    snapshot.data![1];

                // retornamos el contructor pasando la lista de imagenes y una instancia de la lista.
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: anuncios.length,
                  itemBuilder: (context, index) {
                    final anuncio = anuncios[index];
                    // crear una lista con las urls de las imagenes relacionadas a cada uno de los anuncios.
                    List<String> images = allImagesAnuncio
                        .where((imagen) => imagen.anuncio.id == anuncio.id)
                        .map((images) => images.imagen)
                        .toList();
                    return AnuncioCardPunto(
                      images: images,
                      anuncio: anuncio,
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
