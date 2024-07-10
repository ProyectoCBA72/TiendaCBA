// ignore_for_file: prefer_final_fields, file_names, use_super_parameters, library_private_types_in_public_api

import 'dart:async';
import 'package:tienda_app/Details/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Widget para mostrar la tarjeta de un producto individual.
class ProductoCardUnidad extends StatefulWidget {
  final List<String> images; // Lista de URLs de imágenes del producto
  final ProductoModel producto; // Modelo del producto a mostrar

  const ProductoCardUnidad({
    Key? key,
    required this.images,
    required this.producto,
  }) : super(key: key);

  @override
  _ProductoCardUnidadState createState() => _ProductoCardUnidadState();
}

class _ProductoCardUnidadState extends State<ProductoCardUnidad> {
  int _currentImageIndex = 0; // Índice de la imagen actual en la lista
  Timer? _timer; // Temporizador para cambiar automáticamente la imagen
  List<String> _images = []; // Lista local de imágenes

  bool _isOnSale = true; // Indica si el producto está en oferta

  @override
  void initState() {
    super.initState();
    _loadImages(); // Carga las imágenes al inicializarse
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela el temporizador al destruir el widget
    super.dispose();
  }

  /// Carga las imágenes del widget padre al estado local.
  void _loadImages() {
    _images = widget.images;
  }

  /// Inicia el temporizador para cambiar automáticamente la imagen cada 3 segundos.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
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
                builder: (builder) => DetailsScreen(
                  producto: producto,
                ),
              ),
            );
          },
          onHover: (isHovered) {
            if (isHovered) {
              _startTimer(); // Inicia el temporizador al pasar el ratón sobre la tarjeta
            } else {
              _timer?.cancel(); // Cancela el temporizador al dejar de pasar el ratón sobre la tarjeta
            }
          },
          child: Stack(
            children: [
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
                                  // Acción al presionar el botón de editar (favorito)
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
                                  // Acción al presionar el botón de eliminar (carrito de compra)
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
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                    Text(
                                      _isOnSale
                                          ? '\$${formatter.format(producto.precioOferta)}'
                                          : '\$${formatter.format(producto.precio)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _isOnSale ? Colors.white : Colors.red,
                                        decoration: _isOnSale ? null : TextDecoration.lineThrough,
                                      ),
                                    ),
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

