// ignore_for_file: file_names

import 'dart:convert';
import '../source.dart';
import 'anuncioModel.dart';
import 'package:http/http.dart' as http;

import 'usuarioModel.dart';

class ComentarioModel {
  final int id;
  final String descripcion;
  final String fecha;
  final int usuario;
  final AnuncioModel anuncio;

  ComentarioModel({
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.usuario,
    required this.anuncio,
  });
}

List<ComentarioModel> comentarios = [];

// Futuro para traer los datos de la api

Future<List<ComentarioModel>> getComentarios() async {
  String url = "";

  url = "$sourceApi/api/comentarios/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    comentarios.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var comentarioData in decodedData) {
      comentarios.add(
        ComentarioModel(
          id: comentarioData['id'] ?? 0,
          descripcion: comentarioData['descripcion'] ?? "",
          fecha: comentarioData['fecha'] ?? "",
          usuario: comentarioData['usuario'] ?? 0,
          anuncio: AnuncioModel(
            id: comentarioData['anuncio']['id'] ?? 0,
            titulo: comentarioData['anuncio']['titulo'] ?? "",
            fecha: comentarioData['anuncio']['fecha'] ?? "",
            descripcion: comentarioData['anuncio']['descripcion'] ?? "",
            evento: comentarioData['anuncio']['evento'] ?? false,
            eventoIncripcionInicio:
                comentarioData['anuncio']['eventoIncripcionInicio'] ?? "",
            eventoIncripcionFin:
                comentarioData['anuncio']['eventoIncripcionFin'] ?? "",
            maxCupos: comentarioData['anuncio']['maxcupos'] ?? 0,
            anexo: comentarioData['anuncio']['anexo'] ?? "",
            usuario: UsuarioModel(
              id: comentarioData['anuncio']['usuario']['id'] ?? 0,
              nombres: comentarioData['anuncio']['usuario']['nombres'] ?? "",
              apellidos:
                  comentarioData['anuncio']['usuario']['apellidos'] ?? "",
              tipoDocumento:
                  comentarioData['anuncio']['usuario']['tipoDocumento'] ?? "",
              numeroDocumento:
                  comentarioData['anuncio']['usuario']['numeroDocumento'] ?? "",
              correoElectronico: comentarioData['anuncio']['usuario']
                      ['correoElectronico'] ??
                  "",
              ciudad: comentarioData['anuncio']['usuario']['ciudad'] ?? "",
              direccion:
                  comentarioData['anuncio']['usuario']['direccion'] ?? "",
              telefono: comentarioData['anuncio']['usuario']['telefono'] ?? "",
              telefonoCelular:
                  comentarioData['anuncio']['usuario']['telefonoCelular'] ?? "",
              rol1: comentarioData['anuncio']['usuario']['rol1'] ?? "",
              rol2: comentarioData['anuncio']['usuario']['rol2'] ?? "",
              rol3: comentarioData['anuncio']['usuario']['rol3'] ?? "",
              estado: comentarioData['anuncio']['usuario']['estado'] ?? true,
              cargo: comentarioData['anuncio']['usuario']['cargo'] ?? "",
              ficha: comentarioData['anuncio']['usuario']['ficha'] ?? "",
              vocero: comentarioData['anuncio']['usuario']['vocero'] ?? false,
              fechaRegistro:
                  comentarioData['anuncio']['usuario']['fechaRegistro'] ?? "",
              sede: comentarioData['anuncio']['usuario']['sede'] ?? 0,
              puntoVenta:
                  comentarioData['anuncio']['usuario']['puntoVenta'] ?? 0,
              unidadProduccion:
                  comentarioData['anuncio']['usuario']['unidadProduccion'] ?? 0,
            ),
            fechaEvento: comentarioData['anuncio']['fechaEvento'] ?? "",
          ),
        ),
      );
    }
    // Devolver la lista de cometarios
    return comentarios;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
