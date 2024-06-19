// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteRecibidoAgnoLider extends StatelessWidget {
  const ReporteRecibidoAgnoLider({
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
              legend: Legend(
                  isVisible: Responsive.isMobile(context) ? false : true),
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: 'Año'),
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Cantidad de Producciones'),
              ),
              series: <CartesianSeries>[
                FastLineSeries<ProduccionAgnoDataLider, String>(
                  name: 'Cárnicos',
                  dataSource: _getProduccionDataAgno('Cárnicos'),
                  xValueMapper: (ProduccionAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataLider data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                FastLineSeries<ProduccionAgnoDataLider, String>(
                  name: 'Lácteos',
                  dataSource: _getProduccionDataAgno('Lácteos'),
                  xValueMapper: (ProduccionAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataLider data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                FastLineSeries<ProduccionAgnoDataLider, String>(
                  name: 'Apicultura',
                  dataSource: _getProduccionDataAgno('Apicultura'),
                  xValueMapper: (ProduccionAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataLider data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                FastLineSeries<ProduccionAgnoDataLider, String>(
                  name: 'Porcicultura',
                  dataSource: _getProduccionDataAgno('Porcicultura'),
                  xValueMapper: (ProduccionAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataLider data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                FastLineSeries<ProduccionAgnoDataLider, String>(
                  name: 'Hortalizas',
                  dataSource: _getProduccionDataAgno('Hortalizas'),
                  xValueMapper: (ProduccionAgnoDataLider data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataLider data, _) =>
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

  List<ProduccionAgnoDataLider> _getProduccionDataAgno(String tipoProduccion) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Cárnicos': [
        ProduccionAgnoDataLider('2022', 30),
        ProduccionAgnoDataLider('2023', 28),
        ProduccionAgnoDataLider('2024', 34),
      ],
      'Lácteos': [
        ProduccionAgnoDataLider('2022', 20),
        ProduccionAgnoDataLider('2023', 24),
        ProduccionAgnoDataLider('2024', 22),
      ],
      'Apicultura': [
        ProduccionAgnoDataLider('2022', 10),
        ProduccionAgnoDataLider('2023', 12),
        ProduccionAgnoDataLider('2024', 14),
      ],
      'Porcicultura': [
        ProduccionAgnoDataLider('2022', 15),
        ProduccionAgnoDataLider('2023', 18),
        ProduccionAgnoDataLider('2024', 20),
      ],
      'Hortalizas': [
        ProduccionAgnoDataLider('2022', 25),
        ProduccionAgnoDataLider('2023', 27),
        ProduccionAgnoDataLider('2024', 29),
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
