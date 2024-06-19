// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReporteDevolucionesPuntoAgnoLider extends StatelessWidget {
  const ReporteDevolucionesPuntoAgnoLider({
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
                SplineAreaSeries<DevolucionesAgnoDataLider, String>(
                  name: 'Portería CBA',
                  dataSource: _getDevolucionesDataAgno('Portería CBA'),
                  xValueMapper: (DevolucionesAgnoDataLider data, _) => data.agno,
                  yValueMapper: (DevolucionesAgnoDataLider data, _) => data.devoluciones,
                  color: Colors.blue.withOpacity(0.5),
                  borderColor: Colors.blue,
                  borderWidth: 2,
                ),
                SplineAreaSeries<DevolucionesAgnoDataLider, String>(
                  name: 'Coliseo CBA',
                  dataSource: _getDevolucionesDataAgno('Coliseo CBA'),
                  xValueMapper: (DevolucionesAgnoDataLider data, _) => data.agno,
                  yValueMapper: (DevolucionesAgnoDataLider data, _) => data.devoluciones,
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

  List<DevolucionesAgnoDataLider> _getDevolucionesDataAgno(String puntoVenta) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Portería CBA': [
        DevolucionesAgnoDataLider('2022', 100000),
        DevolucionesAgnoDataLider('2023', 120000),
        DevolucionesAgnoDataLider('2024', 140000),
      ],
      'Coliseo CBA': [
        DevolucionesAgnoDataLider('2022', 90000),
        DevolucionesAgnoDataLider('2023', 100000),
        DevolucionesAgnoDataLider('2024', 110000),
      ],
    };

    return data[puntoVenta] ?? [];
  }
}

class DevolucionesAgnoDataLider {
  DevolucionesAgnoDataLider(this.agno, this.devoluciones);

  final String agno;
  final double devoluciones;
}










