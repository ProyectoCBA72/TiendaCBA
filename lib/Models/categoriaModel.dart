// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';

/// Clase que representa una categoría en la aplicación.
///
/// Esta clase contiene los atributos necesarios para representar una categoría.
class CategoriaModel {
  /// Identificador único de la categoría.
  final int id;

  /// Nombre de la categoría.
  final String nombre;

  /// Ruta de la imagen de la categoría.
  final String imagen;

  /// Icono de la categoría.
  final String icono;

  /// Crea una nueva instancia de [CategoriaModel].
  ///
  /// Los parámetros [id], [nombre], [imagen] y [icono] son obligatorios
  /// y se utilizan para inicializar los atributos de la categoría.
  CategoriaModel({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.icono,
  });
}

/// Lista de [CategoriaModel] que representan las categorías cargadas en la aplicación.
///
/// Esta lista se utiliza para almacenar y acceder a las instancias de [CategoriaModel]
/// que representan las categorías cargadas en la aplicación.
List<CategoriaModel> categorias = [];

// Método para obtener los datos de las categorías
Future<List<CategoriaModel>> getCategorias() async {
  // URL base para obtener las categorías
  // Se utiliza para concatenar con la ruta de la API
  String url = "";

  // Concatenar la URL base con la ruta de la API para obtener las categorías
  url = "$sourceApi/api/categorias/";

  /// Obtener las categorías a través de una solicitud HTTP GET.
  ///
  /// Este método realiza una solicitud GET a la URL especificada
  /// para obtener la lista de categorías disponibles en la aplicación.
  ///
  /// Devuelve una [Future] que se resuelve con la lista de [CategoriaModel]
  /// si la solicitud es exitosa, de lo contrario lanza una excepción.
  final response = await http.get(
    Uri.parse(url), // URL a la que se realiza la solicitud HTTP GET
  );

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    categorias.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de categorías con los datos decodificados
    for (var categoriaData in decodedData) {
      categorias.add(
        CategoriaModel(
          id: categoriaData['id'] ?? 0,
          nombre: categoriaData['nombre'] ?? "",
          imagen: categoriaData['imagen'] ?? "",
          icono: categoriaData['icono'] ?? "",
        ),
      );
    }

    // Devolver la lista de categorias
    return categorias;
  } else {
    // Lanzar una excepción si la respuesta no es exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
