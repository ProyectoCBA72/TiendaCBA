// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';

import 'package:tienda_app/Anuncio/anuncioScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/anuncioModel.dart';

class AnuncioCardUnidad extends StatefulWidget {
  final List<String> images;
  final AnuncioModel anuncio;
  const AnuncioCardUnidad(
      {super.key, required this.images, required this.anuncio});

  @override
  _AnuncioCardUnidadState createState() => _AnuncioCardUnidadState();
}

class _AnuncioCardUnidadState extends State<AnuncioCardUnidad> {
  int _currentImageIndex = 0;
  Timer? _timer;
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  void _loadImages() async {
    _images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    final AnuncioModel anuncio = widget.anuncio;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        height: 200,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => AnuncioScreen(
                          anuncio: anuncio,
                          images: _images,
                        )));
          },
          onHover: (isHovered) {
            if (isHovered) {
              _startTimer();
            } else {
              _timer?.cancel();
            }
          },
          child: 
          _images.isNotEmpty ?
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: FadeTransition(
              key: ValueKey<int>(_currentImageIndex),
              opacity: const AlwaysStoppedAnimation(1),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_images[_currentImageIndex]),
                    fit: BoxFit.fill,
                  ),
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x000005cc),
                      blurRadius: 30,
                      offset: Offset(10, 10),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              // Acción al presionar el botón de edición
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              // Acción al presionar el botón de eliminación
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        left: 5,
                        child: Container(
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, left: 6),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    anuncio.titulo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: 'Calibri-Bold',
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ): const Text('Este Anuncio no tiene Imagenes'),
        ),
      ),
    );
  }
}
