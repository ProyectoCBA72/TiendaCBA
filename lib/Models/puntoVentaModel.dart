// ignore_for_file: file_names

import 'dart:convert';
import '../source.dart';
import 'package:http/http.dart' as http;

/// Clase que representa un punto de venta en la aplicación.
///
/// Esta clase define una estructura de datos para representar un punto de venta.
/// Un punto de venta contiene información como el identificador único, el nombre,
/// la ubicación, el estado del punto de venta y la sede a la cual pertenece el punto de venta.
class PuntoVentaModel {
  /// Identificador único del punto de venta.
  final int id;

  /// Nombre del punto de venta.
  final String nombre;

  /// Ubicación del punto de venta.
  final String ubicacion;

  /// Estado del punto de venta.
  ///
  /// Si es verdadero, el punto de venta está activo.
  /// Si es falso, el punto de venta está inactivo.
  final bool estado;

  /// Identificador de la sede a la cual pertenece el punto de venta.
  final int sede;

  /// Constructor para crear una instancia de [PuntoVentaModel].
  ///
  /// Los parámetros [id], [nombre], [ubicacion], [estado] y [sede] son obligatorios.
  PuntoVentaModel({
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.estado,
    required this.sede,
  });
}

/// Lista que almacena los puntos de venta obtenidos de la API.
///
/// Esta lista se utiliza para almacenar los puntos de venta obtenidos de la API.
/// Es una lista de objetos de tipo [PuntoVentaModel].
List<PuntoVentaModel> puntosVenta = [];

/// Lista que contiene los puntos de venta obtenidos de la API.
///
/// Esta lista se utiliza para almacenar los puntos de venta obtenidos de la API.
/// Cada elemento de la lista es un objeto de tipo [PuntoVentaModel].
///
/// Esta lista se inicializa vacía y se llenará con los datos obtenidos de la API.

// Método para obtener los datos de los puntos de venta
Future<List<PuntoVentaModel>> getPuntosVenta() async {
  // URL para obtener los puntos de venta de la API
  // Esta URL se utiliza para realizar una solicitud GET a la API y obtener los puntos de venta disponibles.
  String url = "";

  // Construir la URL de la API utilizando la variable de configuración [sourceApi]
  url = "$sourceApi/api/puntos-venta/";

  // Realizar una solicitud GET a la URL para obtener los puntos de venta
  // El método [http.get] devuelve una promesa que se resuelve en una instancia de la clase [http.Response].
  // La respuesta de la solicitud se almacena en la variable [response].
  final response = await http.get(Uri.parse(url));

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    puntosVenta.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de puntos de venta con datos
    for (var puntoVentaData in decodedData) {
      puntosVenta.add(
        PuntoVentaModel(
          id: puntoVentaData['id'] ?? 0,
          nombre: puntoVentaData['nombre'] ?? "",
          ubicacion: puntoVentaData['ubicacion'] ?? "",
          estado: puntoVentaData['estado'] ?? true,
          sede: puntoVentaData['sede'] ?? 0,
        ),
      );
    }
    // Devolver la lista de puntos de venta
    return puntosVenta;
  } else {
    // Si el código de estado no es 200, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
