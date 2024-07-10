// ignore_for_file: file_names

import 'dart:convert';
import '../source.dart';
import 'usuarioModel.dart';
import 'package:http/http.dart' as http;

/// Clase que representa un pedido en la aplicación.
///
/// Esta clase define una estructura de datos para representar un pedido.
/// Un pedido contiene información como el número del pedido, la fecha de encargo, la fecha de entrega,
/// si es un pedido grupal, el estado del pedido, si ha sido entregado, el punto de venta al que
/// pertenece el pedido, si el pedido ha sido confirmado y el usuario al que pertenece el pedido.
class PedidoModel {
  /// El identificador único del pedido.
  final int id;

  /// El número del pedido.
  final int numeroPedido;

  /// La fecha en la que se encargo el pedido.
  final String fechaEncargo;

  /// La fecha en la que se espera que se entregue el pedido.
  final String fechaEntrega;

  /// Indica si el pedido es grupal o no.
  final bool grupal;

  /// El estado del pedido.
  final String estado;

  /// Indica si el pedido ha sido entregado o no.
  final bool entregado;

  /// El identificador del punto de venta al que pertenece el pedido.
  final int puntoVenta;

  /// Indica si el pedido ha sido confirmado o no.
  final bool pedidoConfirmado;

  /// El usuario al que pertenece el pedido.
  final UsuarioModel usuario;

  /// Crea una instancia de [PedidoModel].
  ///
  /// Los parámetros requeridos para la construcción del objeto son:
  ///
  /// - `id`: El identificador único del pedido.
  /// - `numeroPedido`: El número del pedido.
  /// - `fechaEncargo`: La fecha en la que se encargo el pedido.
  /// - `fechaEntrega`: La fecha en la que se espera que se entregue el pedido.
  /// - `grupal`: Indica si el pedido es grupal o no.
  /// - `estado`: El estado del pedido.
  /// - `entregado`: Indica si el pedido ha sido entregado o no.
  /// - `puntoVenta`: El identificador del punto de venta al que pertenece el pedido.
  /// - `pedidoConfirmado`: Indica si el pedido ha sido confirmado o no.
  /// - `usuario`: El usuario al que pertenece el pedido.
  PedidoModel({
    required this.id,
    required this.numeroPedido,
    required this.fechaEncargo,
    required this.fechaEntrega,
    required this.grupal,
    required this.estado,
    required this.entregado,
    required this.puntoVenta,
    required this.pedidoConfirmado,
    required this.usuario,
  });
}

/// Lista que almacena todas las instancias de [PedidoModel].
///
/// Esta lista se utiliza para almacenar todos los pedidos
/// que se han generado en la aplicación.
/// Los elementos de esta lista son de tipo [PedidoModel].
/// Puedes agregar elementos a esta lista utilizando el método [add],
/// y puedes iterar sobre sus elementos utilizando un bucle [for] o el método [index].
///
/// Ejemplo de uso:
///   // Agregar un pedido a la lista
///   pedidos.add(PedidoModel(
///     id: 1,
///     numeroPedido: 123,
///     fechaEncargo: DateTime.now(),
///     fechaEntrega: DateTime.now().add(Duration(days: 7)),
///     grupal: false,
///     estado: 'En espera',
///     entregado: false,
///     puntoVenta: 1,
///     pedidoConfirmado: true,
///     usuario: UsuarioModel(id: 1, nombre: 'Juan Perez'),
///   ));
List<PedidoModel> pedidos = [];

// Método para obtener los datos de los pedidos
Future<List<PedidoModel>> getPedidos() async {
  /// URL base para la conexión al backend.
  String url = "";

  // Construir la URL de la API para obtener los pedidos
  // Se concatena la URL base con la ruta específica para obtener los pedidos.
  url = "$sourceApi/api/pedidos/";

  // Realizar una solicitud GET a la URL de la API para obtener los pedidos.
  // El método 'await' se utiliza para esperar la respuesta de la solicitud.
  final response = await http.get(Uri.parse(url));
  // Se agrega un comentario explicando el propósito de la solicitud HTTP.
  // Se agrega un comentario para explicar que se espera una respuesta con un código de estado 200 (OK).

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    pedidos.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    //Llenar la lista de pedidos con los datos decodificados
    for (var pedidoData in decodedData) {
      pedidos.add(
        PedidoModel(
          id: pedidoData['id'] ?? 0,
          numeroPedido: pedidoData['numeroPedido'] ?? 0,
          fechaEncargo: pedidoData['fechaEncargo'] ?? "",
          fechaEntrega: pedidoData['fechaEntrega'] ?? "",
          grupal: pedidoData['grupal'] ?? false,
          estado: pedidoData['estado'] ?? "",
          entregado: pedidoData['entregado'] ?? false,
          puntoVenta: pedidoData['puntoVenta'] ?? 0,
          pedidoConfirmado: pedidoData['pedidoConfirmado'],
          usuario: UsuarioModel(
            id: pedidoData['usuario']['id'] ?? 0,
            nombres: pedidoData['usuario']['nombres'] ?? "",
            apellidos: pedidoData['usuario']['apellidos'] ?? "",
            tipoDocumento: pedidoData['usuario']['tipoDocumento'] ?? "",
            numeroDocumento: pedidoData['usuario']['numeroDocumento'] ?? "",
            correoElectronico: pedidoData['usuario']['correoElectronico'] ?? "",
            ciudad: pedidoData['usuario']['ciudad'] ?? "",
            direccion: pedidoData['usuario']['direccion'] ?? "",
            telefono: pedidoData['usuario']['telefono'] ?? "",
            telefonoCelular: pedidoData['usuario']['telefonoCelular'] ?? "",
            rol1: pedidoData['usuario']['rol1'] ?? "",
            rol2: pedidoData['usuario']['rol2'] ?? "",
            rol3: pedidoData['usuario']['rol3'] ?? "",
            estado: pedidoData['usuario']['estado'] ?? true,
            cargo: pedidoData['usuario']['cargo'] ?? "",
            ficha: pedidoData['usuario']['ficha'] ?? "",
            vocero: pedidoData['usuario']['vocero'] ?? false,
            fechaRegistro: pedidoData['usuario']['fechaRegistro'] ?? "",
            sede: pedidoData['usuario']['sede'] ?? 0,
            puntoVenta: pedidoData['usuario']['puntoVenta'] ?? 0,
            unidadProduccion: pedidoData['usuario']['unidadProduccion'] ?? 0,
          ),
        ),
      );
    }

    // Devolver la lista de pedidos.
    return pedidos;
  } else {
    // Lanzar una excepción si la respuesta no tiene un código de estado 200 (OK).
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
