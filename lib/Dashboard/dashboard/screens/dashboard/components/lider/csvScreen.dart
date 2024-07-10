// ignore_for_file: avoid_print, use_build_context_synchronously, file_names

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/controllers/MenuAppController.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/main/main_screen_usuario.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:csv/csv.dart';
import 'package:tienda_app/source.dart';
import 'package:http/http.dart' as http;

class UploadUsersCSV extends StatefulWidget {
  const UploadUsersCSV({super.key});

  @override
  State<UploadUsersCSV> createState() => _UploadUsersCSVState();
}

class _UploadUsersCSVState extends State<UploadUsersCSV> {
  List<UsuarioRegisterModel> _usuariosCompletos = [];
  List<UsuarioRegisterModel> _usuariosIncompletos = [];

  final List<UsuarioRegisterModel> _usuariosCargados = [];

  Future<void> _loadCSV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        // creamos una variable de las bytes del archivo
        final bytes = result.files.single.bytes;
        if (bytes != null) {
          // convertimos las bytes en formato string para poder convertirlo a csv.
          final csvString = utf8.decode(bytes);
          // convertimos el string en un formato mas legibles, lista de lista, con el fin de filtrar mejor los datos.
          List<List<dynamic>> csvTable =
              const CsvToListConverter().convert(csvString, eol: '\n');
          // Convertimos la lista de listas csvTable a una lista de Usuarios Model.
          List<UsuarioRegisterModel> usuarios = csvTable.skip(1).map((row) {
            return UsuarioRegisterModel.fromCsv(row);
          }).toList();
          // creamos las listas vacias para llenar con los datos ya comprobados
          List<UsuarioRegisterModel> completos = [];
          List<UsuarioRegisterModel> incompletos = [];

          // En cada uno de los usuarios en la lista principal verificamos si esta completo.
          for (var usuario in usuarios) {
            if (usuario.isComplete) {
              // si esta completo se agrega a los completo
              completos.add(usuario);
            } else {
              // si no lo esta se agrega a los incompletos
              incompletos.add(usuario);
            }
          }

          setState(() {
            // reahustamos las varibles para igualar los datos y poder usarlos mas adelante.
            _usuariosCompletos = completos;
            _usuariosIncompletos = incompletos;
          });
        } else {
          print("No se pudo leer el archivo seleccionado.");
        }
      } else {
        print('No file selected');
      }
    } catch (e) {
      print("Error al cargar el archivo CSV: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el archivo CSV: $e')),
      );
    }
  }

  // Construimos el encabezdo de la tabla, los valores que vamos a traer,
  // no se puede de la misma menera de abajo porque en las listas esquipeamos el primer row, que es donde esta eso.
  Widget _buildTableHeader() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 2,
                child: Text('Nombres',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            Expanded(
                flex: 2,
                child: Text('Apellidos',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            Expanded(
                flex: 2,
                child: Text('Teléfono',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            Expanded(
                flex: 2,
                child: Text('Tipo Documento',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            Expanded(
                flex: 2,
                child: Text('No Documento',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            Expanded(
                flex: 2,
                child: Text('Correo',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            Expanded(
                flex: 2,
                child: Text('Eliminar',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          ],
        ),
      ),
    );
  }

// construimos un registro De Usuario sea completo o incompleto.
  Widget _buildUserRow(UsuarioRegisterModel usuario) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 2,
              child: Text(
                usuario.nombres,
                style: const TextStyle(color: Colors.black),
              )),
          Expanded(
              flex: 2,
              child: Text(
                usuario.apellidos,
                style: const TextStyle(color: Colors.black),
              )),
          Expanded(
              flex: 2,
              child: Text(
                usuario.telefono,
                style: const TextStyle(color: Colors.black),
              )),
          Expanded(
              flex: 2,
              child: Text(
                usuario.tipoDocumento,
                style: const TextStyle(color: Colors.black),
              )),
          Expanded(
              flex: 2,
              child: Text(
                usuario.noDocumento,
                style: const TextStyle(color: Colors.black),
              )),
          Expanded(
              flex: 2,
              child: Text(
                usuario.correo,
                style: const TextStyle(color: Colors.black),
              )),
          // boton de eliminar en cada uno de los resgistros.
          Expanded(
              flex: 2,
              child: IconButton(
                onPressed: () {
                  // eliminamos el registro de la lista local, por si a caso.
                  deleteUser(usuario);
                },
                icon: const Icon(
                  Icons.delete,
                  size: 22,
                  color: Colors.red,
                ),
              )),
        ],
      ),
    );
  }

// funcion para eliminar el usuario de la lista local, al presionar el boton de eliminar.
  deleteUser(UsuarioRegisterModel usuario) {
    setState(() {
      _usuariosCompletos.remove(usuario);
      _usuariosIncompletos.remove(usuario);
    });
  }

  // Funcion para agregar los usuarios validos (usuariosCompletos)
  Future addUser(UsuarioRegisterModel usuario) async {
    final users = await getUsuarios();
    // verificamos en la base de datos si el usuario ya esta creado. ( documento )
    final isAdded =
        users.any((user) => user.numeroDocumento == usuario.noDocumento);
    // Pasos para hacer le post
    String url;
    url = '$sourceApi/api/usuarios/';

    final headers = {
      'Content-Type': 'application/json',
    };

    var defaultRol = "EXTERNO";
    var defaultStatus = true;
    final body = {
      'ciudad': '',
      'nombres': usuario.nombres,
      'apellidos': usuario.apellidos,
      'tipoDocumento': usuario.tipoDocumento,
      'numeroDocumento': usuario.noDocumento,
      'correoElectronico': usuario.correo,
      'telefono': '',
      'telefonoCelular': usuario.telefono,
      'rol1': defaultRol,
      'rol2': '',
      'rol3': '',
      'estado': defaultStatus,
      'sede': 1,
    };

    if (isAdded) {
      // si el usuario ya esta agregado se muestra un scaffold message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario ya registrado ${usuario.noDocumento}')),
      );
    } else {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        // si se envio correctamente se agrega el usuario a una lista local con el fin de mostrar los datos cargados, funcion a implemnetar
        setState(() {
          _usuariosCargados.add(usuario);
        });
        print('datos enviados');
      } else {
        print('Error al enviar datos: ${response.statusCode}');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usuariosCargados.clear();
    _usuariosCompletos.clear();
    _usuariosIncompletos.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Registrar Usuarios',
                      style: TextStyle(
                        fontFamily: 'Calibri-Bold',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // si la lista de usuarios validos no esta vacia, se crea el boton de subir.
                if (_usuariosCompletos.isNotEmpty)
                  Tooltip(
                    message: 'Cargar usuarios',
                    child: GestureDetector(
                      onTap: () {
                        // Acción de confirmar
                        modalPost();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // una vez cargado el archivo csv, se comprueba que las listas no esten vacias y se muestra la informacion.
          _usuariosCompletos.isEmpty && _usuariosIncompletos.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'Carga un archivo CSV',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        _buildTableHeader(),
                        const ListTile(
                          title: Text('Usuarios Completos',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        // de esta manera podemos construir un widget teniendo de base una lista.es como un listView.Builder
                        ..._usuariosCompletos.map((usuario) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: _buildUserRow(usuario),
                            )),
                        const Divider(),
                        const ListTile(
                          title: Text('Usuarios Incompletos',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        // de esta manera podemos construir un widget teniendo de base una lista.es como un listView.Builder
                        ..._usuariosIncompletos.map(
                          (usuario) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: _buildUserRow(usuario),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadCSV,
        tooltip: 'Cargar CSV',
        // Idea para que una vez cargado el archivo, cambie el icono de subir a recargar.
        child: Icon(_usuariosCompletos.isEmpty || _usuariosIncompletos.isEmpty
            ? Icons.file_upload
            : Icons.replay_rounded),
      ),
    );
  }

  // Modal Para confirmar la subida de los usuarios, con el fin de explicar que los usuarios no se van a subir si estan incompletos.
  void modalPost() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Importante!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Tenga en cuenta que los usuarios con algun dato faltante no se podran registrar. ",
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              ClipOval(
                child: Container(
                  width: 100, // Ajusta el tamaño según sea necesario
                  height: 100, // Ajusta el tamaño según sea necesario
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: Image.asset(
                    "assets/img/logo.png",
                    fit: BoxFit.cover, // Ajusta la imagen al contenedor
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Cancelar", () {
                    Navigator.pop(context);
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Aceptar", () async {
                    // por cada uno de los usuario completos creamos un registro en la base de datos.
                    for (var usuario in _usuariosCompletos) {
                      await addUser(usuario);
                    }
                    // mostramos el mensaje de los usuarios cargados.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Se cargaron ${_usuariosCargados.length} Usuarios')),
                    );
                    // cerramos el modal y construimos la vista del dashboard de nuevo.
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                                create: (context) => MenuAppController()),
                          ],
                          child: const MainScreenUsuario(),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Crea un botón con los estilos de diseño especificados.
  ///
  /// Parámetros:
  ///   - [text]: El texto que se mostrará en el botón.
  ///   - [onPressed]: La acción que se ejecutará cuando se presione el botón.
  ///
  /// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Borde redondeado
        gradient: const LinearGradient(
          colors: [
            botonClaro, // Color de fondo claro
            botonOscuro, // Color de fondo oscuro
          ],
        ), // Gradiente de color
        boxShadow: const [
          BoxShadow(
            color: botonSombra, // Color de sombra
            blurRadius: 5, // Radio de la sombra
            offset: Offset(0, 3), // Desplazamiento en x e y de la sombra
          ),
        ], // Sombra
      ),
      child: Material(
        color: Colors.transparent, // Color de fondo transparente
        child: InkWell(
          onTap: onPressed, // Controlador de eventos al presionar el botón
          borderRadius:
              BorderRadius.circular(10), // Borde redondeado con un radio de 10
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10), // Padding vertical de 10
            child: Center(
              child: Text(
                text, // Texto del botón
                style: const TextStyle(
                  color: background1, // Color del texto
                  fontSize: 13, // Tamaño de fuente
                  fontWeight: FontWeight.bold, // Fuente en negrita
                  fontFamily: 'Calibri-Bold', // Fuente Calibri en negrita
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
