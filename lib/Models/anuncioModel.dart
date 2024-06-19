// ignore_for_file: file_names

import 'dart:convert';

import '../source.dart';
import 'usuarioModel.dart';
import 'package:http/http.dart' as http;

class AnuncioModel {
  final int id;
  final String titulo;
  final String fecha;
  final String descripcion;
  final bool evento;
  final String fechaEvento;
  final String eventoIncripcionInicio;
  final String eventoIncripcionFin;
  final int maxCupos;
  final String anexo;
  final UsuarioModel usuario;

  AnuncioModel({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.descripcion,
    required this.usuario,
    required this.fechaEvento,
    required this.evento,
    required this.eventoIncripcionInicio,
    required this.eventoIncripcionFin,
    required this.maxCupos,
    required this.anexo,
  });
}

List<AnuncioModel> anuncios = [];

// Futuro para traer los datos de la api

Future<List<AnuncioModel>> getAnuncios() async {
  String url = "";

  url = "$sourceApi/api/anuncios/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    anuncios.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var anuncioData in decodedData) {
      anuncios.add(
        AnuncioModel(
          id: anuncioData['id'] ?? 0,
          titulo: anuncioData['titulo'] ?? "",
          fecha: anuncioData['fecha'] ?? "",
          descripcion: anuncioData['descripcion'] ?? "",
          evento: anuncioData['evento'] ?? false,
          eventoIncripcionInicio: anuncioData['eventoIncripcionInicio'] ?? "",
          eventoIncripcionFin: anuncioData['eventoIncripcionFin'] ?? "",
          maxCupos: anuncioData['maxcupos'] ?? 0,
          anexo: anuncioData['anexo'] ?? "",
          usuario: UsuarioModel(
            id: anuncioData['usuario']['id'] ?? 0,
            nombres: anuncioData['usuario']['nombres'] ?? "",
            apellidos: anuncioData['usuario']['apellidos'] ?? "",
            tipoDocumento: anuncioData['usuario']['tipoDocumento'] ?? "",
            numeroDocumento: anuncioData['usuario']['numeroDocumento'] ?? "",
            correoElectronico:
                anuncioData['usuario']['correoElectronico'] ?? "",
            ciudad: anuncioData['usuario']['ciudad'] ?? "",
            direccion: anuncioData['usuario']['direccion'] ?? "",
            telefono: anuncioData['usuario']['telefono'] ?? "",
            telefonoCelular: anuncioData['usuario']['telefonoCelular'] ?? "",
            rol1: anuncioData['usuario']['rol1'] ?? "",
            rol2: anuncioData['usuario']['rol2'] ?? "",
            rol3: anuncioData['usuario']['rol3'] ?? "",
            estado: anuncioData['usuario']['estado'] ?? true,
            cargo: anuncioData['usuario']['cargo'] ?? "",
            ficha: anuncioData['usuario']['ficha'] ?? "",
            vocero: anuncioData['usuario']['vocero'] ?? false,
            fechaRegistro: anuncioData['usuario']['fechaRegistro'] ?? "",
            sede: anuncioData['usuario']['sede'] ?? 0,
            puntoVenta: anuncioData['usuario']['puntoVenta'] ?? 0,
            unidadProduccion: anuncioData['usuario']['unidadProduccion'] ?? 0,
          ),
          fechaEvento: anuncioData['fechaEvento'] ?? "",
        ),
      );
    }
    // print('Número de anuncios cargados: ${anuncios.length}');
    // print(
    //     'Primer anuncio: ${anuncios.isNotEmpty ? anuncios[0] : "Lista vacía"}');
    // print(
    //     'Primer anuncio - Título: ${anuncios.isNotEmpty ? anuncios[0].usuario.id : "Lista vacía"}');

    // Devolver la lista de imagenes
    return anuncios;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
