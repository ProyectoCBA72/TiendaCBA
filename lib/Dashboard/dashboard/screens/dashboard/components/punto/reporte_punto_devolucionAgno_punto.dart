// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteDevolucionesPuntoAgnoPunto extends StatelessWidget {
  const ReporteDevolucionesPuntoAgnoPunto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Devoluciones por año",
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
                interval: 1,
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Devoluciones (COP)'),
              ),
              series: <CartesianSeries>[
                SplineAreaSeries<DevolucionesAgnoDataPunto, String>(
                  name: 'Portería CBA',
                  dataSource: _getDevolucionesDataAgno('Portería CBA'),
                  xValueMapper: (DevolucionesAgnoDataPunto data, _) =>
                      data.agno,
                  yValueMapper: (DevolucionesAgnoDataPunto data, _) =>
                      data.devoluciones,
                  color: Colors.blue.withOpacity(0.5),
                  borderColor: Colors.blue,
                  borderWidth: 2,
                ),
                SplineAreaSeries<DevolucionesAgnoDataPunto, String>(
                  name: 'Coliseo CBA',
                  dataSource: _getDevolucionesDataAgno('Coliseo CBA'),
                  xValueMapper: (DevolucionesAgnoDataPunto data, _) =>
                      data.agno,
                  yValueMapper: (DevolucionesAgnoDataPunto data, _) =>
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

  List<DevolucionesAgnoDataPunto> _getDevolucionesDataAgno(String puntoVenta) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Portería CBA': [
        DevolucionesAgnoDataPunto('2022', 100000),
        DevolucionesAgnoDataPunto('2023', 120000),
        DevolucionesAgnoDataPunto('2024', 140000),
      ],
      'Coliseo CBA': [
        DevolucionesAgnoDataPunto('2022', 90000),
        DevolucionesAgnoDataPunto('2023', 100000),
        DevolucionesAgnoDataPunto('2024', 110000),
      ],
    };

    return data[puntoVenta] ?? [];
  }
}

class DevolucionesAgnoDataPunto {
  DevolucionesAgnoDataPunto(this.agno, this.devoluciones);

  final String agno;
  final double devoluciones;
}
