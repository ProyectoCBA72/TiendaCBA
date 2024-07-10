import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/productoCardPunto.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';

// Vista donde se llaman las tarjetas superiores de conteo de reservas y se organizan para adaptarse a todos los dispositivos

class CardsProductoPunto extends StatelessWidget {
  const CardsProductoPunto({
    super.key,
  });

  // Método asincrónico para obtener los datos del futuro
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
            // Encabezado de la sección de productos
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
                          color: botonSombra, // Sombra con verde más claro
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Acción al presionar "Añadir Producto"
                        },
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

            // Botón "Añadir Producto" para dispositivos móviles
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
                      color: botonSombra, // Sombra con verde más claro
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Acción al presionar "Añadir Producto" en móvil
                    },
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

            // Construcción de la lista de productos del punto de venta
            SizedBox(
              height: 300,
              child: FutureBuilder(
                future: futureData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Muestra un indicador de carga mientras se espera la respuesta
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Muestra un mensaje de error si ocurre algún problema con la carga de datos
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    // Obtiene la lista de productos y sus imágenes
                    List<ProductoModel> productos = snapshot.data![0];
                    List<ImagenProductoModel> allImages = snapshot.data![1];

                    // Filtra los productos por el punto de venta del usuario autenticado
                    final List<ProductoModel> productosPunto = productos
                        .where((producto) =>
                            producto.usuario.puntoVenta ==
                            usuarioAutenticado!.puntoVenta)
                        .toList();

                    // Verifica si hay productos para mostrar
                    if (productosPunto.isNotEmpty) {
                      // Construye una lista horizontal de tarjetas de productos
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productosPunto.length,
                        itemBuilder: (context, index) {
                          ProductoModel producto = productosPunto[index];

                          // Obtiene las imágenes asociadas al producto
                          List<String> images = allImages
                              .where(
                                  (imagen) => imagen.producto.id == producto.id)
                              .map((imagen) => imagen.imagen)
                              .toList();

                          // Retorna la tarjeta del producto
                          return ProductoCardPunto(
                            images: images,
                            producto: producto,
                          );
                        },
                      );
                    } else {
                      // Muestra un mensaje si no hay productos para mostrar
                      return const Center(
                        child: Text(
                          'No hay productos para mostrar en este punto',
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

