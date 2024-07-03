// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tienda_app/Models/produccionModel.dart'; // Importa el modelo de producción
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ReporteProduccionMesUnidad extends StatelessWidget {
  final UsuarioModel usuario;
  const ReporteProduccionMesUnidad({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Producciones despachadas por mes",
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
            child: FutureBuilder(
              future:
                  getProducciones(), // Obtén los datos de producción usando el método getProducciones
              builder:
                  (context, AsyncSnapshot<List<ProduccionModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error al cargar datos: ${snapshot.error}'));
                } else {
                  // Construye el gráfico cuando los datos están disponibles
                  return SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: const Legend(
                        isVisible: true), // Muestra la leyenda si no es un dispositivo móvil
                    primaryXAxis: const CategoryAxis(
                        title: AxisTitle(text: 'Meses')), // Eje X para meses
                    primaryYAxis: const NumericAxis(
                        title: AxisTitle(
                            text:
                                'Cantidad de Producciones')), // Eje Y para cantidad de producciones
                    series: _buildSeries(snapshot.data!,
                        usuario), // Construye las series del gráfico con los datos obtenidos
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Función para construir las series del gráfico
  List<StepLineSeries<ProduccionMesDataUnidad, String>> _buildSeries(
      List<ProduccionModel> data, UsuarioModel usuario) {
    List<ProduccionModel> unidadesFiltradas = data
        .where((p) => p.unidadProduccion.id == usuario.unidadProduccion)
        .toList();

    // Obtiene el conjunto de nombres de unidades de producción únicos
    final unidadesProduccion =
        unidadesFiltradas.map((e) => e.unidadProduccion.nombre).toSet();

    // Mapea cada nombre de unidad de producción a una serie de gráfico StepLineSeries
    return unidadesProduccion.map((unidad) {
      return StepLineSeries<ProduccionMesDataUnidad, String>(
        name:
            unidad, // Nombre de la serie es el nombre de la unidad de producción
        dataSource: _getProduccionDataMes(unidad, data,
            usuario), // Obtiene los datos de producción por mes para la unidad específica
        xValueMapper: (ProduccionMesDataUnidad data, _) =>
            data.mes, // Mapea el nombre del mes en el eje X
        yValueMapper: (ProduccionMesDataUnidad data, _) =>
            data.cantidad, // Mapea la cantidad de producciones en el eje Y
        color: _getColor(), // Color de la serie
      );
    }).toList(); // Convierte el conjunto de series a una lista
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

  // Función para obtener los datos de producción por mes para una unidad de producción específica
  List<ProduccionMesDataUnidad> _getProduccionDataMes(String unidadProduccion,
      List<ProduccionModel> producciones, UsuarioModel usuario) {
    // Obtiene el mes actual y los últimos cuatro meses como fecha inicial para calcular el balance
    final now = DateTime.now();
    final lastFourMonths =
        List.generate(4, (index) => DateTime(now.year, now.month - index, 1));

    // Mapa para almacenar los datos de producción por mes
    final data = <String, double>{};
    for (var month in lastFourMonths) {
      // Filtra las producciones por unidad y mes, luego suma la cantidad despachada
      data[_getNombreMes(month)] = producciones
          .where((p) =>
              p.unidadProduccion.nombre ==
                  unidadProduccion && // Filtra por nombre de unidad de producción
              DateTime.parse(p.fechaDespacho).month ==
                  month.month && // Filtra por mes de despacho
              DateTime.parse(p.fechaDespacho).year ==
                  month.year && // Filtra por año de despacho

              p.estado == "ENVIADO") // Filtra el estado de la producción
          .fold(
              0,
              (prev, element) =>
                  prev +
                  element
                      .cantidad); // Suma la cantidad de producciones despachadas
    }

    // Convierte el mapa de datos en una lista de objetos ProduccionMesDataUnidad
    return data.entries
        .map((entry) => ProduccionMesDataUnidad(entry.key, entry.value))
        .toList();
  }
}

// Función para obtener el nombre del mes a partir de una fecha
String _getNombreMes(DateTime fecha) {
  switch (fecha.month) {
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

// Clase de modelo para almacenar los datos de producción por mes
class ProduccionMesDataUnidad {
  ProduccionMesDataUnidad(this.mes, this.cantidad);

  final String mes; // Nombre del mes
  final double cantidad; // Cantidad de producciones despachadas
}
