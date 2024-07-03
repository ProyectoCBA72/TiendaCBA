import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/puntoCardLider.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';

// Vista donde se llamaran las cards superiores de conteo de reservas y las organiza que se adapten a todos los dispositivos

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
                          color: botonSombra, // Verde más claro para sombra
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
            if (Responsive.isMobile(context))
              const SizedBox(height: defaultPadding),
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
                      color: botonSombra, // Verde más claro para sombra
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
            const SizedBox(height: defaultPadding),
            SizedBox(
              height: 245,
              child: FutureBuilder(
                future: getPuntosVenta(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<PuntoVentaModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error al cargar puntos: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return const Text('No se encontraron puntos');
                  } else {
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
                      return const Center(
                        child: Text(
                          'No hay puntos de venta en su sede',
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
