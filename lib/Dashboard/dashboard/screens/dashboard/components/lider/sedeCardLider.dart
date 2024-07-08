// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';
import 'package:tienda_app/Models/sedeModel.dart';
import 'package:tienda_app/Sede/sedeScreen.dart';
import 'package:flutter/material.dart';

/// Widget que muestra una tarjeta de sede en la pantalla de un líder con imágenes y detalles al hacer clic.
///
/// Esta clase extiende [StatefulWidget] y tiene dos parámetros obligatorios:
/// [sede] que representa la información de la sede y [imagenes] que es una lista de
/// las imágenes de la sede.
class SedeCardLider extends StatefulWidget {
  /// Representa la información de la sede.
  final SedeModel sede;

  /// Representa la lista de imágenes de la sede.
  final List<String> images;

  /// Constructor del widget que recibe la información de la sede y las imágenes.
  const SedeCardLider({super.key, required this.sede, required this.images});

  /// Crea un estado [_SedeCardLiderState] para manejar los datos de la pantalla.
  @override
  _SedeCardLiderState createState() => _SedeCardLiderState();
}

class _SedeCardLiderState extends State<SedeCardLider> {
  /// Índice de la imagen actual en [_images].
  ///
  /// Es utilizado para mostrar la imagen correspondiente en la tarjeta.
  int _currentImageIndex = 0;

  /// Represents the timer that changes the images in the background of the screen.
  ///
  /// It changes the image every 3 seconds. If the last image is reached, it goes back
  /// to the first one.
  Timer? _timer;

  /// List of images to be displayed in the card.
  ///
  /// It is loaded from the server and stored here between changes.
  List<String> _images = [];

  @override

  /// Initializes the state of the widget.
  ///
  /// This is called automatically when the widget is inserted into the tree.
  /// It is responsible for loading the images of the sede.
  @override
  void initState() {
    // Call the superclass's initState method
    super.initState();

    // Load the images of the sede
    _loadImages();
  }

  @override

  /// Libera los recursos utilizados por el widget.
  ///
  /// Este método se llama automáticamente cuando el widget se elimina del árbol.
  /// Es responsable de liberar los recursos utilizados por el temporizador.
  @override
  void dispose() {
    // Cancela el temporizador si todavía está activo
    _timer?.cancel();

    // Llama al método [dispose] del padre para liberar recursos adicionales
    super.dispose();
  }

  /// Inicia un temporizador que cambia la imagen actual cada 3 segundos.
  ///
  /// Se encarga de actualizar el índice de la imagen actual y reiniciarlo a 0 cuando se alcanza el final de la lista.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  /// Carga las imágenes de la sede.
  ///
  /// Este método se encarga de cargar las imágenes de la sede. Se llama en el método [initState] de la clase [_SedeCardLiderState]. La lista de imágenes se asigna al atributo [_images].
  ///
  /// No devuelve nada.
  void _loadImages() {
    // Asigna la lista de imágenes proporcionadas por el widget a la variable [_images].
    _images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    final sede = widget.sede; // Obtiene la sede del widget padre
    return Padding(
      padding:
          const EdgeInsets.all(20), // Añade padding alrededor de la tarjeta
      child: SizedBox(
        width: 400,
        height: 200,
        child: InkWell(
          onTap: () {
            // Navega a SedeScreen al hacer tap en la tarjeta
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => SedeScreen(
                  imagenes: _images, // Pasa la lista de imágenes
                  sede: sede, // Pasa la sede
                ),
              ),
            );
          },
          onHover: (isHovered) {
            // Inicia o cancela el temporizador al pasar el cursor sobre la tarjeta
            if (isHovered) {
              _startTimer(); // Inicia el temporizador
            } else {
              _timer?.cancel(); // Cancela el temporizador
            }
          },
          child: AnimatedSwitcher(
            duration: const Duration(
                milliseconds: 500), // Duración de la animación de cambio
            child: FadeTransition(
              key: ValueKey<int>(_currentImageIndex), // Clave para la animación
              opacity:
                  const AlwaysStoppedAnimation(1), // Opacidad de la transición
              child: Container(
                margin:
                    const EdgeInsets.all(10), // Margen alrededor del contenedor
                padding:
                    const EdgeInsets.all(5), // Padding interno del contenedor
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        _images[_currentImageIndex]), // Imagen de la lista
                    fit: BoxFit.fill, // Ajuste de la imagen
                  ),
                  color: Colors.black12, // Color de fondo
                  borderRadius: BorderRadius.circular(10), // Borde redondeado
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x000005cc), // Color de la sombra
                      blurRadius: 30, // Radio de desenfoque de la sombra
                      offset: Offset(10, 10), // Desplazamiento de la sombra
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10), // Padding en la parte inferior
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38, // Color de fondo del botón
                            borderRadius:
                                BorderRadius.circular(20), // Borde redondeado
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.white), // Icono de edición
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
                            color: Colors.black38, // Color de fondo del botón
                            borderRadius:
                                BorderRadius.circular(20), // Borde redondeado
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.white), // Icono de eliminación
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
                            borderRadius:
                                BorderRadius.circular(10), // Borde redondeado
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5,
                                left: 6), // Padding interno del contenedor
                            child: SingleChildScrollView(
                              scrollDirection: Axis
                                  .vertical, // Permite el desplazamiento vertical
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    sede.nombre, // Nombre de la sede
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold, // Texto en negrita
                                      fontSize: 20, // Tamaño de fuente
                                      fontFamily:
                                          'Calibri-Bold', // Fuente específica
                                      color: Colors.white, // Color del texto
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
