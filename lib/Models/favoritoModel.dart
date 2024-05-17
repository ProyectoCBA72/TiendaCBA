// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'categoriaModel.dart';
import 'productoModel.dart';
import "../source.dart";
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import 'usuarioModel.dart';

class FavoritoModel {
  final int id;
  final int usuario;
  final ProductoModel producto;

  FavoritoModel({
    required this.id,
    required this.usuario,
    required this.producto,
  });
}

List<FavoritoModel> favoritos = [];

// Futuro para traer los datos de la api

Future<List<FavoritoModel>> getFavoritos() async {
  String url = "";

  url = "$sourceApi/api/favoritos/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    favoritos.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    for (var favoritoData in decodedData) {
      favoritos.add(
        FavoritoModel(
          id: favoritoData['id'] ?? 0,
          usuario: favoritoData['usuario'] ?? 0,
          producto: ProductoModel(
            id: favoritoData['producto']['id'] ?? 0,
            nombre: favoritoData['producto']['nombre'] ?? "",
            descripcion: favoritoData['producto']['descripcion'] ?? "",
            estado: favoritoData['producto']['estado'] ?? true,
            maxReserva: favoritoData['producto']['maxReserva'] ?? 1000000,
            unidadMedida: favoritoData['producto']['unidadMedida'] ?? "",
            destacado: favoritoData['producto']['destacado'] ?? false,
            precio: favoritoData['producto']['precio'] ?? 0,
            precioAprendiz: favoritoData['producto']['precioAprendiz'] ?? 0,
            precioInstructor: favoritoData['producto']['precioInstructor'] ?? 0,
            precioFuncionario:
                favoritoData['producto']['precioFuncionario'] ?? 0,
            precioOferta: favoritoData['producto']['precioOferta'] ?? 0,
            precioOfertaAprendiz:
                favoritoData['producto']['precioOfertaAprendiz'] ?? 0,
            precioOfertaFuncionario:
                favoritoData['producto']['precioOfertaFuncionario'] ?? 0,
            precioOfertaInstructor:
                favoritoData['producto']['precioOfertaInstructor'] ?? 0,
            exclusivo: favoritoData['exclusivo'] ?? false,
            categoria: CategoriaModel(
              id: favoritoData['producto']['categoria']['id'] ?? 0,
              nombre: favoritoData['producto']['categoria']['nombre'] ?? "",
              imagen: favoritoData['producto']['categoria']['imagen'] ?? "",
              icono: favoritoData['producto']['categoria']['icono'] ?? "",
            ),
            unidadProduccion: UnidadProduccionModel(
              id: favoritoData['producto']['unidadProduccion']['id'] ?? 0,
              nombre:
                  favoritoData['producto']['unidadProduccion']['nombre'] ?? "",
              logo: favoritoData['producto']['unidadProduccion']['logo'] ?? "",
              descripccion: favoritoData['producto']['unidadProduccion']
                      ['descripcion'] ??
                  "",
              estado: favoritoData['producto']['unidadProduccion']['estado'] ??
                  true,
              sede: SedeModel(
                id: favoritoData['producto']['unidadProduccion']['sede']
                        ['id'] ??
                    0,
                nombre: favoritoData['producto']['unidadProduccion']['sede']
                        ['nombre'] ??
                    "",
                ciudad: favoritoData['producto']['unidadProduccion']['sede']
                        ['ciudad'] ??
                    "",
                departamento: favoritoData['producto']['unidadProduccion']
                        ['sede']['departamento'] ??
                    "",
                regional: favoritoData['producto']['unidadProduccion']['sede']
                        ['regional'] ??
                    "",
                direccion: favoritoData['producto']['unidadProduccion']['sede']
                        ['direccion'] ??
                    "",
                telefono1: favoritoData['producto']['unidadProduccion']['sede']
                        ['telefono1'] ??
                    "",
                telefono2: favoritoData['producto']['unidadProduccion']['sede']
                        ['telefono2'] ??
                    "",
                correo: favoritoData['producto']['unidadProduccion']['sede']
                        ['correo'] ??
                    "",
                longitud: favoritoData['producto']['unidadProduccion']['sede']
                        ['longitud'] ??
                    "",
                latitud: favoritoData['producto']['unidadProduccion']['sede']
                        ['latitud'] ??
                    "",
              ),
            ),
            usuario: UsuarioModel(
              id: favoritoData['producto']['usuario']['id'] ?? 0,
              nombres: favoritoData['producto']['usuario']['nombres'] ?? "",
              apellidos: favoritoData['producto']['usuario']['apellidos'] ?? "",
              tipoDocumento:
                  favoritoData['producto']['usuario']['tipoDocumento'] ?? "",
              numeroDocumento:
                  favoritoData['producto']['usuario']['numeroDocumento'] ?? "",
              correoElectronico: favoritoData['producto']['usuario']
                      ['correoElectronico'] ??
                  "",
              ciudad: favoritoData['producto']['usuario']['ciudad'] ?? "",
              direccion: favoritoData['producto']['usuario']['direccion'] ?? "",
              telefono: favoritoData['producto']['usuario']['telefono'] ?? "",
              telefonoCelular:
                  favoritoData['producto']['usuario']['telefonoCelular'] ?? "",
              foto: favoritoData['producto']['usuario']['foto'] ?? "",
              rol1: favoritoData['producto']['usuario']['rol1'] ?? "",
              rol2: favoritoData['producto']['usuario']['rol2'] ?? "",
              rol3: favoritoData['producto']['usuario']['rol3'] ?? "",
              estado: favoritoData['producto']['usuario']['estado'] ?? true,
              cargo: favoritoData['producto']['usuario']['cargo'] ?? "",
              ficha: favoritoData['producto']['usuario']['ficha'] ?? "",
              vocero: favoritoData['producto']['usuario']['vocero'] ?? false,
              fechaRegistro:
                  favoritoData['producto']['usuario']['fechaRegistro'] ?? "",
              sede: favoritoData['producto']['usuario']['sede'] ?? 0,
            ),
          ),
        ),
      );
    }
    
    print(favoritos[0].producto.unidadProduccion.sede);
    // Devolver la lista llena
    return favoritos;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
