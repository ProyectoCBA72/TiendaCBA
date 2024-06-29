// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteDevolucionesPuntoMesPunto extends StatelessWidget {
  const ReporteDevolucionesPuntoMesPunto({
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
                SplineAreaSeries<DevolucionesMesDataPunto, String>(
                  name: 'Portería CBA',
                  dataSource: _getDevolucionesDataMes('Portería CBA'),
                  xValueMapper: (DevolucionesMesDataPunto data, _) => data.mes,
                  yValueMapper: (DevolucionesMesDataPunto data, _) =>
                      data.devoluciones,
                  color: Colors.blue.withOpacity(0.5),
                  borderColor: Colors.blue,
                  borderWidth: 2,
                ),
                SplineAreaSeries<DevolucionesMesDataPunto, String>(
                  name: 'Coliseo CBA',
                  dataSource: _getDevolucionesDataMes('Coliseo CBA'),
                  xValueMapper: (DevolucionesMesDataPunto data, _) => data.mes,
                  yValueMapper: (DevolucionesMesDataPunto data, _) =>
                      data.devoluciones,
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

  List<DevolucionesMesDataPunto> _getDevolucionesDataMes(String puntoVenta) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Portería CBA': [
        DevolucionesMesDataPunto('Enero', 100000),
        DevolucionesMesDataPunto('Febrero', 120000),
        DevolucionesMesDataPunto('Marzo', 140000),
        DevolucionesMesDataPunto('Abril', 160000),
        DevolucionesMesDataPunto('Mayo', 180000),
      ],
      'Coliseo CBA': [
        DevolucionesMesDataPunto('Enero', 90000),
        DevolucionesMesDataPunto('Febrero', 100000),
        DevolucionesMesDataPunto('Marzo', 110000),
        DevolucionesMesDataPunto('Abril', 120000),
        DevolucionesMesDataPunto('Mayo', 130000),
      ],
    };

    return data[puntoVenta] ?? [];
  }
}

class DevolucionesMesDataPunto {
  DevolucionesMesDataPunto(this.mes, this.devoluciones);

  final String mes;
  final double devoluciones;
}
