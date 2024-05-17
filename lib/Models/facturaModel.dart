// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';
import 'medioPagoModel.dart';
import 'pedidoModel.dart';
import 'usuarioModel.dart';

class FacturaModel {
  final int id;
  final String fecha;
  final MedioPagoModel medioPago;
  final PedidoModel pedido;

  FacturaModel({
    required this.id,
    required this.fecha,
    required this.medioPago,
    required this.pedido,
  });
}

List<FacturaModel> facturas = [];

// Futuro para traer los datos de la api

Future<List<FacturaModel>> getFacturas() async {
  String url = "";

  url = "$sourceApi/api/facturas/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    facturas.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var facturaData in decodedData) {
      facturas.add(
        FacturaModel(
          id: facturaData['id'] ?? 0,
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
              foto: facturaData['pedido']['usuario']['foto'] ?? "",
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
            ),
          ),
        ),
      );
    }

    // Devolver la lista de sedes
    return facturas;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
