// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'categoriaModel.dart';
import 'productoModel.dart';
import "../source.dart";
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import 'usuarioModel.dart';

/// Clase que representa un visitado en la aplicación.
///
/// Esta clase contiene información sobre un visitado, como su identificador único,
/// la fecha en que se vio y el producto que se vio.
class VisitadoModel {
  /// El identificador único del visitado.
  final int id;

  /// La fecha en que se vio el producto.
  final String fechaVista;

  /// El identificador del usuario que vio el producto.
  final int usuario;

  /// El producto que se vio.
  final ProductoModel producto;

  /// Crea una instancia de [VisitadoModel].
  ///
  /// Los parámetros [id] y [fechaVista] son obligatorios.
  VisitadoModel({
    required this.id,
    required this.fechaVista,
    required this.usuario,
    required this.producto,
  });
}

/// Lista que almacena todas las instancias de [VisitadoModel].
///
/// Esta lista se utiliza para almacenar todos los visitados
/// que se han generado en la aplicación.
/// Los elementos de esta lista son de tipo [VisitadoModel].
/// Puedes agregar elementos a esta lista utilizando el método [add],
/// y puedes iterar sobre sus elementos utilizando un bucle [for] o el método [index].
List<VisitadoModel> visitados = [];

// Método para obtener los datos de los visitados
Future<List<VisitadoModel>> getVisitados() async {
  // URL para obtener los datos de los visitados de la API
  // Esta URL se utiliza para realizar una solicitud GET a la API y obtener los datos de los visitados.
  String url = "";

  // Construir la URL de la API utilizando la variable de configuración [sourceApi]
  url = "$sourceApi/api/visitados/";

  // Realizar una solicitud GET a la URL para obtener los datos de los visitados
  // El método [http.get] devuelve una promesa que se resuelve en una instancia de la clase [http.Response].
  // La respuesta de la solicitud se almacena en la variable [response].
  final response = await http.get(Uri.parse(url));

  // Verificar si la respuesta fue exitosa
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    visitados.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos de los visitados
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
            exclusivo: visitadoData['exclusivo'] ?? false,
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
              puntoVenta:
                  visitadoData['producto']['usuario']['puntoVenta'] ?? 0,
              unidadProduccion:
                  visitadoData['producto']['usuario']['unidadProduccion'] ?? 0,
            ),
          ),
        ),
      );
    }

    // Devolver la lista de visitados
    return visitados;
  } else {
    // Manejar el error de respuesta HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
