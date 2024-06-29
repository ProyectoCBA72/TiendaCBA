// ignore_for_file: file_names

import 'dart:math';

String generateRandomCode() {
  final random = Random();
  String code = '';
  for (int i = 0; i < 6; i++) {
    code += random.nextInt(10).toString();
  }
  return code;
}
