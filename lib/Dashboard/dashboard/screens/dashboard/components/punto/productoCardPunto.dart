// ignore_for_file: prefer_final_fields, file_names, use_super_parameters, library_private_types_in_public_api

import 'dart:async';
import 'package:tienda_app/Details/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ProductoCardPunto extends StatefulWidget {
  final ProductoModel producto;
  final List<String> images;

  const ProductoCardPunto({
    Key? key,
    required this.producto,
    required this.images,
  }) : super(key: key);

  @override
  _ProductoCardPuntoState createState() => _ProductoCardPuntoState();
}

class _ProductoCardPuntoState extends State<ProductoCardPunto> {
  int _currentImageIndex = 0; // Índice de la imagen actual que se muestra
  Timer? _timer; // Temporizador para cambiar automáticamente las imágenes
  List<String> _images = []; // Lista de imágenes del producto

  bool _isOnSale = true; // Variable que indica si el producto está en oferta

  @override
  void initState() {
    super.initState();
    _loadImages(); // Carga las imágenes iniciales del widget
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela el temporizador al destruir el widget
    super.dispose();
  }

  void _startTimer() {
    // Inicia un temporizador que cambia la imagen cada 3 segundos
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length; // Cambia al siguiente índice de imagen
      });
    });
  }

  void _loadImages() {
    // Carga las imágenes del widget desde widget.images al estado local _images
    _images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto; // Obtiene el objeto ProductoModel desde los parámetros widget
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        height: 200,
        child: InkWell(
          onTap: () {
            // Navega a la pantalla de detalle del producto al hacer tap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => DetailsScreen(producto: producto),
              ),
            );
          },
          onHover: (isHovered) {
            // Inicia o cancela el temporizador según el hover del usuario sobre la tarjeta
            if (isHovered) {
              _startTimer();
            } else {
              _timer?.cancel();
            }
          },
          child: Stack(
            children: [
              // Widget que maneja las animaciones y transiciones entre las imágenes
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
                        image: NetworkImage(_images[_currentImageIndex]), // Obtiene la imagen actual desde _images
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
                          // Botón de edición en la esquina superior izquierda
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
                                  // Acción al presionar el botón de edición (a implementar)
                                },
                              ),
                            ),
                          ),
                          // Botón de eliminación en la esquina superior derecha
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
                                  // Acción al presionar el botón de eliminación (a implementar)
                                },
                              ),
                            ),
                          ),
                          // Contenedor con información del producto en la parte inferior
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
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    const SizedBox(height: 5),
                                    // Precio del producto (normal o en oferta)
                                    Text(
                                      _isOnSale
                                          ? "\$${formatter.format(producto.precioOferta)}"
                                          : "\$${formatter.format(producto.precio)}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _isOnSale ? Colors.white : Colors.red,
                                        decoration:
                                            _isOnSale ? null : TextDecoration.lineThrough,
                                      ),
                                    ),
                                    // Etiqueta de "Oferta" si el producto está en oferta
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

