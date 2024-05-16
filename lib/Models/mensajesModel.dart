// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';

class MensajeModel {
  final int id;
  final String fecha;
  final String contenido;
  final int usuarioEmisor;
  final int usuarioReceptor;

  MensajeModel({
    required this.id,
    required this.fecha,
    required this.contenido,
    required this.usuarioEmisor,
    required this.usuarioReceptor,
  });
}

List<MensajeModel> mensajes = [];

// Futuro para traer los datos de la api

Future<List<MensajeModel>> getMensajes() async {
  String url = "";

  url = "$sourceApi/api/mensajes/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    mensajes.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

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

    // Devolver la lista de mensajes llena
    return mensajes;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
