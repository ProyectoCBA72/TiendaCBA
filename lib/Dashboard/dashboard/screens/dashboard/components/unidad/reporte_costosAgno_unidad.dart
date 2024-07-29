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
    Map<String, List<ProduccionCostoDataAgnoUnidad>> productionDataByProduct =
        {};

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
        ProductoModel? product =
            products.firstWhere((product) => product.id == production.producto);
        if (product == null) continue;

        // Agrupar los datos por nombre del producto
        if (!productionDataByProduct.containsKey(product.nombre)) {
          productionDataByProduct[product.nombre] = [];
        }

        productionDataByProduct[product.nombre]!.add(
            ProduccionCostoDataAgnoUnidad(
                year.toDouble(), production.costoProduccion.toDouble()));
      }
    }

    // Ordenar los productos por costo total de producción y seleccionar los 7 más caros
    List<MapEntry<String, List<ProduccionCostoDataAgnoUnidad>>> sortedProducts =
        productionDataByProduct.entries.toList()
          ..sort((a, b) => b.value
              .fold(0, (sum, item) => sum + item.costo.toInt())
              .compareTo(a.value.fold(0, (sum, item) => sum + item.costo)));

    // Mapear los datos ordenados a la estructura utilizada por la gráfica
    return sortedProducts.take(7).map((entry) {
      return ProduccionCostoDataAgnoUnidadGroup(entry.key, entry.value);
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
