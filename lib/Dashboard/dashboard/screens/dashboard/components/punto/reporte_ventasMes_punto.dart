// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteProductosMasVendidosMesPunto extends StatelessWidget {
  const ReporteProductosMasVendidosMesPunto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            child: SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(isVisible: Responsive.isMobile(context) ? false : true),
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: 'Meses'),
                interval: 1,
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Cantidad Vendida'),
              ),
              series: <CartesianSeries>[
                SplineSeries<ProduccionVentaDataMesPunto, String>(
                  name: 'Huevos',
                  dataSource: _getProduccionVentaDataMes('Huevos'),
                  xValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                SplineSeries<ProduccionVentaDataMesPunto, String>(
                  name: 'Leche',
                  dataSource: _getProduccionVentaDataMes('Leche'),
                  xValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                SplineSeries<ProduccionVentaDataMesPunto, String>(
                  name: 'Queso',
                  dataSource: _getProduccionVentaDataMes('Queso'),
                  xValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                SplineSeries<ProduccionVentaDataMesPunto, String>(
                  name: 'Astromelias',
                  dataSource: _getProduccionVentaDataMes('Astromelias'),
                  xValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                SplineSeries<ProduccionVentaDataMesPunto, String>(
                  name: 'Miel',
                  dataSource: _getProduccionVentaDataMes('Miel'),
                  xValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.cantidad,
                  color: Colors.purple,
                ),
                SplineSeries<ProduccionVentaDataMesPunto, String>(
                  name: 'Leche de cabra',
                  dataSource: _getProduccionVentaDataMes('Leche de cabra'),
                  xValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.cantidad,
                  color: Colors.brown,
                ),
                SplineSeries<ProduccionVentaDataMesPunto, String>(
                  name: 'Pan',
                  dataSource: _getProduccionVentaDataMes('Pan'),
                  xValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesPunto data, _) =>
                      data.cantidad,
                  color: Colors.pink,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<ProduccionVentaDataMesPunto> _getProduccionVentaDataMes(
      String producto) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Huevos': [
        ProduccionVentaDataMesPunto('Enero', 500),
        ProduccionVentaDataMesPunto('Febrero', 550),
        ProduccionVentaDataMesPunto('Marzo', 600),
        ProduccionVentaDataMesPunto('Abril', 650),
        ProduccionVentaDataMesPunto('Mayo', 700),
      ],
      'Leche': [
        ProduccionVentaDataMesPunto('Enero', 400),
        ProduccionVentaDataMesPunto('Febrero', 420),
        ProduccionVentaDataMesPunto('Marzo', 450),
        ProduccionVentaDataMesPunto('Abril', 470),
        ProduccionVentaDataMesPunto('Mayo', 500),
      ],
      'Queso': [
        ProduccionVentaDataMesPunto('Enero', 700),
        ProduccionVentaDataMesPunto('Febrero', 750),
        ProduccionVentaDataMesPunto('Marzo', 800),
        ProduccionVentaDataMesPunto('Abril', 850),
        ProduccionVentaDataMesPunto('Mayo', 900),
      ],
      'Astromelias': [
        ProduccionVentaDataMesPunto('Enero', 300),
        ProduccionVentaDataMesPunto('Febrero', 320),
        ProduccionVentaDataMesPunto('Marzo', 350),
        ProduccionVentaDataMesPunto('Abril', 370),
        ProduccionVentaDataMesPunto('Mayo', 400),
      ],
      'Miel': [
        ProduccionVentaDataMesPunto('Enero', 600),
        ProduccionVentaDataMesPunto('Febrero', 620),
        ProduccionVentaDataMesPunto('Marzo', 650),
        ProduccionVentaDataMesPunto('Abril', 670),
        ProduccionVentaDataMesPunto('Mayo', 700),
      ],
      'Leche de cabra': [
        ProduccionVentaDataMesPunto('Enero', 800),
        ProduccionVentaDataMesPunto('Febrero', 850),
        ProduccionVentaDataMesPunto('Marzo', 900),
        ProduccionVentaDataMesPunto('Abril', 950),
        ProduccionVentaDataMesPunto('Mayo', 1000),
      ],
      'Pan': [
        ProduccionVentaDataMesPunto('Enero', 200),
        ProduccionVentaDataMesPunto('Febrero', 220),
        ProduccionVentaDataMesPunto('Marzo', 250),
        ProduccionVentaDataMesPunto('Abril', 270),
        ProduccionVentaDataMesPunto('Mayo', 300),
      ],
    };

    return data[producto] ?? [];
  }
}

class ProduccionVentaDataMesPunto {
  ProduccionVentaDataMesPunto(this.mes, this.cantidad);

  final String mes;
  final double cantidad;
}
