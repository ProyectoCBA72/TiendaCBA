// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';

import 'package:tienda_app/Home/anuncioCard.dart';
import 'package:tienda_app/Home/logoSection.dart';
import 'package:tienda_app/Home/misionSection.dart';
import 'package:tienda_app/Home/productoCard.dart';
import 'package:tienda_app/Home/profileCard.dart';
import 'package:tienda_app/Home/sedeCard.dart';
import 'package:tienda_app/Home/senaSection.dart';
import 'package:tienda_app/Tienda/tiendaScreen.dart';
import 'package:tienda_app/constantsDesign.dart';
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

  // Lista de URLs de imágenes
  final List<String> imageUrls = [
    'assets/fondo1.jpg',
    'assets/fondo2.jpg',
    'assets/fondo3.jpg',
    'assets/fondo4.jpg',
  ];

  // Índice de la imagen actual
  int _currentIndex = 0;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    _controller.dispose(); // Liberar recursos de la animación
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Capa verde semitransparente
          Container(
            color: Colors.green.withOpacity(
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
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            // Coloca aquí tu imagen de logo
                            child: Image.asset('assets/logo.png'),
                          ),

                          const SizedBox(width: 20),

                          // Texto
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Centro de biotecnología agropecuaria',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.06, // 6% del ancho de la pantalla
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "BakbakOne"),
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
                                      fontFamily: "BakbakOne"),
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
                            'Centro de biotecnología agropecuaria',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width *
                                  0.06, // 6% del ancho de la pantalla
                              fontWeight: FontWeight.bold,
                              fontFamily: "BakbakOne",
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
                              fontFamily: "BakbakOne",
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Logo
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.2, // 20% del ancho de la pantalla
                            height: MediaQuery.of(context).size.width *
                                0.2, // 20% del ancho de la pantalla
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            // Coloca aquí tu imagen de logo
                            child: Image.asset('assets/logo.png'),
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
                        const Text(
                          'Anuncios',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'BakbakOne',
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const AnuncioCard();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Text(
                          'Productos Destacados',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'BakbakOne',
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const ProductoCard();
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
                        const Text(
                          'Conozca Nuestras Sedes',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'BakbakOne',
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const SedeCard();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Center(
                          child: Text(
                            '©SENA 2024',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'BakbakOne',
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
                                    builder: (context) => const TiendaScreen()),
                              );
                            },
                            icon: const Icon(
                              Icons.store,
                              color: Colors.white,
                            )))),
                const SizedBox(width: 20),
                GestureDetector(onTap: () {}, child: const ProfileCard()),
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      // Coloca aquí tu imagen de logo
                      child: Image.asset('assets/logo.png'),
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
  }
}
