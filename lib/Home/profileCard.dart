// ignore_for_file: use_full_hex_values_for_flutter_colors, file_names

import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Contenedor que envuelve la tarjeta de perfil.
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFF2F0F2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      // Fila que contiene elementos si el usuario no ha iniciado sesión.
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 38,
              height: 38,
              color: primaryColor,
              child: const Icon(
                Icons.login,
                color: Colors.white,
              ),
            ),
          ),
          if (!Responsive.isMobile(context))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text("Iniciar Sesión"),
            ),
        ],
      ),
    );
  }
}
