// ignore_for_file: file_names

import 'package:flutter/material.dart';

/// La clase `Tiendacontroller` extiende `ChangeNotifier` y se utiliza para
/// controlar el estado de la tienda.
class Tiendacontroller extends ChangeNotifier {

  /// La cantidad de productos en el carrito.
  int _count = 0;

  /// Retorna la cantidad de productos en el carrito.
  int get count => _count;

  /// Actualiza la cantidad de productos en el carrito y notifica a los
  /// observadores.
  ///
  /// El parámetro [newCount] es el nuevo valor de la cantidad de productos.
  void updateCount(int newCount) {
    _count = newCount;
    notifyListeners();
  }
}
