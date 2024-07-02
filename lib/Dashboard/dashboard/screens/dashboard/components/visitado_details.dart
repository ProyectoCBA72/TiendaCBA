// ignore_for_file: use_full_hex_values_for_flutter_colors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/visitadoModel.dart';
import 'package:tienda_app/cardProducts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';
import 'package:http/http.dart' as http;
import '../../../../../provider.dart';
import '../../../../../source.dart';

// Contenedor el cual almacenará las cards de los sitios favoritos del usuario
class VisitadoDetails extends StatefulWidget {
  const VisitadoDetails({
    super.key,
  });

  @override
  State<VisitadoDetails> createState() => _VisitadoDetailsState();
}

class _VisitadoDetailsState extends State<VisitadoDetails> {
  @override
  void initState() {
    super.initState();
    deleteVisitos2Days();
  }

  Future deleteVisitos2Days() async {
    final visitados = await getVisitados();
    final now = DateTime.now();

    for (var visita in visitados) {
      final fechaVisita = DateTime.parse(visita.fechaVista);
      if (now.difference(fechaVisita).inDays >= 2) {
        // delete visitado
        final url = "$sourceApi/api/visitados/${visita.id}/";

        final headers = {
          'Content-Type': 'application/json',
        };

        final response = await http.delete(
          Uri.parse(url),
          headers: headers,
        );

        if (response.statusCode == 204) {
          print('Datos eliminados correctamente');
        }
      }
    }
  }

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
                      "Visitados",
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
                        // Traemos todos los productos
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
                                    // traemos los visitados y seleccionamos lo que pertenecen al usuario actual.
                                    return FutureBuilder(
                                      future: getVisitados(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return const Center(
                                            child: Text('No hay Visitados'),
                                          );
                                        } else {
                                          // Todos los productos
                                          final productos =
                                              snapshotProductos.data!;
                                          // todos los visitados
                                          final productosVisitados =
                                              snapshot.data!;
                                          // visitados que son del usuario actual
                                          final visitadosUsuario =
                                              productosVisitados
                                                  .where((visitado) =>
                                                      visitado.usuario ==
                                                      usuario.id)
                                                  .toList();
                                          // productos donde el id es igual al del visitado. ( 2 listas )
                                          final productosVisitadosList =
                                              productos
                                                  .where((producto) =>
                                                      visitadosUsuario.any(
                                                          (visitado) =>
                                                              visitado.producto
                                                                      .id ==
                                                                  producto.id &&
                                                              producto.estado))
                                                  .toList();
                                          return GridView.builder(
                                            itemCount:
                                                productosVisitadosList.length,
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
                                              final productovisitado =
                                                  productosVisitadosList[index];
                                              List<String>
                                                  imagenesProductoVisitado =
                                                  allImages
                                                      .where((imagen) =>
                                                          imagen.producto.id ==
                                                          productovisitado.id)
                                                      .map((imagen) =>
                                                          imagen.imagen)
                                                      .toList();

                                              return CardProducts(
                                                producto: productovisitado,
                                                imagenes:
                                                    imagenesProductoVisitado,
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
