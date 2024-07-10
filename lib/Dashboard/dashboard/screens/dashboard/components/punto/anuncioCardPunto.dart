// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';

import 'package:tienda_app/Anuncio/anuncioScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/anuncioModel.dart';

/// Widget que representa una tarjeta de un anuncio en la aplicación.
///
/// Esta clase extiende [StatefulWidget] y tiene dos parámetros obligatorios:
/// [images] que es una lista de las imágenes del anuncio y [anuncio] que
/// representa la información del anuncio. El widget tiene un estado
/// [_AnuncioCardPuntoState] que se encarga de manejar los datos de la pantalla.
class AnuncioCardPunto extends StatefulWidget {
  /// Lista de las imágenes del anuncio.
  final List<String> images;

  /// Objeto que contiene la información del anuncio.
  final AnuncioModel anuncio;

  /// Constructor del widget.
  ///
  /// Recibe como parámetros [images] y [anuncio].
  const AnuncioCardPunto(
      {super.key, required this.images, required this.anuncio});

  @override
  // State del widget.
  _AnuncioCardPuntoState createState() => _AnuncioCardPuntoState();
}

class _AnuncioCardPuntoState extends State<AnuncioCardPunto> {
  /// Índice actual de la imagen en la lista de imágenes.
  ///
  /// Inicialmente se establece en 0, que es el primer elemento de la lista.
  int _currentImageIndex = 0;

  /// Temporizador que cambia la imagen actual cada 3 segundos.
  ///
  /// Se inicializa en el método [initState] y se cancela en el método [dispose].
  Timer? _timer;

  /// Lista de las imágenes del anuncio.
  ///
  /// Se inicializa en el método [initState] al cargar las imágenes del anuncio.
  List<String> _images = [];

  @override

  /// Inicializa el estado del widget.
  ///
  /// Se llama una vez cuando se crea el widget. Se encarga de cargar las imágenes del anuncio.
  @override
  void initState() {
    // Llama al método initState del padre.
    super.initState();

    // Carga las imágenes del anuncio.
    _loadImages();
  }

  @override

  /// Libera los recursos utilizados por el temporizador.
  ///
  /// Se llama automáticamente cuando se elimina el widget.
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por el temporizador.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos adicionales.
  @override
  void dispose() {
    // Cancela el temporizador si está activo
    _timer?.cancel();

    // Llama al método [dispose] del widget base
    super.dispose();
  }

  /// Inicia un temporizador que cambia la imagen actual cada 3 segundos.
  ///
  /// Se encarga de actualizar el índice de la imagen actual y reiniciarlo a 0 cuando se alcanza el final de la lista.
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
  /// Este método asigna la lista de imágenes proporcionadas por el widget
  /// al atributo [_images].
  void _loadImages() {
    // Asigna la lista de imágenes proporcionadas por el widget
    // a la variable [_images].
    _images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    final AnuncioModel anuncio =
        widget.anuncio; // Obtener el anuncio desde los parámetros del widget

    return Padding(
      padding: const EdgeInsets.all(20), // Padding exterior del widget
      child: SizedBox(
        width: 400,
        height: 200,
        child: InkWell(
          onTap: () {
            // Navegar a la pantalla de detalles del anuncio al hacer tap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => AnuncioScreen(
                  anuncio: anuncio,
                  images:
                      _images, // Pasar el anuncio y las imágenes a la pantalla de detalles
                ),
              ),
            );
          },
          onHover: (isHovered) {
            if (isHovered) {
              _startTimer(); // Iniciar temporizador cuando se detecta hover
            } else {
              _timer
                  ?.cancel(); // Cancelar temporizador cuando se deja de hacer hover
            }
          },
          child: _images
                  .isNotEmpty // Verificar si hay imágenes para mostrar en el anuncio
              ? AnimatedSwitcher(
                  duration: const Duration(
                      milliseconds:
                          500), // Duración de la animación al cambiar imágenes
                  child: FadeTransition(
                    key: ValueKey<int>(
                        _currentImageIndex), // Clave para gestionar la transición de imágenes
                    opacity: const AlwaysStoppedAnimation(
                        1), // Animación de opacidad constante
                    child: Container(
                      margin: const EdgeInsets.all(
                          10), // Margen interior del contenedor principal
                      padding: const EdgeInsets.all(
                          5), // Padding interior del contenedor principal
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(_images[
                              _currentImageIndex]), // Imagen del anuncio desde la red
                          fit: BoxFit
                              .fill, // Ajuste de la imagen dentro del contenedor
                        ),
                        color: Colors.black12, // Color de fondo del contenedor
                        borderRadius: BorderRadius.circular(
                            10), // Borde redondeado del contenedor
                        boxShadow: const [
                          BoxShadow(
                            color: Color(
                                0x000005cc), // Color y transparencia de la sombra
                            blurRadius: 30, // Radio de desenfoque de la sombra
                            offset:
                                Offset(10, 10), // Desplazamiento de la sombra
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom:
                                10), // Padding en la parte inferior del contenedor
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              left: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .black38, // Color de fondo del contenedor del botón de edición
                                  borderRadius: BorderRadius.circular(
                                      20), // Borde redondeado del contenedor
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white), // Ícono de edición
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
                                  color: Colors
                                      .black38, // Color de fondo del contenedor del botón de eliminación
                                  borderRadius: BorderRadius.circular(
                                      20), // Borde redondeado del contenedor
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color:
                                          Colors.white), // Ícono de eliminación
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
                                  color: Colors
                                      .black54, // Color de fondo del contenedor de texto
                                  borderRadius: BorderRadius.circular(
                                      10), // Borde redondeado del contenedor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5,
                                      left:
                                          6), // Padding interior del contenedor de texto
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis
                                        .vertical, // Dirección de desplazamiento del texto
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          anuncio.titulo, // Título del anuncio
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            fontFamily: 'Calibri-Bold',
                                            color: Colors
                                                .white, // Color del texto del título
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
                  'Este Anuncio no tiene Imagenes'), // Mensaje si no hay imágenes para mostrar
        ),
      ),
    );
  }
}
