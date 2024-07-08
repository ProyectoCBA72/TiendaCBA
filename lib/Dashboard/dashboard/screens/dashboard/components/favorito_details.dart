// ignore_for_file: use_full_hex_values_for_flutter_colors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Models/favoritoModel.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';

import '../../../../../cardProducts.dart';

// Contenedor el cual almacenará las cards de los sitios favoritos del usuario
class FavoritoDetails extends StatelessWidget {
  const FavoritoDetails({
    super.key,
  });

  /// Método que construye el widget.
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        // Verificamos si el estado de la aplicación o el usuario autenticado es nulo
        if (appState == null || appState.usuarioAutenticado == null) {
          // Mostramos un indicador de carga si no hay usuario autenticado
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Obtenemos el usuario autenticado del estado de la aplicación
        final usuario = appState.usuarioAutenticado!;

        return Container(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: 10.0),
          decoration: const BoxDecoration(
            color: Color(0xFFFF2F0F2),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
            height: 625,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Favoritos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Calibri-Bold',
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Padding(
                      padding: const EdgeInsets.all(5.0), // Reducido el padding
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        // Traemos las imágenes de los productos
                        child: FutureBuilder(
                          future: getImagenProductos(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ImagenProductoModel>>
                                  snapshotImagenes) {
                            // Verificamos el estado de la conexión para mostrar el contenido adecuado
                            if (snapshotImagenes.connectionState ==
                                ConnectionState.waiting) {
                              // Mostramos un indicador de carga mientras se obtienen las imágenes
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshotImagenes.hasError) {
                              // Mostramos un indicador de error si hubo un problema al obtener las imágenes
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              // Obtenemos todas las imágenes
                              final allImages = snapshotImagenes.data!;
                              // Traemos todos los productos
                              return FutureBuilder(
                                future: getProductos(),
                                builder: (context, snapshotProductos) {
                                  // Verificamos el estado de la conexión para mostrar el contenido adecuado
                                  if (snapshotProductos.connectionState ==
                                      ConnectionState.waiting) {
                                    // Mostramos un indicador de carga mientras se obtienen los productos
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    // Traemos los productos favoritos del usuario
                                    return FutureBuilder(
                                      future: getFavoritos(),
                                      builder: (context, snapshot) {
                                        // Verificamos el estado de la conexión para mostrar el contenido adecuado
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // Mostramos un indicador de carga mientras se obtienen los productos favoritos
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          // Mostramos un mensaje si no hay productos favoritos
                                          return const Center(
                                            child: Text(
                                                'No hay productos favoritos'),
                                          );
                                        } else if (snapshot.hasError) {
                                          // Mostramos un mensaje de error si hubo un problema al obtener los productos favoritos
                                          return Center(
                                            child: Text(
                                                'Error al cargar productos favoritos: ${snapshot.error}'),
                                          );
                                        } else {
                                          // Obtenemos todos los productos
                                          final productos =
                                              snapshotProductos.data!;
                                          // Obtenemos todos los productos favoritos
                                          final productosFavoritos =
                                              snapshot.data!;
                                          // Filtramos los productos favoritos que pertenecen al usuario actual
                                          final favoritosUsuario =
                                              productosFavoritos
                                                  .where((favorito) =>
                                                      favorito.usuario ==
                                                      usuario.id)
                                                  .toList();
                                          // Filtramos los productos donde el id es igual al del producto favorito y el producto está activo
                                          final productosFavoritosList =
                                              productos
                                                  .where((producto) =>
                                                      favoritosUsuario.any(
                                                          (favorito) =>
                                                              favorito.producto
                                                                      .id ==
                                                                  producto.id &&
                                                              producto.estado))
                                                  .toList();
                                          return GridView.builder(
                                            itemCount:
                                                productosFavoritosList.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  Responsive.isTablet(context)
                                                      ? 2
                                                      : 1,
                                              crossAxisSpacing:
                                                  5.0, // Ajuste del espacio entre columnas
                                              mainAxisSpacing:
                                                  10.0, // Ajuste del espacio entre filas
                                            ),
                                            itemBuilder: (context, index) {
                                              // Obtenemos el producto favorito actual
                                              final productoFavorito =
                                                  productosFavoritosList[index];
                                              // Filtramos las imágenes correspondientes al producto favorito
                                              List<String>
                                                  imagenesProductoFavorito =
                                                  allImages
                                                      .where((imagen) =>
                                                          imagen.producto.id ==
                                                          productoFavorito.id)
                                                      .map((imagen) =>
                                                          imagen.imagen)
                                                      .toList();

                                              // Retornamos el widget CardProducts con el producto favorito y sus imágenes
                                              return CardProducts(
                                                producto: productoFavorito,
                                                imagenes:
                                                    imagenesProductoFavorito,
                                              );
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
