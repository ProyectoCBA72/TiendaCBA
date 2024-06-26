import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteProductosMasVendidosMesLider extends StatelessWidget {
  final UsuarioModel usuario;
  const ReporteProductosMasVendidosMesLider({
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
                getPuntosVenta()
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
                    child: Text('Error al cargar datos: ${snapshot.error}'),
                  );
                } else {
                  // Procesar los datos para obtener los productos más vendidos
                  final facturas = snapshot.data![0] as List<FacturaModel>;
                  final productos = snapshot.data![1] as List<ProductoModel>;
                  final auxPedidos = snapshot.data![2] as List<AuxPedidoModel>;
                  final puntos = snapshot.data![3] as List<PuntoVentaModel>;

                  // Filtrar las facturas de los últimos 4 meses incluyendo el mes actual
                  final DateTime now = DateTime.now();
                  final List<FacturaModel> facturasUltimos4Meses = facturas.where((factura) {
                    final DateTime fechaFactura = DateTime.parse(factura.fecha);
                    return fechaFactura.isAfter(now.subtract(const Duration(days: 30 * 4 - 1)));
                  }).toList();

                  // Mapa para almacenar las ventas por producto por mes
                  final Map<String, Map<String, double>> ventasPorProductoPorMes = {};

                  // Iterar sobre las facturas filtradas para calcular las ventas por producto por mes
                  for (var factura in facturasUltimos4Meses) {
                    final DateTime fechaFactura = DateTime.parse(factura.fecha);
                    final String mes = _getNombreMes(fechaFactura);
                    for (var punto in puntos) {
                      for (var auxPedido in auxPedidos) {
                        if (auxPedido.pedido.id == factura.pedido.id &&
                            punto.id == factura.pedido.puntoVenta &&
                            punto.sede == usuario.sede) {
                          final producto = productos.firstWhere((p) => p.id == auxPedido.producto).nombre;
                          ventasPorProductoPorMes.putIfAbsent(producto, () => {});
                          ventasPorProductoPorMes[producto]!.putIfAbsent(mes, () => 0);
                          ventasPorProductoPorMes[producto]![mes] =
                              ventasPorProductoPorMes[producto]![mes]! + auxPedido.cantidad.toDouble();
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

                  // Colores para las series
                  final List<Color> coloresSeries = [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                    Colors.brown,
                    Colors.pink,
                  ];

                  // Construir el gráfico de líneas con los datos obtenidos
                  return SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: Legend(
                        isVisible: Responsive.isMobile(context) ? false : true),
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
                        SplineSeries<ProduccionVentaDataMesLider, String>(
                          name: top7Productos[i],
                          dataSource: _getProduccionVentaDataMes(
                              top7Productos[i], ventasPorProductoPorMes),
                          xValueMapper: (ProduccionVentaDataMesLider data, _) =>
                              data.mes,
                          yValueMapper: (ProduccionVentaDataMesLider data, _) =>
                              data.cantidad,
                          color: coloresSeries[i % coloresSeries.length], // Asignar color basado en la lista de colores
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

  // Función para obtener los datos de ventas por producto por mes
  List<ProduccionVentaDataMesLider> _getProduccionVentaDataMes(
      String producto, Map<String, Map<String, double>> ventasPorProductoPorMes) {
    final List<ProduccionVentaDataMesLider> data = [];
    if (ventasPorProductoPorMes.containsKey(producto)) {
      ventasPorProductoPorMes[producto]!.forEach((mes, cantidad) {
        data.add(ProduccionVentaDataMesLider(mes, cantidad));
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
class ProduccionVentaDataMesLider {
  ProduccionVentaDataMesLider(this.mes, this.cantidad);

  final String mes;
  final double cantidad;
}

