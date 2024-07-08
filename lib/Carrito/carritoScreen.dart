// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/Carrito/source/carritoBodyScreen.dart';
import '../Home/profileCard.dart';
import '../constantsDesign.dart';

/// Esta clase representa la pantalla de carrito de la aplicación.
///
/// Esta clase extiende [StatefulWidget] y se utiliza para mostrar la pantalla de carrito.
class CarritoScreen extends StatefulWidget {
  /// Constructor de la clase [CarritoScreen].
  ///
  /// El parámetro [key] es opcional y se utiliza para identificar el widget en la árbol de widgets.
  const CarritoScreen({super.key});

  /// Retorna el estado de la pantalla de carrito.
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
          // Imagen de fondo del carrito
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

          // Botón de retroceso en la parte superior izquierda
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

          // Tarjeta de perfil en la parte superior derecha
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

          // Cuerpo del carrito
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
