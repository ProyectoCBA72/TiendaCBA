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
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/291054585_608787604116674_5459347250647540917_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeH_EaJiLzjHCtCKc-3kz8v8BThRk_DJMm4FOFGT8Mkybr0xkliPnsxlu9NY84c4YeleRpj3_4nawfzpz7JZFi-1&_nc_ohc=nkXMMaKtV_EQ7kNvgEeXiaY&_nc_ht=scontent-bog2-2.xx&oh=00_AYA92tgWRsYU18YiwNHtN-EQGBRCkLc47fGj3pWkQdwDrw&oe=6643F5F4',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/290347158_608787637450004_7021336845368539183_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeE4hpIJy5wn0A87ek-7_Hm3YTZGF1pNLzlhNkYXWk0vOaEJpIkzmg3mqkQHqhz_bV3CFSgkBD52bgmceNIO3-Sj&_nc_ohc=bq225GahLXMQ7kNvgFax10O&_nc_ht=scontent-bog2-2.xx&oh=00_AYAy2VZ8cXYfXdtnGveHvOq-CnoTOV8PniJB5HKHam7vFg&oe=6643F628',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/290313642_608787627450005_4351049694493049378_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeGJUV0nds0yuPHVdal6d5DKOQB2pjGWPcA5AHamMZY9wLMarTKjycgFjye-75ujgdL--kBEM3DNTn3UzjVSdGzM&_nc_ohc=5vFWPvNafFwQ7kNvgHPKLjj&_nc_ht=scontent-bog2-2.xx&oh=00_AYBQtllW7hDIce9YzZBqX0mbItNsbV7bdk0TJukRZ_ivRw&oe=6643C72A',
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
