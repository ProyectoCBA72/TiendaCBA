// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteProductosMasVendidosMesLider extends StatelessWidget {
  const ReporteProductosMasVendidosMesLider({
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
                SplineSeries<ProduccionVentaDataMesLider, String>(
                  name: 'Huevos',
                  dataSource: _getProduccionVentaDataMes('Huevos'),
                  xValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                SplineSeries<ProduccionVentaDataMesLider, String>(
                  name: 'Leche',
                  dataSource: _getProduccionVentaDataMes('Leche'),
                  xValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                SplineSeries<ProduccionVentaDataMesLider, String>(
                  name: 'Queso',
                  dataSource: _getProduccionVentaDataMes('Queso'),
                  xValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                SplineSeries<ProduccionVentaDataMesLider, String>(
                  name: 'Astromelias',
                  dataSource: _getProduccionVentaDataMes('Astromelias'),
                  xValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                SplineSeries<ProduccionVentaDataMesLider, String>(
                  name: 'Miel',
                  dataSource: _getProduccionVentaDataMes('Miel'),
                  xValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.cantidad,
                  color: Colors.purple,
                ),
                SplineSeries<ProduccionVentaDataMesLider, String>(
                  name: 'Leche de cabra',
                  dataSource: _getProduccionVentaDataMes('Leche de cabra'),
                  xValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.cantidad,
                  color: Colors.brown,
                ),
                SplineSeries<ProduccionVentaDataMesLider, String>(
                  name: 'Pan',
                  dataSource: _getProduccionVentaDataMes('Pan'),
                  xValueMapper: (ProduccionVentaDataMesLider data, _) =>
                      data.mes,
                  yValueMapper: (ProduccionVentaDataMesLider data, _) =>
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

  List<ProduccionVentaDataMesLider> _getProduccionVentaDataMes(
      String producto) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Huevos': [
        ProduccionVentaDataMesLider('Enero', 500),
        ProduccionVentaDataMesLider('Febrero', 550),
        ProduccionVentaDataMesLider('Marzo', 600),
        ProduccionVentaDataMesLider('Abril', 650),
        ProduccionVentaDataMesLider('Mayo', 700),
      ],
      'Leche': [
        ProduccionVentaDataMesLider('Enero', 400),
        ProduccionVentaDataMesLider('Febrero', 420),
        ProduccionVentaDataMesLider('Marzo', 450),
        ProduccionVentaDataMesLider('Abril', 470),
        ProduccionVentaDataMesLider('Mayo', 500),
      ],
      'Queso': [
        ProduccionVentaDataMesLider('Enero', 700),
        ProduccionVentaDataMesLider('Febrero', 750),
        ProduccionVentaDataMesLider('Marzo', 800),
        ProduccionVentaDataMesLider('Abril', 850),
        ProduccionVentaDataMesLider('Mayo', 900),
      ],
      'Astromelias': [
        ProduccionVentaDataMesLider('Enero', 300),
        ProduccionVentaDataMesLider('Febrero', 320),
        ProduccionVentaDataMesLider('Marzo', 350),
        ProduccionVentaDataMesLider('Abril', 370),
        ProduccionVentaDataMesLider('Mayo', 400),
      ],
      'Miel': [
        ProduccionVentaDataMesLider('Enero', 600),
        ProduccionVentaDataMesLider('Febrero', 620),
        ProduccionVentaDataMesLider('Marzo', 650),
        ProduccionVentaDataMesLider('Abril', 670),
        ProduccionVentaDataMesLider('Mayo', 700),
      ],
      'Leche de cabra': [
        ProduccionVentaDataMesLider('Enero', 800),
        ProduccionVentaDataMesLider('Febrero', 850),
        ProduccionVentaDataMesLider('Marzo', 900),
        ProduccionVentaDataMesLider('Abril', 950),
        ProduccionVentaDataMesLider('Mayo', 1000),
      ],
      'Pan': [
        ProduccionVentaDataMesLider('Enero', 200),
        ProduccionVentaDataMesLider('Febrero', 220),
        ProduccionVentaDataMesLider('Marzo', 250),
        ProduccionVentaDataMesLider('Abril', 270),
        ProduccionVentaDataMesLider('Mayo', 300),
      ],
    };

    return data[producto] ?? [];
  }
}

class ProduccionVentaDataMesLider {
  ProduccionVentaDataMesLider(this.mes, this.cantidad);

  final String mes;
  final double cantidad;
}
