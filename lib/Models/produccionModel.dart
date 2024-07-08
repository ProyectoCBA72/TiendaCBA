// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import '../source.dart';

/// Clase que representa una producción en la aplicación.
///
/// Esta clase contiene los atributos necesarios para representar una producción.
class ProduccionModel {
  /// Identificador único de la producción.
  final int id;

  /// Número de la producción.
  final int numero;

  /// Estado de la producción.
  final String estado;

  /// Cantidad producida.
  final int cantidad;

  /// Fecha de despacho de la producción.
  final String fechaDespacho;

  /// Observaciones de la producción.
  final String observaciones;

  /// Costo de producción.
  final int costoProduccion;

  /// Fecha de producción.
  final String fechaProduccion;

  /// Fecha de vencimiento de la producción.
  final String fechaVencimiento;

  /// Identificador del producto producido.
  final int producto;

  /// Unidad de producción a la que pertenece.
  final UnidadProduccionModel unidadProduccion;

  /// Constructor de la clase [ProduccionModel].
  ///
  /// Recibe los atributos necesarios para crear una producción.
  ProduccionModel({
    required this.cantidad,
    required this.id,
    required this.numero,
    required this.estado,
    required this.fechaDespacho,
    required this.observaciones,
    required this.costoProduccion,
    required this.fechaProduccion,
    required this.fechaVencimiento,
    required this.producto,
    required this.unidadProduccion,
  });
}

/// Lista que almacena los objetos de tipo [ProduccionModel].
///
/// Esta lista se utiliza para almacenar todas las producciones
/// que se han registrado en la aplicación.
///
/// Cada elemento de la lista es de tipo [ProduccionModel] y representa
/// una producción con sus atributos correspondientes.
List<ProduccionModel> producciones = [];

// Método para obtener los datos de las producciones

Future<List<ProduccionModel>> getProducciones() async {
  // URL para obtener las producciones de la API
  // Esta URL se utiliza para realizar una solicitud GET a la API y obtener las producciones disponibles.
  String url = "";

  // Construir la URL de la API utilizando la variable de configuración [sourceApi]
  url = "$sourceApi/api/producciones/";

  // Realizar una solicitud GET a la URL para obtener las producciones
  // El método [http.get] devuelve una promesa que se resuelve en una instancia de la clase [http.Response].
  // La respuesta de la solicitud se almacena en la variable [response].
  final response = await http.get(Uri.parse(url));

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    producciones.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de producciones con datos
    for (var produccionData in decodedData) {
      producciones.add(
        ProduccionModel(
          id: produccionData['id'] ?? 0,
          numero: produccionData['numero'] ?? 0,
          estado: produccionData['estado'] ?? "",
          cantidad: produccionData['cantidad'] ?? 0,
          fechaDespacho: produccionData['fechaDespacho'] ?? "",
          observaciones: produccionData['observaciones'] ?? "",
          costoProduccion: produccionData['costoProduccion'] ?? "",
          fechaProduccion: produccionData['fechaProduccion'] ?? "",
          fechaVencimiento: produccionData['fechaVencimiento'] ?? "",
          producto: produccionData['producto'] ?? 0,
          unidadProduccion: UnidadProduccionModel(
            id: produccionData['unidadProduccion']['id'] ?? 0,
            nombre: produccionData['unidadProduccion']['nombre'] ?? "",
            logo: produccionData['unidadProduccion']['logo'] ?? "",
            descripccion:
                produccionData['unidadProduccion']['descripcion'] ?? "",
            estado: produccionData['unidadProduccion']['estado'] ?? true,
            sede: SedeModel(
              id: produccionData['unidadProduccion']['sede']['id'] ?? 0,
              nombre:
                  produccionData['unidadProduccion']['sede']['nombre'] ?? "",
              ciudad:
                  produccionData['unidadProduccion']['sede']['ciudad'] ?? "",
              departamento: produccionData['unidadProduccion']['sede']
                      ['departamento'] ??
                  "",
              regional:
                  produccionData['unidadProduccion']['sede']['regional'] ?? "",
              direccion:
                  produccionData['unidadProduccion']['sede']['direccion'] ?? "",
              telefono1:
                  produccionData['unidadProduccion']['sede']['telefono1'] ?? 0,
              telefono2:
                  produccionData['unidadProduccion']['sede']['telefono2'] ?? 0,
              correo:
                  produccionData['unidadProduccion']['sede']['correo'] ?? "",
              longitud:
                  produccionData['unidadProduccion']['sede']['longitud'] ?? "",
              latitud:
                  produccionData['unidadProduccion']['sede']['latitud'] ?? "",
            ),
          ),
        ),
      );
    }

    // Devolver la lista de producciones
    return producciones;
  } else {
    // En caso de que la respuesta no sea exitosa, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
