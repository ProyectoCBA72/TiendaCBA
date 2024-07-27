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
/// Representa una pantalla que genera un PDF con la constancia de un pedido.
///
/// Esta clase define una pantalla que genera un PDF con la constancia de un
/// pedido. La pantalla no tiene estado y utiliza un [StatefulWidget] para
/// almacenar los datos del pedido y del usuario. Los datos se pasan al estado
/// a través del constructor. Esta pantalla es utilizada para mostrar la
/// constancia del pedido al usuario.
///
/// Parámetros requeridos para la construcción del widget:
///
/// - `usuario`: El objeto de usuario que realizó el pedido.
/// - `pedido`: El objeto de pedido que se va a generar la constancia.
class PdfPageConstanciaPedidoScreen extends StatefulWidget {
  const PdfPageConstanciaPedidoScreen({
    super.key,
    required this.usuario,
    required this.pedido,
  });

  /// El objeto de usuario que realizó el pedido.
  final UsuarioModel usuario;

  /// El objeto de pedido que se va a generar la constancia.
  final AuxPedidoModel pedido;

  /// Método que crea el estado para el widget.
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
  /// Los datos del usuario que realizó el pedido.
  final UsuarioModel usuario;

  /// Los datos del pedido para el cual se generará la constancia.
  final AuxPedidoModel pedido;

  /// Constructor para inicializar las variables con los datos del pedido.
  ///
  /// Parámetros requeridos para la construcción del widget:
  ///
  /// - `usuario`: El objeto de usuario que realizó el pedido.
  /// - `pedido`: El objeto de pedido que se va a generar la constancia.
  _PdfPageConstanciaPedidoScreenState({
    required this.usuario,
    required this.pedido,
  });

  /// Variable para almacenar información de impresión.
  PrintingInfo? printingInfo;

  // Método para inicializar el estado.
  @override

  /// Inicializa el estado del widget.
  ///
  /// Este método llama al método privado [_init] para obtener información de impresión.
  @override
  void initState() {
    // Llamamos al método base para inicializar el estado.
    super.initState();

    // Llamamos al método privado [_init] para obtener información de impresión.
    _init();
  }

  // Método para obtener información de impresión.
  /// Método para obtener información de impresión.
  ///
  /// Este método utiliza el paquete [printing] para obtener información sobre el dispositivo
  /// y el entorno en el cual se generará el PDF. Luego, actualiza el estado del widget
  /// con la información obtenida.
  Future<void> _init() async {
    // Obtenemos la información de impresión.
    final info = await Printing.info();

    // Actualizamos el estado del widget con la información obtenida.
    setState(() {
      printingInfo = info;
    });
  }

  // Método para construir y mostrar la pantalla PDF.
  @override

  /// Método para construir y mostrar la pantalla PDF.
  ///
  /// Este método construye la interfaz de usuario de la pantalla PDF.
  /// Agrega un [AppBar] con un botón de retroceso y un título.
  /// Crea un widget [PdfPreview] que muestra el PDF generado y
  /// permite guardarlo en el dispositivo o compartirlo.
  ///
  /// Devuelve un [Scaffold] con la interfaz de usuario de la pantalla PDF.
  Widget build(BuildContext context) {
    // Se activa el modo de depuración para el widget RichText.
    pw.RichText.debug = true;

    // Se definen las acciones disponibles en la pantalla PDF.
    final actions = <PdfPreviewAction>[
      // Si no se está ejecutando en un navegador web, se agrega la opción de guardar el PDF.
      if (!kIsWeb)
        const PdfPreviewAction(
          icon: Icon(
            Icons.save,
            color: primaryColor,
          ),
          onPressed: saveAsFile,
        ),
    ];

    // Se construye y devuelve la interfaz de usuario de la pantalla PDF.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Se navega hacia atrás cuando se presiona el botón de retroceso.
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        // Se establece el título de la pantalla PDF.
        title: const Text(
          "CBA MOSQUERA",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      // Se crea un widget PdfPreview que muestra el PDF generado y
      // permite guardarlo en el dispositivo o compartirlo.
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        // Método llamado cuando se imprime el PDF.
        onPrinted: showPrintedToast,
        // Método llamado cuando se comparte el PDF.
        onShared: showSharedToast,
        // Método llamado para generar el PDF.
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
