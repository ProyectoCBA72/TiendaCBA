import 'dart:convert';
import '../source.dart';
import 'usuarioModel.dart';
import 'package:http/http.dart' as http;

class PedidoModel {
  final int id;
  final int numeroPedido;
  final String fechaEncargo;
  final String fechaEntrega;
  final bool grupal;
  final String estado;
  final bool entregado;
  final int puntoVenta;
  final bool pedidoConfirmado;
  final UsuarioModel usuario;

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

List<PedidoModel> pedidos = [];

// Futuro para traer los datos de la api

Future<List<PedidoModel>> getPedidos() async {
  String url = "";

  url = "$sourceApi/api/pedidos/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    pedidos.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

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

    // Devolver la lista de medios de pago con datos.
    return pedidos;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
