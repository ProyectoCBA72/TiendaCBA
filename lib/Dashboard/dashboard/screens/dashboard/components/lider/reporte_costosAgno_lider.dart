// ignore_for_file: file_names

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ReporteCostoProduccionAgnoLider extends StatelessWidget {
  final UsuarioModel usuario;
  const ReporteCostoProduccionAgnoLider({
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al cargar datos: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    List<ProduccionModel> allProductions = snapshot.data![0];
                    List<ProductoModel> allProducts = snapshot.data![1];

                    var data = _calculateTopProductions(
                        allProductions, allProducts, usuario);

                    return SfCartesianChart(
                      tooltipBehavior: TooltipBehavior(enable: true),
                      legend: const Legend(isVisible: true),
                      primaryXAxis: const NumericAxis(
                        title: AxisTitle(text: 'Año'),
                        interval: 1,
                      ),
                      primaryYAxis: NumericAxis(
                        title: const AxisTitle(text: 'Costo de Producción (COP)'),
                        numberFormat: NumberFormat.currency(locale: 'es_CO', symbol: ''),
                      ),
                      series: data.asMap().entries.map((entry) {
                        ProduccionCostoDataAgnoLiderGroup productData = entry.value;
                        return ColumnSeries<ProduccionCostoDataAgnoLider, double>(
                          name: productData.nombre,
                          dataSource: productData.datos,
                          xValueMapper: (ProduccionCostoDataAgnoLider data, _) => data.anio,
                          yValueMapper: (ProduccionCostoDataAgnoLider data, _) => data.costo,
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

  Color _getColor() {
    final random = Random();
    final hue = random.nextDouble() * 360;
    final saturation = random.nextDouble() * (0.5 - 0.2) + 0.2;
    final value = random.nextDouble() * (0.9 - 0.5) + 0.5;

    return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
  }

  List<ProduccionCostoDataAgnoLiderGroup> _calculateTopProductions(
      List<ProduccionModel> productions,
      List<ProductoModel> products,
      UsuarioModel usuario) {
    Map<String, Map<int, double>> productionDataByProduct = {};

    int currentYear = DateTime.now().year;

    for (var production in productions) {
      if (production.fechaProduccion.isNotEmpty &&
          production.unidadProduccion.sede.id == usuario.sede) {
        DateTime productionDate = DateTime.parse(production.fechaProduccion);
        int year = productionDate.year;

        if (year < currentYear - 2) continue;

        var product =
            products.where((product) => product.id == production.producto);

        var productName = product.firstOrNull?.nombre;

        if (productName != null) {
          if (!productionDataByProduct.containsKey(productName)) {
            productionDataByProduct[productName] = {};
          }

          if (!productionDataByProduct[productName]!.containsKey(year)) {
            productionDataByProduct[productName]![year] = 0;
          }

          productionDataByProduct[productName]![year] =
              (productionDataByProduct[productName]![year] ?? 0) + production.costoProduccion.toDouble();
        }
      }
    }

    List<MapEntry<String, Map<int, double>>> sortedProducts = productionDataByProduct.entries.toList()
      ..sort((a, b) => b.value.values.reduce((sum, item) => sum + item)
          .compareTo(a.value.values.reduce((sum, item) => sum + item)));

    return sortedProducts.take(7).map((entry) {
      List<ProduccionCostoDataAgnoLider> datos = entry.value.entries
          .map((e) => ProduccionCostoDataAgnoLider(e.key.toDouble(), e.value))
          .toList();
      return ProduccionCostoDataAgnoLiderGroup(entry.key, datos);
    }).toList();
  }
}

class ProduccionCostoDataAgnoLider {
  ProduccionCostoDataAgnoLider(this.anio, this.costo);

  final double anio;
  final double costo;
}

class ProduccionCostoDataAgnoLiderGroup {
  ProduccionCostoDataAgnoLiderGroup(this.nombre, this.datos);

  final String nombre;
  final List<ProduccionCostoDataAgnoLider> datos;
}
