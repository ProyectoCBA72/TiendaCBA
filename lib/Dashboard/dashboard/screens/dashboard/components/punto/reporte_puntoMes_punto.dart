// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class ReportePuntoVentasMesPunto extends StatelessWidget {
  const ReportePuntoVentasMesPunto({
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
                SplineAreaSeries<BalanceVentasDataMesPunto, String>(
                  name: 'Portería CBA',
                  dataSource: _getBalanceVentasDataMes('Portería CBA'),
                  xValueMapper: (BalanceVentasDataMesPunto data, _) => data.mes,
                  yValueMapper: (BalanceVentasDataMesPunto data, _) =>
                      data.ventas,
                  color: Colors.blue.withOpacity(0.5),
                  borderColor: Colors.blue,
                  borderWidth: 2,
                ),
                SplineAreaSeries<BalanceVentasDataMesPunto, String>(
                  name: 'Coliseo CBA',
                  dataSource: _getBalanceVentasDataMes('Coliseo CBA'),
                  xValueMapper: (BalanceVentasDataMesPunto data, _) => data.mes,
                  yValueMapper: (BalanceVentasDataMesPunto data, _) =>
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

  List<BalanceVentasDataMesPunto> _getBalanceVentasDataMes(String puntoVenta) {
    // Aquí puedes definir tus datos. Este es un ejemplo de datos simulados.
    final data = {
      'Portería CBA': [
        BalanceVentasDataMesPunto('Enero', 500000),
        BalanceVentasDataMesPunto('Febrero', 550000),
        BalanceVentasDataMesPunto('Marzo', 600000),
        BalanceVentasDataMesPunto('Abril', 650000),
        BalanceVentasDataMesPunto('Mayo', 700000),
      ],
      'Coliseo CBA': [
        BalanceVentasDataMesPunto('Enero', 400000),
        BalanceVentasDataMesPunto('Febrero', 420000),
        BalanceVentasDataMesPunto('Marzo', 450000),
        BalanceVentasDataMesPunto('Abril', 470000),
        BalanceVentasDataMesPunto('Mayo', 500000),
      ],
    };

    return data[puntoVenta] ?? [];
  }
}

class BalanceVentasDataMesPunto {
  BalanceVentasDataMesPunto(this.mes, this.ventas);

  final String mes;
  final double ventas;
}
