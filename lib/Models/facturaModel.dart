// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';
import 'medioPagoModel.dart';
import 'pedidoModel.dart';
import 'usuarioModel.dart';

/// Clase FacturaModel que representa una factura.
///
/// Esta clase define una estructura de datos para representar una factura.
/// Una factura es un registro de un pedido realizado por un usuario.
///
/// Atributos:
/// - id: El identificador único de la factura.
/// - numero: El número de la factura.
/// - fecha: La fecha en la que se realizó el pedido.
/// - medioPago: El medio de pago utilizado para realizar el pedido.
/// - pedido: El pedido al que pertenece la factura.
class FacturaModel {
  /// El identificador único de la factura.
  final int id;

  /// El número de la factura.
  final int numero;

  /// La fecha en la que se realizó el pedido.
  final String fecha;

  /// El medio de pago utilizado para realizar el pedido.
  final MedioPagoModel medioPago;

  /// El pedido al que pertenece la factura.
  final PedidoModel pedido;

  /// Crea una instancia de la clase FacturaModel.
  ///
  /// Los parámetros necesarios para crear una instancia son:
  /// - [id]: El identificador único de la factura.
  /// - [fecha]: La fecha en la que se realizó el pedido.
  /// - [medioPago]: El medio de pago utilizado para realizar el pedido.
  /// - [pedido]: El pedido al que pertenece la factura.
  /// - [numero]: El número de la factura.
  FacturaModel({
    required this.id,
    required this.fecha,
    required this.medioPago,
    required this.pedido,
    required this.numero,
  });
}

/// Lista que almacena las instancias de [FacturaModel].
///
/// Esta lista se utiliza para almacenar y acceder a los datos de las
/// facturas obtenidas de la API.
/// Cada factura representa un pedido realizado en la aplicación.
List<FacturaModel> facturas = [];

// Método para obtener los datos de las facturas
Future<List<FacturaModel>> getFacturas() async {
  // URL base para la conexión al backend
  String url = "";

  // Construir la URL completa para obtener las facturas
  // Asegurarse de no dejar espacios en blanco al final de la cadena
  url = "$sourceApi/api/facturas/".trimRight();

  // Realizar la solicitud HTTP GET a la URL construida
  // El método parse() convierte la URL en un objeto URI
  final response = await http.get(Uri.parse(url));

  /**
   * Realiza una solicitud HTTP GET a la API para obtener los datos de las facturas.
   *
   * Esta función construye la URL completa para obtener las facturas a partir de la URL base
   * del backend y realiza una solicitud GET a esa URL. Luego, verifica si la respuesta
   * tiene un código de estado de 200 (OK) y procesa la respuesta JSON para crear una lista de
   * instancias de la clase FacturaModel.
   *
   * @return Una lista de instancias de la clase FacturaModel con los datos obtenidos de la API.
   * @throws Exception Si la respuesta no tiene un código de estado de 200.
   */

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    facturas.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Procesar la respuesta JSON y crear una lista de instancias de la clase FacturaModel
    for (var facturaData in decodedData) {
      facturas.add(
        FacturaModel(
          id: facturaData['id'] ?? 0,
          numero: facturaData['numero'] ?? 0,
          fecha: facturaData['fecha'] ?? "",
          medioPago: MedioPagoModel(
            id: facturaData['medioPago']['id'] ?? 0,
            nombre: facturaData['medioPago']['nombre'] ?? "",
            detalle: facturaData['medioPago']['detalle'] ?? "",
          ),
          pedido: PedidoModel(
            id: facturaData['pedido']['id'] ?? 0,
            numeroPedido: facturaData['pedido']['cantidada'] ?? 0,
            fechaEncargo: facturaData['pedido']['fechaEncargo'] ?? "",
            fechaEntrega: facturaData['pedido']['fechaEntrega'] ?? "",
            grupal: facturaData['pedido']['grupal'] ?? false,
            estado: facturaData['pedido']['estado'] ?? "",
            entregado: facturaData['pedido']['entregado'] ?? false,
            puntoVenta: facturaData['pedido']['puntoVenta'] ?? 0,
            pedidoConfirmado: facturaData['pedido']['pedidoConfirmado'],
            usuario: UsuarioModel(
              id: facturaData['pedido']['usuario']['id'] ?? 0,
              nombres: facturaData['pedido']['usuario']['nombres'] ?? "",
              apellidos: facturaData['pedido']['usuario']['apellidos'] ?? "",
              tipoDocumento:
                  facturaData['pedido']['usuario']['tipoDocumento'] ?? "",
              numeroDocumento:
                  facturaData['pedido']['usuario']['numeroDocumento'] ?? "",
              correoElectronico:
                  facturaData['pedido']['usuario']['correoElectronico'] ?? "",
              ciudad: facturaData['pedido']['usuario']['ciudad'] ?? "",
              direccion: facturaData['pedido']['usuario']['direccion'] ?? "",
              telefono: facturaData['pedido']['usuario']['telefono'] ?? "",
              telefonoCelular:
                  facturaData['pedido']['usuario']['telefonoCelular'] ?? "",
              rol1: facturaData['pedido']['usuario']['rol1'] ?? "",
              rol2: facturaData['pedido']['usuario']['rol2'] ?? "",
              rol3: facturaData['pedido']['usuario']['rol3'] ?? "",
              estado: facturaData['pedido']['usuario']['estado'] ?? true,
              cargo: facturaData['pedido']['usuario']['cargo'] ?? "",
              ficha: facturaData['pedido']['usuario']['ficha'] ?? "",
              vocero: facturaData['pedido']['usuario']['vocero'] ?? false,
              fechaRegistro:
                  facturaData['pedido']['usuario']['fechaRegistro'] ?? "",
              sede: facturaData['pedido']['usuario']['sede'] ?? 0,
              puntoVenta: facturaData['pedido']['usuario']['puntoVenta'] ?? 0,
              unidadProduccion:
                  facturaData['pedido']['usuario']['unidadProduccion'] ?? 0,
            ),
          ),
        ),
      );
    }

    // Devolver la lista de instancias de la clase FacturaModel
    return facturas;
  } else {
    // Lanzar una excepción si la respuesta no tiene un código de estado de 200
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
