// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteProductosMasVendidosAgnoLider extends StatelessWidget {
  const ReporteProductosMasVendidosAgnoLider({
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
                SplineSeries<ProduccionVentaAgnoDataLider, String>(
                  name: 'Huevos',
                  dataSource: _getProduccionVentaDataAgno('Huevos'),
                  xValueMapper: (ProduccionVentaAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataLider data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                SplineSeries<ProduccionVentaAgnoDataLider, String>(
                  name: 'Leche',
                  dataSource: _getProduccionVentaDataAgno('Leche'),
                  xValueMapper: (ProduccionVentaAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataLider data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                SplineSeries<ProduccionVentaAgnoDataLider, String>(
                  name: 'Queso',
                  dataSource: _getProduccionVentaDataAgno('Queso'),
                  xValueMapper: (ProduccionVentaAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataLider data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                SplineSeries<ProduccionVentaAgnoDataLider, String>(
                  name: 'Astromelias',
                  dataSource: _getProduccionVentaDataAgno('Astromelias'),
                  xValueMapper: (ProduccionVentaAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataLider data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                SplineSeries<ProduccionVentaAgnoDataLider, String>(
                  name: 'Miel',
                  dataSource: _getProduccionVentaDataAgno('Miel'),
                  xValueMapper: (ProduccionVentaAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataLider data, _) =>
                      data.cantidad,
                  color: Colors.purple,
                ),
                SplineSeries<ProduccionVentaAgnoDataLider, String>(
                  name: 'Leche de cabra',
                  dataSource: _getProduccionVentaDataAgno('Leche de cabra'),
                  xValueMapper: (ProduccionVentaAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataLider data, _) =>
                      data.cantidad,
                  color: Colors.brown,
                ),
                SplineSeries<ProduccionVentaAgnoDataLider, String>(
                  name: 'Pan',
                  dataSource: _getProduccionVentaDataAgno('Pan'),
                  xValueMapper: (ProduccionVentaAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionVentaAgnoDataLider data, _) =>
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

  List<ProduccionVentaAgnoDataLider> _getProduccionVentaDataAgno(String producto) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Huevos': [
        ProduccionVentaAgnoDataLider('2022', 500),
        ProduccionVentaAgnoDataLider('2023', 550),
        ProduccionVentaAgnoDataLider('2024', 600),
      ],
      'Leche': [
        ProduccionVentaAgnoDataLider('2022', 400),
        ProduccionVentaAgnoDataLider('2023', 420),
        ProduccionVentaAgnoDataLider('2024', 450),
      ],
      'Queso': [
        ProduccionVentaAgnoDataLider('2022', 700),
        ProduccionVentaAgnoDataLider('2023', 750),
        ProduccionVentaAgnoDataLider('2024', 800),
      ],
      'Astromelias': [
        ProduccionVentaAgnoDataLider('2022', 300),
        ProduccionVentaAgnoDataLider('2023', 320),
        ProduccionVentaAgnoDataLider('2024', 350),
      ],
      'Miel': [
        ProduccionVentaAgnoDataLider('2022', 600),
        ProduccionVentaAgnoDataLider('2023', 620),
        ProduccionVentaAgnoDataLider('2024', 650),
      ],
      'Leche de cabra': [
        ProduccionVentaAgnoDataLider('2022', 800),
        ProduccionVentaAgnoDataLider('2023', 850),
        ProduccionVentaAgnoDataLider('2024', 900),
      ],
      'Pan': [
        ProduccionVentaAgnoDataLider('2022', 200),
        ProduccionVentaAgnoDataLider('2023', 220),
        ProduccionVentaAgnoDataLider('2024', 250),
      ],
    };

    return data[producto] ?? [];
  }
}

class ProduccionVentaAgnoDataLider {
  ProduccionVentaAgnoDataLider(this.agno, this.cantidad);

  final String agno;
  final double cantidad;
}
