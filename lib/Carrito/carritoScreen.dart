// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/Carrito/source/carritoBodyScreen.dart';
import '../Home/profileCard.dart';
import '../constantsDesign.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/img/tienda.jpg',
            fit: BoxFit.cover,
          ),

          // Capa verde semitransparente
          Container(
            color: primaryColor.withOpacity(
                0.5), // Ajusta el nivel de opacidad según sea necesario
            width: double.infinity,
            height: double.infinity,
          ),

          Positioned(
            top: 40,
            left: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: background1,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const ProfileCard(),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 110,
            left: 0,
            right: 0,
            bottom: 0,
            child: CarritoBodyScreen(),
          ),
        ],
      ),
    );
  }
}
