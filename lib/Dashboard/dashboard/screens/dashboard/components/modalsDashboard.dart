// ignore_for_file: use_full_hex_values_for_flutter_colors, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';

void operacionFallidaModal(BuildContext context) {
  // Muestra el diálogo modal para confirmar la eliminación de la asistencia
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // Título del diálogo
        title: const Text(
          "¡La operación no se puede realizar!",
          textAlign: TextAlign.center,
        ),
        // Contenido del diálogo
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Mensaje informativo para el usuario
            const Text(
              "No se puede realizar la operación porque no hay ningún registro seleccionado.",
              textAlign: TextAlign.center,
            ),
            // Espaciado entre el texto y la imagen
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
                  color: primaryColor, // Color de fondo del contenedor
                ),
                child: Image.asset(
                  "assets/img/logo.png",
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
            ),
          ],
        ),
        // Botones de acción dentro del diálogo
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                // Construye un botón con los estilos de diseño especificados
                child: _buildButton("Aceptar", () {
                  // Cierra el diálogo cuando se hace clic en el botón de aceptar
                  Navigator.pop(context);
                }),
              ),
            ],
          ),
        ],
      );
    },
  );
}

/// Construye un botón con el texto dado y la función de presionar dada.
///
/// El botón tiene un diseño con bordes redondeados y un gradiente de colores.
/// Al presionar el botón se llama a la función [onPressed].
///
/// El parámetro [text] es el texto que se mostrará en el botón.
/// El parámetro [onPressed] es la función que se ejecutará al presionar el botón.
Widget _buildButton(String text, VoidCallback onPressed) {
  return Container(
    // Ancho fijo del botón
    width: 200,

    // Decoración del contenedor con un borde redondeado, un gradiente de colores y una sombra
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10), // Borde redondeado
      gradient: const LinearGradient(
        colors: [
          botonClaro, // Color claro del gradiente
          botonOscuro, // Color oscuro del gradiente
        ],
      ), // Gradiente de colores
      boxShadow: const [
        BoxShadow(
          color: botonSombra, // Color de la sombra
          blurRadius: 5, // Radio de desfoque de la sombra
          offset: Offset(0, 3), // Desplazamiento de la sombra
        ),
      ], // Sombra
    ),

    // Contenido del contenedor, un Material con un color de fondo transparente
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed, // Función a ejecutar al presionar el botón
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10), // Padding vertical
          child: Center(
            child: Text(
              text, // Texto del botón
              style: const TextStyle(
                color: background1, // Color del texto
                fontSize: 13, // Tamaño de fuente
                fontWeight: FontWeight.bold, // Fuente en negrita
                fontFamily: 'Calibri-Bold', // Fuente en negrita
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
