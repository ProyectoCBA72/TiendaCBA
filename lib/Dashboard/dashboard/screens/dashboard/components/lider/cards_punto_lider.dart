import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/puntoCardLider.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';

// Vista que muestra las tarjetas de puntos de venta, adaptándose a diferentes dispositivos.
class CardsPuntoLider extends StatefulWidget {
  const CardsPuntoLider({
    super.key,
  });

  @override
  State<CardsPuntoLider> createState() => _CardsPuntoLiderState();
}

class _CardsPuntoLiderState extends State<CardsPuntoLider> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, Widget? child) {
        final usuarioAutenticado = appState.usuarioAutenticado;
        return Column(
          children: [
            // Encabezado de las tarjetas de puntos de venta
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Puntos de venta",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontFamily: 'Calibri-Bold'),
                ),
                // Botón "Añadir Punto" visible solo en dispositivos no móviles
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
                              'Añadir Punto',
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
            // Botón "Añadir Punto" visible solo en dispositivos móviles
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
                          'Añadir Punto',
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
            // Espacio adicional antes del listado de tarjetas de puntos de venta
            const SizedBox(height: defaultPadding),
            // Contenedor que muestra las tarjetas de puntos de venta
            SizedBox(
              height: 245,
              child: FutureBuilder(
                future: getPuntosVenta(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<PuntoVentaModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Indicador de carga mientras se espera la respuesta
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Mensaje de error si ocurre un problema al cargar datos
                    return Text('Error al cargar puntos: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    // Mensaje si no se encontraron datos de puntos de venta
                    return const Text('No se encontraron puntos');
                  } else {
                    // Procesamiento de datos y construcción de las tarjetas de puntos de venta
                    List<PuntoVentaModel> puntosVenta = snapshot.data!;
                    List<PuntoVentaModel> puntosVentaSede = puntosVenta
                        .where((puntoVenta) =>
                            puntoVenta.sede == usuarioAutenticado!.sede)
                        .toList();
                    if (puntosVentaSede.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: puntosVentaSede.length,
                        itemBuilder: (context, index) {
                          PuntoVentaModel puntoVentaSede =
                              puntosVentaSede[index];
                          return CardPuntoLider(
                            puntoVenta: puntoVentaSede,
                          );
                        },
                      );
                    } else {
                      // Mensaje si no hay puntos de venta en la sede del usuario
                      return const Center(
                        child: Text(
                          'No hay puntos de venta en esta sede',
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
