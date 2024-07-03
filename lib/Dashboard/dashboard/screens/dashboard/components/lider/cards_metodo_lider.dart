import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/metodoCardLider.dart';
import 'package:tienda_app/Models/medioPagoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista donde se llamaran las cards superiores de conteo de reservas y las organiza que se adapten a todos los dispositivos

class CardsMetodoLider extends StatelessWidget {
  const CardsMetodoLider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Métodos de pago",
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
                          'Añadir Método',
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
                      'Añadir Método',
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
            future: getMediosPago(),
            builder: (BuildContext context,
                AsyncSnapshot<List<MedioPagoModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error al cargar metodos: ${snapshot.error}');
              } else if (snapshot.data == null) {
                return const Text('No se encontraron metodos');
              } else {
                final mediosPago = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mediosPago.length,
                  itemBuilder: (context, index) {
                    return MetodoCardLider(
                      medioPago: mediosPago[index],
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
