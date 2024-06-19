// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteCostoProduccionAgnoUnidad extends StatelessWidget {
  const ReporteCostoProduccionAgnoUnidad({
    super.key,
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
            child: SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(isVisible: Responsive.isMobile(context) ? false : true),
              primaryXAxis: const NumericAxis(
                title: AxisTitle(text: 'Año'),
                interval: 1,
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Costo de Producción (COP)'),
              ),
              series: <CartesianSeries>[
                ColumnSeries<ProduccionCostoDataAgnoUnidad, double>(
                  name: 'Huevos',
                  dataSource: _getProduccionCostoAgnoData('Huevos'),
                  xValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.costo,
                  color: Colors.red,
                ),
                ColumnSeries<ProduccionCostoDataAgnoUnidad, double>(
                  name: 'Leche',
                  dataSource: _getProduccionCostoAgnoData('Leche'),
                  xValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.costo,
                  color: Colors.blue,
                ),
                ColumnSeries<ProduccionCostoDataAgnoUnidad, double>(
                  name: 'Queso',
                  dataSource: _getProduccionCostoAgnoData('Queso'),
                  xValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.costo,
                  color: Colors.green,
                ),
                ColumnSeries<ProduccionCostoDataAgnoUnidad, double>(
                  name: 'Astromelias',
                  dataSource: _getProduccionCostoAgnoData('Astromelias'),
                  xValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.costo,
                  color: Colors.orange,
                ),
                ColumnSeries<ProduccionCostoDataAgnoUnidad, double>(
                  name: 'Miel',
                  dataSource: _getProduccionCostoAgnoData('Miel'),
                  xValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.costo,
                  color: Colors.purple,
                ),
                ColumnSeries<ProduccionCostoDataAgnoUnidad, double>(
                  name: 'Leche de cabra',
                  dataSource: _getProduccionCostoAgnoData('Leche de cabra'),
                  xValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.costo,
                  color: Colors.brown,
                ),
                ColumnSeries<ProduccionCostoDataAgnoUnidad, double>(
                  name: 'Pan',
                  dataSource: _getProduccionCostoAgnoData('Pan'),
                  xValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoUnidad data, _) =>
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

  List<ProduccionCostoDataAgnoUnidad> _getProduccionCostoAgnoData(
      String producto) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Huevos': [
        ProduccionCostoDataAgnoUnidad(2020, 5000),
        ProduccionCostoDataAgnoUnidad(2021, 5500),
        ProduccionCostoDataAgnoUnidad(2022, 6000),
      ],
      'Leche': [
        ProduccionCostoDataAgnoUnidad(2020, 4000),
        ProduccionCostoDataAgnoUnidad(2021, 4200),
        ProduccionCostoDataAgnoUnidad(2022, 4500),
      ],
      'Queso': [
        ProduccionCostoDataAgnoUnidad(2020, 7000),
        ProduccionCostoDataAgnoUnidad(2021, 7500),
        ProduccionCostoDataAgnoUnidad(2022, 8000),
      ],
      'Astromelias': [
        ProduccionCostoDataAgnoUnidad(2020, 3000),
        ProduccionCostoDataAgnoUnidad(2021, 3200),
        ProduccionCostoDataAgnoUnidad(2022, 3500),
      ],
      'Miel': [
        ProduccionCostoDataAgnoUnidad(2020, 6000),
        ProduccionCostoDataAgnoUnidad(2021, 6200),
        ProduccionCostoDataAgnoUnidad(2022, 6500),
      ],
      'Leche de cabra': [
        ProduccionCostoDataAgnoUnidad(2020, 8000),
        ProduccionCostoDataAgnoUnidad(2021, 8500),
        ProduccionCostoDataAgnoUnidad(2022, 9000),
      ],
      'Pan': [
        ProduccionCostoDataAgnoUnidad(2020, 2000),
        ProduccionCostoDataAgnoUnidad(2021, 2200),
        ProduccionCostoDataAgnoUnidad(2022, 2500),
      ],
    };

    return data[producto] ?? [];
  }
}

class ProduccionCostoDataAgnoUnidad {
  ProduccionCostoDataAgnoUnidad(this.anio, this.costo);

  final double anio;
  final double costo;
}
