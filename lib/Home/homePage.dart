// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';
import 'package:provider/provider.dart';
import 'package:tienda_app/Home/anuncioCard.dart';
import 'package:tienda_app/Home/logoSection.dart';
import 'package:tienda_app/Home/misionSection.dart';
import 'package:tienda_app/Home/productoCard.dart';
import 'package:tienda_app/Home/profileCard.dart';
import 'package:tienda_app/Home/sedeCard.dart';
import 'package:tienda_app/Home/senaSection.dart';
import 'package:tienda_app/Models/anuncioModel.dart';
import 'package:tienda_app/Models/imagenAnuncioModel.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/imagenSedeModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/sedeModel.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';
import 'package:tienda_app/Tienda/tiendaScreen.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool secundaria = false;

  late Future<List<dynamic>> _datosFuture;

  // Lista de URLs de imágenes
  final List<String> imageUrls = [
    'assets/img/fondo1.jpg',
    'assets/img/fondo2.jpg',
    'assets/img/fondo3.jpg',
    'assets/img/fondo4.jpg',
  ];

  // Índice de la imagen actual
  int _currentIndex = 0;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _datosFuture = _fetchData();

    // Iniciar el ciclo de cambio de imágenes
    startImageSlideShow();

    // Configurar la animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 0.05), // 5% del tamaño de la pantalla hacia arriba
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true); // Repetir la animación de forma inversa
  }

  void startImageSlideShow() {
    // Cambiar de imagen cada 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _currentIndex = (_currentIndex + 1) % imageUrls.length;
      });
      startImageSlideShow(); // Reiniciar el ciclo
    });
  }

  Future<List<dynamic>> _fetchData() {
    return Future.wait([
      getImagenProductos(),
      getProductos(),
      getImagenSedes(),
      getSedes(),
      getAnuncios(),
      getImagenesAnuncio(),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose(); // Liberar recursos de la animación
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, _) {
      return Scaffold(
        body: Stack(
          children: [
            // Fondo con imágenes que cambian
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Image.asset(
                imageUrls[_currentIndex], // URL de la imagen actual
                key: ValueKey<String>(
                    imageUrls[_currentIndex]), // Key única para la animación
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // Capa verde semitransparente
            Container(
              color: primaryColor.withOpacity(
                  0.5), // Ajusta el nivel de opacidad según sea necesario
              width: double.infinity,
              height: double.infinity,
            ),

            // Logo y texto
            if (secundaria == false)
              Responsive.isDesktop(context)
                  ? Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  0.2, // 20% del ancho de la pantalla
                              height: MediaQuery.of(context).size.width *
                                  0.2, // 20% del ancho de la pantalla
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withOpacity(0.5),
                              ),
                              // Coloca aquí tu imagen de logo
                              child: Image.asset('assets/img/logo.png'),
                            ),

                            const SizedBox(width: 20),

                            // Texto
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Centro de Biotecnología Agropecuaria',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Calibri-Bold",
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Color y opacidad de la sombra
                                          offset: const Offset(2,
                                              2), // Desplazamiento de la sombra (horizontal, vertical)
                                          blurRadius:
                                              3, // Radio de desenfoque de la sombra
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'SENA Mosquera',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.06, // 6% del ancho de la pantalla
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Calibri-Bold",
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Color y opacidad de la sombra
                                          offset: const Offset(2,
                                              2), // Desplazamiento de la sombra (horizontal, vertical)
                                          blurRadius:
                                              3, // Radio de desenfoque de la sombra
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Títulos
                            Text(
                              'Centro de Biotecnología Agropecuaria',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width *
                                    0.06, // 6% del ancho de la pantalla
                                fontWeight: FontWeight.bold,
                                fontFamily: "Calibri-Bold",
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(
                                        0.5), // Color y opacidad de la sombra
                                    offset: const Offset(2,
                                        2), // Desplazamiento de la sombra (horizontal, vertical)
                                    blurRadius:
                                        3, // Radio de desenfoque de la sombra
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'SENA Mosquera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width *
                                    0.06, // 6% del ancho de la pantalla
                                fontWeight: FontWeight.bold,
                                fontFamily: "Calibri-Bold",
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(
                                        0.5), // Color y opacidad de la sombra
                                    offset: const Offset(2,
                                        2), // Desplazamiento de la sombra (horizontal, vertical)
                                    blurRadius:
                                        3, // Radio de desenfoque de la sombra
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Logo
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  0.2, // 20% del ancho de la pantalla
                              height: MediaQuery.of(context).size.width *
                                  0.2, // 20% del ancho de la pantalla
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withOpacity(0.5),
                              ),
                              // Coloca aquí tu imagen de logo
                              child: Image.asset('assets/img/logo.png'),
                            ),
                          ],
                        ),
                      ),
                    ),

            // Contenido
            if (secundaria == true)
              Positioned(
                top: 130,
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Anuncios',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Calibri-Bold',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Color y opacidad de la sombra
                                  offset: const Offset(2,
                                      2), // Desplazamiento de la sombra (horizontal, vertical)
                                  blurRadius:
                                      3, // Radio de desenfoque de la sombra
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            child: FutureBuilder(
                              future: _datosFuture,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>>
                                      snapshotAnuncios) {
                                if (snapshotAnuncios.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshotAnuncios.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error al cargar datos: ${snapshotAnuncios.error}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                                0.5), // Color y opacidad de la sombra
                                            offset: const Offset(2,
                                                2), // Desplazamiento de la sombra (horizontal, vertical)
                                            blurRadius:
                                                3, // Radio de desenfoque de la sombra
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (snapshotAnuncios.data!.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No hay anuncios disponibles en este momento',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                                0.5), // Color y opacidad de la sombra
                                            offset: const Offset(2,
                                                2), // Desplazamiento de la sombra (horizontal, vertical)
                                            blurRadius:
                                                3, // Radio de desenfoque de la sombra
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  final List<AnuncioModel> anuncios =
                                      snapshotAnuncios.data![4];

                                  final List<ImagenAnuncioModel>
                                      imagenesAnuncios =
                                      snapshotAnuncios.data![5];
                                  // Filatramos todos los anuncios en funcion de si esta activo o ya paso el dia.
                                  final anunciosDisponibles =
                                      anuncios.where((anuncio) {
                                    final now = DateTime.now();
                                    final fechaAnuncio =
                                        DateTime.parse(anuncio.fecha);
                                    return fechaAnuncio.isAfter(now) ||
                                        fechaAnuncio.day == now.day;
                                  }).toList();

                                  if (anunciosDisponibles.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'No hay anuncios disponibles en este momento',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                  0.5), // Color y opacidad de la sombra
                                              offset: const Offset(2,
                                                  2), // Desplazamiento de la sombra (horizontal, vertical)
                                              blurRadius:
                                                  3, // Radio de desenfoque de la sombra
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: anunciosDisponibles.length,
                                      itemBuilder: (context, index) {
                                        AnuncioModel anuncio =
                                            anunciosDisponibles[index];

                                        List<String> imagesAnun =
                                            imagenesAnuncios
                                                .where((imagen) =>
                                                    imagen.anuncio.id ==
                                                    anuncio.id)
                                                .map((imagen) => imagen.imagen)
                                                .toList();
                                        return AnuncioCard(
                                          anuncio: anuncio,
                                          images: imagesAnun,
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Text(
                            'Productos Destacados',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Calibri-Bold',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Color y opacidad de la sombra
                                  offset: const Offset(2,
                                      2), // Desplazamiento de la sombra (horizontal, vertical)
                                  blurRadius:
                                      3, // Radio de desenfoque de la sombra
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            child: FutureBuilder(
                              future: _datosFuture,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error al cargar datos: ${snapshot.error}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                                0.5), // Color y opacidad de la sombra
                                            offset: const Offset(2,
                                                2), // Desplazamiento de la sombra (horizontal, vertical)
                                            blurRadius:
                                                3, // Radio de desenfoque de la sombra
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  final List<ImagenProductoModel> allImages =
                                      snapshot.data![0];
                                  final List<ProductoModel> productos =
                                      snapshot.data![1];

                                  if (productos.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'No hay productos',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                  0.5), // Color y opacidad de la sombra
                                              offset: const Offset(2,
                                                  2), // Desplazamiento de la sombra (horizontal, vertical)
                                              blurRadius:
                                                  3, // Radio de desenfoque de la sombra
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  List<ProductoModel> productosFiltrados =
                                      productos
                                          .where((producto) =>
                                              producto.destacado &&
                                              producto.estado)
                                          .toList();
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productosFiltrados.length,
                                    itemBuilder: (context, index) {
                                      final producto =
                                          productosFiltrados[index];
                                      List<String> imagenesProducto = allImages
                                          .where((imagen) =>
                                              imagen.producto.id == producto.id)
                                          .map((imagen) => imagen.imagen)
                                          .toList();
                                      return ProductoCard(
                                        imagenes: imagenesProducto,
                                        producto: producto,
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const SenaSection(),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const MisionSection(),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const LogoSection(),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Text(
                            'Conozca Nuestras Sedes',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Calibri-Bold',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Color y opacidad de la sombra
                                  offset: const Offset(2,
                                      2), // Desplazamiento de la sombra (horizontal, vertical)
                                  blurRadius:
                                      3, // Radio de desenfoque de la sombra
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            child: FutureBuilder(
                              future: _datosFuture,
                              builder: (context, snapshotSedes) {
                                if (snapshotSedes.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshotSedes.data!.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'Sin sedes',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  );
                                } else if (snapshotSedes.hasError) {
                                  return Center(
                                    child: Text(
                                      'Ocurrio un error por favor reportelo ${snapshotSedes.error}',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  );
                                } else {
                                  // Lista de todas la sedes
                                  final List<SedeModel> allsedes =
                                      snapshotSedes.data![3];
                                  final List<ImagenSedeModel> allImagesSedes =
                                      snapshotSedes.data![2];
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: allsedes.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // sede que vamos a contruir
                                      SedeModel sede = allsedes[index];
                                      //Buscamos las imagenes de la sede en base a la sede actual (index)
                                      List<String> imagesSede = allImagesSedes
                                          .where((imagen) =>
                                              imagen.sede.id == sede.id)
                                          .map((imagen) => imagen.imagen)
                                          .toList();
                                      return SedeCard(
                                        sede: sede,
                                        imagenes: imagesSede,
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Center(
                            child: Text(
                              '©SENA 2024',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Calibri-Bold',
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(
                                        0.5), // Color y opacidad de la sombra
                                    offset: const Offset(2,
                                        2), // Desplazamiento de la sombra (horizontal, vertical)
                                    blurRadius:
                                        3, // Radio de desenfoque de la sombra
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            // Iconos en la parte superior derecha
            Positioned(
              top: 40,
              right: 20,
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: Container(
                          // Contenedor que envuelve un botón de búsqueda.
                          color: primaryColor,
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(
                                          create: (context) =>
                                              Tiendacontroller(),
                                        ),
                                      ],
                                      child: const TiendaScreen(),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.store,
                                color: Colors.white,
                              )))),
                  const SizedBox(width: 20),
                  ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: Container(
                          // Contenedor que envuelve un botón de búsqueda.
                          color: primaryColor,
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.chat,
                                color: Colors.white,
                              )))),
                  const SizedBox(width: 20),
                  const ProfileCard(),
                ],
              ),
            ),

            if (secundaria == true)
              Positioned(
                top: 40,
                left: 20,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          secundaria = false;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withOpacity(0.5),
                        ),
                        // Coloca aquí tu imagen de logo
                        child: Image.asset('assets/img/logo.png'),
                      ),
                    ),
                  ],
                ),
              ),

            // Icono de subir
            if (secundaria == false)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward,
                          color: Colors.green, size: 30),
                      onPressed: () {
                        // Aquí puedes añadir la lógica para ir hacia arriba
                        setState(() {
                          secundaria = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
