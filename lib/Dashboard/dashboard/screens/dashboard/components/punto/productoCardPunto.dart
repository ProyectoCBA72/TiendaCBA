// ignore_for_file: prefer_final_fields, file_names, use_super_parameters, library_private_types_in_public_api

import 'dart:async';
import 'package:tienda_app/Details/detailScreen.dart';
import 'package:flutter/material.dart';

class ProductoCardPunto extends StatefulWidget {
  const ProductoCardPunto({Key? key}) : super(key: key);

  @override
  _ProductoCardPuntoState createState() => _ProductoCardPuntoState();
}

class _ProductoCardPuntoState extends State<ProductoCardPunto> {
  int _currentImageIndex = 0;
  Timer? _timer;
  final List<String> _images = [
    'https://definicion.de/wp-content/uploads/2011/02/carne-1.jpg',
    'https://media.gq.com.mx/photos/620bcf7243f71a078a355280/16:9/w_2560%2Cc_limit/carnes-85650597.jpg',
    'https://www.cocinista.es/download/bancorecursos/recetas/cocinar-la-carne-de-vacuno.jpg',
  ];

  bool _isOnSale = true; // Variable que indica si el producto está en oferta

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        height: 200,
        child: InkWell(
          onTap: () {
            /*
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const DetailsScreen()));
            */
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
                                icon: const Icon(Icons.edit,
                                    color: Colors.white),
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
                                    const Text(
                                      "Carne de res",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Calibri-Bold',
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _isOnSale ? "\$ 8.000 COP" : "\$ 11.000 COP",
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


