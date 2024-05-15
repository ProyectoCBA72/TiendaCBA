// ignore_for_file: use_full_hex_values_for_flutter_colors, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var primaryColor = Colors.green;

var background1 = const Color(0xFFFF2F0F2);

var botonClaro = const Color(0xFF00FF00);

var botonOscuro = const Color(0xFF008000);

var botonSombra = const Color(0xFF32CD32);

const secondaryColor = Color(0xFF000000);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  canvasColor: secondaryColor,
  // Ignorar el uso de miembros obsoletos, ya que se ha migrado a un nuevo enfoque.
  // ignore: deprecated_member_use
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  // Definición del tema para el cajón de navegación.
  drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFFF2F0F2)),
  // Configuración del tema de texto utilizando Google Fonts con el color principal.
  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: primaryColor),
  // Configuración del tema de botón elevado con el color principal.
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(primaryColor),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
    ),
  ),
  // Configuración del tema del botón flotante de acción con colores específicos.
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xFFFF2F0F2), foregroundColor: primaryColor),
);
