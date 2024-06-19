// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteProductosMasVendidosMesUnidad extends StatelessWidget {
  const ReporteProductosMasVendidosMesUnidad({
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
                SplineSeries<ProduccionVentaDataMesUnidad, String>(
                  name: 'Huevos',
                  dataSource: _getProduccionVentaDataMes('Huevos'),
                  xValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                SplineSeries<ProduccionVentaDataMesUnidad, String>(
                  name: 'Leche',
                  dataSource: _getProduccionVentaDataMes('Leche'),
                  xValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                SplineSeries<ProduccionVentaDataMesUnidad, String>(
                  name: 'Queso',
                  dataSource: _getProduccionVentaDataMes('Queso'),
                  xValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                SplineSeries<ProduccionVentaDataMesUnidad, String>(
                  name: 'Astromelias',
                  dataSource: _getProduccionVentaDataMes('Astromelias'),
                  xValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                SplineSeries<ProduccionVentaDataMesUnidad, String>(
                  name: 'Miel',
                  dataSource: _getProduccionVentaDataMes('Miel'),
                  xValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.cantidad,
                  color: Colors.purple,
                ),
                SplineSeries<ProduccionVentaDataMesUnidad, String>(
                  name: 'Leche de cabra',
                  dataSource: _getProduccionVentaDataMes('Leche de cabra'),
                  xValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.cantidad,
                  color: Colors.brown,
                ),
                SplineSeries<ProduccionVentaDataMesUnidad, String>(
                  name: 'Pan',
                  dataSource: _getProduccionVentaDataMes('Pan'),
                  xValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesUnidad data, _) =>
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

  List<ProduccionVentaDataMesUnidad> _getProduccionVentaDataMes(
      String producto) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Huevos': [
        ProduccionVentaDataMesUnidad('Enero', 500),
        ProduccionVentaDataMesUnidad('Febrero', 550),
        ProduccionVentaDataMesUnidad('Marzo', 600),
        ProduccionVentaDataMesUnidad('Abril', 650),
        ProduccionVentaDataMesUnidad('Mayo', 700),
      ],
      'Leche': [
        ProduccionVentaDataMesUnidad('Enero', 400),
        ProduccionVentaDataMesUnidad('Febrero', 420),
        ProduccionVentaDataMesUnidad('Marzo', 450),
        ProduccionVentaDataMesUnidad('Abril', 470),
        ProduccionVentaDataMesUnidad('Mayo', 500),
      ],
      'Queso': [
        ProduccionVentaDataMesUnidad('Enero', 700),
        ProduccionVentaDataMesUnidad('Febrero', 750),
        ProduccionVentaDataMesUnidad('Marzo', 800),
        ProduccionVentaDataMesUnidad('Abril', 850),
        ProduccionVentaDataMesUnidad('Mayo', 900),
      ],
      'Astromelias': [
        ProduccionVentaDataMesUnidad('Enero', 300),
        ProduccionVentaDataMesUnidad('Febrero', 320),
        ProduccionVentaDataMesUnidad('Marzo', 350),
        ProduccionVentaDataMesUnidad('Abril', 370),
        ProduccionVentaDataMesUnidad('Mayo', 400),
      ],
      'Miel': [
        ProduccionVentaDataMesUnidad('Enero', 600),
        ProduccionVentaDataMesUnidad('Febrero', 620),
        ProduccionVentaDataMesUnidad('Marzo', 650),
        ProduccionVentaDataMesUnidad('Abril', 670),
        ProduccionVentaDataMesUnidad('Mayo', 700),
      ],
      'Leche de cabra': [
        ProduccionVentaDataMesUnidad('Enero', 800),
        ProduccionVentaDataMesUnidad('Febrero', 850),
        ProduccionVentaDataMesUnidad('Marzo', 900),
        ProduccionVentaDataMesUnidad('Abril', 950),
        ProduccionVentaDataMesUnidad('Mayo', 1000),
      ],
      'Pan': [
        ProduccionVentaDataMesUnidad('Enero', 200),
        ProduccionVentaDataMesUnidad('Febrero', 220),
        ProduccionVentaDataMesUnidad('Marzo', 250),
        ProduccionVentaDataMesUnidad('Abril', 270),
        ProduccionVentaDataMesUnidad('Mayo', 300),
      ],
    };

    return data[producto] ?? [];
  }
}

class ProduccionVentaDataMesUnidad {
  ProduccionVentaDataMesUnidad(this.mes, this.cantidad);

  final String mes;
  final double cantidad;
}
