// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteProduccionAgnoUnidad extends StatelessWidget {
  const ReporteProduccionAgnoUnidad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Producciones despachadas por año",
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
                StepLineSeries<ProduccionAgnoDataUnidad, String>(
                  name: 'Cárnicos',
                  dataSource: _getProduccionDataAgno('Cárnicos'),
                  xValueMapper: (ProduccionAgnoDataUnidad data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                StepLineSeries<ProduccionAgnoDataUnidad, String>(
                  name: 'Lácteos',
                  dataSource: _getProduccionDataAgno('Lácteos'),
                  xValueMapper: (ProduccionAgnoDataUnidad data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                StepLineSeries<ProduccionAgnoDataUnidad, String>(
                  name: 'Apicultura',
                  dataSource: _getProduccionDataAgno('Apicultura'),
                  xValueMapper: (ProduccionAgnoDataUnidad data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                StepLineSeries<ProduccionAgnoDataUnidad, String>(
                  name: 'Porcicultura',
                  dataSource: _getProduccionDataAgno('Porcicultura'),
                  xValueMapper: (ProduccionAgnoDataUnidad data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                StepLineSeries<ProduccionAgnoDataUnidad, String>(
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
        ProduccionAgnoDataUnidad('Enero', 30),
        ProduccionAgnoDataUnidad('Febrero', 28),
        ProduccionAgnoDataUnidad('Marzo', 34),
      ],
      'Lácteos': [
        ProduccionAgnoDataUnidad('Enero', 20),
        ProduccionAgnoDataUnidad('Febrero', 24),
        ProduccionAgnoDataUnidad('Marzo', 22),
      ],
      'Apicultura': [
        ProduccionAgnoDataUnidad('Enero', 10),
        ProduccionAgnoDataUnidad('Febrero', 12),
        ProduccionAgnoDataUnidad('Marzo', 14),
      ],
      'Porcicultura': [
        ProduccionAgnoDataUnidad('Enero', 15),
        ProduccionAgnoDataUnidad('Febrero', 18),
        ProduccionAgnoDataUnidad('Marzo', 20),
      ],
      'Hortalizas': [
        ProduccionAgnoDataUnidad('Enero', 25),
        ProduccionAgnoDataUnidad('Febrero', 27),
        ProduccionAgnoDataUnidad('Marzo', 29),
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
