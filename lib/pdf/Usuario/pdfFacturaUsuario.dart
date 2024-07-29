// Importaciones necesarias para Flutter.
// ignore_for_file: no_logic_in_create_state

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/menu.dart';
import 'package:tienda_app/pdf/url_text.dart';

class PdfFacturaUsuarioScreen extends StatefulWidget {
  const PdfFacturaUsuarioScreen({
    super.key,
    required this.usuario,
    required this.registro,
  });

  final UsuarioModel usuario;

  final List<DataGridRow> registro;

  @override
  State<PdfFacturaUsuarioScreen> createState() =>
      _PdfFacturaUsuarioScreenState(usuario: usuario, registro: registro);
}

class _PdfFacturaUsuarioScreenState extends State<PdfFacturaUsuarioScreen> {
  final UsuarioModel usuario;

  final List<DataGridRow> registro;

  _PdfFacturaUsuarioScreenState({
    required this.usuario,
    required this.registro,
  });

  PrintingInfo? printingInfo;

  @override
  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();

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
      title: 'CBA Mosquera reporte de ventas',
    );

    // Carga de la imagen del logo desde los recursos.
    final logoImage = pw.MemoryImage(
        (await rootBundle.load('assets/img/logo2.png')).buffer.asUint8List());

    // Construcción de la tabla
    final tableHeaders = [
      'Número',
      'Usuario',
      'Número Pedido',
      'Producto',
      'Fecha Venta',
      'Valor Pedido',
      'Medio Pago',
      'Vendedor',
    ];
    final tableData = registro.map((item) {
      // Obtener una lista de celdas con sus índices
      final cellsWithIndex = item.getCells().asMap().entries;

      // Mapeo de cada celda a su valor correspondiente con formato condicional
      return cellsWithIndex.map((entry) {
        final index = entry.key;
        final cell = entry.value;

        // Condición para aplicar el formato deseado en el índice específico
        return index == 5
            ? "\$${formatter.format(cell.value)}"
            : index == 4
                ? formatFechaHora(cell.value.toString())
                : cell.value.toString();
      }).toList();
    }).toList();

    // Agrega una página al documento PDF.
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        orientation: pw.PageOrientation.landscape,
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
              "Reporte de ventas",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 20, // Ajustar el tamaño para un texto secundario
                fontWeight: pw.FontWeight.normal,
              ),
            ),
          ),
          pw.SizedBox(height: 10),

          // Tabla
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black, width: 1),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: tableHeaders.map((header) {
                  return pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      header,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
              ...tableData.map((row) {
                return pw.TableRow(
                  children: row.map((cell) {
                    return pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        cell,
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
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
