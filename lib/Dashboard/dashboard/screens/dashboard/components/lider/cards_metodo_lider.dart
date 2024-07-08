import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/metodoCardLider.dart';
import 'package:tienda_app/Models/medioPagoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista que muestra las tarjetas de métodos de pago, adaptándose a diferentes dispositivos.
class CardsMetodoLider extends StatelessWidget {
  const CardsMetodoLider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Encabezado de las tarjetas de métodos de pago
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
            // Botón "Añadir Método" visible solo en dispositivos no móviles
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
        // Espacio adicional en dispositivos móviles
        if (Responsive.isMobile(context))
          const SizedBox(height: defaultPadding),
        // Botón "Añadir Método" visible solo en dispositivos móviles
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
        // Espacio adicional antes del listado de tarjetas de métodos de pago
        const SizedBox(height: defaultPadding),
        // Contenedor que muestra las tarjetas de métodos de pago
        SizedBox(
          height: 215,
          child: FutureBuilder(
            future: getMediosPago(),
            builder: (BuildContext context,
                AsyncSnapshot<List<MedioPagoModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Indicador de carga mientras se espera la respuesta
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // Mensaje de error si ocurre un problema al cargar datos
                return Center(
                  child: Text('Error al cargar métodos de pago: ${snapshot.error}'),
                );
              } else {
                // Construcción de las tarjetas de métodos de pago
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
