// ignore_for_file: prefer_final_fields, file_names, use_super_parameters, library_private_types_in_public_api

import 'dart:async';
import 'package:tienda_app/Details/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ProductoCardPunto extends StatefulWidget {
  final ProductoModel producto;
  final List<String> images;
  const ProductoCardPunto(
      {Key? key, required this.producto, required this.images})
      : super(key: key);

  @override
  _ProductoCardPuntoState createState() => _ProductoCardPuntoState();
}

class _ProductoCardPuntoState extends State<ProductoCardPunto> {
  int _currentImageIndex = 0;
  Timer? _timer;
  List<String> _images = [];

  bool _isOnSale = true; // Variable que indica si el producto está en oferta

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

  void _loadImages() {
    _images = widget.images;
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
            
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) =>   DetailsScreen(producto: producto,)));
            
          },
          onHover: (isHovered) {
            if (isHovered) {
              _startTimer();
            } else {
              _timer?.cancel();
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
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  // Acción al presionar el favorito
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
                                  // Acción al presionar el carrito de compra
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
                                    producto.nombre  ,
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
                                          ? "\$${formatter.format(producto.precioOferta)}"
                                          : "\$${formatter.format(producto.precio)}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _isOnSale
                                            ? Colors.white
                                            : Colors.red,
                                        decoration: _isOnSale
                                            ? null
                                            : TextDecoration.lineThrough,
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
