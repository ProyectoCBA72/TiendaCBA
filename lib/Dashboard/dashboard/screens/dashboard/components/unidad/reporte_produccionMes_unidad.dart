// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteProduccionMesUnidad extends StatelessWidget {
  const ReporteProduccionMesUnidad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Producciones despachadas por mes",
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
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Cantidad de Producciones'),
              ),
              series: <CartesianSeries>[
                StepLineSeries<ProduccionMesDataUnidad, String>(
                  name: 'Cárnicos',
                  dataSource: _getProduccionDataMes('Cárnicos'),
                  xValueMapper: (ProduccionMesDataUnidad data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                StepLineSeries<ProduccionMesDataUnidad, String>(
                  name: 'Lácteos',
                  dataSource: _getProduccionDataMes('Lácteos'),
                  xValueMapper: (ProduccionMesDataUnidad data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                StepLineSeries<ProduccionMesDataUnidad, String>(
                  name: 'Apicultura',
                  dataSource: _getProduccionDataMes('Apicultura'),
                  xValueMapper: (ProduccionMesDataUnidad data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                StepLineSeries<ProduccionMesDataUnidad, String>(
                  name: 'Porcicultura',
                  dataSource: _getProduccionDataMes('Porcicultura'),
                  xValueMapper: (ProduccionMesDataUnidad data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataUnidad data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                StepLineSeries<ProduccionMesDataUnidad, String>(
                  name: 'Hortalizas',
                  dataSource: _getProduccionDataMes('Hortalizas'),
                  xValueMapper: (ProduccionMesDataUnidad data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataUnidad data, _) =>
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

  List<ProduccionMesDataUnidad> _getProduccionDataMes(String tipoProduccion) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Cárnicos': [
        ProduccionMesDataUnidad('Enero', 30),
        ProduccionMesDataUnidad('Febrero', 28),
        ProduccionMesDataUnidad('Marzo', 34),
        ProduccionMesDataUnidad('Abril', 32),
        ProduccionMesDataUnidad('Mayo', 40),
      ],
      'Lácteos': [
        ProduccionMesDataUnidad('Enero', 20),
        ProduccionMesDataUnidad('Febrero', 24),
        ProduccionMesDataUnidad('Marzo', 22),
        ProduccionMesDataUnidad('Abril', 26),
        ProduccionMesDataUnidad('Mayo', 30),
      ],
      'Apicultura': [
        ProduccionMesDataUnidad('Enero', 10),
        ProduccionMesDataUnidad('Febrero', 12),
        ProduccionMesDataUnidad('Marzo', 14),
        ProduccionMesDataUnidad('Abril', 15),
        ProduccionMesDataUnidad('Mayo', 18),
      ],
      'Porcicultura': [
        ProduccionMesDataUnidad('Enero', 15),
        ProduccionMesDataUnidad('Febrero', 18),
        ProduccionMesDataUnidad('Marzo', 20),
        ProduccionMesDataUnidad('Abril', 22),
        ProduccionMesDataUnidad('Mayo', 25),
      ],
      'Hortalizas': [
        ProduccionMesDataUnidad('Enero', 25),
        ProduccionMesDataUnidad('Febrero', 27),
        ProduccionMesDataUnidad('Marzo', 29),
        ProduccionMesDataUnidad('Abril', 30),
        ProduccionMesDataUnidad('Mayo', 35),
      ],
    };

    return data[tipoProduccion] ?? [];
  }
}

class ProduccionMesDataUnidad {
  ProduccionMesDataUnidad(this.mes, this.cantidad);

  final String mes;
  final double cantidad;
}
