// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sedeModel.dart';
import '../source.dart';

/// Clase que representa una unidad de producción en la aplicación.
///
/// Contiene información como el identificador único, el nombre, el logo, la
/// descripción, el estado y la sede a la que está asociada.
class UnidadProduccionModel {
  /// Identificador único de la unidad de producción.
  final int id;

  /// Nombre de la unidad de producción.
  final String nombre;

  /// Logo de la unidad de producción.
  final String logo;

  /// Descripción de la unidad de producción.
  final String descripccion;

  /// Estado de la unidad de producción.
  final bool estado;

  /// Sede a la que está asociada la unidad de producción.
  final SedeModel sede;

  /// Crea una nueva instancia de la clase [UnidadProduccionModel].
  ///
  /// Los parámetros [id], [nombre], [logo], [descripccion], [estado] y [sede]
  /// son obligatorios.
  UnidadProduccionModel({
    required this.id,
    required this.nombre,
    required this.logo,
    required this.descripccion,
    required this.estado,
    required this.sede,
  });
}

/// Lista que almacena los objetos de tipo [UnidadProduccionModel].
///
/// Esta lista se utiliza para almacenar todas las unidades de producción
/// que se han registrado en la aplicación.
///
/// Cada elemento de la lista es de tipo [UnidadProduccionModel] y representa
/// una unidad de producción con sus atributos correspondientes.
///
/// Por defecto, la lista se inicializa vacía.
List<UnidadProduccionModel> unidadesProduccion = [];

// Método para obtener los datos de las unidades de producción
Future<List<UnidadProduccionModel>> getUndadesProduccion() async {
  /// URL para obtener las unidades de producción de la API.
  ///
  /// Esta URL se utiliza para hacer una solicitud GET a la API y obtener
  /// los datos de las unidades de producción.
  String url = "";

  // Construir la URL completa para obtener las unidades de producción
  url = "$sourceApi/api/unidades-produccion/";

  /// Realiza una solicitud GET a la URL de la API para obtener los datos de las unidades de producción.
  ///
  /// Esta función utiliza la biblioteca http de Dart para realizar la solicitud GET.
  /// La respuesta de la solicitud se almacena en la variable [response].
  final response = await http.get(Uri.parse(url));

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    unidadesProduccion.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos decodificados
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

    // Devolver la lista de unidades de producción
    return unidadesProduccion;
  } else {
    // Lanzar una excepción si la respuesta no fue exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
