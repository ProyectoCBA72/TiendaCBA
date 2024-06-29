// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteDevolucionesPuntoAgnoLider extends StatelessWidget {
  final UsuarioModel usuario;

  const ReporteDevolucionesPuntoAgnoLider({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del reporte
        Text(
          "Balance de devoluciones por año",
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
                getDevoluciones(),
                getPuntosVenta(),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al cargar datos: ${snapshot.error}'),
                  );
                } else {
                  // Datos disponibles
                  List<AuxPedidoModel> auxPedidos = snapshot.data![0];
                  List<DevolucionesModel> devoluciones = snapshot.data![1];
                  List<PuntoVentaModel> puntos = snapshot.data![2];

                  return SfCartesianChart(
                    // Configuración del gráfico
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: Legend(
                      isVisible: Responsive.isMobile(context) ? false : true,
                    ),
                    primaryXAxis: const CategoryAxis(
                      title: AxisTitle(text: 'Año'),
                      interval: 1,
                    ),
                    primaryYAxis: NumericAxis(
                      title: const AxisTitle(text: 'Devoluciones (COP)'),
                      numberFormat: NumberFormat.currency(
                          locale: 'es_CO', symbol: ''),
                    ),
                    series: <CartesianSeries>[
                      // Generación dinámica de series para cada punto de venta
                      for (var i = 0; i < puntos.length; i++)
                        SplineAreaSeries<DevolucionesAgnoDataLider, String>(
                          name: puntos[i].nombre,
                          dataSource: _getDevolucionesDataAgno(
                            puntos[i],
                            auxPedidos,
                            devoluciones,
                            usuario,
                          ),
                          xValueMapper: (DevolucionesAgnoDataLider data, _) =>
                              data.agno,
                          yValueMapper: (DevolucionesAgnoDataLider data, _) =>
                              data.devoluciones,
                          color: _getColor(i, puntos.length),
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

  // Función para obtener datos de devoluciones por año para un punto de venta específico
  List<DevolucionesAgnoDataLider> _getDevolucionesDataAgno(
    PuntoVentaModel puntoVenta,
    List<AuxPedidoModel> auxPedidos,
    List<DevolucionesModel> devoluciones,
    UsuarioModel usuario,
  ) {
    Map<String, double> devolucionesPorAnio = {};
    int currentYear = DateTime.now().year;

    for (var devolucion in devoluciones) {
      var pedido = devolucion.factura.pedido;

      // Filtrar devoluciones por punto de venta y sede del usuario
      if (puntoVenta.id == pedido.puntoVenta &&
          puntoVenta.sede == usuario.sede) {
        var anio = DateTime.parse(devolucion.fecha).year;

        // Considerar solo los últimos 3 años (incluyendo el año actual)
        if (anio >= currentYear - 2) {
          var totalDevolucion = auxPedidos
              .where((aux) => aux.pedido.id == pedido.id)
              .fold(0, (sum, aux) => sum + aux.precio);

          // Actualizar la suma de devoluciones por cada año
          devolucionesPorAnio.update(
            anio.toString(),
            (value) => value + totalDevolucion,
            ifAbsent: () => totalDevolucion.toDouble(),
          );
        }
      }
    }

    // Convertir el mapa a una lista de objetos DevolucionesAgnoDataLider
    return devolucionesPorAnio.entries
        .map((entry) => DevolucionesAgnoDataLider(entry.key, entry.value))
        .toList();
  }

  // Función para generar colores automáticamente basados en el índice
  Color _getColor(int index, int totalPuntos) {
    final hue = (360 / totalPuntos) * index;
    return HSVColor.fromAHSV(1.0, hue, 0.8, 0.9).toColor();
  }
}

// Modelo de datos para el balance de devoluciones por año
class DevolucionesAgnoDataLider {
  DevolucionesAgnoDataLider(this.agno, this.devoluciones);

  final String agno;
  final double devoluciones;
}

