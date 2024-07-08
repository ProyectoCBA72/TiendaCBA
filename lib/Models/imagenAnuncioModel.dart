// ignore_for_file: file_names

import 'dart:convert';
import 'anuncioModel.dart';
import '../source.dart';
import 'usuarioModel.dart';
import 'package:http/http.dart' as http;

/// Clase que representa una imagen de un anuncio en la aplicación.
///
/// Esta clase contiene los atributos necesarios para representar una imagen de un anuncio.
/// Una imagen es un registro de una imagen de un anuncio.
///
/// Atributos:
/// - [id]: El identificador único de la imagen.
/// - [imagen]: La ruta de la imagen.
/// - [anuncio]: El anuncio al que pertenece la imagen.
class ImagenAnuncioModel {
  /// El identificador único de la imagen.
  final int id;

  /// La ruta de la imagen.
  final String imagen;

  /// El anuncio al que pertenece la imagen.
  final AnuncioModel anuncio;

  /// Crea una nueva instancia de [ImagenAnuncioModel] con los argumentos proporcionados.
  ///
  /// Los argumentos [id], [imagen] y [anuncio] son obligatorios y se deben proporcionar.
  ImagenAnuncioModel({
    required this.id,
    required this.imagen,
    required this.anuncio,
  });
}

/// Lista que almacena las instancias de [ImagenAnuncioModel].
///
/// Esta lista se utiliza para almacenar y acceder a los datos de las
/// imágenes de los anuncios obtenidas de la API.
/// Cada imagen representa una imagen de un anuncio publicado en la aplicación.
List<ImagenAnuncioModel> imagenesAnuncio = [];

// Método para obtener los datos de las imagenes
Future<List<ImagenAnuncioModel>> getImagenesAnuncio() async {
  // URL base para la conexión al backend
  String url = "";

  // Construir la URL para obtener las imágenes de los anuncios
  // Se utiliza la URL base del backend seguida de "/api/imagenes-anuncio/"
  url = "$sourceApi/api/imagenes-anuncio/";

  // Realizar una solicitud GET a la URL construida
  // Se espera una respuesta del servidor con una lista de imágenes de anuncios
  final response = await http.get(Uri.parse(url));

  // Comprobar si la solicitud se realizó correctamente
  // Si la respuesta del servidor tiene un código de estado 200,
  // se considera que la solicitud se realizó correctamente
  // y se procede a procesar los datos obtenidos

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    imagenesAnuncio.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar sobre los datos decodificados
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
    return imagenesAnuncio;
  } else {
    // Si la respuesta no fue exitosa, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
