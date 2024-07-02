// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ReportePuntoVentasAgnoPunto extends StatelessWidget {
  final UsuarioModel usuario;

  const ReportePuntoVentasAgnoPunto({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del reporte
        Text(
          "Balance de ventas por año",
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
              // Carga de datos asincrónica
              future: Future.wait([
                getAuxPedidos(),
                getFacturas(),
                getPuntosVenta(),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                // Si los datos están cargando, muestra un indicador de carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // Si ocurre un error al cargar los datos, muestra un mensaje de error
                  return Center(
                    child: Text('Error al cargar datos: ${snapshot.error}'),
                  );
                } else {
                  // Cuando los datos están disponibles
                  List<AuxPedidoModel> auxPedidos = snapshot.data![0];
                  List<FacturaModel> facturas = snapshot.data![1];
                  List<PuntoVentaModel> puntos = snapshot.data![2];

                  return SfCartesianChart(
                    // Configuración del gráfico
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: const Legend(
                      isVisible: true,
                    ),
                    primaryXAxis: const CategoryAxis(
                      title: AxisTitle(text: 'Año'),
                      interval: 1,
                    ),
                    primaryYAxis: NumericAxis(
                      title: const AxisTitle(text: 'Ventas (COP)'),
                      numberFormat:
                          NumberFormat.currency(locale: 'es_CO', symbol: ''),
                    ),
                    series: <CartesianSeries>[
                      // Generación dinámica de series para cada punto de venta
                      for (var i = 0; i < puntos.length; i++)
                        if (puntos[i].id == usuario.puntoVenta)
                          SplineAreaSeries<BalanceVentasAgnoDataPunto, String>(
                            name: puntos[i].nombre,
                            dataSource: _getBalanceVentasDataAgno(
                              puntos[i],
                              auxPedidos,
                              facturas,
                            ),
                            xValueMapper:
                                (BalanceVentasAgnoDataPunto data, _) =>
                                    data.agno,
                            yValueMapper:
                                (BalanceVentasAgnoDataPunto data, _) =>
                                    data.ventas,
                            color: _getColor(
                                i,
                                puntos
                                    .length), // Color automático basado en el índice
                            borderWidth: 2,
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

  // Función para obtener los datos de ventas por año para un punto de venta específico
  List<BalanceVentasAgnoDataPunto> _getBalanceVentasDataAgno(
    PuntoVentaModel puntoVenta,
    List<AuxPedidoModel> auxPedidos,
    List<FacturaModel> facturas,
  ) {
    Map<String, double> ventasPorAnio = {};
    int currentYear = DateTime.now().year;

    for (var factura in facturas) {
      var pedido = factura.pedido;

      // Filtrar facturas por punto de venta
      if (puntoVenta.id == pedido.puntoVenta) {
        var anio = DateTime.parse(factura.fecha).year;

        // Considerar solo los últimos 3 años (incluyendo el año actual)
        if (anio >= currentYear - 2) {
          var totalVenta = auxPedidos
              .where((aux) => aux.pedido.id == pedido.id)
              .fold(0, (sum, aux) => sum + aux.precio);

          // Actualizar la suma de ventas por cada año
          ventasPorAnio.update(
            anio.toString(),
            (value) => value + totalVenta,
            ifAbsent: () => totalVenta.toDouble(),
          );
        }
      }
    }

    // Convertir el mapa a una lista de objetos BalanceVentasAgnoDataPunto
    return ventasPorAnio.entries
        .map((entry) => BalanceVentasAgnoDataPunto(entry.key, entry.value))
        .toList();
  }

  // Función para generar colores automáticamente basados en el índice
  Color _getColor(int index, int totalPuntos) {
    final hue = (360 / totalPuntos) *
        index; // Calcular el tono de color basado en el índice
    return HSVColor.fromAHSV(1.0, hue, 0.8, 0.9)
        .toColor(); // Convertir a color HSV y luego a Color
  }
}

// Modelo de datos para el balance de ventas por año
class BalanceVentasAgnoDataPunto {
  BalanceVentasAgnoDataPunto(this.agno, this.ventas);

  final String agno;
  final double ventas;
}
