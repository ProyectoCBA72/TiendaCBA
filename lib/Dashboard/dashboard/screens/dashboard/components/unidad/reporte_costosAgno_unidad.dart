// ignore_for_file: file_names, unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ReporteCostoProduccionAgnoUnidad extends StatelessWidget {
  final UsuarioModel usuario;
  const ReporteCostoProduccionAgnoUnidad({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Costo de producción por año",
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
                future: Future.wait([getProducciones(), getProductos()]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  // Mostrar un indicador de carga mientras se esperan los datos
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                    // Mostrar un mensaje de error si la carga falla
                  } else if (snapshot.hasError) {
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

                    // Calcular los datos para los 7 productos con mayor costo de producción
                    var data = _calculateTopProductions(
                        allProductions, allProducts, usuario);

                    // Construir y mostrar la gráfica
                    return SfCartesianChart(
                      tooltipBehavior: TooltipBehavior(enable: true),
                      legend: const Legend(isVisible: true),
                      primaryXAxis: const NumericAxis(
                        title: AxisTitle(text: 'Año'),
                        interval: 1,
                      ),
                      primaryYAxis: NumericAxis(
                        title:
                            const AxisTitle(text: 'Costo de Producción (COP)'),
                        numberFormat:
                            NumberFormat.currency(locale: 'es_CO', symbol: ''),
                      ),
                      series: data.asMap().entries.map((entry) {
                        ProduccionCostoDataAgnoUnidadGroup productData =
                            entry.value;
                        return ColumnSeries<ProduccionCostoDataAgnoUnidad,
                            double>(
                          name: productData.nombre,
                          dataSource: productData.datos,
                          xValueMapper:
                              (ProduccionCostoDataAgnoUnidad data, _) =>
                                  data.anio,
                          yValueMapper:
                              (ProduccionCostoDataAgnoUnidad data, _) =>
                                  data.costo,
                          color: _getColor(), // Asignar color
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

  // Función para calcular los datos de los 7 productos con mayor costo de producción
  List<ProduccionCostoDataAgnoUnidadGroup> _calculateTopProductions(
      List<ProduccionModel> productions,
      List<ProductoModel> products,
      UsuarioModel usuario) {
    Map<String, Map<int, double>> productionDataByProduct = {};

    int currentYear = DateTime.now().year;

    // Recorrer todas las producciones
    for (var production in productions) {
      // Verificar si la fecha de producción no está vacía y la unidad coincide con la del usuario
      if (production.fechaProduccion.isNotEmpty &&
          production.unidadProduccion.id == usuario.unidadProduccion) {
        DateTime productionDate = DateTime.parse(production.fechaProduccion);
        int year = productionDate.year;

        // Filtrar los datos para los últimos tres años
        if (year < currentYear - 2) continue;

        // Encontrar el producto correspondiente a la producción actual
        var product =
            products.where((product) => product.id == production.producto);

        var productName = product.firstOrNull?.nombre;

        if (productName != null) {
          // Inicializar la entrada si no existe
          if (!productionDataByProduct.containsKey(productName)) {
            productionDataByProduct[productName] = {};
          }

          // Sumar los costos de producción por año
          if (!productionDataByProduct[productName]!.containsKey(year)) {
            productionDataByProduct[productName]![year] = 0;
          }
          productionDataByProduct[productName]![year] =
              productionDataByProduct[productName]![year]! +
                  production.costoProduccion;
        }
      }
    }

    // Ordenar los productos por costo total de producción y seleccionar los 7 más caros
    List<MapEntry<String, Map<int, double>>> sortedProducts =
        productionDataByProduct.entries.toList()
          ..sort((a, b) => b.value.values
              .fold(0, (sum, item) => sum + item.toInt())
              .compareTo(
                  a.value.values.fold(0, (sum, item) => sum + item.toInt())));

    // Mapear los datos ordenados a la estructura utilizada por la gráfica
    return sortedProducts.take(7).map((entry) {
      List<ProduccionCostoDataAgnoUnidad> datos = entry.value.entries
          .map((e) => ProduccionCostoDataAgnoUnidad(e.key.toDouble(), e.value))
          .toList();
      return ProduccionCostoDataAgnoUnidadGroup(entry.key, datos);
    }).toList();
  }
}

// Clase para representar los datos de costo de producción por año
class ProduccionCostoDataAgnoUnidad {
  ProduccionCostoDataAgnoUnidad(this.anio, this.costo);

  final double anio;
  final double costo;
}

// Clase para agrupar los datos de costo de producción por producto
class ProduccionCostoDataAgnoUnidadGroup {
  ProduccionCostoDataAgnoUnidadGroup(this.nombre, this.datos);

  final String nombre;
  final List<ProduccionCostoDataAgnoUnidad> datos;
}
