import 'dart:convert';

import '../source.dart';
import 'facturaModel.dart';
import 'package:http/http.dart' as http;

import 'medioPagoModel.dart';
import 'pedidoModel.dart';
import 'usuarioModel.dart';

class DevolucionesModel {
  final int id;
  final String fecha;
  final bool estado;
  final FacturaModel factura;

  DevolucionesModel({
    required this.id,
    required this.fecha,
    required this.estado,
    required this.factura,
  });
}

List<DevolucionesModel> devoluciones = [];

// Futuro para traer los datos de la api

Future<List<DevolucionesModel>> getDevoluciones() async {
  String url = "";

  url = "$sourceApi/api/devoluciones/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    devoluciones.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var devolucionData in decodedData) {
      devoluciones.add(
        DevolucionesModel(
          id: devolucionData['id'] ?? 0,
          fecha: devolucionData['fecha'],
          estado: devolucionData['estado'] ?? false,
          factura: FacturaModel(
            id: devolucionData['factura']['id'] ?? 0,
            fecha: devolucionData['factura']['fecha'] ?? "",
            medioPago: MedioPagoModel(
              id: devolucionData['factura']['medioPago']['id'] ?? 0,
              nombre: devolucionData['factura']['medioPago']['nombre'] ?? "",
              detalle: devolucionData['factura']['medioPago']['detalle'] ?? "",
            ),
            pedido: PedidoModel(
              id: devolucionData['factura']['pedido']['id'] ?? 0,
              numeroPedido:
                  devolucionData['factura']['pedido']['cantidada'] ?? 0,
              fechaEncargo:
                  devolucionData['factura']['pedido']['fechaEncargo'] ?? "",
              fechaEntrega:
                  devolucionData['factura']['pedido']['fechaEntrega'] ?? "",
              grupal: devolucionData['factura']['pedido']['grupal'] ?? false,
              estado: devolucionData['factura']['pedido']['estado'] ?? "",
              entregado:
                  devolucionData['factura']['pedido']['entregado'] ?? false,
              puntoVenta:
                  devolucionData['factura']['pedido']['puntoVenta'] ?? 0,
              pedidoConfirmado: devolucionData['factura']['pedido']
                  ['pedidoConfirmado'],
              usuario: UsuarioModel(
                id: devolucionData['factura']['pedido']['usuario']['id'] ?? 0,
                nombres: devolucionData['factura']['pedido']['usuario']
                        ['nombres'] ??
                    "",
                apellidos: devolucionData['factura']['pedido']['usuario']
                        ['apellidos'] ??
                    "",
                tipoDocumento: devolucionData['factura']['pedido']['usuario']
                        ['tipoDocumento'] ??
                    "",
                numeroDocumento: devolucionData['factura']['pedido']['usuario']
                        ['numeroDocumento'] ??
                    "",
                correoElectronico: devolucionData['factura']['pedido']
                        ['usuario']['correoElectronico'] ??
                    "",
                ciudad: devolucionData['factura']['pedido']['usuario']
                        ['ciudad'] ??
                    "",
                direccion: devolucionData['factura']['pedido']['usuario']
                        ['direccion'] ??
                    "",
                telefono: devolucionData['factura']['pedido']['usuario']
                        ['telefono'] ??
                    "",
                telefonoCelular: devolucionData['factura']['pedido']['usuario']
                        ['telefonoCelular'] ??
                    "",
                foto: devolucionData['factura']['pedido']['usuario']['foto'] ??
                    "",
                rol1: devolucionData['factura']['pedido']['usuario']['rol1'] ??
                    "",
                rol2: devolucionData['factura']['pedido']['usuario']['rol2'] ??
                    "",
                rol3: devolucionData['factura']['pedido']['usuario']['rol3'] ??
                    "",
                estado: devolucionData['factura']['pedido']['usuario']
                        ['estado'] ??
                    true,
                cargo: devolucionData['factura']['pedido']['usuario']
                        ['cargo'] ??
                    "",
                ficha: devolucionData['factura']['pedido']['usuario']
                        ['ficha'] ??
                    "",
                vocero: devolucionData['factura']['pedido']['usuario']
                        ['vocero'] ??
                    false,
                fechaRegistro: devolucionData['factura']['pedido']['usuario']
                        ['fechaRegistro'] ??
                    "",
                sede:
                    devolucionData['factura']['pedido']['usuario']['sede'] ?? 0,
              ),
            ),
          ),
        ),
      );
    }

    // Devolver la lista con los valores llenos
    return devoluciones;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
