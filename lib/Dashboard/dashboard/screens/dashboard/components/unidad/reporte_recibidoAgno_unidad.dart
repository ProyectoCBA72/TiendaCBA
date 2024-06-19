// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteRecibidoAgnoUnidad extends StatelessWidget {
  const ReporteRecibidoAgnoUnidad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Producciones recibidas por año",
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
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Cantidad de Producciones'),
              ),
              series: <CartesianSeries>[
                FastLineSeries<ProduccionAgnoDataUnidad, String>(
                  name: 'Cárnicos',
                  dataSource: _getProduccionDataAgno('Cárnicos'),
                  xValueMapper: (ProduccionAgnoDataUnidad data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                FastLineSeries<ProduccionAgnoDataUnidad, String>(
                  name: 'Lácteos',
                  dataSource: _getProduccionDataAgno('Lácteos'),
                  xValueMapper: (ProduccionAgnoDataUnidad data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                FastLineSeries<ProduccionAgnoDataUnidad, String>(
                  name: 'Apicultura',
                  dataSource: _getProduccionDataAgno('Apicultura'),
                  xValueMapper: (ProduccionAgnoDataUnidad data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                FastLineSeries<ProduccionAgnoDataUnidad, String>(
                  name: 'Porcicultura',
                  dataSource: _getProduccionDataAgno('Porcicultura'),
                  xValueMapper: (ProduccionAgnoDataUnidad data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                FastLineSeries<ProduccionAgnoDataUnidad, String>(
                  name: 'Hortalizas',
                  dataSource: _getProduccionDataAgno('Hortalizas'),
                  xValueMapper: (ProduccionAgnoDataUnidad data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<ProduccionAgnoDataUnidad> _getProduccionDataAgno(String tipoProduccion) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Cárnicos': [
        ProduccionAgnoDataUnidad('2022', 30),
        ProduccionAgnoDataUnidad('2023', 28),
        ProduccionAgnoDataUnidad('2024', 34),
      ],
      'Lácteos': [
        ProduccionAgnoDataUnidad('2022', 20),
        ProduccionAgnoDataUnidad('2023', 24),
        ProduccionAgnoDataUnidad('2024', 22),
      ],
      'Apicultura': [
        ProduccionAgnoDataUnidad('2022', 10),
        ProduccionAgnoDataUnidad('2023', 12),
        ProduccionAgnoDataUnidad('2024', 14),
      ],
      'Porcicultura': [
        ProduccionAgnoDataUnidad('2022', 15),
        ProduccionAgnoDataUnidad('2023', 18),
        ProduccionAgnoDataUnidad('2024', 20),
      ],
      'Hortalizas': [
        ProduccionAgnoDataUnidad('2022', 25),
        ProduccionAgnoDataUnidad('2023', 27),
        ProduccionAgnoDataUnidad('2024', 29),
      ],
    };

    return data[tipoProduccion] ?? [];
  }
}

class ProduccionAgnoDataUnidad {
  ProduccionAgnoDataUnidad(this.agno, this.cantidad);

  final String agno;
  final double cantidad;
}
