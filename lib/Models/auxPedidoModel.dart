// ignore_for_file: file_names

import 'dart:convert';
import '../source.dart';
import 'pedidoModel.dart';
import 'usuarioModel.dart';
import 'package:http/http.dart' as http;

/// Clase AuxPedidoModel que representa un auxiliar de un pedido.
///
/// Esta clase define una estructura de datos para representar un auxiliar de un pedido.
/// Un auxiliar es un producto que se vende con un pedido, con una cantidad y un precio determinado.
///
/// Atributos:
/// - id: El identificador único del auxiliar.
/// - cantidad: La cantidad del producto vendido en el auxiliar.
/// - precio: El precio del producto vendido en el auxiliar.
/// - producto: El identificador del producto vendido en el auxiliar.
/// - pedido: El pedido al que pertenece el auxiliar.
class AuxPedidoModel {
  /// El identificador único del auxiliar.
  final int id;

  /// La cantidad del producto vendido en el auxiliar.
  int cantidad;

  /// El precio del producto vendido en el auxiliar.
  final int precio;

  /// El identificador del producto vendido en el auxiliar.
  final int producto;

  /// El pedido al que pertenece el auxiliar.
  final PedidoModel pedido;

  /// Constructor para crear un objeto de tipo AuxPedidoModel.
  ///
  /// Recibe los siguientes parámetros obligatorios:
  /// - id: El identificador único del auxiliar.
  /// - cantidad: La cantidad del producto vendido en el auxiliar.
  /// - precio: El precio del producto vendido en el auxiliar.
  /// - producto: El identificador del producto vendido en el auxiliar.
  /// - pedido: El pedido al que pertenece el auxiliar.
  AuxPedidoModel({
    required this.id,
    required this.cantidad,
    required this.precio,
    required this.producto,
    required this.pedido,
  });
}

/// Lista que almacena los objetos de tipo AuxPedidoModel.
/// Esta lista se utiliza para almacenar los auxiliares de pedidos.
/// Cada auxiliar representa un producto vendido y su información asociada.
List<AuxPedidoModel> auxPedidos = [];

/// Lista que almacena los objetos de tipo AuxPedidoModel.
///
/// Esta lista se utiliza para almacenar los auxiliares de pedidos.
/// Cada auxiliar representa un producto vendido y su información asociada.

/// Future para obtener los auxiliares de pedidos.
Future<List<AuxPedidoModel>> getAuxPedidos() async {

  /// URL para obtener los auxiliares de pedidos.
  ///
  /// Se utiliza para realizar una solicitud GET a la API y obtener los auxiliares de pedidos.
  /// La URL se construye utilizando la variable [sourceApi] y se concatena con el endpoint "/api/aux-pedidos/".
  String url = "";

  // Construir la URL para obtener los auxiliares de pedidos
  url = "$sourceApi/api/aux-pedidos/";

  // Realizar una solicitud GET a la URL para obtener los auxiliares de pedidos
  final response = await http.get(Uri.parse(url));

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    auxPedidos.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de auxiliares de pedidos con los datos decodificados
    for (var auxPedidoData in decodedData) {
      auxPedidos.add(
        AuxPedidoModel(
          id: auxPedidoData['id'] ?? 0,
          cantidad: auxPedidoData['cantidad'] ?? 0,
          precio: auxPedidoData['precio'] ?? 0,
          producto: auxPedidoData['producto'],
          pedido: PedidoModel(
            id: auxPedidoData['pedido']['id'] ?? 0,
            numeroPedido: auxPedidoData['pedido']['numeroPedido'] ?? 0,
            fechaEncargo: auxPedidoData['pedido']['fechaEncargo'] ?? "",
            fechaEntrega: auxPedidoData['pedido']['fechaEntrega'] ?? "",
            grupal: auxPedidoData['pedido']['grupal'] ?? false,
            estado: auxPedidoData['pedido']['estado'] ?? "",
            entregado: auxPedidoData['pedido']['entregado'] ?? false,
            puntoVenta: auxPedidoData['pedido']['puntoVenta'] ?? 0,
            pedidoConfirmado:
                auxPedidoData['pedido']['pedidoConfirmado'] ?? false,
            usuario: UsuarioModel(
              id: auxPedidoData['pedido']['usuario']['id'] ?? 0,
              nombres: auxPedidoData['pedido']['usuario']['nombres'] ?? "",
              apellidos: auxPedidoData['pedido']['usuario']['apellidos'] ?? "",
              tipoDocumento:
                  auxPedidoData['pedido']['usuario']['tipoDocumento'] ?? "",
              numeroDocumento:
                  auxPedidoData['pedido']['usuario']['numeroDocumento'] ?? "",
              correoElectronico:
                  auxPedidoData['pedido']['usuario']['correoElectronico'] ?? "",
              ciudad: auxPedidoData['pedido']['usuario']['ciudad'] ?? "",
              direccion: auxPedidoData['pedido']['usuario']['direccion'] ?? "",
              telefono: auxPedidoData['pedido']['usuario']['telefono'] ?? "",
              telefonoCelular:
                  auxPedidoData['pedido']['usuario']['telefonoCelular'] ?? "",
              rol1: auxPedidoData['pedido']['usuario']['rol1'] ?? "",
              rol2: auxPedidoData['pedido']['usuario']['rol2'] ?? "",
              rol3: auxPedidoData['pedido']['usuario']['rol3'] ?? "",
              estado: auxPedidoData['pedido']['usuario']['estado'] ?? true,
              cargo: auxPedidoData['pedido']['usuario']['cargo'] ?? "",
              ficha: auxPedidoData['pedido']['usuario']['ficha'] ?? "",
              vocero: auxPedidoData['pedido']['usuario']['vocero'] ?? false,
              fechaRegistro:
                  auxPedidoData['pedido']['usuario']['fechaRegistro'] ?? "",
              sede: auxPedidoData['pedido']['usuario']['sede'] ?? 0,
              puntoVenta: auxPedidoData['pedido']['usuario']['puntoVenta'] ?? 0,
              unidadProduccion:
                  auxPedidoData['pedido']['usuario']['unidadProduccion'] ?? 0,
            ),
          ),
        ),
      );
    }

    // Devolver la lista de auxiliares de pedidos
    return auxPedidos;
  } else {
    // Lanza una excepción si la respuesta no es exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
