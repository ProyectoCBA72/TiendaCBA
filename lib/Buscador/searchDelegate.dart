// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Models/bodegaModel.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';
import 'package:tienda_app/Tienda/tiendaScreen.dart';
import 'package:tienda_app/cardProducts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

class SearchProductoDelegate extends SearchDelegate {
  List<ProductoModel> filterProducts =
      []; // Lista de productos filtrados inicialmente vacía.

  List<ProductoModel> suggestionProducts =
      []; // Lista de productos filtrados inicialmente vacía.

  Future<List<dynamic>> futureDataSearch;

  SearchProductoDelegate(
    this.futureDataSearch,
  ); // Constructor de la clase.

  @override
  String get searchFieldLabel =>
      'Buscar producto'; // Etiqueta del campo de búsqueda.

  @override
  ThemeData appBarTheme(BuildContext context) {
    // Personaliza el tema de la barra de búsqueda.
    return ThemeData(
      inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.all(12),
          hintStyle: TextStyle(
            color: Colors.grey, // Cambia el color del hint text
          ),
          border: InputBorder.none),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: primaryColor), // Color del indicador de progreso.
      // Configuración del tema de texto utilizando Google Fonts con el color principal.
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.normal,
            color: primaryColor), // Estilo de texto grande.
        displayMedium: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.normal,
            color: primaryColor), // Estilo de texto mediano.
        displaySmall: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.normal,
            color: primaryColor), // Estilo de texto pequeño.
        headlineLarge: TextStyle(
            fontFamily: 'Calibri-Bold',
            fontWeight: FontWeight.bold,
            color: primaryColor), // Estilo de encabezado grande.
        headlineMedium: TextStyle(
            fontFamily: 'Calibri-Bold',
            fontWeight: FontWeight.bold,
            color: primaryColor), // Estilo de encabezado mediano.
        headlineSmall: TextStyle(
            fontFamily: 'Calibri-Bold',
            fontWeight: FontWeight.bold,
            color: primaryColor), // Estilo de encabezado pequeño.
        titleLarge: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.normal,
            color: primaryColor), // Estilo de título grande.
        titleMedium: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.normal,
            color: primaryColor), // Estilo de título mediano.
        titleSmall: TextStyle(
            fontFamily: 'Calibri-Italic',
            fontStyle: FontStyle.italic,
            color: Colors.grey), // Estilo de título pequeño e itálico.
        bodyLarge: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.normal,
            color: primaryColor), // Estilo de cuerpo de texto grande.
        bodyMedium: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.normal,
            color: primaryColor), // Estilo de cuerpo de texto mediano.
        bodySmall: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.normal,
            color: primaryColor), // Estilo de cuerpo de texto pequeño.
        labelLarge: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.normal,
            color: primaryColor), // Estilo de etiqueta grande.
        labelMedium: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.normal,
            color: primaryColor), // Estilo de etiqueta mediana.
        labelSmall: TextStyle(
            fontFamily: 'Calibri-Light',
            fontWeight: FontWeight.w300,
            color: primaryColor), // Estilo de etiqueta pequeña y ligera.
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Construye la acción de limpiar el texto de búsqueda.
    return [
      IconButton(
        onPressed: () {
          query =
              ''; // Limpia la consulta actual al presionar el botón de limpiar.
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Construye el ícono de retroceso para volver a la página anterior.
    return IconButton(
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const TiendaScreen())); // Navega de regreso a la pantalla anterior al presionar el ícono de retroceso.
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Construye los resultados de la búsqueda.
    return _buildFutureBuilder(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Construye las sugerencias mientras se escribe en el campo de búsqueda.
    return _buildSuggestions(context);
  }

  Widget _buildFutureBuilder(BuildContext context) {
    final puntoVenta =
        Provider.of<PuntoVentaProvider>(context, listen: false).puntoVenta;
    // Construye un FutureBuilder para manejar la carga de datos de búsqueda.
    return FutureBuilder(
      future:
          futureDataSearch, // Llama al método fechData para obtener los datos necesarios.
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de progreso mientras se cargan los datos.
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Muestra un mensaje de error si ocurre un error durante la carga de datos.
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Muestra un mensaje si no hay datos disponibles para mostrar.
          return const Center(
            child: Text('No data available'),
          );
        } else {
          // Si hay datos disponibles, filtra los productos según la consulta actual y construye una cuadrícula de resultados.
          // Primera lista del snapshot que almacena los productos, Indice [0]
          List<ProductoModel> productos = snapshot.data![0];
          // Segunda lista del snapshot que almacena las imagenes, Indice [1]
          List<ImagenProductoModel> allImagenProductos = snapshot.data![1];
          // tercera lista del snapshot que almacena las bodegas, Indice [2]
          List<BodegaModel> bodegas = snapshot.data![2];

          // Lista de bodegas donde el punto de venta sea igual al seleccionado en la tienda

          final bodegasPunto = bodegas
              .where((bodega) => bodega.puntoVenta.id == puntoVenta!.id)
              .toList();

          // Lista de los productos disponibles, es decir los que hay uno o mas  en bodega.
          final productosDisponibles = productos.where((producto) {
            return bodegasPunto.any((bodega) =>
                bodega.producto.id == producto.id && bodega.cantidad > 1);
          }).toList();

          // Actualizamos la lista definida anteriormente.
          filterProducts = productosDisponibles.where((producto) {
            return (producto.nombre
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    producto.categoria.nombre
                        .toLowerCase()
                        .contains(query.toLowerCase())) &&
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

  // construye la lista de sugerencias
  Widget _buildSuggestions(BuildContext context) {
    final puntoVenta =
        Provider.of<PuntoVentaProvider>(context, listen: false).puntoVenta;
    return FutureBuilder<List>(
      future: futureDataSearch,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          List<ProductoModel> productos = snapshot.data![0];
          List<BodegaModel> bodegas = snapshot.data![2];

          // Lista de bodegas donde el punto de venta sea igual al seleccionado en la tienda

          final bodegasPunto = bodegas
              .where((bodega) => bodega.puntoVenta.id == puntoVenta!.id)
              .toList();

          // Lista de los productos disponibles, es decir los que hay uno o mas  en bodega.
          final productosDisponibles = productos.where((producto) {
            return bodegasPunto.any((bodega) =>
                bodega.producto.id == producto.id && bodega.cantidad > 1);
          }).toList();

          suggestionProducts = productosDisponibles.where((prod) {
            return prod.nombre.toLowerCase().contains(query.toLowerCase()) ||
                prod.categoria.nombre
                    .toLowerCase()
                    .contains(query.toLowerCase());
          }).toList();

          return Stack(
            children: [
              _buildAllProducts(context),
              if (query.isNotEmpty)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.white.withOpacity(0.9),
                    height: 200, // Limita la altura de las sugerencias
                    child: ListView.builder(
                      itemCount: suggestionProducts.length,
                      itemBuilder: (context, index) {
                        final producto = suggestionProducts[index];
                        return ListTile(
                          title: Text(producto.nombre),
                          selectedTileColor: Colors.grey[200],
                          subtitle: Text(producto.categoria.nombre),
                          onTap: () {
                            query = producto.nombre;
                            showResults(context);
                          },
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  // construye todos los productos para colocar en el fondo de las sugerencias.
  Widget _buildAllProducts(BuildContext context) {
    final puntoVenta =
        Provider.of<PuntoVentaProvider>(context, listen: false).puntoVenta;
    return FutureBuilder<List<dynamic>>(
      future: futureDataSearch,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          List<ProductoModel> productos = snapshot.data![0];
          List<ImagenProductoModel> allImagenProductos = snapshot.data![1];
          List<BodegaModel> bodegas = snapshot.data![2];

          // Lista de bodegas donde el punto de venta sea igual al seleccionado en la tienda

          final bodegasPunto = bodegas
              .where((bodega) => bodega.puntoVenta.id == puntoVenta!.id)
              .toList();

          // Lista de los productos disponibles, es decir los que hay uno o mas  en bodega.
          final productosDisponibles = productos.where((producto) {
            return bodegasPunto.any((bodega) =>
                bodega.producto.id == producto.id && bodega.cantidad > 1);
          }).toList();

          final allProductos =
              productosDisponibles.where((prod) => prod.estado).toList();
          return GridView.builder(
            itemCount: allProductos.length,
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
              final producto = allProductos[index];
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
