import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/categoriaCardLider.dart';
import 'package:tienda_app/Models/categoriaModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista que muestra las tarjetas de categorías, adaptándose a diferentes dispositivos.
class CardsCategoriaLider extends StatelessWidget {
  const CardsCategoriaLider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Encabezado de las tarjetas de categorías
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Categorías",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontFamily: 'Calibri-Bold'),
            ),
            // Botón "Añadir Categoría" visible solo en dispositivos no móviles
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
                          'Añadir Categoría',
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
        // Botón "Añadir Categoría" visible solo en dispositivos móviles
        if (Responsive.isMobile(context))
          Center(
            child: Container(
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
                        'Añadir Categoría',
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
          ),
        // Espacio adicional antes del listado de tarjetas de categorías
        const SizedBox(height: defaultPadding),
        // Contenedor que muestra las tarjetas de categorías
        SizedBox(
          height: 300,
          child: FutureBuilder(
            future: getCategorias(),
            builder: (BuildContext context,
                AsyncSnapshot<List<CategoriaModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Indicador de carga mientras se espera la respuesta
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // Mensaje de error si ocurre un problema al cargar datos
                return Center(
                  child: Text(
                    'Ocurrió un error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                // Construcción de las tarjetas de categorías
                final categorias = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    CategoriaModel categoria = categorias[index];
                    return CategoriaCardLider(
                      categoria: categoria,
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
