// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteProductosMasVendidosAgnoPunto extends StatelessWidget {
  const ReporteProductosMasVendidosAgnoPunto({
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
              legend: Legend(isVisible: Responsive.isMobile(context) ? false : true),
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: 'Año'),
                interval: 1,
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Cantidad Vendida'),
              ),
              series: <CartesianSeries>[
                SplineSeries<ProduccionVentaAgnoDataPunto, String>(
                  name: 'Huevos',
                  dataSource: _getProduccionVentaDataAgno('Huevos'),
                  xValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                SplineSeries<ProduccionVentaAgnoDataPunto, String>(
                  name: 'Leche',
                  dataSource: _getProduccionVentaDataAgno('Leche'),
                  xValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                SplineSeries<ProduccionVentaAgnoDataPunto, String>(
                  name: 'Queso',
                  dataSource: _getProduccionVentaDataAgno('Queso'),
                  xValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                SplineSeries<ProduccionVentaAgnoDataPunto, String>(
                  name: 'Astromelias',
                  dataSource: _getProduccionVentaDataAgno('Astromelias'),
                  xValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                SplineSeries<ProduccionVentaAgnoDataPunto, String>(
                  name: 'Miel',
                  dataSource: _getProduccionVentaDataAgno('Miel'),
                  xValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.purple,
                ),
                SplineSeries<ProduccionVentaAgnoDataPunto, String>(
                  name: 'Leche de cabra',
                  dataSource: _getProduccionVentaDataAgno('Leche de cabra'),
                  xValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.brown,
                ),
                SplineSeries<ProduccionVentaAgnoDataPunto, String>(
                  name: 'Pan',
                  dataSource: _getProduccionVentaDataAgno('Pan'),
                  xValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
                      data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataPunto data, _) =>
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

  List<ProduccionVentaAgnoDataPunto> _getProduccionVentaDataAgno(
      String producto) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Huevos': [
        ProduccionVentaAgnoDataPunto('2022', 500),
        ProduccionVentaAgnoDataPunto('2023', 550),
        ProduccionVentaAgnoDataPunto('2024', 600),
      ],
      'Leche': [
        ProduccionVentaAgnoDataPunto('2022', 400),
        ProduccionVentaAgnoDataPunto('2023', 420),
        ProduccionVentaAgnoDataPunto('2024', 450),
      ],
      'Queso': [
        ProduccionVentaAgnoDataPunto('2022', 700),
        ProduccionVentaAgnoDataPunto('2023', 750),
        ProduccionVentaAgnoDataPunto('2024', 800),
      ],
      'Astromelias': [
        ProduccionVentaAgnoDataPunto('2022', 300),
        ProduccionVentaAgnoDataPunto('2023', 320),
        ProduccionVentaAgnoDataPunto('2024', 350),
      ],
      'Miel': [
        ProduccionVentaAgnoDataPunto('2022', 600),
        ProduccionVentaAgnoDataPunto('2023', 620),
        ProduccionVentaAgnoDataPunto('2024', 650),
      ],
      'Leche de cabra': [
        ProduccionVentaAgnoDataPunto('2022', 800),
        ProduccionVentaAgnoDataPunto('2023', 850),
        ProduccionVentaAgnoDataPunto('2024', 900),
      ],
      'Pan': [
        ProduccionVentaAgnoDataPunto('2022', 200),
        ProduccionVentaAgnoDataPunto('2023', 220),
        ProduccionVentaAgnoDataPunto('2024', 250),
      ],
    };

    return data[producto] ?? [];
  }
}

class ProduccionVentaAgnoDataPunto {
  ProduccionVentaAgnoDataPunto(this.agno, this.cantidad);

  final String agno;
  final double cantidad;
}
