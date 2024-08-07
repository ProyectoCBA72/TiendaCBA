// ignore_for_file: file_names

import '../source.dart';
import 'categoriaModel.dart';
import 'puntoVentaModel.dart';
import 'productoModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import 'usuarioModel.dart';

/// Clase que representa una bodega en la aplicación.
///
/// Contiene información sobre la cantidad de productos en la bodega, el
/// producto que se encuentra en la bodega y el punto de venta al que está
/// asociada.
class BodegaModel {
  /// Identificador único de la bodega.
  final int id;

  /// Cantidad de productos que hay en la bodega.
  final int cantidad;

  /// Producto que se encuentra en la bodega.
  final ProductoModel producto;

  /// Punto de venta al que está asociada la bodega.
  final PuntoVentaModel puntoVenta;

  /// Crea una nueva instancia de [BodegaModel].
  ///
  /// Los parámetros [id], [cantidad], [producto] y [puntoVenta] son obligatorios.
  BodegaModel({
    required this.id,
    required this.cantidad,
    required this.producto,
    required this.puntoVenta,
  });
}

/// Lista que almacena las instancias de [BodegaModel] obtenidas de la API.
///
/// Esta lista se utiliza para almacenar y acceder a los datos de las bodegas
/// proporcionadas por la API.
List<BodegaModel> bodegas = [];

/// Lista que almacena las instancias de [BodegaModel].
///
/// Esta lista se utiliza para almacenar y acceder a los datos de las bodegas
/// obtenidas de la API. La lista se inicializa vacía y se llenará con los
/// datos obtenidos de la API utilizando el método [getBodegas].

// Metodo para obtener los datos de las bodegas

Future<List<BodegaModel>> getBodegas() async {
  // Url de la API
  String url = "";

  // Construir la URL de la API para obtener los datos de las bodegas
  url = "$sourceApi/api/bodegas/";

  /// Realiza una solicitud GET a la URL de la API para obtener los datos
  /// de las bodegas.
  ///
  /// Esta función hace una solicitud GET a la URL de la API para obtener los
  /// datos de las bodegas. Luego, decodifica la respuesta JSON a UTF-8 y
  /// los datos obtenidos se utilizan para llenar la lista [bodegas].
  ///
  /// No se requiere ningún parámetro.
  ///
  /// Devuelve una [Future] que contiene una lista de [BodegaModel] con los
  /// datos de las bodegas.
  final response = await http.get(Uri.parse(url));

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    bodegas.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de bodegas
    for (var bodegaData in decodedData) {
      bodegas.add(
        BodegaModel(
          id: bodegaData['id'] ?? 0,
          cantidad: bodegaData['cantidad'] ?? 0,
          producto: ProductoModel(
            id: bodegaData['producto']['id'] ?? 0,
            nombre: bodegaData['producto']['nombre'] ?? "",
            descripcion: bodegaData['producto']['descripcion'] ?? "",
            estado: bodegaData['producto']['estado'] ?? true,
            maxReserva: bodegaData['producto']['maxReserva'] ?? 1000000,
            unidadMedida: bodegaData['producto']['unidadMedida'] ?? "",
            destacado: bodegaData['producto']['destacado'] ?? false,
            precio: bodegaData['producto']['precio'] ?? 0,
            precioAprendiz: bodegaData['producto']['precioAprendiz'] ?? 0,
            precioInstructor: bodegaData['producto']['precioInstructor'] ?? 0,
            precioFuncionario: bodegaData['producto']['precioFuncionario'] ?? 0,
            precioOferta: bodegaData['producto']['precioOferta'] ?? 0,
            exclusivo: bodegaData['exclusivo'] ?? false,
            categoria: CategoriaModel(
              id: bodegaData['producto']['categoria']['id'] ?? 0,
              nombre: bodegaData['producto']['categoria']['nombre'] ?? "",
              imagen: bodegaData['producto']['categoria']['imagen'] ?? "",
              icono: bodegaData['producto']['categoria']['icono'] ?? "",
            ),
            unidadProduccion: UnidadProduccionModel(
              id: bodegaData['producto']['unidadProduccion']['id'] ?? 0,
              nombre:
                  bodegaData['producto']['unidadProduccion']['nombre'] ?? "",
              logo: bodegaData['producto']['unidadProduccion']['logo'] ?? "",
              descripccion: bodegaData['producto']['unidadProduccion']
                      ['descripcion'] ??
                  "",
              estado:
                  bodegaData['producto']['unidadProduccion']['estado'] ?? true,
              sede: SedeModel(
                id: bodegaData['producto']['unidadProduccion']['sede']['id'] ??
                    0,
                nombre: bodegaData['producto']['unidadProduccion']['sede']
                        ['nombre'] ??
                    "",
                ciudad: bodegaData['producto']['unidadProduccion']['sede']
                        ['ciudad'] ??
                    "",
                departamento: bodegaData['producto']['unidadProduccion']['sede']
                        ['departamento'] ??
                    "",
                regional: bodegaData['producto']['unidadProduccion']['sede']
                        ['regional'] ??
                    "",
                direccion: bodegaData['producto']['unidadProduccion']['sede']
                        ['direccion'] ??
                    "",
                telefono1: bodegaData['producto']['unidadProduccion']['sede']
                        ['telefono1'] ??
                    "",
                telefono2: bodegaData['producto']['unidadProduccion']['sede']
                        ['telefono2'] ??
                    "",
                correo: bodegaData['producto']['unidadProduccion']['sede']
                        ['correo'] ??
                    "",
                longitud: bodegaData['producto']['unidadProduccion']['sede']
                        ['longitud'] ??
                    "",
                latitud: bodegaData['producto']['unidadProduccion']['sede']
                        ['latitud'] ??
                    "",
              ),
            ),
            usuario: UsuarioModel(
              id: bodegaData['producto']['usuario']['id'] ?? 0,
              nombres: bodegaData['producto']['usuario']['nombres'] ?? "",
              apellidos: bodegaData['producto']['usuario']['apellidos'] ?? "",
              tipoDocumento:
                  bodegaData['producto']['usuario']['tipoDocumento'] ?? "",
              numeroDocumento:
                  bodegaData['producto']['usuario']['numeroDocumento'] ?? "",
              correoElectronico:
                  bodegaData['producto']['usuario']['correoElectronico'] ?? "",
              ciudad: bodegaData['producto']['usuario']['ciudad'] ?? "",
              direccion: bodegaData['producto']['usuario']['direccion'] ?? "",
              telefono: bodegaData['producto']['usuario']['telefono'] ?? "",
              telefonoCelular:
                  bodegaData['producto']['usuario']['telefonoCelular'] ?? "",
              rol1: bodegaData['producto']['usuario']['rol1'] ?? "",
              rol2: bodegaData['producto']['usuario']['rol2'] ?? "",
              rol3: bodegaData['producto']['usuario']['rol3'] ?? "",
              estado: bodegaData['producto']['usuario']['estado'] ?? true,
              cargo: bodegaData['producto']['usuario']['cargo'] ?? "",
              ficha: bodegaData['producto']['usuario']['ficha'] ?? "",
              vocero: bodegaData['producto']['usuario']['vocero'] ?? false,
              fechaRegistro:
                  bodegaData['producto']['usuario']['fechaRegistro'] ?? "",
              sede: bodegaData['producto']['usuario']['sede'] ?? 0,
              puntoVenta: bodegaData['producto']['usuario']['puntoVenta'] ?? 0,
              unidadProduccion:
                  bodegaData['producto']['usuario']['unidadProduccion'] ?? 0,
            ),
          ),
          puntoVenta: PuntoVentaModel(
            id: bodegaData['puntoVenta']['id'] ?? 0,
            nombre: bodegaData['puntoVenta']['nombre'] ?? "",
            ubicacion: bodegaData['puntoVenta']['ubicacion'] ?? "",
            estado: bodegaData['puntoVenta']['estado'] ?? true,
            sede: bodegaData['puntoVenta']['sede'] ?? 0,
          ),
        ),
      );
    }
    // Devolver la lista de bodegas
    return bodegas;
  } else {
    // Lanzar una excepción si la respuesta no es exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
