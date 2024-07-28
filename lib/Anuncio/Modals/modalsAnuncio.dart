// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:url_launcher/url_launcher.dart';

/// Muestra un diálogo para compartir la información de un anuncio a través de WhatsApp.
///
/// El diálogo solicita al usuario que ingrese un número de teléfono celular y
/// envía un mensaje con la información del anuncio a través de WhatsApp.
///
/// [context] es el contexto de la aplicación donde se mostrará el diálogo.
/// [text] es el texto que se enviará junto con el número de teléfono celular.
void modalCompartirWhatsappAnuncio(BuildContext context, String text) {
  // Crea un controlador de texto para el campo de ingreso del número de teléfono celular.
  TextEditingController telefono = TextEditingController();
  // Crea una clave global para el formulario.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Muestra el diálogo con el contenido personalizado.
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          '¿Quiere compartir la información de este anuncio vía WhatsApp?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Mensaje informativo para el usuario
              const Text(
                "Por favor, ingrese el número de teléfono celular de la persona con la cual desea compartir este producto.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              // Muestra el logo de la aplicación en un contenedor circular.
              ClipOval(
                child: Container(
                  width: 100, // Ajusta el tamaño según sea necesario
                  height: 100, // Ajusta el tamaño según sea necesario
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        primaryColor, // Cambia primaryColor por un color específico
                  ),
                  child: Image.asset(
                    "assets/img/logo.png",
                    fit: BoxFit.cover, // Ajusta la imagen al contenedor
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: TextFormField(
                      // Estilos del texto
                      style: const TextStyle(color: Colors.black),
                      controller: telefono,
                      obscureText: false,
                      decoration: InputDecoration(
                        // Estilos de borde y color de fondo
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Teléfono Celular',
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      // Configuración del teclado
                      keyboardType: TextInputType.phone, // Cambio realizado
                      // Validación del campo
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'El teléfono celular es obligatorio';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // vincular whatsapp
                    String celular = telefono.text;
                    String mensaje = text;
                    String url = "https://wa.me/$celular?text=$mensaje";
                    final Uri _url = Uri.parse(url);

                    launchUrl(_url);
                  }
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
        ],
      );
    },
  );
}
