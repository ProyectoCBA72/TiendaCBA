// ignore_for_file: use_full_hex_values_for_flutter_colors, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const primaryColor = Colors.green;

const background1 = Color(0xFFFF2F0F2);

const botonClaro = Color(0xFF00FF00);

const botonOscuro = Color(0xFF008000);

const botonSombra = Color(0xFF32CD32);

const secondaryColor = Color(0xFF000000);

const defaultPadding = 16.0;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  canvasColor: secondaryColor,
  // Ignorar el uso de miembros obsoletos, ya que se ha migrado a un nuevo enfoque.
  // ignore: deprecated_member_use
  scaffoldBackgroundColor: Colors.white,
  // Definición del tema para el cajón de navegación.
  drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFFF2F0F2)),
  // Configuración del tema de texto utilizando Google Fonts con el color principal.
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        color: primaryColor),
    displayMedium: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        color: primaryColor),
    displaySmall: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        color: primaryColor),
    headlineLarge: TextStyle(
        fontFamily: 'Calibri-Bold',
        fontWeight: FontWeight.bold,
        color: primaryColor),
    headlineMedium: TextStyle(
        fontFamily: 'Calibri-Bold',
        fontWeight: FontWeight.bold,
        color: primaryColor),
    headlineSmall: TextStyle(
        fontFamily: 'Calibri-Bold',
        fontWeight: FontWeight.bold,
        color: primaryColor),
    titleLarge: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        color: primaryColor),
    titleMedium: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        color: primaryColor),
    titleSmall: TextStyle(
        fontFamily: 'Calibri-Italic',
        fontStyle: FontStyle.italic,
        color: Colors.grey),
    bodyLarge: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        color: primaryColor),
    bodyMedium: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        color: primaryColor),
    bodySmall: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        color: primaryColor),
    labelLarge: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        color: primaryColor),
    labelMedium: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        color: primaryColor),
    labelSmall: TextStyle(
        fontFamily: 'Calibri-Light',
        fontWeight: FontWeight.w300,
        color: primaryColor),
  ),
  // Configuración del tema de botón elevado con el color principal.
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(primaryColor),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return primaryColor; // Color de fondo cuando está seleccionado
      }
      return Colors.transparent; // Color de fondo cuando no está seleccionado
    }),
  ),
  // Configuración del tema del botón flotante de acción con colores específicos.
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFF2F0F2), foregroundColor: primaryColor),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: primaryColor,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: primaryColor), // Color del borde cuando no está enfocado
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: primaryColor), // Color del borde cuando está enfocado
    ),
  ),
);

NumberFormat formatter = NumberFormat.currency(
  locale: 'es_CO', // Español Colombia
  symbol: '', // Símbolo de pesos colombianos
  decimalDigits: 2, // Número de decimales
);

String twoDigits(int n) => n.toString().padLeft(2, '0');

// formato para las fechas para no estar a cada rato haciendolo
String formatFechaHora(String fechaString) {
  try {
    DateTime fecha = DateTime.parse(fechaString);
    return '${twoDigits(fecha.day)}-${twoDigits(fecha.month)}-${fecha.year} ${twoDigits(fecha.hour)}:${twoDigits(fecha.minute)}';
  } catch (e) {
    return 'Fecha inválida';
  }
}
