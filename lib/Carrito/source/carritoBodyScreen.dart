// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Carrito/carritoScreen.dart';
import 'package:tienda_app/Carrito/source/carritoTabla.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Tienda/tiendaScreen.dart';
import 'package:tienda_app/source.dart';
import '../../Models/productoModel.dart';
import '../../provider.dart';
import '../../Models/auxPedidoModel.dart';
import '../../constantsDesign.dart';
import 'package:http/http.dart' as http;

class CarritoBodyScreen extends StatefulWidget {
  const CarritoBodyScreen({super.key});

  @override
  State<CarritoBodyScreen> createState() => _CarritoBodyScreenState();
}

class _CarritoBodyScreenState extends State<CarritoBodyScreen> {
// futuro para actualizar la cantidad y el precio del aux pedido.
  Future<void> _updateAuxPedido(
      int id, int cantidad, int precio, int producto, int pedido) async {
    try {
      final url = Uri.parse('$sourceApi/api/aux-pedidos/$id/');

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

      if (response.statusCode == 200) {
        print('Pedido actualizado con éxito.');
      } else {
        print('Error al actualizar el pedido: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _removeProducto(int id) async {
    try {
      final url = Uri.parse('$sourceApi/api/aux-pedidos/$id/');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        print('producto eliminado.');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const CarritoScreen()));
      } else {
        print('Error al eliminar el producto: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }

// funcion para calcular el total de los productos, aun se trabaja ( cambio )
  String calcularTotal(List<AuxPedidoModel> pedidos) {
    double suma = 0.0;
    for (AuxPedidoModel pedido in pedidos) {
      suma += pedido.precio;
    }
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
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
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                  } else {
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
                        if (snapshotProductos.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshotProductos.hasError) {
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
                        } else if (!snapshotProductos.hasData ||
                            snapshotProductos.data!.isEmpty) {
                          return Center(
                              child: Text(
                            'No hay producto relaciondo error.',
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
                        } else {
                          return FutureBuilder(
                            future: getImagenProductos(),
                            builder: (context, snapshotImagenes) {
                              if (snapshotImagenes.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshotImagenes.hasError) {
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
                              } else if (!snapshotImagenes.hasData ||
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
                              } else {
                                // donde contruimos las cards de los productos.
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
                                                // buscamos el producto.
                                                final producto = productos
                                                    .firstWhere((prod) =>
                                                        prod.id ==
                                                        auxPedido.producto);
                                                // buscamos la primera imagen del producto en cuestion.
                                                final imagenProd = imagenesTotal
                                                    .firstWhere((imagen) =>
                                                        imagen.producto.id ==
                                                        auxPedido.producto);
                                                return cardProduct(
                                                  context,
                                                  auxPedido,
                                                  producto,
                                                  imagenProd,
                                                );
                                              },
                                            ),
                                    ),
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

  confimacionPedidoModal(context, List<AuxPedidoModel> auxPedido) {
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
                ))),
          ),
        );
      },
    );
  }

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
                    Navigator.pop(context);
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

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            botonClaro,
            botonOscuro,
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: botonSombra,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
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
    );
  }

  Dismissible cardProduct(BuildContext context, AuxPedidoModel auxPedido,
      ProductoModel producto, ImagenProductoModel imagen) {
    final double imageWidth = MediaQuery.of(context).size.width *
        0.4; // Ajustar el ancho de la imagen relativo al tamaño de la pantalla
    const double cardHeight = 150.0; // Altura fija para la tarjeta

    return Dismissible(
      key: Key(auxPedido.id.toString()),
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
      onDismissed: (direction) {
        setState(() {
          borrarProductoModal(context, auxPedido);
        });
      },
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
                    Container(
                      width: imageWidth * 0.6,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                final cantidadFinal = auxPedido.cantidad - 1;
                                if (cantidadFinal > 0) {
                                  final precioFinal =
                                      cantidadFinal * producto.precio;
                                  _updateAuxPedido(
                                    auxPedido.id,
                                    cantidadFinal,
                                    precioFinal,
                                    auxPedido.producto,
                                    auxPedido.pedido.id,
                                  );
                                } else {
                                  borrarProductoModal(context, auxPedido);
                                }
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                auxPedido.cantidad.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Calibri-Bold',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (auxPedido.cantidad < producto.maxReserva) {
                                  final cantidadFinal = auxPedido.cantidad + 1;
                                  final precioFinal =
                                      cantidadFinal * producto.precio;
                                  _updateAuxPedido(
                                      auxPedido.id,
                                      cantidadFinal,
                                      precioFinal,
                                      auxPedido.producto,
                                      auxPedido.pedido.id);
                                }
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
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

  void borrarProductoModal(BuildContext context, AuxPedidoModel auxPedido) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("¿Desea eliminar este producto?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
                  child: _buildButton("Eliminar", () {
                    Navigator.pop(context);
                    _removeProducto(auxPedido.id);
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
