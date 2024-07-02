// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import '../source.dart';

class ProduccionModel {
  final int id;
  final int numero;
  final String estado;
  final int cantidad;
  final String fechaDespacho;
  final String observaciones;
  final int costoProduccion;
  final String fechaProduccion;
  final String fechaVencimiento;
  final int producto;
  final UnidadProduccionModel unidadProduccion;

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

List<ProduccionModel> producciones = [];

// Futuro para traer los datos de la api

Future<List<ProduccionModel>> getProducciones() async {
  String url = "";

  url = "$sourceApi/api/producciones/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    producciones.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

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
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
