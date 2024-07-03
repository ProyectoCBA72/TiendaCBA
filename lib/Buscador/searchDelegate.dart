import 'package:flutter/material.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/cardProducts.dart';
import 'package:tienda_app/responsive.dart';

class SearchProductoDelegate extends SearchDelegate {
  List<ProductoModel> filterProducts = [];

  // traemos los datos sin iterar de la clase anterior
  Future<List<dynamic>> datosFuture;

  SearchProductoDelegate(this.datosFuture);

//  creamos un futuro para traer los datos al tiempo.
  Future<List<dynamic>> fechData() {
    return Future.wait([
      getProductos(),   
      getImagenProductos(),
    ]);
  }

  // Funcion con del boton de la parte derecha.
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  // Personalizar el input
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.white,
      textTheme: const TextTheme(),
      inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.all(12),
          hintStyle: TextStyle(
            color: Colors.grey, // Cambia el color del hint text
          ),
          border: InputBorder.none),
    );
  }

  // Icono de la izquierda para regresar a la pagina anterior
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

// Sugerencias al ir escribiendo
  @override
  Widget buildResults(BuildContext context) {
    return _buildFutureBuilder(context);
  }

// resultados al darle enter o buscar.
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildFutureBuilder(context);
  }

  // funcion para obtener los datos de la busqueda, con un future por el momento ( error )
  Widget _buildFutureBuilder(BuildContext context) {
    return FutureBuilder(
      // future: datosFuture, // al ser asi las imagenes se mezclan por alguna razon.
      future: fechData(), // en este caso funciona pero se demora un poco mas.
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        } else {
          List<ProductoModel> productos = snapshot.data![0];
          List<ImagenProductoModel> allImagenProductos = snapshot.data![1];
          filterProducts = productos.where((producto) {
            return (producto.nombre.toLowerCase().contains(query.trim()) ||
                    producto.categoria.nombre
                        .toLowerCase()
                        .contains(query.trim())) &&
                producto.estado;
          }).toList();
          return GridView.builder(
            itemCount: filterProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isMobile(context)
                  ? 1
                  : Responsive.isTablet(context)
                      ? 3
                      : 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              final producto = filterProducts[index];
              List<String> imagenesProducto = allImagenProductos
                  .where((imagen) => imagen.producto.id == producto.id)
                  .map((imagen) => imagen.imagen)
                  .toList();
              return CardProducts(
                producto: producto,
                imagenes: imagenesProducto,
              );
            },
          );
        }
      },
    );
  }
}
