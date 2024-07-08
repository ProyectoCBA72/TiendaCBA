// ignore_for_file: file_names

import 'dart:convert';

import '../source.dart';
import 'anuncioModel.dart';
import 'package:http/http.dart' as http;

import 'usuarioModel.dart';

/// Clase BoletaModel que representa una boleta.
///
/// Esta clase define una estructura de datos para representar una boleta.
/// Una boleta es un registro de un usuario que compra un anuncio.
///
/// Atributos:
/// - id: El identificador único de la boleta.
/// - usuario: El identificador del usuario que compra el anuncio.
/// - anuncio: El anuncio que se compra.
class BoletaModel {
  /// El identificador único de la boleta.
  final int id;

  /// El identificador del usuario que compra el anuncio.
  final int usuario;

  /// El anuncio que se compra.
  final AnuncioModel anuncio;

  /// Crea una nueva instancia de [BoletaModel].
  ///
  /// Los parámetros [id], [usuario] y [anuncio] son requeridos y no pueden ser nulos.
  BoletaModel({
    required this.id,
    required this.usuario,
    required this.anuncio,
  });
}

/// Lista que almacena todas las instancias de [BoletaModel].
///
/// Esta lista se utiliza para almacenar todas las boletas
/// que se han generado en la aplicación.
/// Los elementos de esta lista son de tipo [BoletaModel].
/// Puedes agregar elementos a esta lista utilizando el método [add],
/// y puedes iterar sobre sus elementos utilizando un bucle [for] o el método [index].
///
/// Ejemplo de uso:
///   // Agregar una boleta a la lista
///   boletas.add(BoletaModel(
///     id: 1,
///     usuario: 1,
///     anuncio: AnuncioModel(id: 1, titulo: "Anuncio de prueba"),
///   ));
List<BoletaModel> boletas = [];

// Metodo para obtener los datos de las boletas

Future<List<BoletaModel>> getBoletas() async {
  /// URL base para la conexión al backend, seguida de la ruta para obtener las boletas.
  ///
  /// La variable [url] se utiliza para construir la URL completa para realizar la petición HTTP.
  String url = "";

  /// Construye la URL completa para obtener las boletas.
  ///
  /// La variable [url] se inicializa con la URL base del backend y se agrega la ruta para obtener las boletas.
  ///
  /// Devuelve una cadena con la URL completa.
  url = "$sourceApi/api/boletas/";

  /// Realiza una petición HTTP GET para obtener las boletas.
  ///
  /// La variable [response] almacena la respuesta de la petición HTTP.
  ///
  /// Devuelve un objeto [http.Response] que contiene la respuesta de la petición HTTP.
  final response = await http.get(Uri.parse(url));

  /// Verifica si la petición HTTP fue exitosa.
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    boletas.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos decodificados
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

    // Devolver la lista de boletas
    return boletas;
  } else {
    // Si la petición HTTP fallo, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
