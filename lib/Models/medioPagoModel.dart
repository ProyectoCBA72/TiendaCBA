// ignore_for_file: file_names

import 'dart:convert';
import '../source.dart';
import 'package:http/http.dart' as http;

class MedioPagoModel {
  final int id;
  final String nombre;
  final String detalle;

  MedioPagoModel({
    required this.id,
    required this.nombre,
    required this.detalle,
  });
}

List<MedioPagoModel> mediosPago = [];

// Futuro para traer los datos de la api

Future<List<MedioPagoModel>> getMediosPago() async {
  String url = "";

  url = "$sourceApi/api/medios-pago/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    mediosPago.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var medioPagoData in decodedData) {
      mediosPago.add(
        MedioPagoModel(
          id: medioPagoData['id'] ?? 0,
          nombre: medioPagoData['nombre'] ?? "",
          detalle: medioPagoData['detalle'] ?? "",
        ),
      );
    }

    // Devolver la lista de medios de pago con datos.
    return mediosPago;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
