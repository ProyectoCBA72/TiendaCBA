// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ReporteVendedoresPunto extends StatelessWidget {
  final UsuarioModel usuario;

  const ReporteVendedoresPunto({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del reporte
        Text(
          "Balance de ventas diario por vendedor",
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
                getAuxPedidos(), // Obtener pedidos auxiliares
                getFacturas(), // Obtener facturas
                getUsuarios(), // Obtener usuarios
                getDevoluciones(), // Obtener devoluciones
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
                  List<UsuarioModel> usuarios = snapshot.data![2];
                  List<DevolucionesModel> devoluciones = snapshot.data![3];

                  return SfCartesianChart(
                    // Configuración del gráfico
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: const Legend(
                      isVisible: true,
                    ),
                    primaryXAxis: DateTimeAxis(
                      title: const AxisTitle(text: 'Fecha'),
                      dateFormat: DateFormat('dd/MM'),
                      intervalType: DateTimeIntervalType.days,
                      interval: 1,
                      minimum: DateTime.now().subtract(const Duration(days: 2)),
                      maximum: DateTime.now(),
                    ),
                    primaryYAxis: NumericAxis(
                      title: const AxisTitle(text: 'Ventas (COP)'),
                      numberFormat:
                          NumberFormat.currency(locale: 'es_CO', symbol: ''),
                    ),
                    series: <CartesianSeries>[
                      // Generación dinámica de series para cada vendedor
                      for (var vendedor in usuarios.where((u) =>
                          u.puntoVenta == usuario.puntoVenta &&
                          facturas.any((f) =>
                              f.usuarioVendedor == u.id &&
                              devoluciones.any((d) => d.factura.id != f.id))))
                        SplineAreaSeries<BalanceVendedoresDataPunto, DateTime>(
                          name: vendedor.nombres, // Nombre del vendedor
                          dataSource: _getBalanceVentasDataDiario(
                            vendedor,
                            auxPedidos,
                            facturas,
                            devoluciones,
                          ),
                          xValueMapper: (BalanceVendedoresDataPunto data, _) =>
                              data.fecha,
                          yValueMapper: (BalanceVendedoresDataPunto data, _) =>
                              data.ventas,
                          color:
                              _getColor(), // Color automático para el vendedor
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

  List<BalanceVendedoresDataPunto> _getBalanceVentasDataDiario(
    UsuarioModel vendedor,
    List<AuxPedidoModel> auxPedidos,
    List<FacturaModel> facturas,
    List<DevolucionesModel> devoluciones,
  ) {
    // Mapa para almacenar las ventas por día
    Map<DateTime, double> ventasPorDia = {};

    // Obtener la fecha de hoy y los últimos dos días
    DateTime now = DateTime.now();
    DateTime startDate =
        now.subtract(const Duration(days: 2)); // Últimos 3 días, incluyendo hoy

    for (var factura in facturas) {
      if (factura.usuarioVendedor != vendedor.id) {
        continue;
      }
      var fechaFactura = DateTime.parse(factura.fecha);

      // Verificar que la factura esté dentro de los últimos tres días
      if (fechaFactura.isAfter(startDate) ||
          fechaFactura.isAtSameMomentAs(startDate)) {
        var pedido = factura.pedido;

        // Calcular el total de ventas para el pedido
        var totalVenta = auxPedidos
            .where((aux) => aux.pedido.id == pedido.id)
            .fold(0, (sum, aux) => sum + aux.precio);

        // Normalizar la fecha a medianoche (00:00:00)
        var fechaNormalizada =
            DateTime(fechaFactura.year, fechaFactura.month, fechaFactura.day);

        // Actualizar la suma de ventas por cada día
        ventasPorDia.update(
          fechaNormalizada,
          (value) => value + totalVenta,
          ifAbsent: () => totalVenta.toDouble(),
        );
      }
    }

    // Convertir el mapa a una lista de objetos BalanceVendedoresDataPunto
    return ventasPorDia.entries
        .map((entry) => BalanceVendedoresDataPunto(entry.key, entry.value))
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
}

// Modelo de datos para el balance de ventas por día
class BalanceVendedoresDataPunto {
  BalanceVendedoresDataPunto(this.fecha, this.ventas);

  final DateTime fecha; // Fecha de la venta
  final double ventas; // Cantidad de ventas
}
