// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';

/// Clase que representa un mensaje en la aplicación.
///
/// Esta clase contiene información sobre un mensaje, incluyendo su identificador,
/// fecha, contenido y los usuarios que lo han enviado y recibido.
class MensajeModel {
  /// El identificador único del mensaje.
  final int id;

  /// La fecha en la que se envió el mensaje.
  final String fecha;

  /// El contenido del mensaje.
  final String contenido;

  /// El identificador del usuario que envió el mensaje.
  final int usuarioEmisor;

  /// El identificador del usuario que recibió el mensaje.
  final int usuarioReceptor;

  /// Crea una instancia de [MensajeModel].
  ///
  /// Los parámetros obligatorios son [id], [fecha], [contenido], [usuarioEmisor]
  /// y [usuarioReceptor].
  MensajeModel({
    required this.id,
    required this.fecha,
    required this.contenido,
    required this.usuarioEmisor,
    required this.usuarioReceptor,
  });
}

/// Lista de mensajes.
///
/// Esta lista almacena instancias de la clase [MensajeModel], que representan
/// los mensajes enviados y recibidos en la aplicación.
///
/// Los mensajes se agregan a esta lista utilizando el método [add], y se pueden
/// iterar utilizando un bucle [for] o utilizando el método [index].
///
/// Ejemplo de uso:
///   // Agregar un mensaje a la lista
///   mensajes.add(MensajeModel(
///     id: 1,
///     fecha: "2023-01-01",
///     contenido: "Mensaje de prueba",
///     usuarioEmisor: 1,
///     usuarioReceptor: 2,
///   ));
List<MensajeModel> mensajes = [];

// Método para obtener los datos de los mensajes
Future<List<MensajeModel>> getMensajes() async {
  /// URL utilizada para obtener los mensajes a través de la API.
  ///
  /// Esta URL se utiliza para realizar una solicitud GET a la API y obtener los mensajes.
  String url = "";

  // Construir la URL a partir de la URL base de la API y la ruta específica para obtener los mensajes.
  url = "$sourceApi/api/mensajes/";

  // Realizar una solicitud GET a la URL para obtener los mensajes.
  //
  // El método http.get devuelve un objeto Future que se resolverá con
  // un objeto Response cuando se complete la solicitud.
  final response = await http.get(Uri.parse(url));

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    mensajes.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos decodificados
    for (var mensajesData in decodedData) {
      mensajes.add(
        MensajeModel(
          id: mensajesData['id'] ?? 0,
          fecha: mensajesData['fecha'] ?? "",
          contenido: mensajesData['contenido'] ?? "",
          usuarioEmisor: mensajesData['usuarioEmisor'] ?? 0,
          usuarioReceptor: mensajesData['usuarioReceptor'] ?? 0,
        ),
      );
    }

    // Devolver la lista de mensajes
    return mensajes;
  } else {
    // Lanzar una excepción si la respuesta no es exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
