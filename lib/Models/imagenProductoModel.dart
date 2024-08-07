// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'categoriaModel.dart';
import 'productoModel.dart';
import '../source.dart';
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import 'usuarioModel.dart';

/// Clase que representa una imagen de un producto.
///
/// Esta clase contiene los atributos necesarios para representar una imagen de un producto.
class ImagenProductoModel {
  /// Identificador único de la imagen.
  final int id;

  /// Ruta de la imagen.
  final String imagen;

  /// Producto al que pertenece la imagen.
  final ProductoModel producto;

  /// Crea una nueva instancia de [ImagenProductoModel].
  ///
  /// Los parámetros [id] y [imagen] son obligatorios, mientras que [producto]
  /// es obligatorio.
  ImagenProductoModel({
    required this.id,
    required this.imagen,
    required this.producto,
  });
}

/// Lista que almacena los objetos [ImagenProductoModel] representando las imágenes de los productos.
///
/// Esta lista se utiliza para almacenar los datos de las imágenes de los productos.
/// Cada objeto [ImagenProductoModel] en la lista representa una imagen de un producto.
List<ImagenProductoModel> imagenProductos = [];

/// Lista que almacena los objetos [ImagenProductoModel] representando las imágenes de los productos.
///
/// Esta lista se utiliza para almacenar los datos de las imágenes de los productos.
/// Cada objeto [ImagenProductoModel] en la lista representa una imagen de un producto.
///

// Método para obtener los datos de las imagenes
Future<List<ImagenProductoModel>> getImagenProductos() async {
  // URL base para la obtención de imágenes de productos
  String url = "";

  /// URL que se utiliza para obtener las imágenes de los productos a través de una solicitud HTTP GET.
  ///
  /// La URL se construye concatenando la constante [sourceApi] con "/api/imagenes/".
  url = "$sourceApi/api/imagenes/";

  /// Realiza una solicitud HTTP GET a la URL construida para obtener las imágenes de los productos.
  ///
  /// La respuesta de la solicitud se almacena en la variable [response].
  final response = await http.get(Uri.parse(url));

  // Verifica si la respuesta fue exitosa
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    imagenProductos.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos de las imagenes
    for (var imagenProductoData in decodedData) {
      imagenProductos.add(
        ImagenProductoModel(
          id: imagenProductoData['id'] ?? 0,
          imagen: imagenProductoData['imagen'] ?? "",
          producto: ProductoModel(
            id: imagenProductoData['producto']['id'] ?? 0,
            nombre: imagenProductoData['producto']['nombre'] ?? "",
            descripcion: imagenProductoData['producto']['descripcion'] ?? "",
            estado: imagenProductoData['producto']['estado'] ?? true,
            maxReserva: imagenProductoData['producto']['maxReserva'] ?? 1000000,
            unidadMedida: imagenProductoData['producto']['unidadMedida'] ?? "",
            destacado: imagenProductoData['producto']['destacado'] ?? false,
            precio: imagenProductoData['producto']['precio'] ?? 0,
            precioAprendiz:
                imagenProductoData['producto']['precioAprendiz'] ?? 0,
            precioInstructor:
                imagenProductoData['producto']['precioInstructor'] ?? 0,
            precioFuncionario:
                imagenProductoData['producto']['precioFuncionario'] ?? 0,
            precioOferta: imagenProductoData['producto']['precioOferta'] ?? 0,
            exclusivo: imagenProductoData['exclusivo'] ?? false,
            categoria: CategoriaModel(
              id: imagenProductoData['producto']['categoria']['id'] ?? 0,
              nombre:
                  imagenProductoData['producto']['categoria']['nombre'] ?? "",
              imagen:
                  imagenProductoData['producto']['categoria']['imagen'] ?? "",
              icono: imagenProductoData['producto']['categoria']['icono'] ?? "",
            ),
            unidadProduccion: UnidadProduccionModel(
              id: imagenProductoData['producto']['unidadProduccion']['id'] ?? 0,
              nombre: imagenProductoData['producto']['unidadProduccion']
                      ['nombre'] ??
                  "",
              logo: imagenProductoData['producto']['unidadProduccion']
                      ['logo'] ??
                  "",
              descripccion: imagenProductoData['producto']['unidadProduccion']
                      ['descripcion'] ??
                  "",
              estado: imagenProductoData['producto']['unidadProduccion']
                      ['estado'] ??
                  true,
              sede: SedeModel(
                id: imagenProductoData['producto']['unidadProduccion']['sede']
                        ['id'] ??
                    0,
                nombre: imagenProductoData['producto']['unidadProduccion']
                        ['sede']['nombre'] ??
                    "",
                ciudad: imagenProductoData['producto']['unidadProduccion']
                        ['sede']['ciudad'] ??
                    "",
                departamento: imagenProductoData['producto']['unidadProduccion']
                        ['sede']['departamento'] ??
                    "",
                regional: imagenProductoData['producto']['unidadProduccion']
                        ['sede']['regional'] ??
                    "",
                direccion: imagenProductoData['producto']['unidadProduccion']
                        ['sede']['direccion'] ??
                    "",
                telefono1: imagenProductoData['producto']['unidadProduccion']
                        ['sede']['telefono1'] ??
                    "",
                telefono2: imagenProductoData['producto']['unidadProduccion']
                        ['sede']['telefono2'] ??
                    "",
                correo: imagenProductoData['producto']['unidadProduccion']
                        ['sede']['correo'] ??
                    "",
                longitud: imagenProductoData['producto']['unidadProduccion']
                        ['sede']['longitud'] ??
                    "",
                latitud: imagenProductoData['producto']['unidadProduccion']
                        ['sede']['latitud'] ??
                    "",
              ),
            ),
            usuario: UsuarioModel(
              id: imagenProductoData['producto']['usuario']['id'] ?? 0,
              nombres:
                  imagenProductoData['producto']['usuario']['nombres'] ?? "",
              apellidos:
                  imagenProductoData['producto']['usuario']['apellidos'] ?? "",
              tipoDocumento: imagenProductoData['producto']['usuario']
                      ['tipoDocumento'] ??
                  "",
              numeroDocumento: imagenProductoData['producto']['usuario']
                      ['numeroDocumento'] ??
                  "",
              correoElectronico: imagenProductoData['producto']['usuario']
                      ['correoElectronico'] ??
                  "",
              ciudad: imagenProductoData['producto']['usuario']['ciudad'] ?? "",
              direccion:
                  imagenProductoData['producto']['usuario']['direccion'] ?? "",
              telefono:
                  imagenProductoData['producto']['usuario']['telefono'] ?? "",
              telefonoCelular: imagenProductoData['producto']['usuario']
                      ['telefonoCelular'] ??
                  "",
              rol1: imagenProductoData['producto']['usuario']['rol1'] ?? "",
              rol2: imagenProductoData['producto']['usuario']['rol2'] ?? "",
              rol3: imagenProductoData['producto']['usuario']['rol3'] ?? "",
              estado:
                  imagenProductoData['producto']['usuario']['estado'] ?? true,
              cargo: imagenProductoData['producto']['usuario']['cargo'] ?? "",
              ficha: imagenProductoData['producto']['usuario']['ficha'] ?? "",
              vocero:
                  imagenProductoData['producto']['usuario']['vocero'] ?? false,
              fechaRegistro: imagenProductoData['producto']['usuario']
                      ['fechaRegistro'] ??
                  "",
              sede: imagenProductoData['producto']['usuario']['sede'] ?? 0,
              puntoVenta:
                  imagenProductoData['producto']['usuario']['puntoVenta'] ?? 0,
              unidadProduccion: imagenProductoData['producto']['usuario']
                      ['unidadProduccion'] ??
                  0,
            ),
          ),
        ),
      );
    }

    // Devolver la lista de imagenes
    return imagenProductos;
  } else {
    // Lanzar una excepción si la respuesta no fue exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
