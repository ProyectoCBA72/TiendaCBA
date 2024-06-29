// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:cryptography/cryptography.dart';

// ignore: non_constant_identifier_names
Future encrypt() async {
  final algorithm = Argon2id(
    memory: 10 * 1000, // 10 MB
    parallelism: 2, // Use maximum two CPU cores .
    iterations:
        1, 
    hashLength: 256, 
  );

  final secretKey = await algorithm.deriveKeyFromPassword(
    password: 'Diego12345',
    nonce: [1, 2, 3],
  );
  final secretKeyBytes = await secretKey.extractBytes();

  final secretKeyBase64 = base64Encode(secretKeyBytes);
  print(secretKeyBase64);
  return secretKeyBase64;
}
