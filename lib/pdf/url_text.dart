// Importaciones necesarias para Flutter y el paquete de creación de PDF.
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Definición de la clase UrlText que extiende pw.StatelessWidget.
class UrlText extends pw.StatelessWidget {
  // Propiedades de la clase: texto y URL.
  final String text;
  final String url;

  // Constructor que toma el texto, la URL y un estilo de texto como parámetros.
  UrlText(this.text, this.url, {required TextStyle style});

  // Método build para construir el widget de texto con enlace URL.
  @override
  pw.Widget build(pw.Context context) => pw.UrlLink(
      // Configuración del enlace URL con la URL proporcionada.
      destination: url,
      // Construcción del widget de texto con estilo específico.
      child: pw.Text(text,
          style: pw.TextStyle(
              // Configuración del estilo del texto.
              decoration: pw.TextDecoration.underline, // Subrayado del texto.
              color: PdfColor.fromHex(
                  "#A9A9A9"), // Color del texto en formato hexadecimal.
              fontSize: 13))); // Tamaño de fuente del texto.
}
