// ignore_for_file: file_names

import 'dart:convert';

import '../source.dart';
import 'bodegaModel.dart';
import 'package:http/http.dart' as http;

import 'categoriaModel.dart';
import 'productoModel.dart';
import 'puntoVentaModel.dart';
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import 'usuarioModel.dart';

class InventarioModel {
  final int id;
  final int stock;
  final String fecha;
  final BodegaModel bodega;

  InventarioModel({
    required this.id,
    required this.stock,
    required this.fecha,
    required this.bodega,
  });
}

List<InventarioModel> inventarios = [];

// Futuro para traer los datos de la api

Future<List<InventarioModel>> getInventario() async {
  String url = "";

  url = "$sourceApi/api/inventarios/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    inventarios.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var inventarioData in decodedData) {
      inventarios.add(
        InventarioModel(
          id: inventarioData['id'] ?? 0,
          stock: inventarioData['stock'] ?? 0,
          fecha: inventarioData['fecha'] ?? "",
          bodega: BodegaModel(
            id: inventarioData['bodega']['id'] ?? 0,
            cantidad: inventarioData['bodega']['cantidad'] ?? 0,
            produccion: inventarioData['bodega']['produccion'] ?? 0,
            producto: ProductoModel(
              id: inventarioData['bodega']['producto']['id'] ?? 0,
              nombre: inventarioData['bodega']['producto']['nombre'] ?? "",
              descripcion: inventarioData['bodega']['producto']['descripcion'] ?? "",
              estado: inventarioData['bodega']['producto']['estado'] ?? true,
              maxReserva: inventarioData['bodega']['producto']['maxReserva'] ?? 1000000,
              unidadMedida: inventarioData['bodega']['producto']['unidadMedida'] ?? "",
              destacado: inventarioData['bodega']['producto']['destacado'] ?? false,
              precio: inventarioData['bodega']['producto']['precio'] ?? 0,
              precioAprendiz: inventarioData['bodega']['producto']['precioAprendiz'] ?? 0,
              precioInstructor: inventarioData['bodega']['producto']['precioInstructor'] ?? 0,
              precioFuncionario:
                  inventarioData['bodega']['producto']['precioFuncionario'] ?? 0,
              precioOferta: inventarioData['bodega']['producto']['precioOferta'] ?? 0,
              precioOfertaAprendiz:
                  inventarioData['bodega']['producto']['precioOfertaAprendiz'] ?? 0,
              precioOfertaFuncionario:
                  inventarioData['bodega']['producto']['precioOfertaFuncionario'] ?? 0,
              precioOfertaInstructor:
                  inventarioData['bodega']['producto']['precioOfertaInstructor'] ?? 0,
              exclusivo: inventarioData['exclusivo'] ?? false,
              categoria: CategoriaModel(
                id: inventarioData['bodega']['producto']['categoria']['id'] ?? 0,
                nombre: inventarioData['bodega']['producto']['categoria']['nombre'] ?? "",
                imagen: inventarioData['bodega']['producto']['categoria']['imagen'] ?? "",
                icono: inventarioData['bodega']['producto']['categoria']['icono'] ?? "",
              ),
              unidadProduccion: UnidadProduccionModel(
                id: inventarioData['bodega']['producto']['unidadProduccion']['id'] ?? 0,
                nombre:
                    inventarioData['bodega']['producto']['unidadProduccion']['nombre'] ?? "",
                logo: inventarioData['bodega']['producto']['unidadProduccion']['logo'] ?? "",
                descripccion: inventarioData['bodega']['producto']['unidadProduccion']
                        ['descripcion'] ??
                    "",
                estado: inventarioData['bodega']['producto']['unidadProduccion']['estado'] ??
                    true,
                sede: SedeModel(
                  id: inventarioData['bodega']['producto']['unidadProduccion']['sede']
                          ['id'] ??
                      0,
                  nombre: inventarioData['bodega']['producto']['unidadProduccion']['sede']
                          ['nombre'] ??
                      "",
                  ciudad: inventarioData['bodega']['producto']['unidadProduccion']['sede']
                          ['ciudad'] ??
                      "",
                  departamento: inventarioData['bodega']['producto']['unidadProduccion']
                          ['sede']['departamento'] ??
                      "",
                  regional: inventarioData['bodega']['producto']['unidadProduccion']['sede']
                          ['regional'] ??
                      "",
                  direccion: inventarioData['bodega']['producto']['unidadProduccion']['sede']
                          ['direccion'] ??
                      "",
                  telefono1: inventarioData['bodega']['producto']['unidadProduccion']['sede']
                          ['telefono1'] ??
                      "",
                  telefono2: inventarioData['bodega']['producto']['unidadProduccion']['sede']
                          ['telefono2'] ??
                      "",
                  correo: inventarioData['bodega']['producto']['unidadProduccion']['sede']
                          ['correo'] ??
                      "",
                  longitud: inventarioData['bodega']['producto']['unidadProduccion']['sede']
                          ['longitud'] ??
                      "",
                  latitud: inventarioData['bodega']['producto']['unidadProduccion']['sede']
                          ['latitud'] ??
                      "",
                ),
              ),
              usuario: UsuarioModel(
                id: inventarioData['bodega']['producto']['usuario']['id'] ?? 0,
                nombres: inventarioData['bodega']['producto']['usuario']['nombres'] ?? "",
                apellidos: inventarioData['bodega']['producto']['usuario']['apellidos'] ?? "",
                tipoDocumento:
                    inventarioData['bodega']['producto']['usuario']['tipoDocumento'] ?? "",
                numeroDocumento:
                    inventarioData['bodega']['producto']['usuario']['numeroDocumento'] ?? "",
                correoElectronico: inventarioData['bodega']['producto']['usuario']
                        ['correoElectronico'] ??
                    "",
                ciudad: inventarioData['bodega']['producto']['usuario']['ciudad'] ?? "",
                direccion: inventarioData['bodega']['producto']['usuario']['direccion'] ?? "",
                telefono: inventarioData['bodega']['producto']['usuario']['telefono'] ?? "",
                telefonoCelular:
                    inventarioData['bodega']['producto']['usuario']['telefonoCelular'] ?? "",
                foto: inventarioData['bodega']['producto']['usuario']['foto'] ?? "",
                rol1: inventarioData['bodega']['producto']['usuario']['rol1'] ?? "",
                rol2: inventarioData['bodega']['producto']['usuario']['rol2'] ?? "",
                rol3: inventarioData['bodega']['producto']['usuario']['rol3'] ?? "",
                estado: inventarioData['bodega']['producto']['usuario']['estado'] ?? true,
                cargo: inventarioData['bodega']['producto']['usuario']['cargo'] ?? "",
                ficha: inventarioData['bodega']['producto']['usuario']['ficha'] ?? "",
                vocero: inventarioData['bodega']['producto']['usuario']['vocero'] ?? false,
                fechaRegistro:
                    inventarioData['bodega']['producto']['usuario']['fechaRegistro'] ?? "",
                sede: inventarioData['bodega']['producto']['usuario']['sede'] ?? 0,
              ),
            ),
            puntoVenta: PuntoVentaModel(
              id: inventarioData['bodega']['puntoVenta']['id'] ?? 0,
              nombre: inventarioData['bodega']['puntoVenta']['nombre'] ?? "",
              ubicacion: inventarioData['bodega']['puntoVenta']['ubicacion'] ?? "",
              estado: inventarioData['bodega']['puntoVenta']['estado'] ?? true,
              sede: inventarioData['bodega']['puntoVenta']['sede'] ?? 0,
            ),
          ),
        ),
      );
    }

    // Devolver la lista con los valores llenos
    return inventarios;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
