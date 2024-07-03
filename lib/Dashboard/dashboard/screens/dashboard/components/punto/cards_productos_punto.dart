import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/productoCardPunto.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';

// Vista donde se llamaran las cards superiores de conteo de reservas y las organiza que se adapten a todos los dispositivos

class CardsProductoPunto extends StatelessWidget {
  const CardsProductoPunto({
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
                      child: Text('error: ${snapshot.error}'),
                    );
                  } else {
                    // creamos las intancias de los datos traidos del futuro en su respectivo indice
                    List<ProductoModel> productos = snapshot.data![0];
                    List<ImagenProductoModel> allImages = snapshot.data![1];
                    // creamos otra lista con el fin de tener solo los productos que el usuario con el rol unidad tiene.
                    final List<ProductoModel> productosPunto = productos
                        .where((producto) =>
                            producto.usuario.puntoVenta ==
                            usuarioAutenticado!.puntoVenta)
                        .toList();

                    // verificamos si hay productos en la lista.
                    if (productosPunto.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productosPunto.length,
                        itemBuilder: (context, index) {
                          ProductoModel producto = productosPunto[index];
                          List<String> images = allImages
                              .where(
                                  (imagen) => imagen.producto.id == producto.id)
                              .map((imagen) => imagen.imagen)
                              .toList();
                          return ProductoCardPunto(
                            images: images,
                            producto: producto,
                          );
                        },
                      );
                    } else {
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
