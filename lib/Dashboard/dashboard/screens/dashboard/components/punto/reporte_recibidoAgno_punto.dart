// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteRecibidoAgnoPunto extends StatelessWidget {
  const ReporteRecibidoAgnoPunto({
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
                FastLineSeries<ProduccionAgnoDataPunto, String>(
                  name: 'Cárnicos',
                  dataSource: _getProduccionDataAgno('Cárnicos'),
                  xValueMapper: (ProduccionAgnoDataPunto data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                FastLineSeries<ProduccionAgnoDataPunto, String>(
                  name: 'Lácteos',
                  dataSource: _getProduccionDataAgno('Lácteos'),
                  xValueMapper: (ProduccionAgnoDataPunto data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                FastLineSeries<ProduccionAgnoDataPunto, String>(
                  name: 'Apicultura',
                  dataSource: _getProduccionDataAgno('Apicultura'),
                  xValueMapper: (ProduccionAgnoDataPunto data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                FastLineSeries<ProduccionAgnoDataPunto, String>(
                  name: 'Porcicultura',
                  dataSource: _getProduccionDataAgno('Porcicultura'),
                  xValueMapper: (ProduccionAgnoDataPunto data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                FastLineSeries<ProduccionAgnoDataPunto, String>(
                  name: 'Hortalizas',
                  dataSource: _getProduccionDataAgno('Hortalizas'),
                  xValueMapper: (ProduccionAgnoDataPunto data, _) => data.agno,
                  yValueMapper: (ProduccionAgnoDataPunto data, _) =>
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

  List<ProduccionAgnoDataPunto> _getProduccionDataAgno(String tipoProduccion) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Cárnicos': [
        ProduccionAgnoDataPunto('2022', 30),
        ProduccionAgnoDataPunto('2023', 28),
        ProduccionAgnoDataPunto('2024', 34),
      ],
      'Lácteos': [
        ProduccionAgnoDataPunto('2022', 20),
        ProduccionAgnoDataPunto('2023', 24),
        ProduccionAgnoDataPunto('2024', 22),
      ],
      'Apicultura': [
        ProduccionAgnoDataPunto('2022', 10),
        ProduccionAgnoDataPunto('2023', 12),
        ProduccionAgnoDataPunto('2024', 14),
      ],
      'Porcicultura': [
        ProduccionAgnoDataPunto('2022', 15),
        ProduccionAgnoDataPunto('2023', 18),
        ProduccionAgnoDataPunto('2024', 20),
      ],
      'Hortalizas': [
        ProduccionAgnoDataPunto('2022', 25),
        ProduccionAgnoDataPunto('2023', 27),
        ProduccionAgnoDataPunto('2024', 29),
      ],
    };

    return data[tipoProduccion] ?? [];
  }
}

class ProduccionAgnoDataPunto {
  ProduccionAgnoDataPunto(this.agno, this.cantidad);

  final String agno;
  final double cantidad;
}
