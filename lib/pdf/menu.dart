// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

// Función para guardar el documento PDF como archivo y abrirlo.
Future<void> saveAsFile(final BuildContext context, final LayoutCallback build,
    final PdfPageFormat pageFormat) async {
  // Obtener los bytes del documento PDF.
  final bytes = await build(pageFormat);

  // Obtener el directorio de documentos de la aplicación.
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  // Crear un archivo PDF en el directorio de documentos.
  final file = File("$appDocPath/document.pdf");
  print('save as File ${file.path}...');
  // Escribir los bytes del PDF en el archivo.
  await file.writeAsBytes(bytes);
  // Abrir el archivo PDF utilizando la aplicación predeterminada.
  await OpenFile.open(file.path);
}

// Función para mostrar un mensaje cuando el documento se imprime con éxito.
void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Documento impreso satisfactoriamente")));
}

// Función para mostrar un mensaje cuando el documento se comparte con éxito.
void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Documento compartido satisfactoriamente")));
}
