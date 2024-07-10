import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/productoCardLider.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';

// Vista que muestra las tarjetas de productos, adaptándose a diferentes dispositivos.
class CardsProductoLider extends StatelessWidget {
  const CardsProductoLider({
    super.key,
  });

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
            // Encabezado de las tarjetas de productos
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
                // Botón "Añadir Producto" visible solo en dispositivos no móviles
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
            // Espacio adicional en dispositivos móviles
            if (Responsive.isMobile(context))
              const SizedBox(height: defaultPadding),
            // Botón "Añadir Producto" visible solo en dispositivos móviles
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
            // Espacio adicional antes del listado de tarjetas de productos
            const SizedBox(height: defaultPadding),
            // Contenedor que muestra las tarjetas de productos
            SizedBox(
              height: 300,
              child: FutureBuilder(
                future: futureData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Indicador de carga mientras se espera la respuesta
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Mensaje de error si ocurre un problema al cargar datos
                    return Center(
                      child: Text('Error al cargar productos: ${snapshot.error}'),
                    );
                  } else {
                    // Procesamiento de datos y construcción de las tarjetas de productos
                    List<ProductoModel> productos = snapshot.data![0];
                    List<ImagenProductoModel> allImages = snapshot.data![1];
                    // Filtrar los productos por la sede del usuario autenticado
                    final List<ProductoModel> productosLider = productos
                        .where((producto) =>
                            producto.unidadProduccion.sede.id ==
                            usuarioAutenticado!.sede)
                        .toList();
                    // Verificar si hay productos para mostrar
                    if (productosLider.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productosLider.length,
                        itemBuilder: (context, index) {
                          ProductoModel producto = productosLider[index];
                          List<String> images = allImages
                              .where((imagen) => imagen.producto.id == producto.id)
                              .map((imagen) => imagen.imagen)
                              .toList();
                          return ProductoCardLider(
                            images: images,
                            producto: producto,
                          );
                        },
                      );
                    } else {
                      // Mensaje si no hay productos en la sede del usuario
                      return const Center(
                        child: Text(
                          'No hay productos para mostrar en esta sede',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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

