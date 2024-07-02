// ignore_for_file: file_names, avoid_print, use_build_context_synchronously, unnecessary_this

import 'dart:convert';
import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/source.dart';
import 'package:http/http.dart' as http;

class Comentario extends StatefulWidget {
  final int userID;
  final int anuncioID;
  const Comentario({super.key, required this.userID, required this.anuncioID});

  @override
  State<Comentario> createState() => _ComentarioState();
}

class _ComentarioState extends State<Comentario> {
  TextEditingController descripcion = TextEditingController();

  // Anula el método dispose para liberar recursos cuando el widget se desecha
  @override
  void dispose() {
    descripcion.dispose();
    super.dispose();
  }

  Future addComent() async {
    String url;
    url = '$sourceApi/api/comentarios/';

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

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      print('Datos enviados correctamente(Comentario)');
      setState(() {});
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                // controller: titulo,
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
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
