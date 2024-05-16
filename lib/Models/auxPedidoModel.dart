import 'dart:convert';
import '../source.dart';
import 'pedidoModel.dart';
import 'usuarioModel.dart';
import 'package:http/http.dart' as http;

class AuxPedidoModel {
  final int id;
  final int cantidad;
  final int precio;
  final int producto;
  final PedidoModel pedido;

  AuxPedidoModel({
    required this.id,
    required this.cantidad,
    required this.precio,
    required this.producto,
    required this.pedido,
  });
}

List<AuxPedidoModel> auxPedidos = [];

// Futuro para traer los datos de la api

Future<List<AuxPedidoModel>> getAuxPedidos() async {
  String url = "";

  url = "$sourceApi/api/aux-pedidos/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    auxPedidos.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var auxPedidoData in decodedData) {
      auxPedidos.add(
        AuxPedidoModel(
          id: auxPedidoData['id'] ?? 0,
          cantidad: auxPedidoData['cantidad'] ?? 0,
          precio: auxPedidoData['precio'] ?? 0,
          producto: auxPedidoData['producto'],
          pedido: PedidoModel(
            id: auxPedidoData['pedido']['id'] ?? 0,
            numeroPedido: auxPedidoData['pedido']['cantidad'] ?? 0,
            fechaEncargo: auxPedidoData['pedido']['fechaEncargo'] ?? "",
            fechaEntrega: auxPedidoData['pedido']['fechaEntrega'] ?? "",
            grupal: auxPedidoData['pedido']['grupal'] ?? false,
            estado: auxPedidoData['pedido']['estado'] ?? "",
            entregado: auxPedidoData['pedido']['entregado'] ?? false,
            puntoVenta: auxPedidoData['pedido']['puntoVenta'] ?? 0,
            pedidoConfirmado: auxPedidoData['pedido']['pedidoConfirmado'],
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
              foto: auxPedidoData['pedido']['usuario']['foto'] ?? "",
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
            ),
          ),
        ),
      );
    }

    // Devolver la lista de medios de pago con datos.
    return auxPedidos;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
