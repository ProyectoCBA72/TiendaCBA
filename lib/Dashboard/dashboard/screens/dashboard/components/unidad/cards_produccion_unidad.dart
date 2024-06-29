// ignore_for_file: no_leading_underscores_for_local_identifiers, use_super_parameters

import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/card_produccion_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/CardsProduccionClase.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista donde se llamarán las cards superiores de conteo de producciones y se organizan para que se adapten a todos los dispositivos

class CardsProduccionUnidad extends StatelessWidget {
  // Definición de la variable usuario que será recibida como parámetro
  final UsuarioModel usuario;

  const CardsProduccionUnidad({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    // Obtención del tamaño de la pantalla actual
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Título del panel
            Text(
              "Panel unidad de producción",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontFamily: 'Calibri-Bold'),
            ),
          ],
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        // Widget Responsive que adapta el contenido según el tamaño de la pantalla
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
            usuario: usuario,
          ),
          tablet: FileInfoCardGridView(
            usuario: usuario,
          ),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
            usuario: usuario,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  // Definición de la variable usuario que será recibida como parámetro
  final UsuarioModel usuario;

  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.usuario,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProducciones(), // Llamada futura para obtener producciones
        builder:
            (context, AsyncSnapshot<List<ProduccionModel>> snapshotProduccion) {
          // Manejo de los diferentes estados de la conexión
          if (snapshotProduccion.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Muestra un indicador de carga
          } else if (snapshotProduccion.hasError) {
            return Text(
                'Error al cargar producciones: ${snapshotProduccion.error}');
          } else if (snapshotProduccion.data == null) {
            return const Text('No se encontraron producciones');
          } else {
            // Variables para contabilizar las producciones
            int producciones = 0;
            int produccionesPendientes = 0;
            int produccionesCanceladas = 0;
            int produccionesDespachadas = 0;

            // Conteo de los diferentes tipos de producciones
            for (var p = 0; p < snapshotProduccion.data!.length; p++) {
              if (snapshotProduccion.data![p].unidadProduccion.id ==
                  usuario.unidadProduccion) {
                if (snapshotProduccion.data![p].estado == "PENDIENTE") {
                  produccionesPendientes++;
                } else if (snapshotProduccion.data![p].estado == "CANCELADO") {
                  produccionesCanceladas++;
                } else if (snapshotProduccion.data![p].estado == "ENVIADO" &&
                    snapshotProduccion.data![p].fechaDespacho != "") {
                  produccionesDespachadas++;
                }

                producciones++;
              }
            }

            // Creación de la lista de widgets de ProduccionLider con los datos calculados
            List produccionListaUnidad = [
              ProduccionCardClase(
                title: "Producciones",
                svgSrc: "assets/icons/produccion.svg",
                totalReservas: producciones.toString(),
                color: primaryColor,
                percentage: producciones,
              ),
              ProduccionCardClase(
                title: "Despachados",
                svgSrc: "assets/icons/check.svg",
                totalReservas: produccionesDespachadas.toString(),
                color: Colors.green,
                percentage: produccionesDespachadas,
              ),
              ProduccionCardClase(
                title: "Cancelados",
                svgSrc: "assets/icons/cancel.svg",
                totalReservas: produccionesCanceladas.toString(),
                color: Colors.red,
                percentage: produccionesCanceladas,
              ),
              ProduccionCardClase(
                title: "Pendientes",
                svgSrc: "assets/icons/pendiente.svg",
                totalReservas: produccionesPendientes.toString(),
                color: const Color(0xFF007EE5),
                percentage: produccionesPendientes,
              ),
            ];

            // Construcción de la cuadrícula con los widgets de ProduccionLider

            return GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Evita el scroll de la cuadrícula
              shrinkWrap: true,
              itemCount: produccionListaUnidad.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) =>
                  CardProduccionUnidad(info: produccionListaUnidad[index]),
            );
          }
        });
  }
}
