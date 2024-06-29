// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteRecibidoMesLider extends StatelessWidget {
  const ReporteRecibidoMesLider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Producciones recibidas por mes",
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
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Cantidad de Producciones'),
              ),
              series: <CartesianSeries>[
                FastLineSeries<ProduccionMesDataLider, String>(
                  name: 'Cárnicos',
                  dataSource: _getProduccionDataMes('Cárnicos'),
                  xValueMapper: (ProduccionMesDataLider data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataLider data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                FastLineSeries<ProduccionMesDataLider, String>(
                  name: 'Lácteos',
                  dataSource: _getProduccionDataMes('Lácteos'),
                  xValueMapper: (ProduccionMesDataLider data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataLider data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                FastLineSeries<ProduccionMesDataLider, String>(
                  name: 'Apicultura',
                  dataSource: _getProduccionDataMes('Apicultura'),
                  xValueMapper: (ProduccionMesDataLider data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataLider data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                FastLineSeries<ProduccionMesDataLider, String>(
                  name: 'Porcicultura',
                  dataSource: _getProduccionDataMes('Porcicultura'),
                  xValueMapper: (ProduccionMesDataLider data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataLider data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                FastLineSeries<ProduccionMesDataLider, String>(
                  name: 'Hortalizas',
                  dataSource: _getProduccionDataMes('Hortalizas'),
                  xValueMapper: (ProduccionMesDataLider data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataLider data, _) =>
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

  List<ProduccionMesDataLider> _getProduccionDataMes(String tipoProduccion) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Cárnicos': [
        ProduccionMesDataLider('Enero', 30),
        ProduccionMesDataLider('Febrero', 28),
        ProduccionMesDataLider('Marzo', 34),
        ProduccionMesDataLider('Abril', 32),
        ProduccionMesDataLider('Mayo', 40),
      ],
      'Lácteos': [
        ProduccionMesDataLider('Enero', 20),
        ProduccionMesDataLider('Febrero', 24),
        ProduccionMesDataLider('Marzo', 22),
        ProduccionMesDataLider('Abril', 26),
        ProduccionMesDataLider('Mayo', 30),
      ],
      'Apicultura': [
        ProduccionMesDataLider('Enero', 10),
        ProduccionMesDataLider('Febrero', 12),
        ProduccionMesDataLider('Marzo', 14),
        ProduccionMesDataLider('Abril', 15),
        ProduccionMesDataLider('Mayo', 18),
      ],
      'Porcicultura': [
        ProduccionMesDataLider('Enero', 15),
        ProduccionMesDataLider('Febrero', 18),
        ProduccionMesDataLider('Marzo', 20),
        ProduccionMesDataLider('Abril', 22),
        ProduccionMesDataLider('Mayo', 25),
      ],
      'Hortalizas': [
        ProduccionMesDataLider('Enero', 25),
        ProduccionMesDataLider('Febrero', 27),
        ProduccionMesDataLider('Marzo', 29),
        ProduccionMesDataLider('Abril', 30),
        ProduccionMesDataLider('Mayo', 35),
      ],
    };

    return data[tipoProduccion] ?? [];
  }
}

class ProduccionMesDataLider {
  ProduccionMesDataLider(this.mes, this.cantidad);

  final String mes;
  final double cantidad;
}
