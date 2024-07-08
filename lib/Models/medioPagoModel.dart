// ignore_for_file: file_names

import 'dart:convert';
import '../source.dart';
import 'package:http/http.dart' as http;

/// Clase que representa un medio de pago.
///
/// Esta clase define una estructura de datos para representar un medio de pago.
/// Un medio de pago es una opción disponible para realizar un pedido.
/// Atributos:
/// - id: El identificador único del medio de pago.
/// - nombre: El nombre del medio de pago.
/// - detalle: El detalle adicional del medio de pago.
class MedioPagoModel {
  /// El identificador único del medio de pago.
  final int id;

  /// El nombre del medio de pago.
  final String nombre;

  /// El detalle adicional del medio de pago.
  final String detalle;

  /// Constructor privado para instanciar un objeto de la clase MedioPagoModel.
  ///
  /// Recibe los atributos id, nombre y detalle y los asigna a los campos correspondientes.
  MedioPagoModel({
    required this.id,
    required this.nombre,
    required this.detalle,
  });
}

/// Lista que almacena las instancias de [MedioPagoModel].
///
/// Esta lista se utiliza para almacenar y acceder a los datos de los medios de pago obtenidos de la API.
/// Cada medio de pago representa una opción disponible para realizar un pedido.
///
/// Nota: Esta lista se utiliza para almacenar los datos obtenidos de la API.
/// Para obtener los datos de la API, se utiliza el método [getMediosPago].
List<MedioPagoModel> mediosPago = [];

// Método para obtener los datos de los medios de pago
Future<List<MedioPagoModel>> getMediosPago() async {
  // URL para obtener los medios de pago de la API
  // Esta URL se utiliza para realizar una solicitud GET a la API y obtener los medios de pago disponibles.
  String url = "";

  // Construir la URL de la API utilizando la variable de configuración [sourceApi]
  url = "$sourceApi/api/medios-pago/";

  // Realizar una solicitud GET a la URL para obtener los medios de pago
  // El método [http.get] devuelve una promesa que se resuelve en una instancia de la clase [http.Response].
  // La respuesta de la solicitud se almacena en la variable [response].
  final response = await http.get(Uri.parse(url));

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    mediosPago.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de medios de pago con datos
    for (var medioPagoData in decodedData) {
      mediosPago.add(
        MedioPagoModel(
          id: medioPagoData['id'] ?? 0,
          nombre: medioPagoData['nombre'] ?? "",
          detalle: medioPagoData['detalle'] ?? "",
        ),
      );
    }

    // Devolver la lista de medios de pago.
    return mediosPago;
  } else {
    // En caso de que el código de estado no sea 200, se lanza una excepción.
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
