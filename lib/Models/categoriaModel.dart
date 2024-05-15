import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';

class CategoriaModel {
  final int id;
  final String nombre;
  final String imagen;
  final String icono;

  CategoriaModel({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.icono,
  });
}

List<CategoriaModel> categorias = [];

// Futuro para traer los datos de la api

Future<List<CategoriaModel>> getCategorias() async {
  String url = "";

  url = "$sourceApi/api/categorias/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    categorias.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

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
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
