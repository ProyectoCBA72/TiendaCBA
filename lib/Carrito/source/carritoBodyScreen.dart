// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Carrito/source/carritoTabla.dart';
import 'package:tienda_app/Models/bodegaModel.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Tienda/tiendaScreen.dart';
import 'package:tienda_app/source.dart';
import '../../Models/productoModel.dart';
import '../../provider.dart';
import '../../Models/auxPedidoModel.dart';
import '../../constantsDesign.dart';
import 'package:http/http.dart' as http;

/// Esta clase representa la pantalla del cuerpo del carrito de la aplicación.
///
/// Esta clase extiende [StatefulWidget] y proporciona un estado asociado
/// [_CarritoBodyScreenState].
class CarritoBodyScreen extends StatefulWidget {
  final PuntoVentaModel puntoVenta;

  /// Construye un [CarritoBodyScreen] con un [Key] opcional.
  const CarritoBodyScreen({super.key, required this.puntoVenta});

  @override
  // ignore: library_private_types_in_public_api
  State<CarritoBodyScreen> createState() => _CarritoBodyScreenState();
}

class _CarritoBodyScreenState extends State<CarritoBodyScreen> {
  // Varible para no perder el contexto del árbol de widgets
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

// futuro para actualizar la cantidad y el precio del aux pedido.
  /// Futuro para actualizar la cantidad, precio, producto y pedido de un aux pedido.
  ///
  /// Toma el ID del aux pedido, la cantidad, el precio, el ID del producto y el ID del pedido,
  /// y realiza una solicitud PUT al API para actualizar el aux pedido con estos datos.
  ///
  /// @param id El ID del aux pedido a actualizar.
  /// @param cantidad La nueva cantidad del aux pedido.
  /// @param precio El nuevo precio del aux pedido.
  /// @param producto El nuevo ID del producto del aux pedido.
  /// @param pedido El nuevo ID del pedido del aux pedido.
  Future<void> _updateAuxPedido(BuildContext context, int id, int cantidad,
      int precio, int producto, int pedido) async {
    // traermos las bodegas
    final bodegas = await getBodegas();

    final bodega = bodegas
        .where((item) =>
            item.producto.id == producto &&
            item.puntoVenta.id == widget.puntoVenta.id)
        .firstOrNull;

    if (bodega!.cantidad >= cantidad) {
      try {
        // Construir la URL para actualizar el aux pedido
        final url = Uri.parse('$sourceApi/api/aux-pedidos/$id/');

        // Realizar la solicitud PUT al API
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'precio': precio,
            'cantidad': cantidad,
            'producto': producto,
            'pedido': pedido,
          }),
        );

        // Verificar la respuesta de la solicitud
        if (response.statusCode == 200) {
          // Si la respuesta es exitosa, imprimir un mensaje de éxito
          print('Pedido actualizado con éxito.');
          // Mostrar un mensaje de confirmación utilizando ScaffoldMessenger
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text(
                'Pedido actualizado con éxito',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
          setState(() {});
        } else {
          // Si la respuesta no es exitosa, imprimir el mensaje de error
          print('Error al actualizar el pedido: ${response.body}');
        }
      } catch (e) {
        // Si ocurre un error, imprimir el error
        print(e);
      }
    } else {
      if (bodega.cantidad == 0) {
        // si la cantidad en la bodega es de 0 se elimina automaticamente
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text(
              'La cantidad disponible es 0 se eliminara el producto',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        _eliminarProducto(id);
      } else {
        // pero si la bodega tiene valor se actualiza el pedido con ese valor.
        try {
          // Construir la URL para actualizar el aux pedido
          final url = Uri.parse('$sourceApi/api/aux-pedidos/$id/');

          // Realizar la solicitud PUT al API
          final response = await http.put(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'precio': precio,
              'cantidad': bodega.cantidad,
              'producto': producto,
              'pedido': pedido,
            }),
          );

          // Verificar la respuesta de la solicitud
          if (response.statusCode == 200) {
            // Si la respuesta es exitosa, imprimir un mensaje de éxito
            print('Pedido actualizado con éxito. Con el maximo disponible');

            // Mostrar un mensaje de confirmación utilizando ScaffoldMessenger
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text(
                  'Pedido actualizado con éxito. Con el maximo disponible',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
            setState(() {});
          } else {
            // Si la respuesta no es exitosa, imprimir el mensaje de error
            print('Error al actualizar el pedido: ${response.body}');
          }
        } catch (e) {
          // Si ocurre un error, imprimir el error
          print(e);
        }
      }
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'La cantidad disponible en el momento es: ${bodega.cantidad} unidades, ',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  // funcion para verificar si el producto que resta de la eliminacion es eclusivo
  // en caso de que lo sea muestra la modal, si no se elimina

  Future<void> _removeProducto(
      AuxPedidoModel auxPedido, List<AuxPedidoModel> auxPedidos) async {
    final productos = await getProductos();

    if (auxPedidos.length == 2) {
      final auxPedidoRestante = auxPedidos
          .where((item) => item.producto != auxPedido.producto)
          .firstOrNull;

      final productoRestante = productos
          .where((item) => item.id == auxPedidoRestante!.producto)
          .firstOrNull;
      if (productoRestante!.exclusivo) {
        modalEliminarExclusivo();
      } else {
        _eliminarProducto(auxPedido.id);
      }
    } else {
      _eliminarProducto(auxPedido.id);
    }
  }

  // modal de que no se puede eliminar un producto si solo queda un exclusivo.
  void modalEliminarExclusivo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No se puede eliminar "),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "¡No puede llevar un producto exclusivo sin compañia de otro producto!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              // Muestra una imagen circular del logo de la aplicación
              ClipOval(
                child: Container(
                  width: 100, // Ajusta el tamaño según sea necesario
                  height: 100, // Ajusta el tamaño según sea necesario
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: Image.asset(
                    "assets/img/logo.png",
                    fit: BoxFit.cover, // Ajusta la imagen al contenedor
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton(
                    "Aceptar",
                    () {
                      // Cierra el diálogo cuando se hace clic en el botón de aceptar
                      Navigator.pop(context);
                      // Navega a la pantalla de la tienda
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Elimina un producto del carrito.
  ///
  /// @param id El ID del producto a eliminar.

  Future<void> _eliminarProducto(int id) async {
    try {
      final url = Uri.parse('$sourceApi/api/aux-pedidos/$id/');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        print('Producto eliminado con éxito.');
        setState(() {});
      } else {
        print('Error al eliminar el producto: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }

// funcion para calcular el total de los productos, aun se trabaja ( cambio )
  /// Calcula el total de los productos.
  ///
  /// Toma una lista de [AuxPedidoModel] y calcula el total de los precios de
  /// los productos. Devuelve el total formateado como cadena.
  ///
  /// @param pedidos La lista de aux pedidos.
  /// @return El total formateado como cadena.
  String calcularTotal(List<AuxPedidoModel> pedidos) {
    // Inicializar la variable de suma a 0.0
    double suma = 0.0;

    // Iterar sobre cada aux pedido y sumar su precio
    for (AuxPedidoModel pedido in pedidos) {
      suma += pedido.precio;
    }

    // Formatear el valor total y devolverlo
    final costoFinal = formatter.format(suma); // Formatea el valor
    return costoFinal;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final usuarioAutenticado = appState.usuarioAutenticado;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: getAuxPedidos(),
                builder: (context, snapshot) {
                  // Mostrar indicador de carga mientras se obtienen los datos
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Manejar errores en la obtención de los datos
                  else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Error: ${snapshot.error}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontFamily: 'Calibri-Bold',
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(
                                0.5), // Color y opacidad de la sombra
                            offset: const Offset(2,
                                2), // Desplazamiento de la sombra (horizontal, vertical)
                            blurRadius: 3, // Radio de desenfoque de la sombra
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ));
                  }
                  // Mostrar mensaje si no hay pedidos en el carrito
                  else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                      'No hay pedidos en el carrito.',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontFamily: 'Calibri-Bold',
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(
                                0.5), // Color y opacidad de la sombra
                            offset: const Offset(2,
                                2), // Desplazamiento de la sombra (horizontal, vertical)
                            blurRadius: 3, // Radio de desenfoque de la sombra
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ));
                  }
                  // Si hay pedidos en el carrito, construir la vista
                  else {
                    final auxPedidos = snapshot.data!
                        .where((auxPedido) =>
                            auxPedido.pedido.usuario.id ==
                                usuarioAutenticado!.id &&
                            auxPedido.pedido.pedidoConfirmado == false &&
                            auxPedido.pedido.estado == "PENDIENTE")
                        .toList();

                    return FutureBuilder(
                      future: getProductos(),
                      builder: (context, snapshotProductos) {
                        // Mostrar indicador de carga mientras se obtienen los productos
                        if (snapshotProductos.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        // Manejar errores en la obtención de los productos
                        else if (snapshotProductos.hasError) {
                          return Center(
                              child: Text(
                            'Error: ${snapshotProductos.error}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                              fontFamily: 'Calibri-Bold',
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Color y opacidad de la sombra
                                  offset: const Offset(2,
                                      2), // Desplazamiento de la sombra (horizontal, vertical)
                                  blurRadius:
                                      3, // Radio de desenfoque de la sombra
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ));
                        }
                        // Mostrar mensaje si no hay productos relacionados
                        else if (!snapshotProductos.hasData ||
                            snapshotProductos.data!.isEmpty) {
                          return Center(
                              child: Text(
                            'No hay producto relacionado error.',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                              fontFamily: 'Calibri-Bold',
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Color y opacidad de la sombra
                                  offset: const Offset(2,
                                      2), // Desplazamiento de la sombra (horizontal, vertical)
                                  blurRadius:
                                      3, // Radio de desenfoque de la sombra
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ));
                        }
                        // Si hay productos, construir la vista con productos e imágenes
                        else {
                          return FutureBuilder(
                            future: getImagenProductos(),
                            builder: (context, snapshotImagenes) {
                              // Mostrar indicador de carga mientras se obtienen las imágenes
                              if (snapshotImagenes.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              // Manejar errores en la obtención de las imágenes
                              else if (snapshotImagenes.hasError) {
                                return Center(
                                    child: Text(
                                  'Error: ${snapshotImagenes.error}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                    fontFamily: 'Calibri-Bold',
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(
                                            0.5), // Color y opacidad de la sombra
                                        offset: const Offset(2,
                                            2), // Desplazamiento de la sombra (horizontal, vertical)
                                        blurRadius:
                                            3, // Radio de desenfoque de la sombra
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ));
                              }
                              // Mostrar mensaje si no hay imágenes
                              else if (!snapshotImagenes.hasData ||
                                  snapshotImagenes.data!.isEmpty) {
                                return Center(
                                    child: Text(
                                  'Sin Imagen',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                    fontFamily: 'Calibri-Bold',
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(
                                            0.5), // Color y opacidad de la sombra
                                        offset: const Offset(2,
                                            2), // Desplazamiento de la sombra (horizontal, vertical)
                                        blurRadius:
                                            3, // Radio de desenfoque de la sombra
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ));
                              }
                              // Construir las tarjetas de productos si hay datos disponibles
                              else {
                                final imagenesTotal = snapshotImagenes.data!;
                                return Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Mi Carrito",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                          fontFamily: 'Calibri-Bold',
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                  0.5), // Color y opacidad de la sombra
                                              offset: const Offset(2,
                                                  2), // Desplazamiento de la sombra (horizontal, vertical)
                                              blurRadius:
                                                  3, // Radio de desenfoque de la sombra
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: auxPedidos.isEmpty
                                          ? Center(
                                              child: Text(
                                                'No hay productos en el carrito.',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                  fontFamily: 'Calibri-Bold',
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.5), // Color y opacidad de la sombra
                                                      offset: const Offset(2,
                                                          2), // Desplazamiento de la sombra (horizontal, vertical)
                                                      blurRadius:
                                                          3, // Radio de desenfoque de la sombra
                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount: auxPedidos.length,
                                              itemBuilder: (context, index) {
                                                final auxPedido =
                                                    auxPedidos[index];
                                                // Buscamos el producto.
                                                final producto = productos
                                                    .firstWhere((prod) =>
                                                        prod.id ==
                                                        auxPedido.producto);
                                                // Buscamos la primera imagen del producto en cuestión.
                                                final imagenProd = imagenesTotal
                                                    .firstWhere((imagen) =>
                                                        imagen.producto.id ==
                                                        auxPedido.producto);
                                                return cardProduct(
                                                    context,
                                                    auxPedido,
                                                    producto,
                                                    imagenProd,
                                                    auxPedidos);
                                              },
                                            ),
                                    ),
                                    // Tarjeta para mostrar el total del carrito y botón de confirmación
                                    Card(
                                      color: Colors.black.withOpacity(0.5),
                                      margin: const EdgeInsets.all(10.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        height: 80.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "Total:",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall!
                                                          .copyWith(
                                                            fontFamily:
                                                                'Calibri-Bold',
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Flexible(
                                                    child: Text(
                                                      "\$${calcularTotal(auxPedidos)}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium!
                                                          .copyWith(
                                                            fontFamily:
                                                                'Calibri-Bold',
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (auxPedidos.isEmpty) {
                                                    mostrarPedidoVacio(context);
                                                  } else {
                                                    // Acción al pulsar el botón
                                                    confimacionPedidoModal(
                                                        context, auxPedidos);
                                                  }
                                                },
                                                child: Container(
                                                  height: 55.0,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        blurRadius: 6,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "Confirmar Pedido",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'Calibri-Bold',
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
        );
      },
    );
  }

  /// Muestra un diálogo que contiene la tabla de pedidos.
  ///
  /// El diálogo contiene una tabla con los productos agregados al pedido. Los
  /// productos se pasan como parámetro en la lista [auxPedido].
  ///
  /// Parámetros:
  ///
  ///   - `context` (BuildContext): El contexto de la aplicación.
  ///   - `auxPedido` (List<AuxPedidoModel>): Lista de productos del pedido.
  confimacionPedidoModal(BuildContext context, List<AuxPedidoModel> auxPedido) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding: const EdgeInsets.all(15),
                height: 420,
                width: 600,
                child: SingleChildScrollView(
                    // Llamar el formulario para hacer un comentario
                    child: CarritoTabla(
                  auxPedido: auxPedido,
                  puntoVenta: widget.puntoVenta,
                ))),
          ),
        );
      },
    );
  }

  /// Muestra un diálogo que avisa al usuario que no hay productos en el pedido.
  ///
  /// El diálogo contiene un título, un mensaje y una imagen. Si el usuario hace clic
  /// en el botón "Ir a tienda", se navega a la pantalla de la tienda.
  ///
  /// Parámetros:
  ///
  ///   - `context` (BuildContext): El contexto de la aplicación.
  void mostrarPedidoVacio(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("No hay productos en el pedido"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "¡No hay productos en su pedido! Lo invitamos a que visite nuestra tienda.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              // Muestra una imagen circular del logo de la aplicación
              ClipOval(
                child: Container(
                  width: 100, // Ajusta el tamaño según sea necesario
                  height: 100, // Ajusta el tamaño según sea necesario
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: Image.asset(
                    "assets/img/logo.png",
                    fit: BoxFit.cover, // Ajusta la imagen al contenedor
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Ir a tienda", () {
                    // Cierra el diálogo cuando se hace clic en el botón de aceptar
                    Navigator.pop(context);
                    // Navega a la pantalla de la tienda
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TiendaScreen()));
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Builds a button with a linear gradient and shadow.
  ///
  /// Returns a Container with a Material widget as a child. The Material widget
  /// contains an InkWell widget with the specified `onTap` callback. The
  /// Container has a BoxDecoration with a linear gradient and a shadow.
  ///
  /// Parameters:
  ///   - `text`: The text to be displayed on the button.
  ///   - `onPressed`: The callback function to be called when the button is
  ///                   pressed.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      // The button has a linear gradient
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            botonClaro, // The light color of the gradient
            botonOscuro, // The dark color of the gradient
          ],
        ),
        // The button has a shadow
        boxShadow: const [
          BoxShadow(
            color: botonSombra,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      // The button contains a Material widget
      child: Material(
        color:
            Colors.transparent, // The Material widget has a transparent color
        child: InkWell(
          onTap:
              onPressed, // The InkWell widget triggers the `onPressed` callback
          borderRadius: BorderRadius.circular(
              10), // The InkWell widget has rounded corners
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical:
                    10), // The padding between the text and the button's edge
            child: Center(
              child: Text(
                text, // The text displayed on the button
                style: const TextStyle(
                  color: background1, // The color of the text
                  fontSize: 13, // The font size of the text
                  fontWeight: FontWeight.bold, // The font weight of the text
                  fontFamily: 'Calibri-Bold', // The font family of the text
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Esta función crea una tarjeta deslizante (Dismissible) para mostrar un producto.
  /// La tarjeta permite eliminar el producto al deslizarla hacia la izquierda o derecha.
  /// Además, muestra información del producto y permite modificar la cantidad solicitada.
  ///
  /// @param context El contexto de la aplicación.
  /// @param auxPedido El modelo de pedido auxiliar.
  /// @param producto El modelo del producto.
  /// @param imagen El modelo de imagen del producto.
  /// @return Un widget Dismissible que representa la tarjeta del producto.
  Dismissible cardProduct(
      BuildContext context,
      AuxPedidoModel auxPedido,
      ProductoModel producto,
      ImagenProductoModel imagen,
      List<AuxPedidoModel> auxPedidos) {
    // Ajustar el ancho de la imagen relativo al tamaño de la pantalla
    final double imageWidth = MediaQuery.of(context).size.width * 0.4;
    // Altura fija para la tarjeta
    const double cardHeight = 150.0;

    return Dismissible(
      // Clave única para el widget Dismissible
      key: Key(auxPedido.id.toString()),
      // Fondo mostrado cuando se desliza a la izquierda
      background: Container(
        color: Colors.black.withOpacity(0.5),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      ),
      // Fondo mostrado cuando se desliza a la derecha
      secondaryBackground: Container(
        color: Colors.black.withOpacity(0.5),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      ),
      // Acción al deslizar la tarjeta
      onDismissed: (direction) {
        setState(() {
          borrarProductoModal(context, auxPedido, auxPedidos);
        });
      },
      // Contenido de la tarjeta
      child: Card(
        color: Colors.black.withOpacity(0.5),
        margin: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: imageWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(imagen.imagen),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: primaryColor,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: primaryColor,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: cardHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      producto.nombre,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontFamily: 'Calibri-Bold',
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      "\$${formatter.format(producto.precio)} x ${producto.unidadMedida}",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: 'Calibri-Bold',
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 10),
                    // Caja de texto para la cantidad solicitada
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 6.0,
                            color: primaryColor,
                            offset: Offset(0.0, 1.0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Ajusta el ancho basado en el tamaño del contenedor padre
                          final containerWidth = constraints.maxWidth *
                              0.9; // Puedes ajustar este valor según sea necesario
                          return SizedBox(
                            width: containerWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      final cantidadFinal =
                                          auxPedido.cantidad - 1;
                                      if (cantidadFinal > 0) {
                                        final precioFinal =
                                            cantidadFinal * producto.precio;
                                        _updateAuxPedido(
                                          context,
                                          auxPedido.id,
                                          cantidadFinal,
                                          precioFinal,
                                          auxPedido.producto,
                                          auxPedido.pedido.id,
                                        );
                                      } else {
                                        borrarProductoModal(
                                            context, auxPedido, auxPedidos);
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                Center(
                                  child: Text(
                                    auxPedido.cantidad.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Calibri-Bold',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (auxPedido.cantidad <
                                          producto.maxReserva) {
                                        final cantidadFinal =
                                            auxPedido.cantidad + 1;
                                        final precioFinal =
                                            cantidadFinal * producto.precio;
                                        _updateAuxPedido(
                                          context,
                                          auxPedido.id,
                                          cantidadFinal,
                                          precioFinal,
                                          auxPedido.producto,
                                          auxPedido.pedido.id,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'El limite de reserva del producto son ${producto.maxReserva} unidades.')));
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra un diálogo modal para confirmar la eliminación de un producto del carrito.
  ///
  /// El diálogo solicita al usuario que confirme la eliminación del producto. Si el
  /// usuario hace clic en "Cancelar", se cierra el diálogo. Si el usuario hace clic
  /// en "Eliminar", se elimina el producto del carrito.
  ///
  /// Parámetros:
  ///
  ///   - `context` (BuildContext): El contexto de la aplicación.
  ///   - `auxPedido` (AuxPedidoModel): El modelo que representa el producto que se va
  ///     a eliminar.
  void borrarProductoModal(BuildContext context, AuxPedidoModel auxPedido,
      List<AuxPedidoModel> auxPedidos) {
    // Muestra el diálogo modal para confirmar la eliminación del producto.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("¿Desea eliminar este producto?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Muestra el logo de la aplicación en un contenedor circular.
              ClipOval(
                child: Container(
                  width: 100, // Ajusta el tamaño según sea necesario
                  height: 100, // Ajusta el tamaño según sea necesario
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: Image.asset(
                    "assets/img/logo.png",
                    fit: BoxFit.cover, // Ajusta la imagen al contenedor
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Cancelar", () {
                    Navigator.pop(context);
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Eliminar", () async {
                    Navigator.pop(context);
                    _removeProducto(auxPedido, auxPedidos);
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
