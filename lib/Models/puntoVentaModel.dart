// ignore_for_file: file_names

import 'dart:convert';
import '../source.dart';
import 'package:http/http.dart' as http;

class PuntoVentaModel {
  final int id;
  final String nombre;
  final String ubicacion;
  final bool estado;
  final int sede;

  PuntoVentaModel({
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.estado,
    required this.sede,
  });
}

List<PuntoVentaModel> puntosVenta = [];

// Futuro para traer los datos de la api

Future<List<PuntoVentaModel>> getPuntosVenta() async {
  String url = "";

  url = "$sourceApi/api/puntos-venta/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    puntosVenta.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var puntoVentaData in decodedData) {
      puntosVenta.add(
        PuntoVentaModel(
          id: puntoVentaData['id'] ?? 0,
          nombre: puntoVentaData['nombre'] ?? "",
          ubicacion: puntoVentaData['ubicacion'] ?? "",
          estado: puntoVentaData['estado'] ?? true,
          sede: puntoVentaData['sede'] ?? 0,
        ),
      );
    }
    // Devolver la lista de puntos de venta
    return puntosVenta;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
