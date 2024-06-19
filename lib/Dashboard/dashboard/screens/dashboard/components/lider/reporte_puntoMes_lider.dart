// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReportePuntoVentasMesLider extends StatelessWidget {
  const ReportePuntoVentasMesLider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Balance de ventas por mes",
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
                title: AxisTitle(text: 'Ventas (COP)'),
              ),
              series: <CartesianSeries>[
                SplineAreaSeries<BalanceVentasDataMesLider, String>(
                  name: 'Portería CBA',
                  dataSource: _getBalanceVentasDataMes('Portería CBA'),
                  xValueMapper: (BalanceVentasDataMesLider data, _) => data.mes,
                  yValueMapper: (BalanceVentasDataMesLider data, _) =>
                      data.ventas,
                  color: Colors.blue.withOpacity(0.5),
                  borderColor: Colors.blue,
                  borderWidth: 2,
                ),
                SplineAreaSeries<BalanceVentasDataMesLider, String>(
                  name: 'Coliseo CBA',
                  dataSource: _getBalanceVentasDataMes('Coliseo CBA'),
                  xValueMapper: (BalanceVentasDataMesLider data, _) => data.mes,
                  yValueMapper: (BalanceVentasDataMesLider data, _) =>
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

  List<BalanceVentasDataMesLider> _getBalanceVentasDataMes(String puntoVenta) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Portería CBA': [
        BalanceVentasDataMesLider('Enero', 500000),
        BalanceVentasDataMesLider('Febrero', 550000),
        BalanceVentasDataMesLider('Marzo', 600000),
        BalanceVentasDataMesLider('Abril', 650000),
        BalanceVentasDataMesLider('Mayo', 700000),
      ],
      'Coliseo CBA': [
        BalanceVentasDataMesLider('Enero', 400000),
        BalanceVentasDataMesLider('Febrero', 420000),
        BalanceVentasDataMesLider('Marzo', 450000),
        BalanceVentasDataMesLider('Abril', 470000),
        BalanceVentasDataMesLider('Mayo', 500000),
      ],
    };

    return data[puntoVenta] ?? [];
  }
}

class BalanceVentasDataMesLider {
  BalanceVentasDataMesLider(this.mes, this.ventas);

  final String mes;
  final double ventas;
}
