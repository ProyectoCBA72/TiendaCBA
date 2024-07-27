// ignore_for_file: file_names

import 'dart:convert';

import '../source.dart';
import 'facturaModel.dart';
import 'package:http/http.dart' as http;

import 'medioPagoModel.dart';
import 'pedidoModel.dart';
import 'usuarioModel.dart';

/// Clase que representa una devolución en la aplicación.
///
/// Esta clase contiene información sobre una devolución, como su identificador,
/// fecha, estado y factura asociada.
class DevolucionesModel {
  /// Identificador único de la devolución.
  final int id;

  /// Fecha de la devolución.
  final String fecha;

  /// Estado de la devolución.
  ///
  /// Si es `true`, la devolución ha sido completada. Si es `false`, la devolución
  /// está en proceso.
  final bool estado;

  /// Factura asociada a la devolución.
  final FacturaModel factura;

  /// Construye una instancia de [DevolucionesModel].
  ///
  /// Los parámetros requeridos son [id], [fecha], [estado] y [factura].
  DevolucionesModel({
    required this.id,
    required this.fecha,
    required this.estado,
    required this.factura,
  });
}

/// Lista que almacena las instancias de [DevolucionesModel].
///
/// Esta lista se utiliza para almacenar y acceder a los datos de las
/// devoluciones obtenidas de la API.
/// Cada devolución representa una devolución registrada en la aplicación.
List<DevolucionesModel> devoluciones = [];

// Método para obtener los datos de las devoluciones
Future<List<DevolucionesModel>> getDevoluciones() async {
  /// URL base para obtener las devoluciones de la API.
  ///
  /// Esta variable almacena la URL completa para obtener las devoluciones.
  /// Se construye utilizando la URL base del backend y la ruta específica para
  /// obtener las devoluciones.
  String url = "";

  /// Construye la URL completa para obtener las devoluciones.
  ///
  /// No tiene parámetros.
  url = "$sourceApi/api/devoluciones/";

  /// Realiza una petición HTTP GET para obtener las devoluciones de la API.
  ///
  /// No tiene parámetros.
  final response = await http.get(Uri.parse(url));

  /// Verifica el estado de la respuesta.
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    devoluciones.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos decodificados
    for (var devolucionData in decodedData) {
      devoluciones.add(
        DevolucionesModel(
          id: devolucionData['id'] ?? 0,
          fecha: devolucionData['fecha'],
          estado: devolucionData['estado'] ?? false,
          factura: FacturaModel(
            id: devolucionData['factura']['id'] ?? 0,
            numero: devolucionData['factura']['numero'] ?? 0,
            fecha: devolucionData['factura']['fecha'] ?? "",
            usuarioVendedor: devolucionData['factura']['usuarioVendedor'] ?? 0,
            medioPago: MedioPagoModel(
              id: devolucionData['factura']['medioPago']['id'] ?? 0,
              nombre: devolucionData['factura']['medioPago']['nombre'] ?? "",
              detalle: devolucionData['factura']['medioPago']['detalle'] ?? "",
            ),
            pedido: PedidoModel(
              id: devolucionData['factura']['pedido']['id'] ?? 0,
              numeroPedido:
                  devolucionData['factura']['pedido']['numeroPedido'] ?? 0,
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
                puntoVenta: devolucionData['factura']['pedido']['usuario']
                        ['puntoVenta'] ??
                    0,
                unidadProduccion: devolucionData['factura']['pedido']['usuario']
                        ['unidadProduccion'] ??
                    0,
              ),
            ),
          ),
        ),
      );
    }

    // Devolver la lista actualizada de devoluciones
    return devoluciones;
  } else {
    // En caso de que la respuesta no sea exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
