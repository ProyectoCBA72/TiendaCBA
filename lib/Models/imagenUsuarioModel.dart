// ignore_for_file: file_names

import 'dart:convert';
import '../source.dart';
import 'package:http/http.dart' as http;

/// Clase que representa una imagen de un usuario.
///
/// Esta clase contiene los atributos necesarios para representar una imagen de un usuario.
class ImagenUsuarioModel {
  /// Identificador único de la imagen.
  final int id;

  /// Ruta de la imagen.
  final String foto;

  /// Identificador del usuario al que pertenece la imagen.
  final int usuario;

  /// Crea una nueva instancia de [ImagenUsuarioModel].
  ///
  /// Los parámetros [id] y [foto] no pueden ser nulos y [usuario] no puede ser nulo.
  ImagenUsuarioModel({
    required this.id,
    required this.foto,
    required this.usuario,
  });
}

/// Lista que almacena las instancias de [ImagenUsuarioModel].
///
/// Esta lista se utiliza para almacenar y acceder a los datos de las
/// imágenes de los usuarios obtenidas de la API.
/// Cada imagen representa una imagen de un usuario.
List<ImagenUsuarioModel> usuarioimages =
    []; // Lista para almacenar las imágenes de los usuarios

// Método para obtener los datos de las imagenes del usuario
Future<List<ImagenUsuarioModel>> getImagenesUsuarios() async {
  /// URL para obtener las imágenes de los usuarios.
  ///
  /// La URL se construye concatenando la URL base del backend con la ruta
  /// específica para obtener las imágenes de los usuarios.
  String url = "";

  // Construir la URL utilizando la URL base del backend y la ruta para obtener las imágenes de los usuarios
  url = "$sourceApi/api/foto-usuarios/";

  // Hacer una solicitud GET a la URL para obtener las imágenes de los usuarios
  final response = await http.get(Uri.parse(url));

  // Comentario adicional: la respuesta de la solicitud GET se almacena en la variable 'response'.

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    usuarioimages.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos decodificados
    for (var imagenData in decodedData) {
      usuarioimages.add(ImagenUsuarioModel(
        id: imagenData['id'] ?? 0,
        foto: imagenData['foto'],
        usuario: imagenData['usuario']['id'] ?? 0,
      ));
    }

    // Devolver la lista de las imagenes de los usuarios
    return usuarioimages;
  } else {
    // Si la respuesta no es exitosa, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
