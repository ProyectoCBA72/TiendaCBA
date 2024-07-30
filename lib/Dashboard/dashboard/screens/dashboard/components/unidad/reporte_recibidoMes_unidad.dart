// ignore_for_file: file_names, unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/inventarioModel.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ReporteRecibidoMesUnidad extends StatelessWidget {
  final UsuarioModel usuario;
  const ReporteRecibidoMesUnidad({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del reporte
        Text(
          "Producciones recibidas por mes",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontFamily: 'Calibri-Bold'),
        ),
        const SizedBox(height: defaultPadding),
        // Contenedor principal para el gráfico
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            // Usando FutureBuilder para manejar la carga de datos asíncrona
            child: FutureBuilder(
                // Esperar a que se completen las futuras de getProducciones y getInventario
                future: Future.wait([getProducciones(), getInventario()]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  // Mostrar indicador de carga mientras los datos se están cargando
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                    // Mostrar mensaje de error si ocurre algún problema al cargar los datos
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al cargar datos: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    // Cuando los datos están disponibles, procesarlos
                    List<ProduccionModel> producciones = snapshot.data![0];
                    List<InventarioModel> inventarios = snapshot.data![1];

                    // Filtrar y agrupar los datos por mes y unidad de producción
                    Map<String, Map<String, double>> data =
                        _processData(producciones, inventarios, usuario);

                    // Crear el gráfico con los datos procesados
                    return SfCartesianChart(
                      tooltipBehavior: TooltipBehavior(enable: true),
                      legend: const Legend(isVisible: true),
                      primaryXAxis: const CategoryAxis(
                        title: AxisTitle(text: 'Meses'),
                      ),
                      primaryYAxis: const NumericAxis(
                        title: AxisTitle(text: 'Cantidad de Producciones'),
                      ),
                      series: _buildSeries(data),
                    );
                  }
                }),
          ),
        ),
      ],
    );
  }

  // Función para procesar y agrupar los datos por mes y unidad de producción
  Map<String, Map<String, double>> _processData(
      List<ProduccionModel> producciones,
      List<InventarioModel> inventarios,
      UsuarioModel usuario) {
    Map<String, Map<String, double>> data = {};

    // Obtener la fecha actual
    final now = DateTime.now();
    // Obtener los últimos cuatro meses incluyendo el mes actual
    final pastMonths =
        List.generate(4, (i) => DateTime(now.year, now.month - i, 1))
            .map((date) => _getMonthName(date.month))
            .toList();

    // Recorrer todos los inventarios
    for (var inventario in inventarios) {
      // Convertir la fecha del inventario a un objeto DateTime
      final inventarioDate = DateTime.parse(inventario.fecha);
      // Obtener el mes del inventario en formato de texto
      final inventarioMonth = _getMonthName(inventarioDate.month);

      // Verificar si el mes del inventario está dentro de los últimos cuatro meses
      if (pastMonths.contains(inventarioMonth)) {
        // Encontrar la producción correspondiente al inventario
        var produccion = producciones.where((prod) =>
            prod.id == inventario.produccion &&
            prod.unidadProduccion.id == usuario.unidadProduccion &&
            prod.estado == "RECIBIDO");

        // Obtener el nombre de la unidad de producción
        final unidadProduccion =
            produccion.firstOrNull?.unidadProduccion.nombre;

        if (unidadProduccion != null) {
          // Inicializar la entrada en el mapa si no existe
          if (!data.containsKey(unidadProduccion)) {
            data[unidadProduccion] = {for (var month in pastMonths) month: 0};
          }

          // Incrementar el contador de producciones para el mes correspondiente
          data[unidadProduccion]![inventarioMonth] =
              (data[unidadProduccion]![inventarioMonth] ?? 0) + 1;
        }
      }
    }

    return data;
  }

  // Función para construir las series del gráfico a partir de los datos procesados
  List<FastLineSeries<ProduccionMesDataUnidad, String>> _buildSeries(
      Map<String, Map<String, double>> data) {
    List<FastLineSeries<ProduccionMesDataUnidad, String>> series = [];

    // Recorrer los datos agrupados por unidad de producción y mes
    data.forEach((unidadProduccion, monthlyData) {
      series.add(
        FastLineSeries<ProduccionMesDataUnidad, String>(
          name: unidadProduccion,
          // Convertir los datos mensuales en una lista de objetos ProduccionMesDataUnidad
          dataSource: monthlyData.entries
              .map((entry) => ProduccionMesDataUnidad(entry.key, entry.value))
              .toList(),
          xValueMapper: (ProduccionMesDataUnidad data, _) => data.mes,
          yValueMapper: (ProduccionMesDataUnidad data, _) => data.cantidad,
          color: _getColor(),
        ),
      );
    });

    return series;
  }
}

// Función para obtener el color de la serie (aleatorio)
Color _getColor() {
  final random = Random();
  final hue = random.nextDouble() * 360; // Generar tono aleatorio
  final saturation =
      random.nextDouble() * (0.5 - 0.2) + 0.2; // Saturation entre 0.2 y 0.5
  final value =
      random.nextDouble() * (0.9 - 0.5) + 0.5; // Value entre 0.5 y 0.9

  return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
}

// Función para obtener el nombre del mes basado en su número
String _getMonthName(int month) {
  switch (month) {
    case 1:
      return 'Enero';
    case 2:
      return 'Febrero';
    case 3:
      return 'Marzo';
    case 4:
      return 'Abril';
    case 5:
      return 'Mayo';
    case 6:
      return 'Junio';
    case 7:
      return 'Julio';
    case 8:
      return 'Agosto';
    case 9:
      return 'Septiembre';
    case 10:
      return 'Octubre';
    case 11:
      return 'Noviembre';
    case 12:
      return 'Diciembre';
    default:
      return '';
  }
}

// Clase para representar los datos del gráfico, con el mes y la cantidad de producciones
class ProduccionMesDataUnidad {
  ProduccionMesDataUnidad(this.mes, this.cantidad);

  final String mes;
  final double cantidad;
}
