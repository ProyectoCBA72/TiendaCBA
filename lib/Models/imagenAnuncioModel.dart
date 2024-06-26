// ignore_for_file: file_names

import 'dart:convert';
import 'anuncioModel.dart';
import '../source.dart';
import 'usuarioModel.dart';
import 'package:http/http.dart' as http;

class ImagenAnuncioModel {
  final int id;
  final String imagen;
  final AnuncioModel anuncio;

  ImagenAnuncioModel({
    required this.id,
    required this.imagen,
    required this.anuncio,
  });
}

List<ImagenAnuncioModel> imagenesAnuncio = [];

// Futuro para traer los datos de la api

Future<List<ImagenAnuncioModel>> getImagenesAnuncio() async {
  String url = "";

  url = "$sourceApi/api/imagenes-anuncio/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    imagenesAnuncio.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var imagenanuncioData in decodedData) {
      imagenesAnuncio.add(
        ImagenAnuncioModel(
          id: imagenanuncioData['id'] ?? 0,
          imagen: imagenanuncioData['imagen'] ?? "",
          anuncio: AnuncioModel(
            id: imagenanuncioData['anuncio']['id'] ?? 0,
            titulo: imagenanuncioData['anuncio']['titulo'] ?? "",
            fecha: imagenanuncioData['anuncio']['fecha'] ?? "",
            descripcion: imagenanuncioData['anuncio']['descripcion'] ?? "",
            evento: imagenanuncioData['anuncio']['evento'] ?? false,
            eventoIncripcionInicio:
                imagenanuncioData['anuncio']['eventoIncripcionInicio'] ?? "",
            eventoIncripcionFin:
                imagenanuncioData['anuncio']['eventoIncripcionFin'] ?? "",
            maxCupos: imagenanuncioData['anuncio']['maxcupos'] ?? 0,
            anexo: imagenanuncioData['anuncio']['anexo'] ?? "",
            usuario: UsuarioModel(
              id: imagenanuncioData['anuncio']['usuario']['id'] ?? 0,
              nombres: imagenanuncioData['anuncio']['usuario']['nombres'] ?? "",
              apellidos:
                  imagenanuncioData['anuncio']['usuario']['apellidos'] ?? "",
              tipoDocumento: imagenanuncioData['anuncio']['usuario']
                      ['tipoDocumento'] ??
                  "",
              numeroDocumento: imagenanuncioData['anuncio']['usuario']
                      ['numeroDocumento'] ??
                  "",
              correoElectronico: imagenanuncioData['anuncio']['usuario']
                      ['correoElectronico'] ??
                  "",
              ciudad: imagenanuncioData['anuncio']['usuario']['ciudad'] ?? "",
              direccion:
                  imagenanuncioData['anuncio']['usuario']['direccion'] ?? "",
              telefono:
                  imagenanuncioData['anuncio']['usuario']['telefono'] ?? "",
              telefonoCelular: imagenanuncioData['anuncio']['usuario']
                      ['telefonoCelular'] ??
                  "",
              rol1: imagenanuncioData['anuncio']['usuario']['rol1'] ?? "",
              rol2: imagenanuncioData['anuncio']['usuario']['rol2'] ?? "",
              rol3: imagenanuncioData['anuncio']['usuario']['rol3'] ?? "",
              estado: imagenanuncioData['anuncio']['usuario']['estado'] ?? true,
              cargo: imagenanuncioData['anuncio']['usuario']['cargo'] ?? "",
              ficha: imagenanuncioData['anuncio']['usuario']['ficha'] ?? "",
              vocero:
                  imagenanuncioData['anuncio']['usuario']['vocero'] ?? false,
              fechaRegistro: imagenanuncioData['anuncio']['usuario']
                      ['fechaRegistro'] ??
                  "",
              sede: imagenanuncioData['anuncio']['usuario']['sede'] ?? 0,
              puntoVenta:
                  imagenanuncioData['anuncio']['usuario']['puntoVenta'] ?? 0,
              unidadProduccion: imagenanuncioData['anuncio']['usuario']
                      ['unidadProduccion'] ??
                  0,
            ),
            fechaEvento: imagenanuncioData['anuncio']['fechaEvento'] ?? "",
          ),
        ),
      );
    }

    // Devolver la lista de imagenes del anuncio

    // print(imagenesAnuncio[0].imagen);
    return imagenesAnuncio;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
