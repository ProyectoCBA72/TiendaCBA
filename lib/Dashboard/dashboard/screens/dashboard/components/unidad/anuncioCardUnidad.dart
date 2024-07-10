// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';

import 'package:tienda_app/Anuncio/anuncioScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/anuncioModel.dart';

/// Widget que representa una tarjeta de anuncio.
///
/// Este widget muestra las imágenes del anuncio y algunos detalles del mismo.
///
/// Los parámetros requeridos son:
///
/// - `images`: Una lista de imágenes del anuncio.
///
/// - `anuncio`: El objeto `AnuncioModel` que contiene la información del anuncio.
class AnuncioCardUnidad extends StatefulWidget {
  final List<String> images;
  final AnuncioModel anuncio;
  const AnuncioCardUnidad(
      {super.key, required this.images, required this.anuncio});

  @override

  /// Crea un estado que maneja los datos de la pantalla.
  _AnuncioCardUnidadState createState() => _AnuncioCardUnidadState();
}

class _AnuncioCardUnidadState extends State<AnuncioCardUnidad> {
  /// Índice de la imagen actual en la lista de imágenes del anuncio.
  ///
  /// Inicialmente es 0, que representa la primera imagen del anuncio.
  int _currentImageIndex = 0;

  /// Referencia al temporizador que actualiza la imagen del anuncio.
  ///
  /// Se utiliza para controlar la frecuencia de cambio de imágenes.
  Timer? _timer;

  /// Lista de imágenes del anuncio.
  ///
  /// Almacena las imágenes del anuncio como cadenas de texto,
  /// donde cada cadena representa una ruta de archivo de imagen.
  List<String> _images = [];

  @override

  /// Inicializa el estado de la pantalla.
  ///
  /// Se llama automáticamente cuando se crea el widget.
  /// Se encarga de cargar las imágenes del anuncio.
  @override
  void initState() {
    super.initState();

    // Cargar las imágenes del anuncio.
    _loadImages();
  }

  @override

  /// Llamada al método [super.dispose] para liberar los recursos
  /// utilizados por el widget base.
  void dispose() {
    // Cancela cualquier temporizador activo para evitar fugas de memoria
    _timer?.cancel();

    // Llama al método [super.dispose] para liberar los recursos
    // utilizados por el widget base.
    super.dispose();
  }

  /// Inicia el temporizador para cambiar automáticamente la imagen cada 3 segundos.
  ///
  /// Cada 3 segundos se actualiza [_currentImageIndex] con el índice de la siguiente
  /// imagen en [_images]. Si se ha llegado al final de la lista, se vuelve a la primera.
  void _startTimer() {
    // Se crea un temporizador que se ejecuta cada 3 segundos.
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Se actualiza el estado del widget para mostrar la siguiente imagen en la lista.
      setState(() {
        // Se incrementa el índice de la imagen actual y se reinicia a 0 si se alcanza el final de la lista.
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  /// Carga las imágenes del anuncio.
  ///
  /// Se llamada automáticamente cuando se crea el widget.
  /// Se asigna la lista de imágenes proporcionadas por el widget
  /// a la variable [_images].
  ///
  /// No devuelve nada.
  void _loadImages() async {
    // Asigna la lista de imágenes proporcionadas por el widget a la variable [_images].
    _images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    final AnuncioModel anuncio =
        widget.anuncio; // Obtiene el anuncio desde las propiedades del widget
    return Padding(
      padding: const EdgeInsets.all(20), // Espaciado alrededor del widget
      child: SizedBox(
        width: 400,
        height: 200,
        child: InkWell(
          onTap: () {
            // Navegación al detalle del anuncio al hacer tap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => AnuncioScreen(
                  anuncio: anuncio,
                  images: _images, // Pasando imágenes al detalle del anuncio
                ),
              ),
            );
          },
          onHover: (isHovered) {
            // Manejo de eventos de hover sobre el widget
            if (isHovered) {
              _startTimer(); // Inicia el temporizador al pasar el mouse sobre el widget
            } else {
              _timer
                  ?.cancel(); // Cancela el temporizador si se deja de pasar el mouse sobre el widget
            }
          },
          child: _images.isNotEmpty
              ? // Comprueba si hay imágenes disponibles para el anuncio
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
                          image: NetworkImage(_images[
                              _currentImageIndex]), // Carga la imagen del anuncio desde la red
                          fit: BoxFit.fill,
                        ),
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x000005cc),
                            blurRadius: 30,
                            offset: Offset(10, 10),
                          ),
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
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white),
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
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white),
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
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 6),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          anuncio
                                              .titulo, // Muestra el título del anuncio
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
                )
              : const Text(
                  'Este Anuncio no tiene Imagenes'), // Mensaje cuando no hay imágenes disponibles
        ),
      ),
    );
  }
}
