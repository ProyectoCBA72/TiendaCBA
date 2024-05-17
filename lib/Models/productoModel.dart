// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'usuarioModel.dart';
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import 'categoriaModel.dart';
import "../source.dart";

class ProductoModel {
  final int id;
  final String nombre;
  final String descripcion;
  final bool estado;
  final int maxReserva;
  final String unidadMedida;
  final bool destacado;
  final int precio;
  final int precioAprendiz;
  final int precioInstructor;
  final int precioFuncionario;
  final int precioOferta;
  final int precioOfertaAprendiz;
  final int precioOfertaFuncionario;
  final int precioOfertaInstructor;
  final CategoriaModel categoria;
  final UnidadProduccionModel unidadProduccion;
  final UsuarioModel usuario;
  final bool exclusivo;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.estado,
    required this.maxReserva,
    required this.unidadMedida,
    required this.destacado,
    required this.precio,
    required this.precioAprendiz,
    required this.precioInstructor,
    required this.precioFuncionario,
    required this.precioOferta,
    required this.precioOfertaAprendiz,
    required this.precioOfertaFuncionario,
    required this.precioOfertaInstructor,
    required this.categoria,
    required this.unidadProduccion,
    required this.usuario,
    required this.exclusivo,
  });
}

List<ProductoModel> productos = [];

// Futuro para traer los datos de la api

Future<List<ProductoModel>> getProductos() async {
  String url = "";

  url = "$sourceApi/api/productos/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    productos.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var productoData in decodedData) {
      productos.add(
        ProductoModel(
          id: productoData['id'] ?? 0,
          nombre: productoData['nombre'] ?? "",
          descripcion: productoData['descripcion'] ?? "",
          estado: productoData['estado'] ?? true,
          maxReserva: productoData['maxReserva'] ?? 1000000,
          unidadMedida: productoData['unidadMedida'] ?? "",
          destacado: productoData['destacado'] ?? false,
          precio: productoData['precio'] ?? 0,
          precioAprendiz: productoData['precioAprendiz'] ?? 0,
          precioInstructor: productoData['precioInstructor'] ?? 0,
          precioFuncionario: productoData['precioFuncionario'] ?? 0,
          precioOferta: productoData['precioOferta'] ?? 0,
          precioOfertaAprendiz: productoData['precioOfertaAprendiz'] ?? 0,
          precioOfertaFuncionario: productoData['precioOfertaFuncionario'] ?? 0,
          precioOfertaInstructor: productoData['precioOfertaInstructor'] ?? 0,
          exclusivo: productoData['exclusivo'] ?? false,
          categoria: CategoriaModel(
            id: productoData['categoria']['id'] ?? 0,
            nombre: productoData['categoria']['nombre'] ?? "",
            imagen: productoData['categoria']['imagen'] ?? "",
            icono: productoData['categoria']['icono'] ?? "",
          ),
          unidadProduccion: UnidadProduccionModel(
            id: productoData['unidadProduccion']['id'] ?? 0,
            nombre: productoData['unidadProduccion']['nombre'] ?? "",
            logo: productoData['unidadProduccion']['logo'] ?? "",
            descripccion: productoData['unidadProduccion']['descripcion'] ?? "",
            estado: productoData['unidadProduccion']['estado'] ?? true,
            sede: SedeModel(
              id: productoData['unidadProduccion']['sede']['id'] ?? 0,
              nombre: productoData['unidadProduccion']['sede']['nombre'] ?? "",
              ciudad: productoData['unidadProduccion']['sede']['ciudad'] ?? "",
              departamento: productoData['unidadProduccion']['sede']
                      ['departamento'] ??
                  "",
              regional:
                  productoData['unidadProduccion']['sede']['regional'] ?? "",
              direccion:
                  productoData['unidadProduccion']['sede']['direccion'] ?? "",
              telefono1:
                  productoData['unidadProduccion']['sede']['telefono1'] ?? "",
              telefono2:
                  productoData['unidadProduccion']['sede']['telefono2'] ?? "",
              correo: productoData['unidadProduccion']['sede']['correo'] ?? "",
              longitud:
                  productoData['unidadProduccion']['sede']['longitud'] ?? "",
              latitud:
                  productoData['unidadProduccion']['sede']['latitud'] ?? "",
            ),
          ),
          usuario: UsuarioModel(
            id: productoData['usuario']['id'] ?? 0,
            nombres: productoData['usuario']['nombres'] ?? "",
            apellidos: productoData['usuario']['apellidos'] ?? "",
            tipoDocumento: productoData['usuario']['tipoDocumento'] ?? "",
            numeroDocumento: productoData['usuario']['numeroDocumento'] ?? "",
            correoElectronico:
                productoData['usuario']['correoElectronico'] ?? "",
            ciudad: productoData['usuario']['ciudad'] ?? "",
            direccion: productoData['usuario']['direccion'] ?? "",
            telefono: productoData['usuario']['telefono'] ?? "",
            telefonoCelular: productoData['usuario']['telefonoCelular'] ?? "",
            foto: productoData['usuario']['foto'] ?? "",
            rol1: productoData['usuario']['rol1'] ?? "",
            rol2: productoData['usuario']['rol2'] ?? "",
            rol3: productoData['usuario']['rol3'] ?? "",
            estado: productoData['usuario']['estado'] ?? true,
            cargo: productoData['usuario']['cargo'] ?? "",
            ficha: productoData['usuario']['ficha'] ?? "",
            vocero: productoData['usuario']['vocero'] ?? false,
            fechaRegistro: productoData['usuario']['fechaRegistro'] ?? "",
            sede: productoData['usuario']['sede'] ?? 0,
          ),
        ),
      );
    }

    // Devolver la lista de productos
    return productos;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
