// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sedeModel.dart';
import '../source.dart';

class UnidadProduccionModel {
  final int id;
  final String nombre;
  final String logo;
  final String descripccion;
  final bool estado;
  final SedeModel sede;

  UnidadProduccionModel({
    required this.id,
    required this.nombre,
    required this.logo,
    required this.descripccion,
    required this.estado,
    required this.sede,
  });
}

// Lista para almacenar las instancias de las unidades de produccion

List<UnidadProduccionModel> unidadesProduccion = [];

// Futuro para traer los datos de la api

Future<List<UnidadProduccionModel>> getUndadesProduccion() async {
  String url = "";

  url = "$sourceApi/api/unidades-produccion/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    unidadesProduccion.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var unidadProduccionData in decodedData) {
      unidadesProduccion.add(
        UnidadProduccionModel(
          id: unidadProduccionData['id'] ?? 0,
          nombre: unidadProduccionData['nombre'] ?? "",
          logo: unidadProduccionData['logo'] ?? "",
          descripccion: unidadProduccionData['descripcion'] ?? "",
          estado: unidadProduccionData['estado'] ?? true,
          sede: SedeModel(
            id: unidadProduccionData['sede']['id'] ?? 0,
            nombre: unidadProduccionData['sede']['nombre'] ?? "",
            ciudad: unidadProduccionData['sede']['ciudad'] ?? "",
            departamento: unidadProduccionData['sede']['departamento'] ?? "",
            regional: unidadProduccionData['sede']['regional'] ?? "",
            direccion: unidadProduccionData['sede']['direccion'] ?? "",
            telefono1: unidadProduccionData['sede']['telefono1'] ?? "",
            telefono2: unidadProduccionData['sede']['telefono2'] ?? "",
            correo: unidadProduccionData['sede']['correo'] ?? "",
            longitud: unidadProduccionData['sede']['longitud'] ?? "",
            latitud: unidadProduccionData['sede']['latitud'] ?? "",
          ),
        ),
      );
    }

    // Devolver la lista llena
    
    return unidadesProduccion;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
