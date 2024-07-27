// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/Auth/authScreen.dart';
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

/// Muestra un diálogo con un formulario para hacer un comentario.
///
/// El diálogo contiene un formulario para agregar un comentario. El
/// [context] es el contexto de la aplicación donde se mostrará el
/// diálogo.
void inicioSesionComents(BuildContext context) {
  // Muestra un diálogo
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // Título del diálogo
        title: const Text(
          "¿Quiere agregar un comentario?",
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Texto de descripción
            const Text(
              "¡Para agregar un comentario, debe iniciar sesión!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            // Muestra una imagen circular del logo de la aplicación
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
              // Botón para cancelar la operación
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Cancelar", () {
                  Navigator.pop(context);
                }),
              ),
              // Botón para iniciar sesión
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Iniciar Sesión", () {
                  // Ignora el compilador y navega a la pantalla de inicio de sesión
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }),
              )
            ],
          ),
        ],
      );
    },
  );
}

/// Construye un botón con los estilos de diseño especificados.
///
/// El parámetro [text] es el texto que se mostrará en el botón.
/// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
///
/// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
Widget _buildButton(String text, VoidCallback onPressed) {
  // Contenedor con un ancho fijo de 200 píxeles y una apariencia personalizada
  // con un borde redondeado, un gradiente de colores y una sombra.
  return Container(
    width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10), // Borde redondeado.
      gradient: const LinearGradient(
        colors: [
          botonClaro, // Color claro del gradiente.
          botonOscuro, // Color oscuro del gradiente.
        ],
      ),
      boxShadow: const [
        BoxShadow(
          color: botonSombra, // Color de la sombra.
          blurRadius: 5, // Radio de desfoque de la sombra.
          offset: Offset(0, 3), // Desplazamiento de la sombra.
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent, // Color transparente para el Material.
      child: InkWell(
        onTap: onPressed, // Función de presionar.
        borderRadius: BorderRadius.circular(10), // Radio del borde redondeado.
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 10), // Padding vertical.
          child: Center(
            child: Text(
              text, // Texto del botón.
              style: const TextStyle(
                color: background1, // Color del texto.
                fontSize: 13, // Tamaño de fuente.
                fontWeight: FontWeight.bold, // Peso de fuente.
                fontFamily: 'Calibri-Bold', // Fuente.
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Muestra un diálogo modal con una imagen ampliada.
///
/// El parámetro [src] es la URL de la imagen a mostrar.
void modalAmpliacion(BuildContext context, String src) {
  // Muestra un diálogo modal con una imagen ampliada.
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // El contenido del diálogo debe tener un tamaño cero para que el
        // fondo transparente no afecte al diálogo completo.
        contentPadding: EdgeInsets.zero,
        // El color de fondo se establece a transparente para que la imagen
        // pueda ser visible detrás de otras partes del diálogo.
        backgroundColor: Colors.transparent,
        // Crea un contenedor con un borde redondeado para la imagen.
        content: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            // Muestra la imagen en el diálogo.
            child: Image.network(
              src,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
  );
}
