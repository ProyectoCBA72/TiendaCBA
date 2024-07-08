// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import "../source.dart";

/// Clase que representa una sede en la aplicación.
///
/// Esta clase contiene los atributos necesarios para representar una sede.
/// Una sede es un registro de una sede en la aplicación.
class SedeModel {
  /// Identificador único de la sede.
  final int id;

  /// Nombre de la sede.
  final String nombre;

  /// Ciudad donde se encuentra la sede.
  final String ciudad;

  /// Departamento donde se encuentra la sede.
  final String departamento;

  /// Regional donde se encuentra la sede.
  final String regional;

  /// Dirección de la sede.
  final String direccion;

  /// Teléfono 1 de la sede.
  final String telefono1;

  /// Teléfono 2 de la sede (opcional).
  final String telefono2;

  /// Correo electrónico de la sede.
  final String correo;

  /// Latitud de la sede.
  final String latitud;

  /// Longitud de la sede.
  final String longitud;

  /// Crea una nueva instancia de [SedeModel].
  ///
  /// Los parámetros deben ser obligatorios y no pueden ser null.
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

/// Lista que almacena las instancias de [SedeModel].
///
/// Esta lista se utiliza para almacenar y acceder a los datos de las
/// sedes obtenidas de la API. Cada sede representa una ubicación física
/// donde se realiza la venta de productos.
List<SedeModel> sedes = [];

// Método para obtener los datos de las sedes
Future<List<SedeModel>> getSedes() async {
  /// URL para obtener las sedes de la API.
  ///
  /// Esta URL se utiliza para hacer una solicitud GET a la API y obtener
  /// los datos de las sedes.
  String url = "";

  // Construir la URL completa para obtener las sedes
  url = "$sourceApi/api/sedes/";

  /// Realiza una solicitud GET a la URL de la API para obtener los datos de las sedes.
  ///
  /// Esta función utiliza la biblioteca http de Dart para realizar la solicitud GET.
  /// La respuesta de la solicitud se almacena en la variable [response].
  final response = await http.get(Uri.parse(url));

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    sedes.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de sedes con datos decodificados
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
    // Lanzar una excepción si la respuesta no es exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
