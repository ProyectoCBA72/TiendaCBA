// ignore_for_file: file_names

import 'dart:convert';

import '../source.dart';
import 'usuarioModel.dart';
import 'package:http/http.dart' as http;

/// Clase que representa un anuncio en la aplicación.
///
/// Esta clase contiene los atributos necesarios para representar un anuncio.
class AnuncioModel {
  /// Identificador único del anuncio.
  final int id;

  /// Título del anuncio.
  final String titulo;

  /// Fecha del anuncio.
  final String fecha;

  /// Descripción del anuncio.
  final String descripcion;

  /// Indica si el anuncio es un evento.
  final bool evento;

  /// Fecha del evento.
  final String fechaEvento;

  /// Fecha de inicio de la inscripción al evento.
  final String eventoIncripcionInicio;

  /// Fecha de fin de la inscripción al evento.
  final String eventoIncripcionFin;

  /// Número máximo de cupos para el evento.
  final int maxCupos;

  /// Anexo del anuncio.
  final String anexo;

  /// Usuario que creó el anuncio.
  final UsuarioModel usuario;

  /// Crea una nueva instancia de [AnuncioModel].
  ///
  /// Los parámetros [id], [titulo], [fecha], [descripcion], [usuario],
  /// [fechaEvento], [evento], [eventoIncripcionInicio], [eventoIncripcionFin]
  /// y [maxCupos] son obligatorios.
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

/// Lista de anuncios.
///
/// Esta lista almacena instancias de la clase [AnuncioModel], que representan
/// los anuncios publicados en la aplicación.
///
/// Las instancias de esta lista pueden ser agregadas utilizando el método
/// [add], y se pueden iterar utilizando un bucle [for] o utilizando el método
/// [index].
///
/// Ejemplo de uso:
///   // Agregar un anuncio a la lista
///   anuncios.add(AnuncioModel(
///     id: 1,
///     titulo: "Anuncio de prueba",
///     fecha: "2023-01-01",
///     descripcion: "Descripción del anuncio",
///     usuario: UsuarioModel(id: 1, nombre: "Juan Pérez"),
///     fechaEvento: "2023-01-15",
///     evento: true,
///     eventoIncripcionInicio: "2023-01-01",
///     eventoIncripcionFin: "2023-01-14",
///     maxCupos: 100,
///     anexo: "url del anexo",
///   ));
List<AnuncioModel> anuncios = [];

/// Obtener los anuncios de la base de datos.
Future<List<AnuncioModel>> getAnuncios() async {
  /// URL de la API de anuncios.
  ///
  /// Esta variable almacena la URL base de la API de anuncios.
  String url = "";

  // Construir la URL de la API de anuncios.
  url = "$sourceApi/api/anuncios/";

  /// Realizar la solicitud HTTP GET para obtener los anuncios de la base de datos.
  ///
  /// Esta función realiza una solicitud HTTP GET a la URL construida anteriormente
  /// para obtener la lista de anuncios de la base de datos. Si la respuesta es exitosa,
  /// se decodifica la respuesta JSON y se almacena en la lista [anuncios].
  ///
  /// Si la respuesta no es exitosa, se lanza una excepción con el código de estado
  /// de la respuesta.
  ///
  /// Devuelve una [Future] que se completa con la lista de anuncios.
  final response = await http.get(Uri.parse(url));

  // Verifica si la respuesta es exitosa
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    anuncios.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de anuncios con los datos decodificados
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
    // Devuelve la lista de anuncios
    return anuncios;
  } else {
    // Lanza una excepción si la respuesta no es exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
