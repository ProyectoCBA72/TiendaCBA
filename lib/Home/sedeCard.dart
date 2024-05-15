// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';
import 'package:tienda_app/Sede/sedeScreen.dart';
import 'package:flutter/material.dart';

class SedeCard extends StatefulWidget {
  const SedeCard({super.key});

  @override
  _SedeCardState createState() => _SedeCardState();
}

class _SedeCardState extends State<SedeCard> {
  int _currentImageIndex = 0;
  Timer? _timer;
  final List<String> _images = [
    'https://i.ytimg.com/vi/UMBALomvR1Y/hqdefault.jpg',
    'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgGbwguyMNuaGlMS987Ez-BzaCGhhIMCK31lDVf1zcksljEozNYfaJJB0f4m_p95QW5sLiL57lGHXpNmAEzzTfueJyn7DHg9t9Sme4SLl29LP-eJdq3qOYD2AZ6xKrRAe-2UAdTEHKyFN0/s1600/Auditorio.JPG',
    'https://pronacon.com.co/wp-content/uploads/2023/03/WhatsApp-Image-2023-03-08-at-4.49.52-PM.jpeg',
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
                MaterialPageRoute(builder: (builder) => const SedeScreen()));
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
                                    "Centro de biotecnología agropecuaria",
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
