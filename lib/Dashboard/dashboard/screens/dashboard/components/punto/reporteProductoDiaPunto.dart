// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:intl/intl.dart'; // Importa para manejar fechas

class ReporteProductoDiaPunto extends StatefulWidget {
  final UsuarioModel usuario;
  const ReporteProductoDiaPunto({super.key, required this.usuario});

  @override
  State<ReporteProductoDiaPunto> createState() =>
      _ReporteProductoDiaPuntoState();
}

class _ReporteProductoDiaPuntoState extends State<ReporteProductoDiaPunto> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del reporte
        Text(
          "Productos más vendidos hoy",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontFamily: 'Calibri-Bold'),
        ),
        const SizedBox(height: defaultPadding),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: Future.wait([
                getAuxPedidos(),
                getDevoluciones(),
                getProductos(),
                getFacturas(),
                getPuntosVenta(),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                // Si los datos están cargando, mostrar un indicador de carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // Si ocurre un error al cargar los datos, mostrar un mensaje de error
                  return Center(
                    child: Text(
                      'Error al cargar datos: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  // Procesar los datos
                  final auxPedidos = snapshot.data![0] as List<AuxPedidoModel>;
                  final devoluciones =
                      snapshot.data![1] as List<DevolucionesModel>;
                  final productos = snapshot.data![2] as List<ProductoModel>;
                  final facturas = snapshot.data![3] as List<FacturaModel>;
                  final puntosVenta =
                      snapshot.data![4] as List<PuntoVentaModel>;

                  // Agrupar ventas del día
                  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  Map<String, double> productSales = {};

                  for (var factura in facturas) {
                    for (var punto in puntosVenta) {
                      for (var auxPedido in auxPedidos) {
                        var fechaVenta = DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(factura.fecha));

                        if (today == fechaVenta &&
                            factura.pedido.id == auxPedido.pedido.id &&
                            widget.usuario.puntoVenta == punto.id &&
                            devoluciones.any((devolucion) =>
                                devolucion.factura.pedido.id !=
                                factura.pedido.id)) {
                          // Mapear nombres de productos antes de formar el gráfico
                          var productFilter = productos.where(
                              (producto) => producto.id == auxPedido.producto);

                          var productName = productFilter.firstOrNull?.nombre;

                          if (productName != null) {
                            // Asegúrate de que el nombre del producto esté en el mapa
                            if (productSales.containsKey(productName)) {
                              productSales[productName] =
                                  productSales[productName]! +
                                      auxPedido.cantidad.toDouble();
                            } else {
                              productSales[productName] =
                                  auxPedido.cantidad.toDouble();
                            }
                          }
                        }
                      }
                    }
                  }

                  // Obtener los 7 productos más vendidos
                  final top7ProductSales = productSales.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  final limitedProductSales = top7ProductSales.take(7).toList();

                  // Calcular el total de ventas de los 7 productos
                  double totalSales = limitedProductSales.fold(
                      0, (sum, entry) => sum + entry.value);

                  // Convertir a lista para el gráfico con porcentajes
                  final chartData = limitedProductSales.map((entry) {
                    double percentage = (entry.value / totalSales) * 100;
                    return SalesData(
                      productoId: entry.key,
                      valor: percentage,
                    );
                  }).toList();

                  return SfCircularChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: const Legend(isVisible: true),
                    series: <CircularSeries>[
                      PieSeries<SalesData, String>(
                        dataSource: chartData,
                        xValueMapper: (SalesData data, _) => data.productoId,
                        yValueMapper: (SalesData data, _) => data.valor,
                        dataLabelMapper: (SalesData data, _) =>
                            '${data.valor.toStringAsFixed(1)}%',
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        pointColorMapper: (SalesData data, _) => _getColor(),
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Función para obtener el color de la serie (aleatorio)
  Color _getColor() {
    final random = Random();
    final hue = random.nextDouble() * 360; // Generar tono aleatorio
    final saturation =
        random.nextDouble() * (0.5 - 0.2) + 0.2; // Saturation entre 0.2 y 0.5
    final value =
        random.nextDouble() * (0.9 - 0.5) + 0.5; // Value entre 0.5 y 0.9

    return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
  }
}

// Clase para los datos del gráfico
class SalesData {
  final String productoId;
  final double valor;

  SalesData({
    required this.productoId,
    required this.valor,
  });
}
