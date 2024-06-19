// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteCostoProduccionMesUnidad extends StatelessWidget {
  const ReporteCostoProduccionMesUnidad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            child: SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(isVisible: Responsive.isMobile(context) ? false : true),
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: 'Meses'),
                interval: 1,
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Costo de Producción (COP)'),
              ),
              series: <CartesianSeries>[
                ColumnSeries<ProduccionCostoDataMesUnidad, String>(
                  name: 'Huevos',
                  dataSource: _getProduccionCostoMesData('Huevos'),
                  xValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.costo,
                  color: Colors.red,
                ),
                ColumnSeries<ProduccionCostoDataMesUnidad, String>(
                  name: 'Leche',
                  dataSource: _getProduccionCostoMesData('Leche'),
                  xValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.costo,
                  color: Colors.blue,
                ),
                ColumnSeries<ProduccionCostoDataMesUnidad, String>(
                  name: 'Queso',
                  dataSource: _getProduccionCostoMesData('Queso'),
                  xValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.costo,
                  color: Colors.green,
                ),
                ColumnSeries<ProduccionCostoDataMesUnidad, String>(
                  name: 'Astromelias',
                  dataSource: _getProduccionCostoMesData('Astromelias'),
                  xValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.costo,
                  color: Colors.orange,
                ),
                ColumnSeries<ProduccionCostoDataMesUnidad, String>(
                  name: 'Miel',
                  dataSource: _getProduccionCostoMesData('Miel'),
                  xValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.costo,
                  color: Colors.purple,
                ),
                ColumnSeries<ProduccionCostoDataMesUnidad, String>(
                  name: 'Leche de cabra',
                  dataSource: _getProduccionCostoMesData('Leche de cabra'),
                  xValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.costo,
                  color: Colors.brown,
                ),
                ColumnSeries<ProduccionCostoDataMesUnidad, String>(
                  name: 'Pan',
                  dataSource: _getProduccionCostoMesData('Pan'),
                  xValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesUnidad data, _) =>
                      data.costo,
                  color: Colors.pink,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<ProduccionCostoDataMesUnidad> _getProduccionCostoMesData(
      String producto) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Huevos': [
        ProduccionCostoDataMesUnidad('Enero', 5000),
        ProduccionCostoDataMesUnidad('Febrero', 5500),
        ProduccionCostoDataMesUnidad('Marzo', 6000),
        ProduccionCostoDataMesUnidad('Abril', 5500),
        ProduccionCostoDataMesUnidad('Mayo', 6000),
      ],
      'Leche': [
        ProduccionCostoDataMesUnidad('Enero', 4000),
        ProduccionCostoDataMesUnidad('Febrero', 4200),
        ProduccionCostoDataMesUnidad('Marzo', 4500),
        ProduccionCostoDataMesUnidad('Abril', 4200),
        ProduccionCostoDataMesUnidad('Mayo', 4500),
      ],
      'Queso': [
        ProduccionCostoDataMesUnidad('Enero', 7000),
        ProduccionCostoDataMesUnidad('Febrero', 7500),
        ProduccionCostoDataMesUnidad('Marzo', 8000),
        ProduccionCostoDataMesUnidad('Abril', 7500),
        ProduccionCostoDataMesUnidad('Mayo', 8000),
      ],
      'Astromelias': [
        ProduccionCostoDataMesUnidad('Enero', 3000),
        ProduccionCostoDataMesUnidad('Febrero', 3200),
        ProduccionCostoDataMesUnidad('Marzo', 3500),
        ProduccionCostoDataMesUnidad('Abril', 3200),
        ProduccionCostoDataMesUnidad('Mayo', 3500),
      ],
      'Miel': [
        ProduccionCostoDataMesUnidad('Enero', 6000),
        ProduccionCostoDataMesUnidad('Febrero', 6200),
        ProduccionCostoDataMesUnidad('Marzo', 6500),
        ProduccionCostoDataMesUnidad('Abril', 6200),
        ProduccionCostoDataMesUnidad('Mayo', 6500),
      ],
      'Leche de cabra': [
        ProduccionCostoDataMesUnidad('Enero', 8000),
        ProduccionCostoDataMesUnidad('Febrero', 8500),
        ProduccionCostoDataMesUnidad('Marzo', 9000),
        ProduccionCostoDataMesUnidad('Abril', 8500),
        ProduccionCostoDataMesUnidad('Mayo', 9000),
      ],
      'Pan': [
        ProduccionCostoDataMesUnidad('Enero', 2000),
        ProduccionCostoDataMesUnidad('Febrero', 2200),
        ProduccionCostoDataMesUnidad('Marzo', 2500),
        ProduccionCostoDataMesUnidad('Abril', 2200),
        ProduccionCostoDataMesUnidad('Mayo', 2500),
      ],
    };

    return data[producto] ?? [];
  }
}

class ProduccionCostoDataMesUnidad {
  ProduccionCostoDataMesUnidad(this.mes, this.costo);

  final String mes;
  final double costo;
}
