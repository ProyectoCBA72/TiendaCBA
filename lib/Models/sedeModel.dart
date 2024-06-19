// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import "../source.dart";

class SedeModel {
  final int id;
  final String nombre;
  final String ciudad;
  final String departamento;
  final String regional;
  final String direccion;
  final String telefono1;
  final String telefono2;
  final String correo;
  final String latitud;
  final String longitud;

  SedeModel({
    required this.id,
    required this.nombre,
    required this.ciudad,
    required this.departamento,
    required this.regional,
    required this.direccion,
    required this.telefono1,
    required this.telefono2,
    required this.correo,
    required this.longitud,
    required this.latitud,
  });
}

// Lista para almacenar las instancias de las sedes

List<SedeModel> sedes = [];

// Futuro para traer los datos de la api

Future<List<SedeModel>> getSedes() async {
  String url = "";

  url = "$sourceApi/api/sedes/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    sedes.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var sedeData in decodedData) {
      sedes.add(
        SedeModel(
          id: sedeData['id'] ?? 0,
          nombre: sedeData['nombre'] ?? "",
          ciudad: sedeData['ciudad'] ?? "",
          departamento: sedeData['departamento'] ?? "",
          regional: sedeData['regional'] ?? "",
          direccion: sedeData['direccion'] ?? "",
          telefono1: sedeData['telefono1'] ?? "",
          telefono2: sedeData['telefono2'] ?? "",
          correo: sedeData['correo'] ?? "",
          latitud: sedeData['latitud'] ?? "",
          longitud: sedeData['longitud'] ?? "",
        ),
      );
    }

    // Devolver la lista de sedes
    return sedes;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
