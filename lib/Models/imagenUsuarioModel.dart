import 'dart:convert';
import '../source.dart';
import 'package:http/http.dart' as http;

class ImagenUsuarioModel {
  final int id;
  final String foto;
  final int usuario;

  ImagenUsuarioModel({
    required this.id,
    required this.foto,
    required this.usuario,
  });
}

List<ImagenUsuarioModel> usuarioimages = [];

// Futuro para traer los datos de la api

Future<List<ImagenUsuarioModel>> getImagenesUsuarios() async {
  String url = "";

  url = "$sourceApi/api/foto-usuarios/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    usuarioimages.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var imagenData in decodedData) {
      usuarioimages.add(ImagenUsuarioModel(
        id: imagenData['id'] ?? 0,
        foto: imagenData['foto'],
        usuario: imagenData['usuario']['id'] ?? 0,
      ));
    }

    // Devolver la lista de fotos
    return usuarioimages;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
