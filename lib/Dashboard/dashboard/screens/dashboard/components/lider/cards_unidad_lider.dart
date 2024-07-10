import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/unidadCardLider.dart';
import 'package:tienda_app/Models/unidadProduccionModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';

// Vista que muestra las tarjetas de unidades de producción, adaptándose a diferentes dispositivos.
class CardsUnidadLider extends StatelessWidget {
  const CardsUnidadLider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, Widget? child) {
        final usuarioAutenticado = appState.usuarioAutenticado;
        return Column(
          children: [
            // Encabezado de las tarjetas de unidades de producción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Unidades de producción",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontFamily: 'Calibri-Bold'),
                ),
                // Botón "Añadir Unidad" visible solo en dispositivos no móviles
                if (!Responsive.isMobile(context))
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          botonClaro, // Verde más claro
                          botonOscuro, // Verde más oscuro
                        ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: botonSombra, // Sombra en tono verde claro
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              'Añadir Unidad',
                              style: TextStyle(
                                color: background1,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Calibri-Bold',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Espacio adicional en dispositivos móviles
            if (Responsive.isMobile(context))
              const SizedBox(height: defaultPadding),
            // Botón "Añadir Unidad" visible solo en dispositivos móviles
            if (Responsive.isMobile(context))
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      botonClaro, // Verde más claro
                      botonOscuro, // Verde más oscuro
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: botonSombra, // Sombra en tono verde claro
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'Añadir Unidad',
                          style: TextStyle(
                            color: background1,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Calibri-Bold',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Espacio adicional antes del listado de unidades de producción
            const SizedBox(height: defaultPadding),
            // Contenedor que muestra las tarjetas de unidades de producción
            SizedBox(
              height: 215,
              child: FutureBuilder(
                future: getUndadesProduccion(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<UnidadProduccionModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Indicador de carga mientras se espera la respuesta
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Mensaje de error si ocurre un problema al cargar datos
                    return Text('Error al cargar unidades: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    // Mensaje si no se encontraron datos de unidades
                    return const Text('No se encontraron unidades');
                  } else {
                    // Procesamiento de datos y construcción de las tarjetas de unidades
                    List<UnidadProduccionModel> unidadesProduccion =
                        snapshot.data!;
                    // Filtrado de unidades por sede del usuario autenticado
                    List<UnidadProduccionModel> unidadesSedeLider =
                        unidadesProduccion
                            .where((unidadProduccion) =>
                                unidadProduccion.sede.id ==
                                usuarioAutenticado!.sede)
                            .toList();
                    if (unidadesSedeLider.isNotEmpty) {
                      // Si hay unidades de producción, mostrarlas en lista horizontal
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: unidadesSedeLider.length,
                        itemBuilder: (context, index) {
                          return UnidadCardLider(
                            undProduccion: unidadesSedeLider[index],
                          );
                        },
                      );
                    } else {
                      // Si no hay unidades de producción en la sede del usuario
                      return const Center(
                        child: Text(
                          'No hay unidades de producción en esta sede',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
