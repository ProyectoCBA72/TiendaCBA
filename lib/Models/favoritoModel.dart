// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'categoriaModel.dart';
import 'productoModel.dart';
import "../source.dart";
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import 'usuarioModel.dart';

/// Clase FavoritoModel que representa un favorito en la aplicación.
///
/// Esta clase define una estructura de datos para representar un favorito.
/// Un favorito es un producto que ha sido marcado como favorito por un usuario.
///
/// Atributos:
/// - id: El identificador único del favorito.
/// - usuario: El identificador del usuario que marcó el producto como favorito.
/// - producto: El producto marcado como favorito.
class FavoritoModel {
  /// El identificador único del favorito.
  final int id;

  /// El identificador del usuario que marcó el producto como favorito.
  final int usuario;

  /// El producto marcado como favorito.
  final ProductoModel producto;

  /// Constructor que crea un nuevo objeto FavoritoModel.
  ///
  /// Los parámetros son obligatorios.
  FavoritoModel({
    required this.id,
    required this.usuario,
    required this.producto,
  });
}

/// Lista que almacena todas las instancias de [FavoritoModel].
///
/// Esta lista se utiliza para almacenar todos los favoritos
/// que se han marcado en la aplicación.
/// Los elementos de esta lista son de tipo [FavoritoModel].
/// Puedes agregar elementos a esta lista utilizando el método [add],
/// y puedes iterar sobre sus elementos utilizando un bucle [for] o el método [index].
///
/// Ejemplo de uso:
///   // Agregar un favorito a la lista
///   favoritos.add(FavoritoModel(
///     id: 1,
///     usuario: 1,
///     producto: ProductoModel(id: 1, titulo: "Producto de prueba"),
///   ));
List<FavoritoModel> favoritos = [];

// Método para obtener los datos de los favoritos
Future<List<FavoritoModel>> getFavoritos() async {
  /// URL base para obtener los favoritos a través de la API.
  /// Se utiliza para construir la URL completa para realizar la solicitud HTTP GET.
  String url = "";

  // Construir la URL completa para obtener los favoritos
  url = "$sourceApi/api/favoritos/";

  /// Solicitud HTTP GET para obtener los favoritos.
  ///
  /// Realiza una solicitud a la URL construida anteriormente y espera una respuesta.
  /// Si la respuesta tiene un código de estado 200 (OK), se decodifica
  /// la respuesta JSON a UTF-8 y se convierte en una lista de objetos [dynamic].
  /// Luego, se limpia la lista de favoritos existentes y se llena con los
  /// datos actualizados obtenidos de la respuesta.
  ///
  /// Si la respuesta no tiene un código de estado 200, se lanza una excepción
  /// con el mensaje de error obtenido de la respuesta.
  final response = await http.get(Uri.parse(url));

  // Comentario adicional:
  // Es importante manejar casos de error en la respuesta HTTP.
  // En este caso, se lanza una excepción con el mensaje de error obtenido
  // de la respuesta si la respuesta no tiene un código de estado 200.

  // Verificar el estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    favoritos.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de favoritos con los datos decodificados
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
              puntoVenta:
                  favoritoData['producto']['usuario']['puntoVenta'] ?? 0,
              unidadProduccion:
                  favoritoData['producto']['usuario']['unidadProduccion'] ?? 0,
            ),
          ),
        ),
      );
    }
    // Devolver la lista de favoritos
    return favoritos;
  } else {
    // Lanzar una excepción si la respuesta no es exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
