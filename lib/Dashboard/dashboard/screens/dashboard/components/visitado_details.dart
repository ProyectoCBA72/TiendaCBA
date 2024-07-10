// ignore_for_file: use_full_hex_values_for_flutter_colors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/Models/visitadoModel.dart';
import 'package:tienda_app/cardProducts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';
import 'package:http/http.dart' as http;
import '../../../../../provider.dart';
import '../../../../../source.dart';

// Contenedor el cual almacenará las cards de los sitios favoritos del usuario
/// Clase que representa el widget de los detalles de un visitado.
///
/// Este widget muestra las tarjetas de los lugares visitados por el usuario.
/// Acepta un parámetro obligatorio [usuario] que es el modelo de usuario
/// que se está mostrando.
class VisitadoDetails extends StatefulWidget {
  /// Constructor de la clase [VisitadoDetails].
  ///
  /// El parámetro [key] es opcional y se utiliza para identificar el widget
  /// en la árbol de widgets. El parámetro [usuario] es obligatorio y es el modelo
  /// de usuario que se está mostrando.
  const VisitadoDetails({
    super.key,
    required this.usuario,
  });

  /// El modelo de usuario que se está mostrando.
  final UsuarioModel usuario;

  /// El estado del widget [VisitadoDetails].
  @override
  State<VisitadoDetails> createState() => _VisitadoDetailsState();
}

class _VisitadoDetailsState extends State<VisitadoDetails> {
  @override

  /// Método que se llama cuando el estado del widget se inicializa.
  ///
  /// Este método llama al método [deleteVisitos2Days] pasando como parámetro
  /// el modelo de usuario que se está mostrando.
  @override
  void initState() {
    // Llama al método super para inicializar el estado del widget
    super.initState();

    // Llama al método deleteVisitos2Days pasando como parámetro el modelo
    // de usuario que se está mostrando
    deleteVisitos2Days(widget.usuario);
  }

  /// Elimina los visitados que sean más antiguos de 2 días y que pertenezcan al usuario dado.
  ///
  /// El método [deleteVisitos2Days] recibe como parámetro un modelo de usuario [usuario].
  /// Busca todos los visitados obtenidos de la API y verifica si el visitado es más antiguo
  /// de 2 días y si pertenece al usuario dado. Si cumple con estas condiciones, se realiza una
  /// solicitud DELETE a la API para eliminar el visitado.
  ///
  /// No devuelve nada.
  Future<void> deleteVisitos2Days(UsuarioModel usuario) async {
    // Obtiene la lista de visitados de la API
    final visitados = await getVisitados();

    // Obtiene la fecha actual
    final now = DateTime.now();

    // Recorre todos los visitados
    for (var visita in visitados) {
      // Obtiene la fecha de la visita
      final fechaVisita = DateTime.parse(visita.fechaVista);

      // Verifica si la visita es más antigua de 2 días y si pertenece al usuario dado
      if (now.difference(fechaVisita).inDays >= 2 &&
          visita.usuario == usuario.id) {
        // URL para eliminar el visitado de la API
        final url = "$sourceApi/api/visitados/${visita.id}/";

        // Cabeceras de la solicitud DELETE
        final headers = {
          'Content-Type': 'application/json',
        };

        // Realiza la solicitud DELETE a la API para eliminar el visitado
        await http.delete(
          Uri.parse(url),
          headers: headers,
        );
      }
    }
  }

  /// Método que construye el widget.

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState == null || appState.usuarioAutenticado == null) {
          // Si no hay estado de la aplicación o usuario autenticado, mostramos un indicador de carga
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Obtenemos el usuario autenticado
        final usuario = appState.usuarioAutenticado!;
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFF2F0F2),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
            height: 625,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Text(
                      "Visitados",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Calibri-Bold',
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  Padding(
                    padding: const EdgeInsets.all(5.0), // Reducido el padding
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      // Traemos todas las imágenes de los productos
                      child: FutureBuilder(
                        future: getImagenProductos(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ImagenProductoModel>>
                                snapshotImagenes) {
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
                            final allImages = snapshotImagenes.data!;
                            // Traemos todos los productos
                            return FutureBuilder(
                              future: getProductos(),
                              builder: (context, snapshotProductos) {
                                if (snapshotProductos.connectionState ==
                                    ConnectionState.waiting) {
                                  // Mostramos un indicador de carga mientras se obtienen los productos
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  // Traemos los productos visitados y seleccionamos los que pertenecen al usuario actual
                                  return FutureBuilder(
                                    future: getVisitados(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        // Mostramos un indicador de carga mientras se obtienen los productos visitados
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        // Mostramos un mensaje si no hay productos visitados
                                        return const Center(
                                          child: Text(
                                              'No hay productos visitados'),
                                        );
                                      } else if (snapshot.hasError) {
                                        // Mostramos un mensaje de error si hubo un problema al obtener los productos visitados
                                        return Center(
                                          child: Text(
                                              'Error al cargar productos visitados: ${snapshot.error}'),
                                        );
                                      } else {
                                        // Obtenemos todos los productos
                                        final productos =
                                            snapshotProductos.data!;
                                        // Obtenemos todos los productos visitados
                                        final productosVisitados =
                                            snapshot.data!;
                                        // Filtramos los productos visitados que pertenecen al usuario actual
                                        final visitadosUsuario =
                                            productosVisitados
                                                .where((visitado) =>
                                                    visitado.usuario ==
                                                    usuario.id)
                                                .toList();
                                        // Filtramos los productos donde el id es igual al del producto visitado y el producto está activo
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
                                            // Filtramos las imágenes correspondientes al producto visitado
                                            List<String>
                                                imagenesProductoVisitado =
                                                allImages
                                                    .where((imagen) =>
                                                        imagen.producto.id ==
                                                        productovisitado.id)
                                                    .map((imagen) =>
                                                        imagen.imagen)
                                                    .toList();
              
                                            // Retornamos el widget CardProducts con el producto visitado y sus imágenes
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
            ),
          ),
        );
      },
    );
  }
}
