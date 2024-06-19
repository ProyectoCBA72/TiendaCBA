// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteRecibidoMesPunto extends StatelessWidget {
  const ReporteRecibidoMesPunto({
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
              legend: Legend(isVisible: Responsive.isMobile(context) ? false : true),
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: 'Meses'),
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Cantidad de Producciones'),
              ),
              series: <CartesianSeries>[
                FastLineSeries<ProduccionMesDataPunto, String>(
                  name: 'Cárnicos',
                  dataSource: _getProduccionDataMes('Cárnicos'),
                  xValueMapper: (ProduccionMesDataPunto data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.red,
                ),
                FastLineSeries<ProduccionMesDataPunto, String>(
                  name: 'Lácteos',
                  dataSource: _getProduccionDataMes('Lácteos'),
                  xValueMapper: (ProduccionMesDataPunto data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.blue,
                ),
                FastLineSeries<ProduccionMesDataPunto, String>(
                  name: 'Apicultura',
                  dataSource: _getProduccionDataMes('Apicultura'),
                  xValueMapper: (ProduccionMesDataPunto data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.green,
                ),
                FastLineSeries<ProduccionMesDataPunto, String>(
                  name: 'Porcicultura',
                  dataSource: _getProduccionDataMes('Porcicultura'),
                  xValueMapper: (ProduccionMesDataPunto data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataPunto data, _) =>
                      data.cantidad,
                  color: Colors.orange,
                ),
                FastLineSeries<ProduccionMesDataPunto, String>(
                  name: 'Hortalizas',
                  dataSource: _getProduccionDataMes('Hortalizas'),
                  xValueMapper: (ProduccionMesDataPunto data, _) => data.mes,
                  yValueMapper: (ProduccionMesDataPunto data, _) =>
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

  List<ProduccionMesDataPunto> _getProduccionDataMes(String tipoProduccion) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Cárnicos': [
        ProduccionMesDataPunto('Enero', 30),
        ProduccionMesDataPunto('Febrero', 28),
        ProduccionMesDataPunto('Marzo', 34),
        ProduccionMesDataPunto('Abril', 32),
        ProduccionMesDataPunto('Mayo', 40),
      ],
      'Lácteos': [
        ProduccionMesDataPunto('Enero', 20),
        ProduccionMesDataPunto('Febrero', 24),
        ProduccionMesDataPunto('Marzo', 22),
        ProduccionMesDataPunto('Abril', 26),
        ProduccionMesDataPunto('Mayo', 30),
      ],
      'Apicultura': [
        ProduccionMesDataPunto('Enero', 10),
        ProduccionMesDataPunto('Febrero', 12),
        ProduccionMesDataPunto('Marzo', 14),
        ProduccionMesDataPunto('Abril', 15),
        ProduccionMesDataPunto('Mayo', 18),
      ],
      'Porcicultura': [
        ProduccionMesDataPunto('Enero', 15),
        ProduccionMesDataPunto('Febrero', 18),
        ProduccionMesDataPunto('Marzo', 20),
        ProduccionMesDataPunto('Abril', 22),
        ProduccionMesDataPunto('Mayo', 25),
      ],
      'Hortalizas': [
        ProduccionMesDataPunto('Enero', 25),
        ProduccionMesDataPunto('Febrero', 27),
        ProduccionMesDataPunto('Marzo', 29),
        ProduccionMesDataPunto('Abril', 30),
        ProduccionMesDataPunto('Mayo', 35),
      ],
    };

    return data[tipoProduccion] ?? [];
  }
}

class ProduccionMesDataPunto {
  ProduccionMesDataPunto(this.mes, this.cantidad);

  final String mes;
  final double cantidad;
}
