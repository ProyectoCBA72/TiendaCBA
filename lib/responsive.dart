import 'package:flutter/material.dart';

const defaultPadding = 16.0;

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  // Método estático para verificar si el dispositivo es móvil
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  // Método estático para verificar si el dispositivo es una tablet
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 720;

  // Método estático para verificar si el dispositivo es de escritorio
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final Size _size = MediaQuery.of(context).size;

    // Devuelve el widget de escritorio si el ancho es mayor o igual a 1100
    if (_size.width >= 1100) {
      return desktop;
    }
    // Devuelve el widget de tablet si el ancho es mayor o igual a 850 y tablet no es nulo
    else if (_size.width >= 850 && tablet != null) {
      return tablet!;
    }
    // Devuelve el widget móvil en otros casos
    else {
      return mobile;
    }
  }
}
