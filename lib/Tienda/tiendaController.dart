import 'package:flutter/material.dart';

class Tiendacontroller extends ChangeNotifier {

  int _count = 0;

  int get count => _count;

  void updateCount(int newCount) {
    _count = newCount;
    notifyListeners();
  }
}
