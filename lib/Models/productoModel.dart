// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'usuarioModel.dart';
import 'sedeModel.dart';
import 'unidadProduccionModel.dart';
import 'categoriaModel.dart';
import "../source.dart";

/// Clase que representa un producto.
///
/// Esta clase define una estructura de datos para representar un producto.
/// Un producto contiene información como su identificador único, nombre, descripción, estado,
/// cantidad máxima de reserva, unidad de medida, si es destacado o exclusivo, precio, precio para
/// aprendices, precio para instructores, precio para funcionarios y precio de oferta. Además,
/// contiene la categoría a la que pertenece, la unidad de producción a la que pertenece, el usuario al que
/// pertenece y si es exclusivo para un usuario.
class ProductoModel {
  /// Identificador único del producto.
  final int id;

  /// Nombre del producto.
  final String nombre;

  /// Descripción del producto.
  final String descripcion;

  /// Estado del producto (activo o inactivo).
  final bool estado;

  /// Cantidad máxima de reserva del producto.
  final int maxReserva;

  /// Unidad de medida del producto.
  final String unidadMedida;

  /// Si el producto es destacado.
  final bool destacado;

  /// Precio del producto.
  final int precio;

  /// Precio para aprendices del producto.
  final int precioAprendiz;

  /// Precio para instructores del producto.
  final int precioInstructor;

  /// Precio para funcionarios del producto.
  final int precioFuncionario;

  /// Precio de oferta del producto.
  final int precioOferta;

  /// Categoría a la que pertenece el producto.
  final CategoriaModel categoria;

  /// Unidad de producción a la que pertenece el producto.
  final UnidadProduccionModel unidadProduccion;

  /// Usuario al que pertenece el producto.
  final UsuarioModel usuario;

  /// Si el producto es exclusivo para un usuario.
  final bool exclusivo;

  /// Crea un nuevo objeto [ProductoModel].
  ///
  /// Todos los parámetros son requeridos.
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
    required this.categoria,
    required this.unidadProduccion,
    required this.usuario,
    required this.exclusivo,
  });
}


// clase para almacenar los datos del buscador, ( temas de carga )
class ProductoConImagenes {
  final ProductoModel producto;
  final List<String> imagenes;

  ProductoConImagenes({
    required this.producto,
    required this.imagenes,
  });
}

/// Lista que almacena los objetos de tipo [ProductoModel].
///
/// Esta lista se utiliza para almacenar los productos obtenidos de la API.
/// Cada producto representa un objeto con información sobre un producto,
/// como su nombre, descripción, estado, unidad de medida, precio, etc.
///
/// Los elementos de esta lista pueden ser agregados utilizando el método [add],
/// y puedes iterar sobre sus elementos utilizando un bucle [for] o el método [index].
///
/// Ejemplo de uso:
///   // Agregar un producto a la lista
///   productos.add(ProductoModel(
///     id: 1,
///     nombre: "Producto de prueba",
///     // ... otros atributos del producto
///   ));
List<ProductoModel> productos = [];

// Metodo para obtener los datos de los productos
Future<List<ProductoModel>> getProductos() async {
  /// URL de la API que devuelve la lista de productos.
  /// Está formada por la URL base de la API y la ruta relativa a la endpoint.
  /// Ejemplo: "http://localhost:8000/api/productos/"
  String url = "";

  // Construcción de la URL de la API
  url = "$sourceApi/api/productos/";

  /// Realiza una solicitud GET a la URL de la API y devuelve la respuesta.
  ///
  /// La respuesta se espera en formato JSON.
  /// Si la respuesta es exitosa, se decodifica la información en una lista de
  /// objetos de tipo [ProductoModel], que se almacena en la variable [productos].
  ///
  /// Si falla la solicitud o la respuesta es distinta de 200 (OK), se imprime un
  /// mensaje de error.
  final response = await http.get(Uri.parse(url));

  // Verificación del estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    productos.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos actualizados
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
            rol1: productoData['usuario']['rol1'] ?? "",
            rol2: productoData['usuario']['rol2'] ?? "",
            rol3: productoData['usuario']['rol3'] ?? "",
            estado: productoData['usuario']['estado'] ?? true,
            cargo: productoData['usuario']['cargo'] ?? "",
            ficha: productoData['usuario']['ficha'] ?? "",
            vocero: productoData['usuario']['vocero'] ?? false,
            fechaRegistro: productoData['usuario']['fechaRegistro'] ?? "",
            sede: productoData['usuario']['sede'] ?? 0,
            puntoVenta: productoData['usuario']['puntoVenta'] ?? 0,
            unidadProduccion: productoData['usuario']['unidadProduccion'] ?? 0,
          ),
        ),
      );
    }

    // Devolver la lista de productos
    return productos;
  } else {
    // Lanzar una excepción si la respuesta no fue exitosa
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
