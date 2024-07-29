import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/productoCardUnidad.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';

/// Vista que muestra las tarjetas de productos individuales para una unidad de producción.
class CardsProductoUnidad extends StatelessWidget {
  const CardsProductoUnidad({
    super.key,
  });

  /// Función asíncrona que devuelve una lista de datos futuros: productos y sus imágenes.
  Future<List<dynamic>> futureData() async {
    return Future.wait([getProductos(), getImagenProductos()]);
  }

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
                  "Productos",
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
                              'Añadir Producto',
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
                          'Añadir Producto',
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
              height: 300,
              child: FutureBuilder(
                future: futureData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    // Obtener listas de productos e imágenes
                    List<ProductoModel> productos = snapshot.data![0];
                    List<ImagenProductoModel> allImages = snapshot.data![1];

                    // Filtrar productos por la unidad de producción del usuario autenticado
                    final List<ProductoModel> productosUnidad = productos
                        .where((producto) =>
                            producto.unidadProduccion.id ==
                            usuarioAutenticado!.unidadProduccion)
                        .toList();

                    // Verificar si hay productos para mostrar
                    if (productosUnidad.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productosUnidad.length,
                        itemBuilder: (context, index) {
                          ProductoModel producto = productosUnidad[index];

                          // Obtener imágenes asociadas al producto actual
                          List<String> images = allImages
                              .where(
                                  (imagen) => imagen.producto.id == producto.id)
                              .map((imagen) => imagen.imagen)
                              .toList();

                          // Mostrar la tarjeta de producto individual
                          return ProductoCardUnidad(
                            images: images,
                            producto: producto,
                          );
                        },
                      );
                    } else {
                      // Mostrar mensaje si no hay productos para la unidad de producción
                      return const Center(
                        child: Text(
                          'No hay productos para mostrar en esta unidad',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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
