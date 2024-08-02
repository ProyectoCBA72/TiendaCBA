import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:vibration/vibration.dart';

class QrScannerScreen extends StatefulWidget {
  final List<AuxPedidoModel> auxPendientes;
  const QrScannerScreen({super.key, required this.auxPendientes});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = 'Scanear un codigo QR';
  bool isScanning = true; // Controla si el escáner está activo o no

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      } else if (Platform.isIOS) {
        controller!.resumeCamera();
      }
    }
  }

  Future loadData() async {
    return Future.wait([getProductos(), getImagenProductos()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner de Qrs'),
      ),
      body: Center(
        child: isScanning
            ? Column(
                children: [
                  Expanded(
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(qrText),
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Escaneo completo. Pedido: $qrText',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder(
                    future: loadData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Ocurrio un error'),
                        );
                      } else {
                        List<ProductoModel> productosCargados =
                            snapshot.data![0];

                        List<ImagenProductoModel> imagenesCargadas =
                            snapshot.data![1];

                        print(imagenesCargadas);

                        List<AuxPedidoModel> pedProdAEntregar = widget
                            .auxPendientes
                            .where((item) =>
                                item.pedido.numeroPedido.toString() == qrText)
                            .toList();

                        return Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Column(
                            children: [
                              const ListTile(
                                title: Text('Nombre'),
                                subtitle: Text('Cantidad'),
                              ),
                              ListView.builder(
                                  itemBuilder: (BuildContext context, index) {
                                final prodPedido = pedProdAEntregar[index];
                                final productoAentregar = productosCargados
                                    .where((item) =>
                                        item.id == prodPedido.producto)
                                    .first;
                                return ListTile(
                                  title: Text(productoAentregar.nombre),
                                  subtitle:
                                      Text(prodPedido.cantidad.toString()),
                                );
                              })
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isScanning = true; // Reactivar el escáner
                        qrText = 'Scanear un codigo QR'; // Restablecer el texto
                        controller?.resumeCamera(); // Reanudar la cámara
                      });
                    },
                    child: const Text('Terminar'),
                  ),
                ],
              ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
      });
      isScanning = false; // Desactivar el escáner
      controller.pauseCamera(); // Pausar la cámara
      // Vibrar cuando se detecta un código QR
      if (Vibration.hasVibrator() != null) {
        Vibration.vibrate(duration: 200); // Vibrar por 200 ms
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
