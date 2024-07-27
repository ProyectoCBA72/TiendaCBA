import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Muestra un diálogo de alerta que avisa al usuario que no hay registros para elaborar el reporte.
///
/// El diálogo contiene un título, un mensaje, una imagen y un botón de aceptar.
/// Si el usuario hace clic en el botón de aceptar, se cierra el diálogo.
///
/// Parámetros:
///
///   - `context` (BuildContext): El contexto de la aplicación.
void noHayPDFModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // Título del diálogo
        title: const Text(
          "¡No hay registros para elaborar el reporte!",
          textAlign: TextAlign.center,
        ),
        // Contenido del diálogo
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Mensaje informativo para el usuario
            const Text(
              "Por favor, elija los datos para proceder con la construcción del reporte.",
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

/// Construye un botón con los estilos de diseño especificados.
///
/// El parámetro [text] es el texto que se mostrará en el botón.
/// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
///
/// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
Widget _buildButton(String text, VoidCallback onPressed) {
  // Devuelve un contenedor con una decoración circular y un gradiente de color.
  // También tiene sombra y un borde redondeado.
  // El contenedor contiene un widget [Material] que actúa como un botón interactivo.
  // El botón tiene un controlador de eventos [InkWell] que llama a la función [onPressed] cuando se presiona.
  // El [InkWell] tiene un borde redondeado y un padding vertical.
  // El contenido del botón es un texto centrado con un estilo específico.
  return Container(
    width: 200, // Ancho del contenedor
    decoration: BoxDecoration(
      borderRadius:
          BorderRadius.circular(10), // Borde redondeado con un radio de 10
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
