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

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState == null || appState.usuarioAutenticado == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

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
                        // Traemos las iamgenes
                        child: FutureBuilder(
                          future: getImagenProductos(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ImagenProductoModel>>
                                  snapshotImagenes) {
                            if (snapshotImagenes.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              final allImages = snapshotImagenes.data!;
                              // Traemos todos los productos
                              return FutureBuilder(
                                future: getProductos(),
                                builder: (context, snapshotProductos) {
                                  if (snapshotProductos.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return FutureBuilder(
                                      future: getFavoritos(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return const Center(
                                            child: Text('No hay Favoritos'),
                                          );
                                        } else {
                                          final productos =
                                              snapshotProductos.data!;
                                          final productosFavoritos =
                                              snapshot.data!;
                                          final favoritosUsuario =
                                              productosFavoritos
                                                  .where((favorito) =>
                                                      favorito.usuario ==
                                                      usuario.id)
                                                  .toList();
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
                                              final productoFavorito =
                                                  productosFavoritosList[index];

                                              List<String>
                                                  imagenesProductoFavorito =
                                                  allImages
                                                      .where((imagen) =>
                                                          imagen.producto.id ==
                                                          productoFavorito.id)
                                                      .map((imagen) =>
                                                          imagen.imagen)
                                                      .toList();

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
