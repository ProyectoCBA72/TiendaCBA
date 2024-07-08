// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';
import 'sedeModel.dart';

/// Clase que representa una imagen de una sede en la aplicación.
///
/// Esta clase contiene los atributos necesarios para representar una imagen de una sede.
/// Una imagen es un registro de una imagen de una sede.
class ImagenSedeModel {
  /// El identificador único de la imagen.
  final int id;

  /// La ruta de la imagen.
  final String imagen;

  /// La sede al que pertenece la imagen.
  final SedeModel sede;

  /// Constructor para crear una instancia de [ImagenSedeModel].
  ///
  /// Los parámetros required aseguran que se proporcionen valores válidos para
  /// los atributos de la clase.
  ImagenSedeModel({
    required this.id,
    required this.imagen,
    required this.sede,
  });
}

/// Lista que almacena las instancias de [ImagenSedeModel].
///
/// Esta lista se utiliza para almacenar y acceder a los datos de las
/// imágenes de las sedes obtenidas de la API. Cada imagen representa una
/// imagen de una sede en la aplicación.
List<ImagenSedeModel> imagenSedes = [];

// Método para obtener los datos de las imagenes de las sedes
Future<List<ImagenSedeModel>> getImagenSedes() async {
  /// URL utilizada para obtener las imágenes de las sedes a través de la API.
  ///
  /// Esta URL se utiliza para realizar una solicitud GET a la API y obtener las imágenes de las sedes.
  String url = "";

  // Construir la URL a partir de la URL base de la API y la ruta específica para obtener las imágenes de las sedes.
  url = "$sourceApi/api/imagenes-sede/";

  // Realizar una solicitud GET a la URL para obtener las imágenes de las sedes.
  final response = await http.get(Uri.parse(url));
  // Comentario: la función http.get devuelve un objeto Future que se resolverá con
  // un objeto Response cuando se complete la solicitud.

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    imagenSedes.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos decodificados
    for (var imagenSedeData in decodedData) {
      imagenSedes.add(
        ImagenSedeModel(
          id: imagenSedeData['id'] ?? 0,
          imagen: imagenSedeData['imagen'] ?? "",
          sede: SedeModel(
            id: imagenSedeData['sede']['id'] ?? 0,
            nombre: imagenSedeData['sede']['nombre'] ?? "",
            ciudad: imagenSedeData['sede']['ciudad'] ?? "",
            departamento: imagenSedeData['sede']['departamento'] ?? "",
            regional: imagenSedeData['sede']['regional'] ?? "",
            direccion: imagenSedeData['sede']['direccion'] ?? "",
            telefono1: imagenSedeData['sede']['telefono1'] ?? "",
            telefono2: imagenSedeData['sede']['telefono2'] ?? "",
            correo: imagenSedeData['sede']['correo'] ?? "",
            latitud: imagenSedeData['sede']['latitud'] ?? "",
            longitud: imagenSedeData['sede']['longitud'] ?? "",
          ),
        ),
      );
    }

    // Devolver la lista de imagenes de sede
    return imagenSedes;
  } else {
    // En caso de que la respuesta no sea exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
