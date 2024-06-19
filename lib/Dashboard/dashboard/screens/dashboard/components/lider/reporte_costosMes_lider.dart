// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteCostoProduccionMesLider extends StatelessWidget {
  const ReporteCostoProduccionMesLider({
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
              legend: Legend(
                  isVisible: Responsive.isMobile(context) ? false : true),
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: 'Meses'),
                interval: 1,
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Costo de Producción (COP)'),
              ),
              series: <CartesianSeries>[
                ColumnSeries<ProduccionCostoDataMesLider, String>(
                  name: 'Huevos',
                  dataSource: _getProduccionCostoMesData('Huevos'),
                  xValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.costo,
                  color: Colors.red,
                ),
                ColumnSeries<ProduccionCostoDataMesLider, String>(
                  name: 'Leche',
                  dataSource: _getProduccionCostoMesData('Leche'),
                  xValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.costo,
                  color: Colors.blue,
                ),
                ColumnSeries<ProduccionCostoDataMesLider, String>(
                  name: 'Queso',
                  dataSource: _getProduccionCostoMesData('Queso'),
                  xValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.costo,
                  color: Colors.green,
                ),
                ColumnSeries<ProduccionCostoDataMesLider, String>(
                  name: 'Astromelias',
                  dataSource: _getProduccionCostoMesData('Astromelias'),
                  xValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.costo,
                  color: Colors.orange,
                ),
                ColumnSeries<ProduccionCostoDataMesLider, String>(
                  name: 'Miel',
                  dataSource: _getProduccionCostoMesData('Miel'),
                  xValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.costo,
                  color: Colors.purple,
                ),
                ColumnSeries<ProduccionCostoDataMesLider, String>(
                  name: 'Leche de cabra',
                  dataSource: _getProduccionCostoMesData('Leche de cabra'),
                  xValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.costo,
                  color: Colors.brown,
                ),
                ColumnSeries<ProduccionCostoDataMesLider, String>(
                  name: 'Pan',
                  dataSource: _getProduccionCostoMesData('Pan'),
                  xValueMapper: (ProduccionCostoDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionCostoDataMesLider data, _) =>
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

  List<ProduccionCostoDataMesLider> _getProduccionCostoMesData(
      String producto) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Huevos': [
        ProduccionCostoDataMesLider('Enero', 5000),
        ProduccionCostoDataMesLider('Febrero', 5500),
        ProduccionCostoDataMesLider('Marzo', 6000),
        ProduccionCostoDataMesLider('Abril', 5500),
        ProduccionCostoDataMesLider('Mayo', 6000),
      ],
      'Leche': [
        ProduccionCostoDataMesLider('Enero', 4000),
        ProduccionCostoDataMesLider('Febrero', 4200),
        ProduccionCostoDataMesLider('Marzo', 4500),
        ProduccionCostoDataMesLider('Abril', 4200),
        ProduccionCostoDataMesLider('Mayo', 4500),
      ],
      'Queso': [
        ProduccionCostoDataMesLider('Enero', 7000),
        ProduccionCostoDataMesLider('Febrero', 7500),
        ProduccionCostoDataMesLider('Marzo', 8000),
        ProduccionCostoDataMesLider('Abril', 7500),
        ProduccionCostoDataMesLider('Mayo', 8000),
      ],
      'Astromelias': [
        ProduccionCostoDataMesLider('Enero', 3000),
        ProduccionCostoDataMesLider('Febrero', 3200),
        ProduccionCostoDataMesLider('Marzo', 3500),
        ProduccionCostoDataMesLider('Abril', 3200),
        ProduccionCostoDataMesLider('Mayo', 3500),
      ],
      'Miel': [
        ProduccionCostoDataMesLider('Enero', 6000),
        ProduccionCostoDataMesLider('Febrero', 6200),
        ProduccionCostoDataMesLider('Marzo', 6500),
        ProduccionCostoDataMesLider('Abril', 6200),
        ProduccionCostoDataMesLider('Mayo', 6500),
      ],
      'Leche de cabra': [
        ProduccionCostoDataMesLider('Enero', 8000),
        ProduccionCostoDataMesLider('Febrero', 8500),
        ProduccionCostoDataMesLider('Marzo', 9000),
        ProduccionCostoDataMesLider('Abril', 8500),
        ProduccionCostoDataMesLider('Mayo', 9000),
      ],
      'Pan': [
        ProduccionCostoDataMesLider('Enero', 2000),
        ProduccionCostoDataMesLider('Febrero', 2200),
        ProduccionCostoDataMesLider('Marzo', 2500),
        ProduccionCostoDataMesLider('Abril', 2200),
        ProduccionCostoDataMesLider('Mayo', 2500),
      ],
    };

    return data[producto] ?? [];
  }
}

class ProduccionCostoDataMesLider {
  ProduccionCostoDataMesLider(this.mes, this.costo);

  final String mes;
  final double costo;
}
