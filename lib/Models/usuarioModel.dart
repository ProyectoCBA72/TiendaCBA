// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';

/// Clase que representa un usuario en la aplicación.
///
/// Contiene información como el identificador único, los nombres, los apellidos,
/// el tipo de documento, el número de documento, el correo electrónico, la
/// ciudad, la dirección, el teléfono, el teléfono celular, el rol 1, el rol 2,
/// el rol 3, el estado, el cargo, la ficha, el vocero, la fecha de registro,
/// la sede a la que está asociado, el punto de venta al que está asociado y
/// la unidad de producción a la que está asociado.
class UsuarioModel {
  /// Identificador único del usuario.
  final int id;

  /// Nombre del usuario.
  final String nombres;

  /// Apellido del usuario.
  final String apellidos;

  /// Tipo de documento del usuario.
  final String tipoDocumento;

  /// Número de documento del usuario.
  final String numeroDocumento;

  /// Correo electrónico del usuario.
  final String correoElectronico;

  /// Ciudad del usuario.
  final String ciudad;

  /// Dirección del usuario.
  final String direccion;

  /// Teléfono del usuario.
  final String telefono;

  /// Teléfono celular del usuario.
  final String telefonoCelular;

  /// Rol 1 del usuario.
  final String rol1;

  /// Rol 2 del usuario.
  final String rol2;

  /// Rol 3 del usuario.
  final String rol3;

  /// Estado del usuario.
  final bool estado;

  /// Cargo del usuario.
  final String cargo;

  /// Ficha del usuario.
  final String ficha;

  /// Vocero del usuario.
  final bool vocero;

  /// Fecha de registro del usuario.
  final String fechaRegistro;

  /// Sede a la que está asociado el usuario.
  final int sede;

  /// Punto de venta al que está asociado el usuario.
  final int puntoVenta;

  /// Unidad de producción a la que está asociado el usuario.
  final int unidadProduccion;

  /// Crea un nuevo objeto [UsuarioModel] con los parámetros proporcionados.
  UsuarioModel({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.correoElectronico,
    required this.ciudad,
    required this.direccion,
    required this.telefono,
    required this.telefonoCelular,
    required this.rol1,
    required this.rol2,
    required this.rol3,
    required this.estado,
    required this.cargo,
    required this.ficha,
    required this.vocero,
    required this.fechaRegistro,
    required this.sede,
    required this.puntoVenta,
    required this.unidadProduccion,
  });
}

/// Clase que representa un modelo de registro de usuario.
///
/// Esta clase contiene los atributos necesarios para el registro de un usuario,
/// como nombres, apellidos, correo electrónico, tipo de documento, número de documento,
/// y teléfono.
class UsuarioRegisterModel {
  /// Nombre del usuario.
  final String nombres;

  /// Apellidos del usuario.
  final String apellidos;

  /// Correo electrónico del usuario.
  final String correo;

  /// Tipo de documento del usuario.
  final String tipoDocumento;

  /// Número de documento del usuario.
  final String noDocumento;

  /// Teléfono del usuario.
  final String telefono;

  /// Crea un nuevo objeto [UsuarioRegisterModel] con los parámetros proporcionados.
  UsuarioRegisterModel({
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.tipoDocumento,
    required this.noDocumento,
    required this.telefono,
  });

  /// Factory para crear un [UsuarioRegisterModel] a partir de una lista de datos de CSV.
  ///
  /// Si el valor de algún atributo es nulo, se coloca una cadena vacía.
  /// Utiliza el método [toString] para convertir los valores de los atributos numéricos a cadenas.
  factory UsuarioRegisterModel.fromCsv(List<dynamic> row) {
    return UsuarioRegisterModel(
      nombres: row.isNotEmpty ? row[0].toString() : '',
      apellidos: row.length > 1 ? row[1].toString() : '',
      telefono: row.length > 2 ? row[2].toString() : '',
      tipoDocumento: row.length > 3 ? row[3].toString() : '',
      noDocumento: row.length > 4 ? row[4].toString() : '',
      correo: row.length > 5 ? row[5].toString() : '',
    );
  }

  /// Indica si todos los atributos del modelo son completos.
  ///
  /// Un modelo es completo si tiene valores para todos los atributos.
  bool get isComplete {
    return nombres.isNotEmpty &&
        apellidos.isNotEmpty &&
        telefono.isNotEmpty &&
        tipoDocumento.isNotEmpty &&
        noDocumento.isNotEmpty &&
        correo.isNotEmpty;
  }
}

/// Lista que almacena todos los objetos [UsuarioModel].
///
/// Esta lista se utiliza para almacenar todos los usuarios
/// que se han creado en la aplicación.
/// Los elementos de esta lista son de tipo [UsuarioModel].
/// Puedes agregar elementos a esta lista utilizando el método [add],
/// y puedes iterar sobre sus elementos utilizando un bucle [for] o el método [index].
///
/// Ejemplo de uso:
///   // Agregar un usuario a la lista
///   usuarios.add(UsuarioModel(
///     id: 1,
///     nombres: "Juan",
///     apellidos: "Perez",
///     tipoDocumento: "DNI",
///     numeroDocumento: "12345678",
///     correoElectronico: "juan@example.com",
///     ciudad: "Lima",
///     direccion: "Calle 123",
///     telefono: "1234567",
///     telefonoCelular: "987654321",
///     rol1: true,
///     rol2: false,
///     rol3: false,
///     estado: "Activo",
///     cargo: "Administrador",
///     ficha: "123456",
///     vocero: false,
///     fechaRegistro: "2023-01-01",
///     sede: 1,
///     puntoVenta: 1,
///     unidadProduccion: 1,
///   ));
List<UsuarioModel> usuarios = [];

// Método para obtener los datos de los usuarios
Future<List<UsuarioModel>> getUsuarios() async {
  /// URL para obtener los datos de los usuarios de la API.
  ///
  /// Esta URL se utiliza para realizar una solicitud GET a la API y obtener los datos de los usuarios.
  String url = "";

  // Construir la URL de la API utilizando la variable de configuración [sourceApi]
  url = "$sourceApi/api/usuarios/";

  // Realizar una solicitud GET a la URL para obtener los datos de los usuarios
  // El método [http.get] devuelve una promesa que se resuelve en una instancia de la clase [http.Response].
  // La respuesta de la solicitud se almacena en la variable [response].
  final response = await http.get(Uri.parse(url));

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    usuarios.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos decodificados
    for (var usuariodata in decodedData) {
      usuarios.add(
        UsuarioModel(
          id: usuariodata['id'] ?? 0,
          nombres: usuariodata['nombres'] ?? "",
          apellidos: usuariodata['apellidos'] ?? "",
          tipoDocumento: usuariodata['tipoDocumento'] ?? "",
          numeroDocumento: usuariodata['numeroDocumento'] ?? "",
          correoElectronico: usuariodata['correoElectronico'] ?? "",
          ciudad: usuariodata['ciudad'] ?? "",
          direccion: usuariodata['direccion'] ?? "",
          telefono: usuariodata['telefono'] ?? "",
          telefonoCelular: usuariodata['telefonoCelular'] ?? "",
          rol1: usuariodata['rol1'] ?? "",
          rol2: usuariodata['rol2'] ?? "",
          rol3: usuariodata['rol3'] ?? "",
          estado: usuariodata['estado'] ?? true,
          cargo: usuariodata['cargo'] ?? "",
          ficha: usuariodata['ficha'] ?? "",
          vocero: usuariodata['vocero'] ?? false,
          fechaRegistro: usuariodata['fechaRegistro'] ?? "",
          sede: usuariodata['sede'] ?? 0,
          puntoVenta: usuariodata['puntoVenta'] ?? 0,
          unidadProduccion: usuariodata['unidadProduccion'] ?? 0,
        ),
      );
    }

    // Devolver la lista de usuarios
    return usuarios;
  } else {
    // Si la respuesta no fue exitosa, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
