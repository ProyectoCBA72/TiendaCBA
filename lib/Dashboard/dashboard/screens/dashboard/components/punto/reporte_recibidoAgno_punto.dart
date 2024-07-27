// ignore_for_file: file_names, unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/inventarioModel.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ReporteRecibidoAgnoPunto extends StatelessWidget {
  final UsuarioModel usuario;
  const ReporteRecibidoAgnoPunto({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del reporte
        Text(
          "Producciones recibidas por año",
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
              future: Future.wait([getProducciones(), getInventario()]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                // Mostrar indicador de carga mientras los datos se cargan
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

                  // Filtrar y agrupar los datos por año y unidad de producción
                  Map<String, Map<String, double>> data =
                      _processData(producciones, inventarios, usuario);

                  // Crear el gráfico con los datos procesados
                  return SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: const Legend(isVisible: true),
                    primaryXAxis: const CategoryAxis(
                      title: AxisTitle(text: 'Año'),
                    ),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Cantidad de Producciones'),
                    ),
                    series: _buildSeries(data),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Función para procesar y agrupar los datos por año y unidad de producción
  Map<String, Map<String, double>> _processData(
      List<ProduccionModel> producciones,
      List<InventarioModel> inventarios,
      UsuarioModel usuario) {
    Map<String, Map<String, double>> data = {};

    // Obtener el año actual
    final currentYear = DateTime.now().year;
    // Definir los años de interés (últimos tres años incluyendo el actual)
    final pastYears = [currentYear - 2, currentYear - 1, currentYear];

    // Recorrer todos los inventarios
    for (var inventario in inventarios) {
      // Convertir la fecha del inventario a un objeto DateTime
      final inventarioDate = DateTime.parse(inventario.fecha);
      // Obtener el año del inventario
      final inventarioYear = inventarioDate.year;

      // Verificar si el año del inventario está dentro de los años de interés
      if (pastYears.contains(inventarioYear)) {
        // Encontrar la producción correspondiente al inventario
        final produccion = producciones.firstWhere((prod) =>
            prod.id == inventario.produccion &&
            inventario.bodega.puntoVenta.id == usuario.puntoVenta &&
            prod.estado == "RECIBIDO");
        if (produccion != null) {
          // Obtener el nombre de la unidad de producción
          final unidadProduccion = produccion.unidadProduccion.nombre;

          // Inicializar la entrada en el mapa si no existe
          if (!data.containsKey(unidadProduccion)) {
            data[unidadProduccion] = {
              for (var year in pastYears) year.toString(): 0
            };
          }

          // Incrementar el contador de producciones para el año correspondiente
          data[unidadProduccion]![inventarioYear.toString()] =
              (data[unidadProduccion]![inventarioYear.toString()] ?? 0) + 1;
        }
      }
    }

    return data;
  }

  // Función para construir las series del gráfico a partir de los datos procesados
  List<FastLineSeries<ProduccionAgnoDataPunto, String>> _buildSeries(
      Map<String, Map<String, double>> data) {
    List<FastLineSeries<ProduccionAgnoDataPunto, String>> series = [];

    // Recorrer los datos agrupados por unidad de producción y año
    data.forEach((unidadProduccion, yearlyData) {
      series.add(
        FastLineSeries<ProduccionAgnoDataPunto, String>(
          name: unidadProduccion,
          // Convertir los datos anuales en una lista de objetos ProduccionAgnoDataPunto
          dataSource: yearlyData.entries
              .map((entry) => ProduccionAgnoDataPunto(entry.key, entry.value))
              .toList(),
          xValueMapper: (ProduccionAgnoDataPunto data, _) => data.agno,
          yValueMapper: (ProduccionAgnoDataPunto data, _) => data.cantidad,
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

// Clase para representar los datos del gráfico, con el año y la cantidad de producciones
class ProduccionAgnoDataPunto {
  ProduccionAgnoDataPunto(this.agno, this.cantidad);

  final String agno;
  final double cantidad;
}
