// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';
import 'package:tienda_app/Models/sedeModel.dart';
import 'package:tienda_app/Sede/sedeScreen.dart';
import 'package:flutter/material.dart';

/// Widget que representa una tarjeta de una sede en la app.
///
/// Esta clase extiende [StatefulWidget] y tiene dos parámetros obligatorios:
/// [sede] que representa la información de la sede y [imagenes] que es una lista de
/// las imágenes de la sede. El widget tiene un estado [_SedeCardState] que se
/// encarga de manejar los datos de la pantalla.
class SedeCard extends StatefulWidget {
  /// Objeto que representa la sede de la tienda.
  ///
  /// Este atributo es obligatorio y es el modelo que contiene la información de la sede.
  final SedeModel sede;

  /// Lista de imágenes que representa la sede.
  ///
  /// Este atributo es obligatorio y es una lista de las imágenes que se mostrarán en la tarjeta.
  final List<String> imagenes;

  /// Constructor que recibe la sede y las imágenes de la sede.
  ///
  /// El parámetro [sede] es obligatorio y recibe el objeto que representa la sede.
  /// El parámetro [imagenes] es obligatorio y recibe la lista de las imágenes de la sede.
  const SedeCard({super.key, required this.sede, required this.imagenes});

  @override
  _SedeCardState createState() => _SedeCardState();
}

class _SedeCardState extends State<SedeCard> {
  /// Índice de la imagen actual mostrada en la tarjeta.
  ///
  /// Este atributo indica el índice de la imagen actual que se está mostrando en la tarjeta.
  int _currentImageIndex = 0;

  /// Referencia al temporizador que se encarga de cambiar la imagen de la tarjeta.
  ///
  /// Este atributo es una referencia al temporizador que se usa para cambiar la imagen de la tarjeta.
  Timer? _timer;

  /// Lista de imágenes que se mostrarán en la tarjeta.
  ///
  /// Este atributo es la lista de imágenes que se mostrarán en la tarjeta. El atributo se rellena en el método [_loadImages].
  List<String> _images = [];

  @override

  /// Inicializa el estado de la tarjeta de la sede.
  ///
  /// Se llama en el método [initState] de la clase [_SedeCardState]. Se encarga de cargar las imágenes de la sede.
  @override
  void initState() {
    super.initState();

    // Cargar las imágenes de la sede.
    _loadImages();
  }

  @override

  /// Cancela el temporizador si está activo y llama al método [dispose] del widget base.
  ///
  /// Este método se llama en el método [dispose] de la clase [_SedeCardState]. Se encarga de cancelar el temporizador si está activo y llamar al método [dispose] del widget base.
  @override
  void dispose() {
    // Cancela el temporizador si está activo.
    _timer?.cancel();

    // Llama al método [dispose] del widget base.
    super.dispose();
  }

  /// Carga las imágenes de la sede.
  ///
  /// Este método se encarga de cargar las imágenes de la sede. Se llama en el método [initState] de la clase [_SedeCardState]. La lista de imágenes se asigna al atributo [_images].
  ///
  /// No devuelve nada.
  void _loadImages() async {
    // Asigna la lista de imágenes proporcionadas por el widget a la variable [_images].
    _images = widget.imagenes;
  }

  /// Inicia un temporizador que cambia el índice de la imagen actual cada 3 segundos.
  ///
  /// Cada vez que el temporizador se activa, se actualiza el estado del widget
  /// para mostrar la siguiente imagen en la lista de imágenes. El índice de la imagen
  /// se incrementa en uno y se reinicia a 0 cuando alcanza el final de la lista.
  ///
  /// No devuelve nada.
  void _startTimer() {
    // Inicia un temporizador que se ejecuta cada 3 segundos.
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Actualiza el estado del widget para mostrar la siguiente imagen en la lista.
      setState(() {
        // Incrementa el índice de la imagen actual.
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  @override

  /// Widget que muestra una tarjeta de sede con imágenes y detalles al hacer clic.
  ///
  /// Al hacer clic en la tarjeta, navega a la pantalla de detalles de la sede.
  /// Muestra imágenes de manera animada con transiciones de opacidad.
  /// Muestra un indicador de carga cuando las imágenes están siendo cargadas.
  ///
  /// Utiliza [_startTimer] y [_timer] para manejar eventos de hover y cancelar el temporizador.
  ///
  /// Requiere [widget.sede] y [widget.imagenes] para mostrar la información correcta.
  Widget build(BuildContext context) {
    final sede = widget.sede;

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
                builder: (builder) => SedeScreen(
                  imagenes: widget.imagenes,
                  sede: sede,
                ),
              ),
            );
          },
          onHover: (isHovered) {
            if (isHovered) {
              _startTimer(); // Inicia el temporizador cuando el mouse está sobre la tarjeta
            } else {
              _timer
                  ?.cancel(); // Cancela el temporizador cuando el mouse ya no está sobre la tarjeta
            }
          },
          child: Stack(
            children: [
              // Mostrar imágenes con transición animada si _images no está vacío, de lo contrario muestra un indicador de carga
              _images.isNotEmpty
                  ? AnimatedSwitcher(
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
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 6),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              sede.nombre,
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
                  : const Center(
                      child:
                          CircularProgressIndicator()), // Indicador de carga mientras se cargan las imágenes
            ],
          ),
        ),
      ),
    );
  }
}
