// ignore_for_file: file_names

import 'dart:convert';
import '../source.dart';
import 'anuncioModel.dart';
import 'package:http/http.dart' as http;

import 'usuarioModel.dart';

/// Clase que representa un comentario de un anuncio en la aplicación.
///
/// Esta clase define una estructura de datos para representar un comentario de un anuncio.
///
/// Atributos:
/// - id: El identificador único del comentario.
/// - descripcion: La descripción del comentario.
/// - fecha: La fecha en que se hizo el comentario.
/// - usuario: El identificador del usuario que hizo el comentario.
/// - anuncio: El anuncio al que se hace referencia en el comentario.

class ComentarioModel {
  /// El identificador único del comentario.
  final int id;

  /// La descripción del comentario.
  final String descripcion;

  /// La fecha en que se hizo el comentario.
  final String fecha;

  /// El identificador del usuario que hizo el comentario.
  final int usuario;

  /// El anuncio al que se hace referencia en el comentario.
  final AnuncioModel anuncio;

  /// Constructor para crear un objeto ComentarioModel.
  ///
  /// Recibe los siguientes parámetros:
  /// - id: El identificador único del comentario.
  /// - descripcion: La descripción del comentario.
  /// - fecha: La fecha en que se hizo el comentario.
  /// - usuario: El identificador del usuario que hizo el comentario.
  /// - anuncio: El anuncio al que se hace referencia en el comentario.
  ComentarioModel({
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.usuario,
    required this.anuncio,
  });
}

/// Esta lista almacena instancias de la clase [ComentarioModel],
/// que representan los comentarios publicados en la aplicación.
///
/// Las instancias de esta lista pueden ser agregadas utilizando el método
/// [add], y se pueden iterar utilizando un bucle [for] o utilizando el método
/// [index].
///
/// Ejemplo de uso:
///   // Agregar un comentario a la lista
///   comentarios.add(ComentarioModel(
///     id: 1,
///     descripcion: "Comentario de prueba",
///     fecha: "2023-01-01",
///     usuario: 1,
///     anuncio: AnuncioModel(id: 1, titulo: "Anuncio de prueba"),
///   ));
List<ComentarioModel> comentarios = [];

// Método para obtener los datos de los comentarios

Future<List<ComentarioModel>> getComentarios() async {
  /// URL base para la conexión con el backend.
  String url = "";

  // Construir la URL para obtener los comentarios
  url = "$sourceApi/api/comentarios/";

  /// Realiza una solicitud GET a la URL especificada para obtener los
  /// comentarios.
  ///
  /// La respuesta de la solicitud es almacenada en la variable [response].
  final response = await http.get(
    Uri.parse(url), // URL para la solicitud GET
  );

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    comentarios.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos decodificados
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
    // Devolver la lista de comentarios
    return comentarios;
  } else {
    // Lanzar una excepción si la respuesta no es exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
