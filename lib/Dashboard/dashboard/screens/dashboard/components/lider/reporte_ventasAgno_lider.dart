// ignore_for_file: file_names, unnecessary_null_comparison

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

class ReporteProductosMasVendidosAgnoLider extends StatelessWidget {
  final UsuarioModel usuario;
  const ReporteProductosMasVendidosAgnoLider({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del reporte
        Text(
          "Productos más vendidos por año",
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

                  // Mapa para almacenar las ventas por producto por año
                  final Map<String, Map<String, double>>
                      ventasPorProductoPorAgno = {};

                  // Iterar sobre las facturas para calcular las ventas por producto por año
                  for (var factura in facturas) {
                    final agno = factura.fecha.split('-')[0];
                    // Considerar solo los datos de los últimos 3 años (incluyendo el actual)
                    if (int.parse(agno) >= DateTime.now().year - 2) {
                      for (var punto in puntos) {
                        for (var auxPedido in auxPedidos) {
                          if (auxPedido.pedido.id == factura.pedido.id &&
                              punto.id == factura.pedido.puntoVenta &&
                              punto.sede == usuario.sede &&
                              devoluciones.any((devolucion) =>
                                  devolucion.factura.pedido.id !=
                                  factura.pedido.id)) {
                            var producto = productos
                                .where((p) => p.id == auxPedido.producto);

                            var productoNombre = producto.firstOrNull?.nombre;

                            if (productoNombre != null) {
                              ventasPorProductoPorAgno.putIfAbsent(
                                  productoNombre, () => {});
                              ventasPorProductoPorAgno[productoNombre]!
                                  .putIfAbsent(agno, () => 0);
                              ventasPorProductoPorAgno[productoNombre]![agno] =
                                  ventasPorProductoPorAgno[productoNombre]![
                                          agno]! +
                                      auxPedido.cantidad.toDouble();
                            }
                          }
                        }
                      }
                    }
                  }

                  // Obtener los 7 productos más vendidos
                  final List<MapEntry<String, double>> productosMasVendidos =
                      ventasPorProductoPorAgno.entries
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
                      title: AxisTitle(text: 'Año'),
                      interval: 1,
                    ),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Cantidad Vendida'),
                    ),
                    series: <CartesianSeries>[
                      // Crear una serie por cada producto más vendido
                      for (var i = 0; i < top7Productos.length; i++)
                        SplineSeries<ProduccionVentaAgnoDataLider, String>(
                          name: top7Productos[i],
                          dataSource: _getProduccionVentaDataAgno(
                              top7Productos[i], ventasPorProductoPorAgno),
                          xValueMapper:
                              (ProduccionVentaAgnoDataLider data, _) =>
                                  data.agno,
                          yValueMapper:
                              (ProduccionVentaAgnoDataLider data, _) =>
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

  // Función para obtener los datos de ventas por producto por año
  List<ProduccionVentaAgnoDataLider> _getProduccionVentaDataAgno(
      String producto,
      Map<String, Map<String, double>> ventasPorProductoPorAgno) {
    final List<ProduccionVentaAgnoDataLider> data = [];
    if (ventasPorProductoPorAgno.containsKey(producto)) {
      ventasPorProductoPorAgno[producto]!.forEach((agno, cantidad) {
        data.add(ProduccionVentaAgnoDataLider(agno, cantidad));
      });
    }
    return data;
  }
}

// Clase para modelar los datos de producción y venta por año
class ProduccionVentaAgnoDataLider {
  ProduccionVentaAgnoDataLider(this.agno, this.cantidad);

  final String agno;
  final double cantidad;
}
