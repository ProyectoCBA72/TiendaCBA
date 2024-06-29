// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteProductosMasVendidosAgnoUnidad extends StatelessWidget {
  const ReporteProductosMasVendidosAgnoUnidad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Productos más vendidos por año",
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
                title: AxisTitle(text: 'Año'),
                interval: 1,
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Cantidad Vendida'),
              ),
              series: <CartesianSeries>[
                SplineSeries<ProduccionVentaAgnoDataUnidad, String>(
                  name: 'Huevos',
                  dataSource: _getProduccionVentaDataAgno('Huevos'),
                  xValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                SplineSeries<ProduccionVentaAgnoDataUnidad, String>(
                  name: 'Leche',
                  dataSource: _getProduccionVentaDataAgno('Leche'),
                  xValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                SplineSeries<ProduccionVentaAgnoDataUnidad, String>(
                  name: 'Queso',
                  dataSource: _getProduccionVentaDataAgno('Queso'),
                  xValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                SplineSeries<ProduccionVentaAgnoDataUnidad, String>(
                  name: 'Astromelias',
                  dataSource: _getProduccionVentaDataAgno('Astromelias'),
                  xValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                SplineSeries<ProduccionVentaAgnoDataUnidad, String>(
                  name: 'Miel',
                  dataSource: _getProduccionVentaDataAgno('Miel'),
                  xValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.purple,
                ),
                SplineSeries<ProduccionVentaAgnoDataUnidad, String>(
                  name: 'Leche de cabra',
                  dataSource: _getProduccionVentaDataAgno('Leche de cabra'),
                  xValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.brown,
                ),
                SplineSeries<ProduccionVentaAgnoDataUnidad, String>(
                  name: 'Pan',
                  dataSource: _getProduccionVentaDataAgno('Pan'),
                  xValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataUnidad data, _) =>
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

  List<ProduccionVentaAgnoDataUnidad> _getProduccionVentaDataAgno(
      String producto) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Huevos': [
        ProduccionVentaAgnoDataUnidad('2022', 500),
        ProduccionVentaAgnoDataUnidad('2023', 550),
        ProduccionVentaAgnoDataUnidad('2024', 600),
      ],
      'Leche': [
        ProduccionVentaAgnoDataUnidad('2022', 400),
        ProduccionVentaAgnoDataUnidad('2023', 420),
        ProduccionVentaAgnoDataUnidad('2024', 450),
      ],
      'Queso': [
        ProduccionVentaAgnoDataUnidad('2022', 700),
        ProduccionVentaAgnoDataUnidad('2023', 750),
        ProduccionVentaAgnoDataUnidad('2024', 800),
      ],
      'Astromelias': [
        ProduccionVentaAgnoDataUnidad('2022', 300),
        ProduccionVentaAgnoDataUnidad('2023', 320),
        ProduccionVentaAgnoDataUnidad('2024', 350),
      ],
      'Miel': [
        ProduccionVentaAgnoDataUnidad('2022', 600),
        ProduccionVentaAgnoDataUnidad('2023', 620),
        ProduccionVentaAgnoDataUnidad('2024', 650),
      ],
      'Leche de cabra': [
        ProduccionVentaAgnoDataUnidad('2022', 800),
        ProduccionVentaAgnoDataUnidad('2023', 850),
        ProduccionVentaAgnoDataUnidad('2024', 900),
      ],
      'Pan': [
        ProduccionVentaAgnoDataUnidad('2022', 200),
        ProduccionVentaAgnoDataUnidad('2023', 220),
        ProduccionVentaAgnoDataUnidad('2024', 250),
      ],
    };

    return data[producto] ?? [];
  }
}

class ProduccionVentaAgnoDataUnidad {
  ProduccionVentaAgnoDataUnidad(this.agno, this.cantidad);

  final String agno;
  final double cantidad;
}
