// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteCostoProduccionAgnoLider extends StatelessWidget {
  const ReporteCostoProduccionAgnoLider({
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
              legend: Legend(
                  isVisible: Responsive.isMobile(context) ? false : true),
              primaryXAxis: const NumericAxis(
                title: AxisTitle(text: 'Año'),
                interval: 1,
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Costo de Producción (COP)'),
              ),
              series: <CartesianSeries>[
                ColumnSeries<ProduccionCostoDataAgnoLider, double>(
                  name: 'Huevos',
                  dataSource: _getProduccionCostoAgnoData('Huevos'),
                  xValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.costo,
                  color: Colors.red,
                ),
                ColumnSeries<ProduccionCostoDataAgnoLider, double>(
                  name: 'Leche',
                  dataSource: _getProduccionCostoAgnoData('Leche'),
                  xValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.costo,
                  color: Colors.blue,
                ),
                ColumnSeries<ProduccionCostoDataAgnoLider, double>(
                  name: 'Queso',
                  dataSource: _getProduccionCostoAgnoData('Queso'),
                  xValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.costo,
                  color: Colors.green,
                ),
                ColumnSeries<ProduccionCostoDataAgnoLider, double>(
                  name: 'Astromelias',
                  dataSource: _getProduccionCostoAgnoData('Astromelias'),
                  xValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.costo,
                  color: Colors.orange,
                ),
                ColumnSeries<ProduccionCostoDataAgnoLider, double>(
                  name: 'Miel',
                  dataSource: _getProduccionCostoAgnoData('Miel'),
                  xValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.costo,
                  color: Colors.purple,
                ),
                ColumnSeries<ProduccionCostoDataAgnoLider, double>(
                  name: 'Leche de cabra',
                  dataSource: _getProduccionCostoAgnoData('Leche de cabra'),
                  xValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.costo,
                  color: Colors.brown,
                ),
                ColumnSeries<ProduccionCostoDataAgnoLider, double>(
                  name: 'Pan',
                  dataSource: _getProduccionCostoAgnoData('Pan'),
                  xValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
                      data.anio,
                  yValueMapper: (ProduccionCostoDataAgnoLider data, _) =>
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

  List<ProduccionCostoDataAgnoLider> _getProduccionCostoAgnoData(
      String producto) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Huevos': [
        ProduccionCostoDataAgnoLider(2020, 5000),
        ProduccionCostoDataAgnoLider(2021, 5500),
        ProduccionCostoDataAgnoLider(2022, 6000),
      ],
      'Leche': [
        ProduccionCostoDataAgnoLider(2020, 4000),
        ProduccionCostoDataAgnoLider(2021, 4200),
        ProduccionCostoDataAgnoLider(2022, 4500),
      ],
      'Queso': [
        ProduccionCostoDataAgnoLider(2020, 7000),
        ProduccionCostoDataAgnoLider(2021, 7500),
        ProduccionCostoDataAgnoLider(2022, 8000),
      ],
      'Astromelias': [
        ProduccionCostoDataAgnoLider(2020, 3000),
        ProduccionCostoDataAgnoLider(2021, 3200),
        ProduccionCostoDataAgnoLider(2022, 3500),
      ],
      'Miel': [
        ProduccionCostoDataAgnoLider(2020, 6000),
        ProduccionCostoDataAgnoLider(2021, 6200),
        ProduccionCostoDataAgnoLider(2022, 6500),
      ],
      'Leche de cabra': [
        ProduccionCostoDataAgnoLider(2020, 8000),
        ProduccionCostoDataAgnoLider(2021, 8500),
        ProduccionCostoDataAgnoLider(2022, 9000),
      ],
      'Pan': [
        ProduccionCostoDataAgnoLider(2020, 2000),
        ProduccionCostoDataAgnoLider(2021, 2200),
        ProduccionCostoDataAgnoLider(2022, 2500),
      ],
    };

    return data[producto] ?? [];
  }
}

class ProduccionCostoDataAgnoLider {
  ProduccionCostoDataAgnoLider(this.anio, this.costo);

  final double anio;
  final double costo;
}
