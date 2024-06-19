// ignore_for_file: file_names

import 'dart:convert';

import '../source.dart';
import 'anuncioModel.dart';
import 'package:http/http.dart' as http;

import 'usuarioModel.dart';

class BoletaModel {
  final int id;
  final int usuario;
  final AnuncioModel anuncio;

  BoletaModel({
    required this.id,
    required this.usuario,
    required this.anuncio,
  });
}

List<BoletaModel> boletas = [];

// Futuro para traer los datos de la api

Future<List<BoletaModel>> getBoletas() async {
  String url = "";

  url = "$sourceApi/api/boletas/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    boletas.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var boletaData in decodedData) {
      boletas.add(
        BoletaModel(
          id: boletaData['id'] ?? 0,
          usuario: boletaData['usuario'] ?? 0,
          anuncio: AnuncioModel(
            id: boletaData['anuncio']['id'] ?? 0,
            titulo: boletaData['anuncio']['titulo'] ?? "",
            fecha: boletaData['anuncio']['fecha'] ?? "",
            descripcion: boletaData['anuncio']['descripcion'] ?? "",
            evento: boletaData['anuncio']['evento'] ?? false,
            eventoIncripcionInicio:
                boletaData['anuncio']['eventoIncripcionInicio'] ?? "",
            eventoIncripcionFin:
                boletaData['anuncio']['eventoIncripcionFin'] ?? "",
            maxCupos: boletaData['anuncio']['maxcupos'] ?? 0,
            anexo: boletaData['anuncio']['anexo'] ?? "",
            usuario: UsuarioModel(
              id: boletaData['anuncio']['usuario']['id'] ?? 0,
              nombres: boletaData['anuncio']['usuario']['nombres'] ?? "",
              apellidos: boletaData['anuncio']['usuario']['apellidos'] ?? "",
              tipoDocumento:
                  boletaData['anuncio']['usuario']['tipoDocumento'] ?? "",
              numeroDocumento:
                  boletaData['anuncio']['usuario']['numeroDocumento'] ?? "",
              correoElectronico:
                  boletaData['anuncio']['usuario']['correoElectronico'] ?? "",
              ciudad: boletaData['anuncio']['usuario']['ciudad'] ?? "",
              direccion: boletaData['anuncio']['usuario']['direccion'] ?? "",
              telefono: boletaData['anuncio']['usuario']['telefono'] ?? "",
              telefonoCelular:
                  boletaData['anuncio']['usuario']['telefonoCelular'] ?? "",
              rol1: boletaData['anuncio']['usuario']['rol1'] ?? "",
              rol2: boletaData['anuncio']['usuario']['rol2'] ?? "",
              rol3: boletaData['anuncio']['usuario']['rol3'] ?? "",
              estado: boletaData['anuncio']['usuario']['estado'] ?? true,
              cargo: boletaData['anuncio']['usuario']['cargo'] ?? "",
              ficha: boletaData['anuncio']['usuario']['ficha'] ?? "",
              vocero: boletaData['anuncio']['usuario']['vocero'] ?? false,
              fechaRegistro:
                  boletaData['anuncio']['usuario']['fechaRegistro'] ?? "",
              sede: boletaData['anuncio']['usuario']['sede'] ?? 0,
              puntoVenta: boletaData['anuncio']['usuario']['puntoVenta'] ?? 0,
              unidadProduccion:
                  boletaData['anuncio']['usuario']['unidadProduccion'] ?? 0,
            ),
            fechaEvento: boletaData['anuncio']['fechaEvento'] ?? "",
          ),
        ),
      );
    }

    // Devolver la lista de las boletas
    return boletas;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
