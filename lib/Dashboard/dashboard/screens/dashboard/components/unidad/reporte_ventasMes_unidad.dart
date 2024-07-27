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

class ReporteProductosMasVendidosMesUnidad extends StatelessWidget {
  final UsuarioModel usuario;
  const ReporteProductosMasVendidosMesUnidad({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del reporte
        Text(
          "Productos más vendidos por mes",
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
              // FutureBuilder para esperar la carga de datos asincrónicos
              future: Future.wait([
                getFacturas(),
                getProductos(),
                getAuxPedidos(),
                getPuntosVenta(),
                getDevoluciones(),
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
                  // Procesar los datos para obtener los productos más vendidos
                  final facturas = snapshot.data![0] as List<FacturaModel>;
                  final productos = snapshot.data![1] as List<ProductoModel>;
                  final auxPedidos = snapshot.data![2] as List<AuxPedidoModel>;
                  final puntos = snapshot.data![3] as List<PuntoVentaModel>;
                  final devoluciones =
                      snapshot.data![4] as List<DevolucionesModel>;

                  // Filtrar las facturas de los últimos 4 meses incluyendo el mes actual
                  final DateTime now = DateTime.now();
                  final List<FacturaModel> facturasUltimos4Meses =
                      facturas.where((factura) {
                    final DateTime fechaFactura = DateTime.parse(factura.fecha);
                    return fechaFactura.isAfter(
                        now.subtract(const Duration(days: 30 * 4 - 1)));
                  }).toList();

                  // Mapa para almacenar las ventas por producto por mes
                  final Map<String, Map<String, double>>
                      ventasPorProductoPorMes = {};

                  // Iterar sobre las facturas filtradas para calcular las ventas por producto por mes
                  for (var factura in facturasUltimos4Meses) {
                    final DateTime fechaFactura = DateTime.parse(factura.fecha);
                    final String mes = _getNombreMes(fechaFactura);
                    for (var punto in puntos) {
                      for (var auxPedido in auxPedidos) {
                        if (auxPedido.pedido.id == factura.pedido.id &&
                            punto.id == factura.pedido.puntoVenta &&
                            punto.sede == usuario.sede &&
                            devoluciones.any((devolucion) =>
                                devolucion.factura.pedido.id !=
                                factura.pedido.id)) {
                          final productoFiltrado = productos.where((p) =>
                              p.id == auxPedido.producto &&
                              p.unidadProduccion.id ==
                                  usuario.unidadProduccion);

                          final producto = productoFiltrado.firstOrNull?.nombre;

                          if (producto != null) {
                            ventasPorProductoPorMes.putIfAbsent(
                                producto, () => {});
                            ventasPorProductoPorMes[producto]!
                                .putIfAbsent(mes, () => 0);
                            ventasPorProductoPorMes[producto]![mes] =
                                ventasPorProductoPorMes[producto]![mes]! +
                                    auxPedido.cantidad.toDouble();
                          }
                        }
                      }
                    }
                  }

                  // Obtener los 7 productos más vendidos
                  final List<MapEntry<String, double>> productosMasVendidos =
                      ventasPorProductoPorMes.entries
                          .map((entry) => MapEntry(entry.key,
                              entry.value.values.reduce((a, b) => a + b)))
                          .toList()
                        ..sort((a, b) => b.value.compareTo(a.value));

                  final top7Productos =
                      productosMasVendidos.take(7).map((e) => e.key).toList();

                  // Construir el gráfico de líneas con los datos obtenidos
                  return SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: const Legend(isVisible: true),
                    primaryXAxis: const CategoryAxis(
                      title: AxisTitle(text: 'Meses'),
                      interval: 1,
                    ),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Cantidad Vendida'),
                    ),
                    series: <CartesianSeries>[
                      // Crear una serie por cada producto más vendido
                      for (var i = 0; i < top7Productos.length; i++)
                        SplineSeries<ProduccionVentaDataMesUnidad, String>(
                          name: top7Productos[i],
                          dataSource: _getProduccionVentaDataMes(
                              top7Productos[i], ventasPorProductoPorMes),
                          xValueMapper:
                              (ProduccionVentaDataMesUnidad data, _) =>
                                  data.mes,
                          yValueMapper:
                              (ProduccionVentaDataMesUnidad data, _) =>
                                  data.cantidad,
                          color:
                              _getColor(), // Asignar color basado en la lista de colores
                          width:
                              2, // Asegúrate de que el grosor de la línea sea adecuado
                          markerSettings: const MarkerSettings(
                            isVisible: true, // Mostrar marcadores en las líneas
                            shape: DataMarkerType.circle, // Forma del marcador
                          ),
                        ),
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

  // Función para obtener los datos de ventas por producto por mes
  List<ProduccionVentaDataMesUnidad> _getProduccionVentaDataMes(String producto,
      Map<String, Map<String, double>> ventasPorProductoPorMes) {
    final List<ProduccionVentaDataMesUnidad> data = [];
    if (ventasPorProductoPorMes.containsKey(producto)) {
      ventasPorProductoPorMes[producto]!.forEach((mes, cantidad) {
        data.add(ProduccionVentaDataMesUnidad(mes, cantidad));
      });
    }
    return data;
  }

  // Función para obtener el nombre del mes a partir de una fecha
  String _getNombreMes(DateTime fecha) {
    switch (fecha.month) {
      case 1:
        return 'Enero';
      case 2:
        return 'Febrero';
      case 3:
        return 'Marzo';
      case 4:
        return 'Abril';
      case 5:
        return 'Mayo';
      case 6:
        return 'Junio';
      case 7:
        return 'Julio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Septiembre';
      case 10:
        return 'Octubre';
      case 11:
        return 'Noviembre';
      case 12:
        return 'Diciembre';
      default:
        return '';
    }
  }
}

// Clase para modelar los datos de producción y venta por mes
class ProduccionVentaDataMesUnidad {
  ProduccionVentaDataMesUnidad(this.mes, this.cantidad);

  final String mes;
  final double cantidad;
}
