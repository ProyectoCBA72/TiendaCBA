// ignore_for_file: prefer_final_fields, file_names, use_super_parameters, library_private_types_in_public_api

import 'dart:async';
import 'package:tienda_app/Details/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Esta clase representa un widget de tarjeta de producto.
///
/// Consiste en un [StatefulWidget] que muestra una tarjeta con las imágenes
/// del producto y algunos detalles del mismo. El widget acepta dos parámetros,
/// [images] y [producto], que son obligatorios.
class ProductoCardLider extends StatefulWidget {
  /// Lista de imágenes del producto.
  final List<String> images;

  /// Objeto que representa el modelo del producto.
  final ProductoModel producto;

  /// Constructor que crea un nuevo objeto [ProductoCardLider].
  ///
  /// Los parámetros [key] y [images] son obligatorios.
  const ProductoCardLider(
      {Key? key, required this.images, required this.producto})
      : super(key: key);

  /// Sobrecarga del método [createState] para crear un nuevo estado [_ProductoCardLiderState].
  @override
  _ProductoCardLiderState createState() => _ProductoCardLiderState();
}

class _ProductoCardLiderState extends State<ProductoCardLider> {
  /// Índice de la imagen actual mostrada en la tarjeta.
  int _currentImageIndex = 0;

  /// Referencia al temporizador que se utiliza para cambiar las imágenes de la tarjeta.
  Timer? _timer;

  /// Lista de imágenes de la tarjeta.
  ///
  /// Este campo es privado y se utiliza para almacenar las imágenes que se van
  /// mostrando en la tarjeta.
  List<String> _images = [];

  /// Variable que indica si el producto está en oferta.
  ///
  /// Esta variable se utiliza para mostrar o no el texto 'En oferta' en la tarjeta.
  /// Por defecto, está en true, lo que significa que el producto está en oferta.
  bool _isOnSale = true;

  @override

  /// Método que se ejecuta cuando el estado de la tarjeta es inicializado.
  ///
  /// Este método llama al método [super.initState] para inicializar el estado
  /// de la superclase y luego llama al método [_loadImages] para cargar las
  /// imágenes de la tarjeta.
  @override
  void initState() {
    // Inicializar el estado de la superclase
    super.initState();

    // Cargar las imágenes de la tarjeta
    _loadImages();
  }

  @override

  /// Llama al método [dispose] del controlador de pestañas.
  ///
  /// Este método se llama automáticamente cuando el widget se elimina del árbol de widgets.
  /// Libera los recursos utilizados por el controlador de pestañas.
  @override
  void dispose() {
    // Cancela el temporizador si todavía está activo
    _timer?.cancel();

    // Llama al método [dispose] del padre para liberar recursos adicionales
    super.dispose();
  }

  /// Inicia un temporizador que cambia la imagen actual cada 3 segundos.
  ///
  /// Cada vez que el temporizador se activa, se actualiza el estado del widget
  /// para mostrar la siguiente imagen en la lista de imágenes. El índice de la imagen
  /// se incrementa en uno y se reinicia a 0 cuando alcanza el final de la lista.
  void _startTimer() {
    // Se crea un temporizador que se ejecuta cada 3 segundos
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Se actualiza el estado del widget para mostrar la siguiente imagen en la lista
      setState(() {
        // Se incrementa el índice de la imagen actual y se reinicia a 0 si se alcanza el final de la lista
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  /// Carga las imágenes del widget padre al estado local.
  ///
  /// Esto se llama en el método [initState] para inicializar el estado del widget
  /// con las imágenes proporcionadas por el widget padre.
  void _loadImages() {
    // Asigna la lista de imágenes proporcionadas por el widget a la variable [_images].
    _images = widget.images;
  }

  @override

  /// Construye el widget de la tarjeta del producto.
  /// Este widget incluye una imagen del producto, su nombre, precio y botones de acción.
  Widget build(BuildContext context) {
    final producto =
        widget.producto; // Se obtiene el producto desde el widget padre.
    return Padding(
      padding: const EdgeInsets.all(20), // Espacio alrededor del widget
      child: SizedBox(
        width: 400, // Ancho de la tarjeta
        height: 200, // Altura de la tarjeta
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => DetailsScreen(
                          producto:
                              producto, // Se pasa el producto a la pantalla de detalles
                        )));
          },
          onHover: (isHovered) {
            if (isHovered) {
              _startTimer(); // Inicia el temporizador al pasar el mouse por encima
            } else {
              _timer
                  ?.cancel(); // Cancela el temporizador cuando el mouse se aleja
            }
          },
          child: Stack(
            children: [
              // Cambio de imagen con animación
              AnimatedSwitcher(
                duration: const Duration(
                    milliseconds: 500), // Duración de la animación
                child: FadeTransition(
                  key: ValueKey<int>(
                      _currentImageIndex), // Clave única para la animación
                  opacity:
                      const AlwaysStoppedAnimation(1), // Animación de opacidad
                  child: Container(
                    margin: const EdgeInsets.all(
                        10), // Espacio alrededor del contenedor
                    padding: const EdgeInsets.all(
                        5), // Espacio interno del contenedor
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            _images[_currentImageIndex]), // Imagen del producto
                        fit: BoxFit.fill, // Ajuste de la imagen
                      ),
                      color: Colors.black12,
                      borderRadius:
                          BorderRadius.circular(10), // Bordes redondeados
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x000005cc), // Color de la sombra
                          blurRadius: 30, // Radio de desenfoque de la sombra
                          offset: Offset(10, 10), // Posición de la sombra
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10), // Espacio en la parte inferior
                      child: Stack(
                        children: [
                          // Botón de editar
                          Positioned(
                            top: 5,
                            left: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .black38, // Color de fondo del contenedor
                                borderRadius: BorderRadius.circular(
                                    20), // Bordes redondeados
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.white), // Icono del botón
                                onPressed: () {
                                  // Acción al presionar el botón de editar
                                },
                              ),
                            ),
                          ),
                          // Botón de eliminar
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .black38, // Color de fondo del contenedor
                                borderRadius: BorderRadius.circular(
                                    20), // Bordes redondeados
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white), // Icono del botón
                                onPressed: () {
                                  // Acción al presionar el botón de eliminar
                                },
                              ),
                            ),
                          ),
                          // Información del producto
                          Positioned(
                            bottom: 6,
                            left: 5,
                            child: Container(
                              width: 200, // Ancho del contenedor de información
                              height:
                                  100, // Altura del contenedor de información
                              decoration: BoxDecoration(
                                color: Colors
                                    .black54, // Color de fondo del contenedor
                                borderRadius: BorderRadius.circular(
                                    10), // Bordes redondeados
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    10), // Espacio interno del contenedor
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Alineación horizontal
                                  children: [
                                    // Nombre del producto
                                    Text(
                                      producto.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Calibri-Bold',
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            5), // Espacio entre el nombre y el precio
                                    // Precio del producto
                                    Text(
                                      _isOnSale
                                          ? '\$${formatter.format(producto.precioOferta)}' // Precio en oferta
                                          : '\$${formatter.format(producto.precio)}', // Precio regular
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _isOnSale
                                            ? Colors
                                                .white // Color del precio en oferta
                                            : Colors
                                                .red, // Color del precio regular
                                        decoration: _isOnSale
                                            ? null // Sin decoración si está en oferta
                                            : TextDecoration
                                                .lineThrough, // Línea a través del precio regular
                                      ),
                                    ),
                                    // Indicador de oferta
                                    if (_isOnSale)
                                      const Text(
                                        "Oferta!",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}
