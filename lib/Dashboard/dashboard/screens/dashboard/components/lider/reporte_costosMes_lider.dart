// ignore_for_file: file_names, unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:intl/intl.dart';

class ReporteCostoProduccionMesLider extends StatelessWidget {
  final UsuarioModel usuario;
  const ReporteCostoProduccionMesLider({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del reporte
        Text(
          "Costo de producción por mes",
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
                // Obtener producciones y productos
                future: Future.wait([getProducciones(), getProductos()]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Mostrar un indicador de carga mientras se esperan los datos
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Mostrar un mensaje de error si la carga falla
                    return Center(
                      child: Text(
                        'Error al cargar datos: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    // Obtener los datos de las producciones y productos
                    List<ProduccionModel> allProductions = snapshot.data![0];
                    List<ProductoModel> allProducts = snapshot.data![1];

                    // Calcular los datos para los 7 productos con mayor costo de producción en los últimos 4 meses
                    var data = _calculateTopRecentProductions(
                        allProductions, allProducts, usuario);

                    // Construir y mostrar la gráfica
                    return SfCartesianChart(
                      tooltipBehavior: TooltipBehavior(enable: true),
                      legend: const Legend(isVisible: true),
                      primaryXAxis: const CategoryAxis(
                        title: AxisTitle(text: 'Meses'),
                        interval: 1,
                      ),
                      primaryYAxis: NumericAxis(
                        title:
                            const AxisTitle(text: 'Costo de Producción (COP)'),
                        numberFormat:
                            NumberFormat.currency(locale: 'es_CO', symbol: ''),
                      ),
                      series: data.asMap().entries.map((entry) {
                        ProduccionCostoDataMesLiderGroup productData =
                            entry.value;
                        return ColumnSeries<ProduccionCostoDataMesLider,
                            String>(
                          name: productData.nombre,
                          dataSource: productData.datos,
                          xValueMapper: (ProduccionCostoDataMesLider data, _) =>
                              data.mes,
                          yValueMapper: (ProduccionCostoDataMesLider data, _) =>
                              data.costo,
                          color: _getColor(),
                        );
                      }).toList(),
                    );
                  }
                }),
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

  // Función para calcular los datos de los 7 productos con mayor costo de producción en los últimos 4 meses
  List<ProduccionCostoDataMesLiderGroup> _calculateTopRecentProductions(
      List<ProduccionModel> productions,
      List<ProductoModel> products,
      UsuarioModel usuario) {
    Map<String, ProduccionCostoDataMesLiderGroup> productionDataByProduct = {};

    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    for (var production in productions) {
      // Verificar si la fecha de producción no está vacía y la sede coincide con la del usuario
      if (production.fechaProduccion.isNotEmpty &&
          production.unidadProduccion.sede.id == usuario.sede) {
        DateTime productionDate = DateTime.parse(production.fechaProduccion);

        // Filtrar los datos para los últimos cuatro meses
        if (productionDate.isBefore(DateTime(currentYear, currentMonth - 3))) {
          continue;
        }

        // Encontrar el producto correspondiente a la producción actual
        var product =
            products.where((product) => product.id == production.producto);

        var productName = product.firstOrNull?.nombre;

        if (productName != null) {
          // Obtener el nombre del mes
          String month = _getNombreMes(productionDate);
          // Crear una clave única para el producto y mes
          String key = "$productName-$month";

          // Sumar los costos de producción sin que se repitan los productos
          if (!productionDataByProduct.containsKey(key)) {
            productionDataByProduct[key] = ProduccionCostoDataMesLiderGroup(
                productName, [ProduccionCostoDataMesLider(month, 0.0)]);
          }

          productionDataByProduct[key]!.datos[0].costo +=
              production.costoProduccion.toDouble();
        }
      }
    }

    // Agrupar los datos por nombre del producto
    Map<String, List<ProduccionCostoDataMesLider>> groupedDataByProduct = {};

    for (var entry in productionDataByProduct.entries) {
      var productName = entry.value.nombre;
      if (!groupedDataByProduct.containsKey(productName)) {
        groupedDataByProduct[productName] = [];
      }
      groupedDataByProduct[productName]!.add(entry.value.datos[0]);
    }

    // Ordenar los productos por costo total de producción y seleccionar los 7 más caros
    List<MapEntry<String, List<ProduccionCostoDataMesLider>>> sortedProducts =
        groupedDataByProduct.entries.toList()
          ..sort((a, b) => b.value
              .fold(0, (sum, item) => sum + item.costo.toInt())
              .compareTo(a.value.fold(0, (sum, item) => sum + item.costo)));

    // Mapear los datos ordenados a la estructura utilizada por la gráfica
    return sortedProducts.take(7).map((entry) {
      return ProduccionCostoDataMesLiderGroup(entry.key, entry.value);
    }).toList();
  }
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

// Clase para representar los datos de costo de producción por mes
class ProduccionCostoDataMesLider {
  ProduccionCostoDataMesLider(this.mes, this.costo);

  final String mes;
  double costo;
}

// Clase para agrupar los datos de costo de producción por producto
class ProduccionCostoDataMesLiderGroup {
  ProduccionCostoDataMesLiderGroup(this.nombre, this.datos);

  final String nombre;
  final List<ProduccionCostoDataMesLider> datos;
}
