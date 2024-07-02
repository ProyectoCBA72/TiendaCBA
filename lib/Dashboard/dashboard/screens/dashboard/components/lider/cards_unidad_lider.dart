import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/unidadCardLider.dart';
import 'package:tienda_app/Models/unidadProduccionModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';

// Vista donde se llamaran las cards superiores de conteo de reservas y las organiza que se adapten a todos los dispositivos

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
            const SizedBox(height: defaultPadding),
            SizedBox(
              height: 215,
              child: FutureBuilder(
                future: getUndadesProduccion(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<UnidadProduccionModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<UnidadProduccionModel> unidadesProduccion =
                        snapshot.data!;
                    List<UnidadProduccionModel> unidadesSedeLider =
                        unidadesProduccion
                            .where((unidadProduccion) =>
                                unidadProduccion.sede.id ==
                                usuarioAutenticado!.sede)
                            .toList();
                    if (unidadesSedeLider.isNotEmpty) {
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
                      return const Center(
                        child: Text(
                          'No hay unidades de produccion en su sede',
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
