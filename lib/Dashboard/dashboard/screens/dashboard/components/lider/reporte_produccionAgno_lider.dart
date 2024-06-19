// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteProduccionAgnoLider extends StatelessWidget {
  const ReporteProduccionAgnoLider({
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
                StepLineSeries<ProduccionAgnoDataLider, String>(
                  name: 'Cárnicos',
                  dataSource: _getProduccionDataAgno('Cárnicos'),
                  xValueMapper: (ProduccionAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataLider data, _) => data.cantidad,
                  color: Colors.red,
                ),
                StepLineSeries<ProduccionAgnoDataLider, String>(
                  name: 'Lácteos',
                  dataSource: _getProduccionDataAgno('Lácteos'),
                  xValueMapper: (ProduccionAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataLider data, _) => data.cantidad,
                  color: Colors.blue,
                ),
                StepLineSeries<ProduccionAgnoDataLider, String>(
                  name: 'Apicultura',
                  dataSource: _getProduccionDataAgno('Apicultura'),
                  xValueMapper: (ProduccionAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataLider data, _) => data.cantidad,
                  color: Colors.green,
                ),
                StepLineSeries<ProduccionAgnoDataLider, String>(
                  name: 'Porcicultura',
                  dataSource: _getProduccionDataAgno('Porcicultura'),
                  xValueMapper: (ProduccionAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataLider data, _) => data.cantidad,
                  color: Colors.orange,
                ),
                StepLineSeries<ProduccionAgnoDataLider, String>(
                  name: 'Hortalizas',
                  dataSource: _getProduccionDataAgno('Hortalizas'),
                  xValueMapper: (ProduccionAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataLider data, _) => data.cantidad,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<ProduccionAgnoDataLider> _getProduccionDataAgno(String tipoProduccion) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Cárnicos': [
        ProduccionAgnoDataLider('Enero', 30),
        ProduccionAgnoDataLider('Febrero', 28),
        ProduccionAgnoDataLider('Marzo', 34),
      ],
      'Lácteos': [
        ProduccionAgnoDataLider('Enero', 20),
        ProduccionAgnoDataLider('Febrero', 24),
        ProduccionAgnoDataLider('Marzo', 22),
      ],
      'Apicultura': [
        ProduccionAgnoDataLider('Enero', 10),
        ProduccionAgnoDataLider('Febrero', 12),
        ProduccionAgnoDataLider('Marzo', 14),
      ],
      'Porcicultura': [
        ProduccionAgnoDataLider('Enero', 15),
        ProduccionAgnoDataLider('Febrero', 18),
        ProduccionAgnoDataLider('Marzo', 20),
      ],
      'Hortalizas': [
        ProduccionAgnoDataLider('Enero', 25),
        ProduccionAgnoDataLider('Febrero', 27),
        ProduccionAgnoDataLider('Marzo', 29),
      ],
    };

    return data[tipoProduccion] ?? [];
  }
}

class ProduccionAgnoDataLider {
  ProduccionAgnoDataLider(this.agno, this.cantidad);

  final String agno;
  final double cantidad;
}
