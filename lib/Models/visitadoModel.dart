import 'dart:convert';
import 'package:http/http.dart' as http;
import 'categoriaModel.dart';
import 'productoModel.dart';
import "../source.dart";
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import 'usuarioModel.dart';

class VisitadoModel {
  final int id;
  final String fechaVista;
  final int usuario;
  final ProductoModel producto;

  VisitadoModel({
    required this.id,
    required this.fechaVista,
    required this.usuario,
    required this.producto,
  });
}

List<VisitadoModel> visitados = [];

// Futuro para traer los datos de la api

Future<List<VisitadoModel>> getVisitados() async {
  String url = "";

  url = "$sourceApi/api/visitados/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    visitados.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var visitadoData in decodedData) {
      visitados.add(
        VisitadoModel(
          id: visitadoData['id'] ?? 0,
          fechaVista: visitadoData['fechaVista'] ?? "",
          usuario: visitadoData['usuario'] ?? 0,
          producto: ProductoModel(
            id: visitadoData['producto']['id'] ?? 0,
            nombre: visitadoData['producto']['nombre'] ?? "",
            descripcion: visitadoData['producto']['descripcion'] ?? "",
            estado: visitadoData['producto']['estado'] ?? true,
            maxReserva: visitadoData['producto']['maxReserva'] ?? 1000000,
            unidadMedida: visitadoData['producto']['unidadMedida'] ?? "",
            destacado: visitadoData['producto']['destacado'] ?? false,
            precio: visitadoData['producto']['precio'] ?? 0,
            precioAprendiz: visitadoData['producto']['precioAprendiz'] ?? 0,
            precioInstructor: visitadoData['producto']['precioInstructor'] ?? 0,
            precioFuncionario:
                visitadoData['producto']['precioFuncionario'] ?? 0,
            precioOferta: visitadoData['producto']['precioOferta'] ?? 0,
            precioOfertaAprendiz:
                visitadoData['producto']['precioOfertaAprendiz'] ?? 0,
            precioOfertaFuncionario:
                visitadoData['producto']['precioOfertaFuncionario'] ?? 0,
            precioOfertaInstructor:
                visitadoData['producto']['precioOfertaInstructor'] ?? 0,
            categoria: CategoriaModel(
              id: visitadoData['producto']['categoria']['id'] ?? 0,
              nombre: visitadoData['producto']['categoria']['nombre'] ?? "",
              imagen: visitadoData['producto']['categoria']['imagen'] ?? "",
              icono: visitadoData['producto']['categoria']['icono'] ?? "",
            ),
            unidadProduccion: UnidadProduccionModel(
              id: visitadoData['producto']['unidadProduccion']['id'] ?? 0,
              nombre:
                  visitadoData['producto']['unidadProduccion']['nombre'] ?? "",
              logo: visitadoData['producto']['unidadProduccion']['logo'] ?? "",
              descripccion: visitadoData['producto']['unidadProduccion']
                      ['descripcion'] ??
                  "",
              estado: visitadoData['producto']['unidadProduccion']['estado'] ??
                  true,
              sede: SedeModel(
                id: visitadoData['producto']['unidadProduccion']['sede']
                        ['id'] ??
                    0,
                nombre: visitadoData['producto']['unidadProduccion']['sede']
                        ['nombre'] ??
                    "",
                ciudad: visitadoData['producto']['unidadProduccion']['sede']
                        ['ciudad'] ??
                    "",
                departamento: visitadoData['producto']['unidadProduccion']
                        ['sede']['departamento'] ??
                    "",
                regional: visitadoData['producto']['unidadProduccion']['sede']
                        ['regional'] ??
                    "",
                direccion: visitadoData['producto']['unidadProduccion']['sede']
                        ['direccion'] ??
                    "",
                telefono1: visitadoData['producto']['unidadProduccion']['sede']
                        ['telefono1'] ??
                    "",
                telefono2: visitadoData['producto']['unidadProduccion']['sede']
                        ['telefono2'] ??
                    "",
                correo: visitadoData['producto']['unidadProduccion']['sede']
                        ['correo'] ??
                    "",
                longitud: visitadoData['producto']['unidadProduccion']['sede']
                        ['longitud'] ??
                    "",
                latitud: visitadoData['producto']['unidadProduccion']['sede']
                        ['latitud'] ??
                    "",
              ),
            ),
            usuario: UsuarioModel(
              id: visitadoData['producto']['usuario']['id'] ?? 0,
              nombres: visitadoData['producto']['usuario']['nombres'] ?? "",
              apellidos: visitadoData['producto']['usuario']['apellidos'] ?? "",
              tipoDocumento:
                  visitadoData['producto']['usuario']['tipoDocumento'] ?? "",
              numeroDocumento:
                  visitadoData['producto']['usuario']['numeroDocumento'] ?? "",
              correoElectronico: visitadoData['producto']['usuario']
                      ['correoElectronico'] ??
                  "",
              ciudad: visitadoData['producto']['usuario']['ciudad'] ?? "",
              direccion: visitadoData['producto']['usuario']['direccion'] ?? "",
              telefono: visitadoData['producto']['usuario']['telefono'] ?? "",
              telefonoCelular:
                  visitadoData['producto']['usuario']['telefonoCelular'] ?? "",
              foto: visitadoData['producto']['usuario']['foto'] ?? "",
              rol1: visitadoData['producto']['usuario']['rol1'] ?? "",
              rol2: visitadoData['producto']['usuario']['rol2'] ?? "",
              rol3: visitadoData['producto']['usuario']['rol3'] ?? "",
              estado: visitadoData['producto']['usuario']['estado'] ?? true,
              cargo: visitadoData['producto']['usuario']['cargo'] ?? "",
              ficha: visitadoData['producto']['usuario']['ficha'] ?? "",
              vocero: visitadoData['producto']['usuario']['vocero'] ?? false,
              fechaRegistro:
                  visitadoData['producto']['usuario']['fechaRegistro'] ?? "",
              sede: visitadoData['producto']['usuario']['sede'] ?? 0,
            ),
          ),
        ),
      );
    }

    // Devolver la lista llena
    return visitados;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
