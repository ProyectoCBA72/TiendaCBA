// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteDevolucionesPuntoMesLider extends StatelessWidget {
  const ReporteDevolucionesPuntoMesLider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            "Devoluciones por mes",
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
                title: AxisTitle(text: 'Devoluciones (COP)'),
              ),
              series: <CartesianSeries>[
                SplineAreaSeries<DevolucionesMesDataLider, String>(
                  name: 'Portería CBA',
                  dataSource: _getDevolucionesDataMes('Portería CBA'),
                  xValueMapper: (DevolucionesMesDataLider data, _) => data.mes,
                  yValueMapper: (DevolucionesMesDataLider data, _) => data.devoluciones,
                  color: Colors.blue.withOpacity(0.5),
                  borderColor: Colors.blue,
                  borderWidth: 2,
                ),
                SplineAreaSeries<DevolucionesMesDataLider, String>(
                  name: 'Coliseo CBA',
                  dataSource: _getDevolucionesDataMes('Coliseo CBA'),
                  xValueMapper: (DevolucionesMesDataLider data, _) => data.mes,
                  yValueMapper: (DevolucionesMesDataLider data, _) => data.devoluciones,
                  color: Colors.green.withOpacity(0.5),
                  borderColor: Colors.green,
                  borderWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<DevolucionesMesDataLider> _getDevolucionesDataMes(String puntoVenta) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Portería CBA': [
        DevolucionesMesDataLider('Enero', 100000),
        DevolucionesMesDataLider('Febrero', 120000),
        DevolucionesMesDataLider('Marzo', 140000),
        DevolucionesMesDataLider('Abril', 160000),
        DevolucionesMesDataLider('Mayo', 180000),
      ],
      'Coliseo CBA': [
        DevolucionesMesDataLider('Enero', 90000),
        DevolucionesMesDataLider('Febrero', 100000),
        DevolucionesMesDataLider('Marzo', 110000),
        DevolucionesMesDataLider('Abril', 120000),
        DevolucionesMesDataLider('Mayo', 130000),
      ],
    };

    return data[puntoVenta] ?? [];
  }
}

class DevolucionesMesDataLider {
  DevolucionesMesDataLider(this.mes, this.devoluciones);

  final String mes;
  final double devoluciones;
}










