// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';

import 'package:tienda_app/Anuncio/anuncioScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/anuncioModel.dart';

/// Clase del widget que representa una tarjeta de anuncio.
///
/// Este widget muestra una tarjeta con las imágenes del anuncio y algunos detalles del mismo.
/// La información del anuncio es proporcionada mediante el parámetro [anuncio], que es una instancia de [AnuncioModel].
/// Las imágenes del anuncio son proporcionadas mediante el parámetro [images], que es una lista de cadenas.
class AnuncioCardLider extends StatefulWidget {
  final List<String> images;
  final AnuncioModel anuncio;
  const AnuncioCardLider(
      {super.key, required this.images, required this.anuncio});

  /// Crea un estado del widget para manejar la información de la pantalla.
  @override
  _AnuncioCardLiderState createState() => _AnuncioCardLiderState();
}

class _AnuncioCardLiderState extends State<AnuncioCardLider> {
  /// Índice de la imagen actualmente mostrada en la tarjeta.
  ///
  /// Este índice se utiliza para mostrar la imagen correspondiente en la lista de imágenes del anuncio.
  int _currentImageIndex = 0;

  /// Temporizador que se utiliza para cambiar automáticamente la imagen cada cierto tiempo.
  ///
  /// Este temporizador se encarga de actualizar el índice de la imagen actual en la tarjeta.
  Timer? _timer;

  /// Lista de imágenes del anuncio.
  ///
  /// Esta lista se utiliza para almacenar las imágenes del anuncio que se van a mostrar en la tarjeta.
  /// Es necesario cargar las imágenes de forma asíncrona, por lo que se utiliza una lista separada de la lista proporcionada como parámetro en el constructor.
  List<String> _images = [];

  @override

  /// Método inicializado cuando se crea el estado del widget.
  ///
  /// Este método se llama cuando se crea el estado del widget y se utiliza para inicializar variables o hacer llamadas de función.
  ///
  /// Se llama al método [super.initState()] para asegurarse de que se ejecuten todas las inicializaciones necesarias del widget base.
  /// Después de eso, se llama al método [_loadImages()] para cargar las imágenes del anuncio.
  @override
  void initState() {
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
    // Cancela el temporizador si todavía está activo
    _timer?.cancel();

    // Llama al método [dispose] del widget base
    super.dispose();
  }

  /// Inicia un temporizador que cambia automáticamente la imagen cada 3 segundos.
  ///
  /// Este temporizador se utiliza para cambiar automáticamente la imagen en la tarjeta
  /// cada 3 segundos. Se encarga de actualizar el índice de la imagen actual en la lista
  /// de imágenes y luego llama al método [setState] para actualizar el widget y mostrar
  /// la imagen siguiente.
  ///
  /// No devuelve nada.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  /// Carga las imágenes del anuncio de forma asíncrona.
  ///
  /// Las imágenes se cargan de forma asíncrona en el método [initState]
  /// y se asignan al atributo [_images].
  ///
  /// No devuelve nada.
  void _loadImages() async {
    // Obtiene las imágenes del anuncio del widget y las asigna al atributo _images
    _images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    final AnuncioModel anuncio =
        widget.anuncio; // Obtener el modelo de anuncio desde los widgets
    return Padding(
      padding: const EdgeInsets.all(
          20), // Padding constante para el contenedor principal
      child: SizedBox(
        width: 400, // Ancho constante del contenedor
        height: 200, // Altura constante del contenedor
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => AnuncioScreen(
                          anuncio:
                              anuncio, // Pasar el anuncio a la pantalla de anuncio
                          images:
                              _images, // Pasar las imágenes a la pantalla de anuncio
                        )));
          },
          onHover: (isHovered) {
            if (isHovered) {
              _startTimer(); // Iniciar el temporizador al pasar el mouse sobre el widget
            } else {
              _timer
                  ?.cancel(); // Cancelar el temporizador si el mouse ya no está sobre el widget
            }
          },
          child: _images.isNotEmpty // Verificar si hay imágenes disponibles
              ? AnimatedSwitcher(
                  duration: const Duration(
                      milliseconds: 500), // Duración de la animación de cambio
                  child: FadeTransition(
                    key: ValueKey<int>(
                        _currentImageIndex), // Clave para la transición animada
                    opacity: const AlwaysStoppedAnimation(
                        1), // Animación de opacidad constante
                    child: Container(
                      margin:
                          const EdgeInsets.all(10), // Margen interno constante
                      padding:
                          const EdgeInsets.all(5), // Padding interno constante
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(_images[
                              _currentImageIndex]), // Imagen obtenida de la red
                          fit: BoxFit
                              .fill, // Ajuste de la imagen para llenar el contenedor
                        ),
                        color: Colors.black12, // Color de fondo constante
                        borderRadius: BorderRadius.circular(
                            10), // Borde redondeado constante
                        boxShadow: const [
                          BoxShadow(
                            color: Color(
                                0x000005cc), // Color de la sombra constante
                            blurRadius: 30, // Radio de desenfoque constante
                            offset: Offset(10,
                                10), // Desplazamiento de la sombra constante
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom:
                                10), // Padding constante para la parte inferior
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              left: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .black38, // Color de fondo constante
                                  borderRadius: BorderRadius.circular(
                                      20), // Borde redondeado constante
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                      Icons.edit, // Ícono de edición constante
                                      color: Colors
                                          .white), // Color del ícono constante
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
                                      .black38, // Color de fondo constante
                                  borderRadius: BorderRadius.circular(
                                      20), // Borde redondeado constante
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                      Icons
                                          .delete, // Ícono de eliminación constante
                                      color: Colors
                                          .white), // Color del ícono constante
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
                                width:
                                    200, // Ancho constante del contenedor interno
                                height:
                                    100, // Altura constante del contenedor interno
                                decoration: BoxDecoration(
                                  color: Colors
                                      .black54, // Color de fondo constante
                                  borderRadius: BorderRadius.circular(
                                      10), // Borde redondeado constante
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5,
                                      left:
                                          6), // Padding constante para el contenido
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis
                                        .vertical, // Dirección de desplazamiento vertical constante
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // Alineación cruzada constante
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Alineación principal constante
                                      children: [
                                        Text(
                                          anuncio
                                              .titulo, // Título dinámico del anuncio
                                          style: const TextStyle(
                                            fontWeight: FontWeight
                                                .bold, // Peso de la fuente constante
                                            fontSize:
                                                20, // Tamaño de la fuente constante
                                            fontFamily:
                                                'Calibri-Bold', // Familia de fuente constante
                                            color: Colors
                                                .white, // Color de fuente constante
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
                  'Este Anuncio no tiene Imagenes'), // Mensaje mostrado si no hay imágenes
        ),
      ),
    );
  }
}
