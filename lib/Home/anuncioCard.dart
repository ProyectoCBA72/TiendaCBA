// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';

import 'package:tienda_app/Anuncio/anuncioScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/anuncioModel.dart';

/// Widget que representa una tarjeta de anuncio.
///
/// Es un [StatefulWidget] que muestra una tarjeta con las imágenes
/// del anuncio y algunos detalles del mismo. El widget acepta dos parámetros,
/// [anuncio] que representa la información del anuncio y [images] que es una lista de
/// las imágenes del anuncio.
class AnuncioCard extends StatefulWidget {
  /// Modelo del anuncio.
  final AnuncioModel anuncio;

  /// Lista de imágenes del anuncio.
  final List<String> images;

  /// Construye un widget de tarjeta de anuncio.
  ///
  /// Los parámetros [anuncio] y [images] son obligatorios.
  const AnuncioCard({
    super.key,
    required this.anuncio,
    required this.images,
  });

  @override
  _AnuncioCardState createState() => _AnuncioCardState();
}

class _AnuncioCardState extends State<AnuncioCard> {
  /// Índice de la imagen actual en la lista de imágenes del anuncio.
  int _currentImageIndex = 0;

  /// Timer utilizado para la reproducción automática de las imágenes.
  Timer? _timer;

  /// Lista de imágenes del anuncio.
  ///
  /// Esta lista se utiliza para almacenar las imágenes cargadas de forma asíncrona.
  /// La lista se inicializa vacía y se rellena en el método [initState].
  List<String> _images = [];

  @override

  /// Método que se llama cuando el widget se inicializa.
  ///
  /// Se encarga de cargar las imágenes del anuncio de forma asíncrona.
  @override
  void initState() {
    super.initState();

    // Se llama al método [loadImages] para cargar las imágenes del anuncio.
    // Este método se encarga de asignar la lista de imágenes al atributo [_images].
    _loadImages();
  }

  /// Carga las imágenes del anuncio de forma asíncrona.
  ///
  /// Las imágenes se cargan de forma asíncrona en el método [initState]
  /// y se asignan al atributo [_images].
  void _loadImages() async {
    // Se asigna la lista de imágenes proporcionadas por el widget a la variable [_images].
    _images = widget.images;
  }

  @override

  /// Disposa del estado del widget.
  ///
  /// Cancela cualquier temporizador activo y llama al método [super.dispose] para
  /// liberar recursos.
  @override
  void dispose() {
    // Cancela cualquier temporizador activo
    _timer?.cancel();

    // Llama al método [super.dispose] para liberar recursos
    super.dispose();
  }

  /// Inicia un temporizador que cambia el índice de la imagen actual cada 3 segundos.
  ///
  /// Cada vez que el temporizador se activa, se actualiza el estado del widget
  /// para mostrar la siguiente imagen en la lista de imágenes. El índice de la imagen
  /// se incrementa en uno y se reinicia a 0 cuando alcanza el final de la lista.
  void _startTimer() {
    // Se crea un temporizador que se ejecuta cada 3 segundos
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Se actualiza el estado del widget para mostrar la siguiente imagen
      setState(() {
        // Se incrementa el índice de la imagen actual y se reinicia a 0 si se alcanza el final de la lista
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  @override

  /// Construye el widget principal de la pantalla.
  ///
  /// Este widget contiene un anuncio que, al hacer clic, navega a una nueva
  /// pantalla de anuncio. También maneja la animación y el cambio de imagen
  /// al pasar el cursor sobre el widget.
  Widget build(BuildContext context) {
    // Obtiene el anuncio de los datos del widget.
    final anuncio = widget.anuncio;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        height: 200,
        child: InkWell(
          // Maneja el evento de clic.
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => AnuncioScreen(
                  anuncio: anuncio,
                  images: _images,
                ),
              ),
            );
          },
          // Maneja el evento de pasar el cursor.
          onHover: (isHovered) {
            if (isHovered) {
              _startTimer();
            } else {
              _timer?.cancel();
            }
          },
          child: AnimatedSwitcher(
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
                      // Posiciona el contenedor de texto en la parte inferior izquierda.
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
                                  // Muestra el título del anuncio.
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
          ),
        ),
      ),
    );
  }
}
