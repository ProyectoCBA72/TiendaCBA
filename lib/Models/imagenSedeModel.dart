// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';
import 'sedeModel.dart';

class ImagenSedeModel {
  final int id;
  final String imagen;
  final SedeModel sede;

  ImagenSedeModel({
    required this.id,
    required this.imagen,
    required this.sede,
  });
}

List<ImagenSedeModel> imagenSedes = [];

// Futuro para traer los datos de la api

Future<List<ImagenSedeModel>> getImagenSedes() async {
  String url = "";

  url = "$sourceApi/api/imagenes-sede/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    imagenSedes.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

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
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
