// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'categoriaModel.dart';
import 'productoModel.dart';
import '../source.dart';
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import 'usuarioModel.dart';

class ImagenProductoModel {
  final int id;
  final String imagen;
  final ProductoModel producto;

  ImagenProductoModel({
    required this.id,
    required this.imagen,
    required this.producto,
  });
}

List<ImagenProductoModel> imagenProductos = [];

// Futuro para traer los datos de la api

Future<List<ImagenProductoModel>> getImagenProductos() async {
  String url = "";

  url = "$sourceApi/api/imagenes/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    imagenProductos.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

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
            precioOfertaAprendiz:
                imagenProductoData['producto']['precioOfertaAprendiz'] ?? 0,
            precioOfertaFuncionario:
                imagenProductoData['producto']['precioOfertaFuncionario'] ?? 0,
            precioOfertaInstructor:
                imagenProductoData['producto']['precioOfertaInstructor'] ?? 0,
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
              foto: imagenProductoData['producto']['usuario']['foto'] ?? "",
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
            ),
          ),
        ),
      );
    }

    // Devolver la lista de imagenes
    return imagenProductos;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
