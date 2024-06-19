// Importaciones necesarias para Flutter.
// ignore_for_file: no_logic_in_create_state

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/url_text.dart';
import 'menu.dart';

// Clase PdfPageScreen que extiende StatefulWidget para la generación de PDF.
// ignore: must_be_immutable
class PdfPageConstanciaPedidoScreen extends StatefulWidget {
  // Parámetros requeridos para la construcción del widget.
  final UsuarioModel usuario;
  final AuxPedidoModel pedido;

  // Constructor que recibe los parámetros necesarios.
  const PdfPageConstanciaPedidoScreen({
    super.key,
    required this.usuario,
    required this.pedido,
  });

  // Método que crea el estado para el widget.
  @override
  State<PdfPageConstanciaPedidoScreen> createState() =>
      _PdfPageConstanciaPedidoScreenState(
          // Pasamos los parámetros al estado.
          usuario: usuario,
          pedido: pedido);
}

// Estado privado para PdfPageScreen.
class _PdfPageConstanciaPedidoScreenState
    extends State<PdfPageConstanciaPedidoScreen> {
  // Variables para almacenar los datos de la reserva.
  final UsuarioModel usuario;
  final AuxPedidoModel pedido;
  // Constructor para inicializar las variables con los datos de la reserva.
  _PdfPageConstanciaPedidoScreenState({
    required this.usuario,
    required this.pedido,
  });

  PrintingInfo? printingInfo;

  // Método para inicializar el estado.
  @override
  void initState() {
    super.initState();
    _init();
  }

  // Método para obtener información de impresión.
  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  // Método para construir y mostrar la pantalla PDF.
  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(
          icon: Icon(
            Icons.save,
            color: primaryColor,
          ),
          onPressed: saveAsFile,
        ),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "CBA MOSQUERA",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: generatePdf,
      ),
    );
  }

  // Método para generar el contenido del PDF.
  Future<Uint8List> generatePdf(final PdfPageFormat format) async {
    final doc = pw.Document(
      title: 'CBA Mosquera constancia de pedido',
    );

    // Carga de la imagen del logo desde los recursos.
    final logoImage = pw.MemoryImage(
        (await rootBundle.load('assets/img/logo2.png')).buffer.asUint8List());
    // Agrega una página al documento PDF.
    doc.addPage(
      pw.MultiPage(
        // Configuración del encabezado de la página.
        header: (final context) => pw.Image(
          alignment: pw.Alignment.topLeft,
          logoImage,
          fit: pw.BoxFit.contain,
          width: 70,
        ),
        // Construcción del contenido de la página.
        build: (final context) => [
          pw.Container(
            padding: const pw.EdgeInsets.only(left: 10, bottom: 20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Padding(padding: const pw.EdgeInsets.only(top: 60)),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              "Nombre: ${usuario.nombres} ${usuario.apellidos}",
                              style: const pw.TextStyle(fontSize: 13)),
                          pw.Text("Correo: ${usuario.correoElectronico}",
                              style: const pw.TextStyle(fontSize: 13)),
                          pw.Text(
                              "Teléfono: ${usuario.telefonoCelular} - ${usuario.telefono}",
                              style: const pw.TextStyle(fontSize: 13)),
                          pw.Text(
                              "Documento: ${usuario.tipoDocumento} - ${usuario.numeroDocumento}",
                              style: const pw.TextStyle(fontSize: 13)),
                          // pw.Text('Estado de la reserva: ${estado}',
                          //     style: pw.TextStyle(fontSize: 13)),
                        ]),
                    pw.SizedBox(width: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Contáctenos",
                            style: const pw.TextStyle(fontSize: 13)),
                        UrlText('CBA MOSQUERA', "15462323",
                            style: const TextStyle(
                                fontSize: 13, color: primaryColor)),
                        UrlText('cbaproyecto72@gmail.com', 'CBA MOSQUERA',
                            style: const TextStyle(
                                fontSize: 13, color: primaryColor)),
                      ],
                    ),
                    pw.SizedBox(width: 40),
                    pw.Padding(padding: pw.EdgeInsets.zero),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Center(
            child: pw.Text(
              "A continuación verá el número correspondiente a su pedido. Es importante tenerlo en cuenta para recibir sus productos.",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 20, // Ajustar el tamaño para un texto secundario
                fontWeight: pw.FontWeight.normal,
              ),
            ),
          ),
          pw.Center(
              child: pw.Padding(
            padding: const pw.EdgeInsets.only(
              top: 40,
            ),
            child: pw.BarcodeWidget(
              data: 'Número de pedido: ${widget.pedido.pedido.numeroPedido}',
              width: 210,
              height: 210,
              barcode: pw.Barcode.qrCode(),
              drawText: false,
            ),
          )),
          pw.Center(
            child: pw.Padding(
                padding: const pw.EdgeInsets.only(
                  top: 10,
                ),
                child: pw.Text(
                  'Número de pedido: ${widget.pedido.pedido.numeroPedido}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 14, // Ajustar el tamaño para un texto secundario
                    fontWeight: pw.FontWeight.normal,
                  ),
                )),
          ),
          pw.Center(
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(top: 60),
              child: pw.Text(
                '¡CBA MOSQUERA!',
                style:
                    pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
    // Guarda el documento y retorna los datos del PDF.
    return doc.save();
  }
}
