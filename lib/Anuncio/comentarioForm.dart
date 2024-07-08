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
  });

  @override
  State<Comentario> createState() => _ComentarioState();
}

class _ComentarioState extends State<Comentario> {
  TextEditingController descripcion = TextEditingController();

  // Anula el método dispose para liberar recursos cuando el widget se desecha
  @override

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
  Future addComent() async {
    // Construir la URL de la API
    String url = '$sourceApi/api/comentarios/';

    // Obtener la fecha actual
    final DateTime now = DateTime.now();

    // Definir los encabezados de la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Definir el cuerpo de la solicitud (JSON)
    final body = {
      'descripcion': descripcion.text,
      'fecha': now.toIso8601String(),
      'usuario': widget.userID,
      'anuncio': widget.anuncioID,
    };

    // Enviar una solicitud POST a la API con los datos del comentario
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Verificar el estado de la respuesta HTTP
    if (response.statusCode == 201) {
      // Ir a la pantalla de inicio
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
      // Imprimir un mensaje de éxito si la operación de inserción es exitosa
      print('Datos enviados correctamente(Comentario)');
      setState(() {});
    } else {
      // Imprimir un mensaje de error si hay un error en la operación de inserción
      print('Error al enviar datos: ${response.statusCode}');
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
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Crear Comentario",
              style: TextStyle(
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
                addComent();
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
                child: const Text(
                  "Enviar",
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
