// ignore_for_file: file_names, avoid_print, use_build_context_synchronously, unnecessary_this

import 'dart:convert';
import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/source.dart';
import 'package:http/http.dart' as http;

/// Esta clase representa el widget del formulario de comentarios.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_ComentarioState] para manejar los datos del formulario.
///
/// Los parámetros [userID] y [anuncioID] son obligatorios y se utilizan para
/// identificar al usuario que está realizando el comentario y el anuncio al que
/// se está comentando, respectivamente.
class Comentario extends StatefulWidget {
  /// Identificador único del usuario que está realizando el comentario.
  final int userID;

  /// Identificador único del anuncio al que se está realizando el comentario.
  final int anuncioID;

  // Variable que puede ser nula, segun la funcion del caso.  con el fin de editar el comentario.
  final int? comentarioID;

  /// Crea una instancia de [Comentario] con los parámetros [userID] y [anuncioID].
  ///
  /// El parámetro [userID] es obligatorio y se utiliza para identificar al usuario
  /// que está realizando el comentario.
  ///
  /// El parámetro [anuncioID] es obligatorio y se utiliza para identificar el
  /// anuncio al que se está realizando el comentario.
  const Comentario({
    super.key,
    required this.userID,
    required this.anuncioID,
    this.comentarioID,
  });

  @override
  State<Comentario> createState() => _ComentarioState();
}

class _ComentarioState extends State<Comentario> {
  TextEditingController descripcion = TextEditingController();

  // Anula el método dispose para liberar recursos cuando el widget se desecha
  @override

  // Al inicar el widget verificamos si se va a crear o actualizar un comentario.
  // así mismo se ejecuta el metodo que iguala los controladores al texto ya traido.
  void initState() {
    super.initState();
    if (widget.comentarioID != null) {
      cargarComentario(widget.comentarioID!);
    }
  }

  /// Se llama automáticamente cuando se elimina el widget.
  ///
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por el
  /// controlador de texto [descripcion]. Finalmente, se llama al método [dispose]
  /// del padre para liberar recursos adicionales.
  @override
  void dispose() {
    // Liberar recursos del controlador de texto
    descripcion.dispose();

    // Liberar recursos del padre
    super.dispose();
  }

  // Función para cargar los datos del comentario existente
  Future<void> cargarComentario(int comentarioID) async {
    // creamos la url para hacer el get a ese comentario especifico.
    String url = '$sourceApi/api/comentarios/$comentarioID/';
    // hacemos la solucitud al backend.
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // si fue correcta decodificamos la respuesta en json y tomamos la descripción para igualarla al controlador.
      final data = jsonDecode(response.body);
      setState(() {
        descripcion.text = data['descripcion'];
      });
    } else {
      print('Error al cargar el comentario: ${response.statusCode}');
    }
  }

  /// Agrega un nuevo comentario a la base de datos.
  ///
  /// Esta función envía una solicitud POST a la API para agregar un nuevo comentario
  /// con la descripción proporcionada por el controlador de texto [descripcion],
  /// la fecha actual y el usuario identificado por [widget.userID] y el anuncio
  /// identificado por [widget.anuncioID].
  ///
  /// No recibe parámetros y devuelve una [Future] que se completa cuando la
  /// operación de inserción es exitosa. Si la operación es exitosa, imprime un
  /// mensaje de éxito y actualiza el estado del widget. Si hay un error en la
  /// operación de inserción, imprime un mensaje de error con el código de estado
  /// HTTP de la respuesta.
  // Función para agregar o actualizar un comentario
  Future addOrUpdateComent() async {
    // variables para el metodo y la url del bakend,
    // con el fin de separar si es editar o crear un comentario
    String url;
    String method;
    if (widget.comentarioID == null) {
      // si no se va a editar se hace el post con la url predeterminada
      url = '$sourceApi/api/comentarios/';
      method = 'POST';
    } else {
      // si se va a editar se hace el put con la url modificada.
      url = '$sourceApi/api/comentarios/${widget.comentarioID}/';
      method = 'PUT';
    }

    final DateTime now = DateTime.now();
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = {
      'descripcion': descripcion.text,
      'fecha': now.toIso8601String(),
      'usuario': widget.userID,
      'anuncio': widget.anuncioID,
    };

    final response = http.Request(method, Uri.parse(url))
      // mediante los [..] configuramos las propiedades sin necesidad de hacer un llamado nuevo,
      ..headers.addAll(headers)
      ..body = jsonEncode(body);

    // procede a hacer el envio de la solicitud y espera de la respuesta
    final streamedResponse = await response.send();

    if (streamedResponse.statusCode == 201 ||
        streamedResponse.statusCode == 200) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
      print('Datos enviados correctamente (Comentario)');
      setState(() {});
    } else {
      print('Error al enviar datos: ${streamedResponse.statusCode}');
    }
  }

  /// Método build para construir la interfaz de usuario de Crear Comentario.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título "Crear Comentario"
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              widget.comentarioID == null
                  ? "Crear Comentario"
                  : "Editar Comentario",
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Calibri-Bold'),
            ),
          ),
          const SizedBox(height: 15),
          // Contenedor para el campo de texto del comentario
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: descripcion,
                maxLines: 10,
                obscureText: false,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(fontSize: 13),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Escriba su comentario",
                  hintStyle: const TextStyle(color: Colors.black),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {}
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Botón para guardar el comentario
          Center(
            child: InkWell(
              onTap: () {
                addOrUpdateComent();
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: Text(
                  widget.comentarioID == null ? "Enviar" : "Guardar",
                  style: const TextStyle(color: primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
