// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Importación de Syncfusion Charts
import 'package:tienda_app/Models/produccionModel.dart'; // Importación del modelo de datos de producción
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart'; // Importación de constantes de diseño
import 'package:tienda_app/responsive.dart'; // Importación de utilidades para diseño responsivo

class ReporteProduccionAgnoLider extends StatelessWidget {
  final UsuarioModel usuario;
  const ReporteProduccionAgnoLider({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Producciones despachadas por año", // Título del reporte
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontFamily: 'Calibri-Bold'), // Estilo del título
        ),
        const SizedBox(
            height: defaultPadding), // Espacio entre el título y el gráfico
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future:
                  getProducciones(), // Llama a la función asincrónica para obtener las producciones
              builder:
                  (context, AsyncSnapshot<List<ProduccionModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(), // Muestra indicador de carga mientras se espera
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'Error al cargar datos: ${snapshot.error}'), // Muestra mensaje de error si falla la carga
                  );
                } else {
                  List<ProduccionModel> producciones = snapshot.data ??
                      []; // Obtiene la lista de producciones del snapshot

                  // Construye y retorna el gráfico de Syncfusion con los datos de producción
                  return SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(
                        enable: true), // Habilita tooltips en el gráfico
                    legend: Legend(
                        isVisible: Responsive.isMobile(context)
                            ? false
                            : true), // Configura visibilidad de la leyenda
                    primaryXAxis: const CategoryAxis(
                      title: AxisTitle(text: 'Año'), // Título del eje X
                    ),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(
                          text: 'Cantidad de Producciones'), // Título del eje Y
                    ),
                    series: producciones
                        .map((produccion) =>
                            StepLineSeries<ProduccionAgnoDataLider, String>(
                              name: produccion.unidadProduccion
                                  .nombre, // Nombre de la serie basado en la unidad de producción
                              dataSource: _getProduccionDataAgno(produccion,
                                  usuario), // Obtiene los datos de producción por año
                              xValueMapper: (ProduccionAgnoDataLider data, _) =>
                                  data.agno, // Mapeo de datos para el eje X
                              yValueMapper: (ProduccionAgnoDataLider data, _) =>
                                  data.cantidad, // Mapeo de datos para el eje Y
                              color:
                                  _getColor(), // Color de la serie (puedes personalizarlo)
                            ))
                        .toList(), // Convierte a lista de series
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Función para obtener los datos de producción por año y unidad de producción
  List<ProduccionAgnoDataLider> _getProduccionDataAgno(
      ProduccionModel produccion, UsuarioModel usuario) {
    Map<String, double> produccionesPorAgno =
        {}; // Mapa para almacenar la cantidad de producciones por año
    int currentYear = DateTime.now().year; // Año actual

    // Filtrar producciones por unidad y considerar solo los últimos 3 años (incluyendo el año actual)
    for (var i = 0; i < 3; i++) {
      int year = currentYear - i;
      produccionesPorAgno[year.toString()] =
          0; // Inicializa cada año con valor 0
    }

    // Itera sobre las producciones para sumar la cantidad por año
    for (var produccion in producciones) {
      var fechaDespacho = DateTime.parse(produccion
          .fechaDespacho); // Convierte la fecha de despacho a DateTime
      var year = fechaDespacho.year; // Obtiene el año como cadena

      // Verifica si la producción  es de los últimos 3 años y si la unidad de producción corresponde a la del usuario
      if (year >= (currentYear - 2) &&
          produccion.unidadProduccion.sede.id == usuario.sede) {
        produccionesPorAgno[year.toString()] = (produccionesPorAgno[
                    year.toString()] ??
                0) +
            produccion.cantidad
                .toDouble(); // Suma la cantidad de producción al año correspondiente
      }
    }

    // Convierte el mapa a una lista de objetos ProduccionAgnoDataLider y la retorna
    return produccionesPorAgno.entries
        .map((entry) => ProduccionAgnoDataLider(entry.key, entry.value))
        .toList();
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
}

// Modelo de datos para las producciones por año
class ProduccionAgnoDataLider {
  ProduccionAgnoDataLider(this.agno, this.cantidad);

  final String agno;
  final double cantidad;
}
