// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';

import 'package:tienda_app/Anuncio/anuncioScreen.dart';
import 'package:flutter/material.dart';

class AnuncioCard extends StatefulWidget {
  const AnuncioCard({super.key});

  @override
  _AnuncioCardState createState() => _AnuncioCardState();
}

class _AnuncioCardState extends State<AnuncioCard> {
  int _currentImageIndex = 0;
  Timer? _timer;
  final List<String> _images = [
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/291054585_608787604116674_5459347250647540917_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_ohc=9CpZgunGxXgQ7kNvgEsEiU8&_nc_ht=scontent-bog2-2.xx&oh=00_AYC08wPJP49Mm_7MKrVz5tCUY62v2BBlx9llMRjS0sEGTg&oe=664C87B4',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/290347158_608787637450004_7021336845368539183_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=5f2048&_nc_ohc=DI5OZ4T9EnIQ7kNvgHzWZvD&_nc_ht=scontent-bog2-2.xx&oh=00_AYASPCVujt3prdtWPIdV7XDC3YK7hrW1YlPst2QkhGNC1g&oe=664C87E8',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/290313642_608787627450005_4351049694493049378_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=5f2048&_nc_ohc=UI9LTAh0uckQ7kNvgFLY6eU&_nc_ht=scontent-bog2-2.xx&oh=00_AYBruzjs-541wag9nOqYyxkJkBtTmNPie2P3DapSWoZAJA&oe=664C912A',
  ];

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
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const AnuncioScreen()));
          },
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
                          child: const Padding(
                            padding: EdgeInsets.only(top: 5, left: 6),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Subasta de bovinos por modalidad de sobre",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: 'BakbakOne',
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
