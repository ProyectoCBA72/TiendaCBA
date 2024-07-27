// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ReportePuntoVentasMesPunto extends StatelessWidget {
  final UsuarioModel usuario;

  const ReportePuntoVentasMesPunto({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del reporte
        Text(
          "Balance de ventas por mes",
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
                getDevoluciones(),
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
                    child: Text(
                      'Error al cargar datos: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  // Cuando los datos están disponibles
                  List<AuxPedidoModel> auxPedidos = snapshot.data![0];
                  List<FacturaModel> facturas = snapshot.data![1];
                  List<PuntoVentaModel> puntos = snapshot.data![2];
                  List<DevolucionesModel> devoluciones = snapshot.data![3];

                  List<PuntoVentaModel> puntosFiltrados =
                      puntos.where((p) => p.id == usuario.puntoVenta).toList();

                  return SfCartesianChart(
                    // Configuración del gráfico
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: const Legend(
                      isVisible: true,
                    ),
                    primaryXAxis: const CategoryAxis(
                      title: AxisTitle(text: 'Meses'),
                      interval: 1,
                    ),
                    primaryYAxis: NumericAxis(
                      title: const AxisTitle(text: 'Ventas (COP)'),
                      numberFormat:
                          NumberFormat.currency(locale: 'es_CO', symbol: ''),
                    ),
                    series: puntosFiltrados.asMap().entries.map((entry) {
                      PuntoVentaModel punto = entry.value;

                      return SplineAreaSeries<BalanceVentasDataMesPunto,
                          String>(
                        // Nombre de la serie basado en el nombre del punto de venta
                        name: punto.nombre,
                        // Datos de ventas por mes para el punto de venta actual
                        dataSource: _getBalanceVentasDataMes(
                            punto, auxPedidos, facturas, devoluciones),
                        xValueMapper: (BalanceVentasDataMesPunto data, _) =>
                            data.mes,
                        yValueMapper: (BalanceVentasDataMesPunto data, _) =>
                            data.ventas,
                        color: _getColor(), // Asignación automática de color
                        borderWidth: 2,
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Función para obtener los datos de ventas por mes para un punto de venta específico
  List<BalanceVentasDataMesPunto> _getBalanceVentasDataMes(
      PuntoVentaModel puntoVenta,
      List<AuxPedidoModel> auxPedidos,
      List<FacturaModel> facturas,
      List<DevolucionesModel> devoluciones) {
    Map<String, double> ventasPorMes = {};
    DateTime now = DateTime.now();

    for (var factura in facturas) {
      var pedido = factura.pedido;

      // Filtrar facturas por punto de venta
      if (puntoVenta.id == pedido.puntoVenta &&
          devoluciones.any((devolucion) =>
              devolucion.factura.pedido.id != factura.pedido.id)) {
        var fechaFactura = DateTime.parse(factura.fecha);
        // Considerar solo los últimos 4 meses (incluyendo el mes actual)
        if (fechaFactura.isAfter(now.subtract(const Duration(days: 120)))) {
          var mes = _getMonthName(fechaFactura.month);
          var totalVenta = auxPedidos
              .where((aux) => aux.pedido.id == pedido.id)
              .fold(0, (sum, aux) => sum + aux.precio);

          // Actualizar la suma de ventas por cada mes
          ventasPorMes.update(
            mes,
            (value) => value + totalVenta,
            ifAbsent: () => totalVenta.toDouble(),
          );
        }
      }
    }

    // Convertir el mapa a una lista de objetos BalanceVentasDataMesPunto
    return ventasPorMes.entries
        .map((entry) => BalanceVentasDataMesPunto(entry.key, entry.value))
        .toList();
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

  // Función para obtener el nombre del mes basado en su número
  String _getMonthName(int month) {
    switch (month) {
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

// Modelo de datos para el balance de ventas por mes
class BalanceVentasDataMesPunto {
  BalanceVentasDataMesPunto(this.mes, this.ventas);

  final String mes;
  final double ventas;
}
