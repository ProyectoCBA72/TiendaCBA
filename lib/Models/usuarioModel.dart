// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';

class UsuarioModel {
  final int id;
  final String nombres;
  final String apellidos;
  final String tipoDocumento;
  final String numeroDocumento;
  final String correoElectronico;
  final String ciudad;
  final String direccion;
  final String telefono;
  final String telefonoCelular;
  final String rol1;
  final String rol2;
  final String rol3;
  final bool estado;
  final String cargo;
  final String ficha;
  final bool vocero;
  final String fechaRegistro;
  final int sede;
  final int puntoVenta;
  final int unidadProduccion;

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

List<UsuarioModel> usuarios = [];

// Futuro para traer los datos de la api

Future<List<UsuarioModel>> getUsuarios() async {
  String url = "";

  url = "$sourceApi/api/usuarios/";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    usuarios.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

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

    // Devolver la lista con los valores llenos
    return usuarios;
  } else {
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
