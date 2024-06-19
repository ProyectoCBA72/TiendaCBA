// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReportePuntoVentasAgnoLider extends StatelessWidget {
  const ReportePuntoVentasAgnoLider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Balance de ventas por año",
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
                title: AxisTitle(text: 'Ventas (COP)'),
              ),
              series: <CartesianSeries>[
                SplineAreaSeries<BalanceVentasAgnoDataLider, String>(
                  name: 'Portería CBA',
                  dataSource: _getBalanceVentasDataAgno('Portería CBA'),
                  xValueMapper: (BalanceVentasAgnoDataLider data, _) =>
                      data.agno,
                  yValueMapper: (BalanceVentasAgnoDataLider data, _) =>
                      data.ventas,
                  color: Colors.blue.withOpacity(0.5),
                  borderColor: Colors.blue,
                  borderWidth: 2,
                ),
                SplineAreaSeries<BalanceVentasAgnoDataLider, String>(
                  name: 'Coliseo CBA',
                  dataSource: _getBalanceVentasDataAgno('Coliseo CBA'),
                  xValueMapper: (BalanceVentasAgnoDataLider data, _) =>
                      data.agno,
                  yValueMapper: (BalanceVentasAgnoDataLider data, _) =>
                      data.ventas,
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

  List<BalanceVentasAgnoDataLider> _getBalanceVentasDataAgno(
      String puntoVenta) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Portería CBA': [
        BalanceVentasAgnoDataLider('2022', 500000),
        BalanceVentasAgnoDataLider('2023', 550000),
        BalanceVentasAgnoDataLider('2024', 600000),
      ],
      'Coliseo CBA': [
        BalanceVentasAgnoDataLider('2022', 400000),
        BalanceVentasAgnoDataLider('2023', 420000),
        BalanceVentasAgnoDataLider('2024', 450000),
      ],
    };

    return data[puntoVenta] ?? [];
  }
}

class BalanceVentasAgnoDataLider {
  BalanceVentasAgnoDataLider(this.agno, this.ventas);

  final String agno;
  final double ventas;
}
