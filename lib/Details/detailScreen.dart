// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import '../Models/auxPedidoModel.dart';
import '../Models/favoritoModel.dart';
import '../Models/imagenProductoModel.dart';
import '../Models/pedidoModel.dart';
import '../Models/usuarioModel.dart';
import '../Tienda/tiendaController.dart';
import '../source.dart';
import 'package:http/http.dart' as http;
import 'sourceDetails/modalsCardAndDetails.dart';

class DetailsScreen extends StatefulWidget {
  final ProductoModel producto;
  const DetailsScreen({super.key, required this.producto});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // URL de la imagen principal
  String mainImageUrl = '';

  var _count = 0;

  bool _isFavorite = false; // variable que almacena si el producto es favorito

  // Lista de URL de miniaturas de imágenes
  List<String> thumbnailUrls = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  // Verificar si el producto es favorito.
  Future<bool> isProductFavorite(int productoId, int userId) async {
    final favoritos = await getFavoritos();

    if (favoritos.isEmpty || favoritos == null) {
      return false; // Devuelve false si no hay favoritos o la lista está vacía
    }
    return favoritos.any((favorito) =>
        favorito.producto.id == productoId && favorito.usuario == userId);
  }

  void _loadImages() async {
    final allImagenes = await getImagenProductos();
    setState(() {
      // Traemos las url de las imagenes relacionadas al produco
      thumbnailUrls = allImagenes
          .where((imagen) => imagen.producto.id == widget.producto.id)
          .map((imagen) => imagen.imagen)
          .toList();
      // Usamos la primera imagen que este dentro de la lista en caso de mezclar usar
      // thumbnailUrls.shuffle();
      mainImageUrl = thumbnailUrls.first;
    });
  }

//  Añadir a favoritos
  Future addFavorite(int usuario) async {
    final String url;

    url = "$sourceApi/api/favoritos/";
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = {
      'usuario': usuario,
      'producto': widget.producto.id,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      setState(() {
        _isFavorite = true;
      });
      print('Datos enviados correctamente');
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

// Remover de favoritos
  Future<void> removeFavoritos(int idUser, int idProducto) async {
    final String url;
    List<FavoritoModel> favoritos = await getFavoritos();

    // Busca el favorito específico basado en idUser y idProducto
    if (favoritos != null) {
      try {
        final favoriteToRemove = favoritos
            .where((favorito) =>
                favorito.usuario == idUser &&
                favorito.producto.id == idProducto)
            .firstOrNull;

        // Depuración: Verificar si se encontró un favorito
        if (favoriteToRemove != null) {
          // Construye la URL con el ID del favorito específico que quieres eliminar
          url = "$sourceApi/api/favoritos/${favoriteToRemove.id}/";

          final headers = {
            'Content-Type': 'application/json',
          };

          final response = await http.delete(
            Uri.parse(url),
            headers: headers,
          );

          if (response.statusCode == 204) {
            setState(() {
              _isFavorite = false;
            });
            print('Datos eliminados correctamente');
          } else {
            print('Error al eliminar datos: ${response.statusCode}');
          }
        } else {
          print('No se encontró el favorito para eliminar.');
        }
      } catch (e) {
        print('Error al buscar el favorito: $e');
      }
    }
  }

  // Futuro para agregar al carrito ya sea crer pedido y aux o solo aux
  Future addProductPedido(UsuarioModel usuario, ProductoModel producto) async {
    final pedidos = await getPedidos();
    final auxPedidos = await getAuxPedidos();
    if (pedidos.isNotEmpty) {
      // Si la lista de pedidos no es vacia buscamos el pedido que el uaurio ya tiene, puede ser nulo.
      final pedidoPendiente = pedidos
          .where((pedido) =>
              pedido.usuario.id == usuario.id &&
              pedido.estado == "PENDIENTE" &&
              pedido.pedidoConfirmado == false)
          .firstOrNull;

      final pedidoNumbers =
          pedidos.map((pedido) => pedido.numeroPedido).toList();

      // buscamos el numero maximo de los pedidos.
      final int anteriorPedido =
          pedidoNumbers.reduce((max, current) => max > current ? max : current);

      if (pedidoPendiente != null) {
        final auxPedidosUsuario = auxPedidos
            .where((auxPedido) => auxPedido.pedido.id == pedidoPendiente.id)
            .toList();

        if (auxPedidosUsuario.isNotEmpty) {
          final isProductAdded = auxPedidosUsuario.any(
              (auxPedidoUsuario) => auxPedidoUsuario.producto == producto.id);

          if (!isProductAdded) {
            // si el producto no se ha añadido.
            if (producto.exclusivo == false) {
              // agrgamos si el producto no es exclusivo
              print('Producto no exclusivo');
              addAuxPedido(producto, pedidoPendiente.id);
            } else if (producto.exclusivo && auxPedidosUsuario.isNotEmpty) {
              print(
                  'producto exclusivo, agregado si ya esta hay mas productos');
              // Añadir el producto exclusivo si ya hay uno o mas productos añadidos
              addAuxPedido(producto, pedidoPendiente.id);
            } else {
              // PRODUCTO EXCLUSIVO, DEBE AÑADIR OTRO PRODUCTO ANTES. modal
              productoExclusivo(context);
            }
          } else {
            isProductAddedModal(context);
            print('EL producto ya se añadió');
          }
        } else {
          // si no hay aux agregamso el producto.
          if (producto.exclusivo == false) {
            // agrgamos si el producto no es exclusivo
            print('Producto no exclusivo');
            addAuxPedido(producto, pedidoPendiente.id);
          } else if (producto.exclusivo && auxPedidosUsuario.isNotEmpty) {
            // Añadir el producto exclusivo si ya hay uno o mas productos añadidos
            addAuxPedido(producto, pedidoPendiente.id);
            print('producto exclusivo, agregado si ya  hay mas productos');
          } else {
            productoExclusivo(context);
          }
        }
      } else {
        await addPedido(anteriorPedido, usuario.id);
        final pedidosNuevo = await getPedidos();
        final pedidoPendiente = pedidosNuevo
            .where((pedido) =>
                pedido.usuario.id == usuario.id &&
                pedido.estado == "PENDIENTE" &&
                pedido.pedidoConfirmado == false)
            .firstOrNull;

        if (producto.exclusivo == false) {
          // agrgamos si el producto no es exclusivo
          print('Producto no exclusivo');
          addAuxPedido(producto, pedidoPendiente!.id);
        } else {
          productoExclusivo(context);
        }

        print('Pedido pendiente es nulo  se crea otro pedido.');
      }
    } // en caso de que la lista sea vacia funcion else... para crear el pedido y el aux del mismo.
    else {
      const int primerPedido = 001000;
      await addPedido(primerPedido, usuario.id);
      final pedidosNuevo = await getPedidos();
      final pedidoPendiente = pedidosNuevo
          .where((pedido) =>
              pedido.usuario.id == usuario.id &&
              pedido.estado == "PENDIENTE" &&
              pedido.pedidoConfirmado == false)
          .firstOrNull;

      if (producto.exclusivo == false) {
        // agrgamos si el producto no es exclusivo
        print('Producto no exclusivo');
        addAuxPedido(producto, pedidoPendiente!.id);
      } else {
        productoExclusivo(context);
      }
      print('lista vacia Creando el primer pedido.');
    }
  }

  Future addPedido(int anteriorPedido, int userID) async {
    final String url = "$sourceApi/api/pedidos/";
    final headers = {
      'Content-Type': 'application/json',
    };
    // Datos como feha encargo y entrega, punto venta, = null
    final body = {
      'numeroPedido': anteriorPedido + 1,
      'grupal': false,
      'estado': 'PENDIENTE',
      'entregado': false,
      'pedidoConfirmado': false,
      'usuario': userID
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      print('Datos enviados correctamente(Pedido nuevo)');
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

  Future addAuxPedido(ProductoModel producto, int pedidoPendienteID) async {
    // agregamos el producto
    final String url = "$sourceApi/api/aux-pedidos/";
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = {
      'cantidad': 1,
      'precio': producto.precio,
      'producto': producto.id,
      'pedido': pedidoPendienteID
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      print('Datos enviados correctamente(auxPedido nuevo)');
      _countPedidos();
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

  Future _countPedidos() async {
    final auxPedidos = await getAuxPedidos();
    final usuario =
        Provider.of<AppState>(context, listen: false).usuarioAutenticado;
    var count = 0;
    if (usuario != null) {
      count = auxPedidos
          .where((auxPedido) =>
              auxPedido.pedido.estado == "PENDIENTE" &&
              auxPedido.pedido.pedidoConfirmado == false &&
              auxPedido.pedido.usuario.id == usuario.id)
          .length;
    } else {
      count = 0;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _count = count;
      });
      Provider.of<Tiendacontroller>(context, listen: false).updateCount(_count);
    });
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final usuarioAutenticado = appState.usuarioAutenticado;
        return Scaffold(
          body: LayoutBuilder(builder: (context, responsive) {
            if (responsive.maxWidth <= 900) {
              var row = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$${formatter.format(producto.precio)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontFamily: 'Calibri-Bold',
                      decoration: TextDecoration
                          .lineThrough, // Añade una línea a través del precio original
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 16), // Espacio entre los precios

                  Text(
                    "\$${formatter.format(producto.precioOferta)}",
                    style: const TextStyle(
                      fontSize: 28,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Calibri-Bold',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Ancho fijo para el diseño de escritorio
                  height: MediaQuery.of(context)
                      .size
                      .height, // Altura fija para el diseño de escritorio
                  child: Scaffold(
                    body: Column(
                      children: [
                        thumbnailUrls.isNotEmpty
                            ?
                            // Imagen principal con miniaturas
                            Expanded(
                                child: Stack(
                                  children: [
                                    // Imagen principal
                                    Positioned.fill(
                                      child: GestureDetector(
                                        onTap: () {
                                          modalAmpliacion(
                                              context, mainImageUrl);
                                        },
                                        child: Image.network(
                                          mainImageUrl,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    // Botón de retroceso
                                    Positioned(
                                      top: 20,
                                      left: 20,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: background1,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  primaryColor.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(
                                                Icons.arrow_back_ios,
                                                size: 24,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Fila de miniaturas
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width, // Ancho fijo para el diseño de escritorio
                                        height: 100,
                                        padding: const EdgeInsets.all(10),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: thumbnailUrls.map((url) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    mainImageUrl = url;
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: mainImageUrl == url
                                                          ? primaryColor
                                                          : Colors
                                                              .transparent, // Color del borde resaltado
                                                      width: mainImageUrl == url
                                                          ? 3
                                                          : 0, // Ancho del borde resaltado
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.5), // Color de la sombra
                                                        spreadRadius:
                                                            1, // Radio de expansión de la sombra
                                                        blurRadius:
                                                            2, // Radio de desenfoque de la sombra
                                                        offset: const Offset(0,
                                                            3), // Desplazamiento de la sombra
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      url,
                                                      width: mainImageUrl == url
                                                          ? 120
                                                          : 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),

                        // Información del Producto
                        Expanded(
                          child: Container(
                            color: background1,
                            padding: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      producto.nombre,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontFamily: 'Calibri-Bold',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Precio',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                          fontFamily: 'Calibri-Bold',
                                          letterSpacing:
                                              1.2, // Espaciado entre letras para destacar más
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                          height:
                                              8), // Espacio entre los textos
                                      row,
                                    ],
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Precio Aprendiz',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                          fontFamily: 'Calibri-Bold',
                                          letterSpacing:
                                              1.2, // Espaciado entre letras para destacar más
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                          height:
                                              8), // Espacio entre los textos
                                      Text(
                                        "\$${formatter.format(producto.precioAprendiz)}",
                                        style: const TextStyle(
                                          fontSize: 28,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Calibri-Bold',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  const Text(
                                    'Descripción',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'Calibri-Bold',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    producto.descripcion,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  const Text(
                                    'Caracteristicas del producto',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'Calibri-Bold',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors
                                                .grey), // Añade un borde gris alrededor del DataTable
                                        borderRadius: BorderRadius.circular(
                                            10), // Opcional: Añade esquinas redondeadas
                                      ),
                                      child: DataTable(
                                        columnSpacing: defaultPadding,
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              'Atributo',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                                fontFamily: 'Calibri-Bold',
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Valor',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                                fontFamily: 'Calibri-Bold',
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: [
                                          DataRow(cells: [
                                            const DataCell(
                                              Text(
                                                'Medida',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                producto.unidadMedida,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(
                                              Text(
                                                'Categoría',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                producto.categoria.nombre,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(
                                              Text(
                                                'Unidad de producción',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                producto
                                                    .unidadProduccion.nombre,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(
                                              Text(
                                                'Sede',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                producto.unidadProduccion.sede
                                                    .nombre,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: defaultPadding),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: Container(
                      color: background1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          height: 85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              if (usuarioAutenticado != null)
                                FutureBuilder<bool>(
                                  future: isProductFavorite(
                                      producto.id, usuarioAutenticado.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    }
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ));
                                    }
                                    _isFavorite = snapshot.data ?? false;

                                    return Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () async {
                                          try {
                                            if (_isFavorite) {
                                              await removeFavoritos(
                                                usuarioAutenticado.id,
                                                producto.id,
                                              );
                                            } else {
                                              await addFavorite(
                                                  usuarioAutenticado.id);
                                            }
                                          } catch (error) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Error: ${error.toString()}')),
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(55),
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                _isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              else
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      inicioSesion(context);
                                    },
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(55),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.favorite_outline,
                                              color: Colors.white, size: 24),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                  width: 10), // Espacio entre botones
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    String text =
                                        "Producto: ${producto.nombre}\n";
                                    text +=
                                        "Descripcion: ${producto.descripcion} \n";
                                    text +=
                                        "Precio: \$${formatter.format(producto.precio)} \n";
                                    text += '\n';
                                    text +=
                                        'Visitanos en nuestra pagina web o aplicacion http://localhost:65500/';
                                    if (UniversalPlatform.isAndroid ||
                                        UniversalPlatform.isIOS) {
                                      Share.share(text);
                                    } else {
                                      modalCompartirWhatsapp(context, text);
                                    }
                                  },
                                  child: Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(55),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.share,
                                            color: Colors.white, size: 24),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width: 10), // Espacio entre botones
                              Expanded(
                                flex: 3, // Este botón ocupará más espacio
                                child: GestureDetector(
                                  onTap: () {
                                    if (usuarioAutenticado != null) {
                                      addProductPedido(
                                          usuarioAutenticado, producto);
                                    } else {
                                      loginPedidoScreen(context);
                                    }
                                  },
                                  child: Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Añadir al carrito",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Calibri-Bold',
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
                    ),
                  ),
                ),
              );
            } else {
              var row = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$${formatter.format(producto.precio)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontFamily: 'Calibri-Bold',
                      decoration: TextDecoration
                          .lineThrough, // Añade una línea a través del precio original
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 16), // Espacio entre los precios

                  Text(
                    "\$${formatter.format(producto.precioOferta)}",
                    style: const TextStyle(
                      fontSize: 28,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Calibri-Bold',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Ancho fijo para el diseño de escritorio
                  height: MediaQuery.of(context)
                      .size
                      .height, // Altura fija para el diseño de escritorio
                  child: Row(
                    children: [
                      thumbnailUrls.isNotEmpty
                          ?
                          // Imagen principal con miniaturas
                          Expanded(
                              flex: 3,
                              child: Stack(
                                children: [
                                  // Imagen principal
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () {
                                        modalAmpliacion(context, mainImageUrl);
                                      },
                                      child: Image.network(
                                        mainImageUrl,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  // Botón de retroceso
                                  Positioned(
                                    top: 20,
                                    left: 20,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: background1,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                primaryColor.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2.0),
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                              size: 24,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Fila de miniaturas
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      width:
                                          800, // Ancho fijo para el diseño de escritorio
                                      height: 100,
                                      padding: const EdgeInsets.all(10),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: thumbnailUrls.map((url) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  mainImageUrl = url;
                                                });
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: mainImageUrl == url
                                                        ? primaryColor
                                                        : Colors
                                                            .transparent, // Color del borde resaltado
                                                    width: mainImageUrl == url
                                                        ? 3
                                                        : 0, // Ancho del borde resaltado
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.5), // Color de la sombra
                                                      spreadRadius:
                                                          1, // Radio de expansión de la sombra
                                                      blurRadius:
                                                          2, // Radio de desenfoque de la sombra
                                                      offset: const Offset(0,
                                                          3), // Desplazamiento de la sombra
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    url,
                                                    width: mainImageUrl == url
                                                        ? 120
                                                        : 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),

                      // Información del Producto
                      Expanded(
                        flex: 2,
                        child: Scaffold(
                          body: Container(
                            color: background1,
                            padding: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      producto.nombre,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontFamily: 'Calibri-Bold',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Precio',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                          fontFamily: 'Calibri-Bold',
                                          letterSpacing:
                                              1.2, // Espaciado entre letras para destacar más
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                          height:
                                              8), // Espacio entre los textos
                                      row
                                    ],
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Precio Aprendiz',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                          fontFamily: 'Calibri-Bold',
                                          letterSpacing:
                                              1.2, // Espaciado entre letras para destacar más
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                          height:
                                              8), // Espacio entre los textos
                                      Text(
                                        "\$${formatter.format(producto.precioAprendiz)}",
                                        style: const TextStyle(
                                          fontSize: 28,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Calibri-Bold',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  const Text(
                                    'Descripción',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'Calibri-Bold',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    producto.descripcion,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  const Text(
                                    'Caracteristicas del producto',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'Calibri-Bold',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors
                                                .grey), // Añade un borde gris alrededor del DataTable
                                        borderRadius: BorderRadius.circular(
                                            10), // Opcional: Añade esquinas redondeadas
                                      ),
                                      child: DataTable(
                                        columnSpacing: defaultPadding,
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              'Atributo',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                                fontFamily: 'Calibri-Bold',
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Valor',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                                fontFamily: 'Calibri-Bold',
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: [
                                          DataRow(cells: [
                                            const DataCell(
                                              Text(
                                                'Medida',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                producto.unidadMedida,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(
                                              Text(
                                                'Categoría',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                producto.categoria.nombre,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(
                                              Text(
                                                'Unidad de producción',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                producto
                                                    .unidadProduccion.nombre,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(
                                              Text(
                                                'Sede',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                producto.unidadProduccion.sede
                                                    .nombre,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: defaultPadding),
                                ],
                              ),
                            ),
                          ),
                          bottomNavigationBar: Container(
                            color: background1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                height: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    if (usuarioAutenticado != null)
                                      FutureBuilder<bool>(
                                        future: isProductFavorite(
                                            producto.id, usuarioAutenticado.id),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.white,
                                            ));
                                          }
                                          if (snapshot.hasError) {
                                            return const Center(
                                                child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ));
                                          }
                                          _isFavorite = snapshot.data ?? false;

                                          return Flexible(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () async {
                                                try {
                                                  if (_isFavorite) {
                                                    await removeFavoritos(
                                                      usuarioAutenticado.id,
                                                      producto.id,
                                                    );
                                                  } else {
                                                    await addFavorite(
                                                        usuarioAutenticado.id);
                                                  }
                                                } catch (error) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Error: ${error.toString()}')),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                height: 55,
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(55),
                                                ),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        _isFavorite
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_outline,
                                                        color: Colors.white,
                                                        size: 24),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    else
                                      Flexible(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            inicioSesion(context);
                                          },
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(55),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.favorite_outline,
                                                    color: Colors.white,
                                                    size: 24),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                        width: 10), // Espacio entre botones
                                    Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          String text =
                                              "Producto: ${producto.nombre}\n";
                                          text +=
                                              "Descripcion: ${producto.descripcion} \n";
                                          text +=
                                              "Precio: ${producto.precio} \n";

                                          if (UniversalPlatform.isAndroid ||
                                              UniversalPlatform.isIOS) {
                                            Share.share(text);
                                          } else {
                                            modalCompartirWhatsapp(
                                                context, text);
                                          }
                                        },
                                        child: Container(
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(55),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.share,
                                                  color: Colors.white,
                                                  size: 24),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 10), // Espacio entre botones
                                    Expanded(
                                      flex: 3, // Este botón ocupará más espacio
                                      child: GestureDetector(
                                        onTap: () {
                                          if (usuarioAutenticado != null) {
                                            addProductPedido(
                                                usuarioAutenticado, producto);
                                          } else {
                                            loginPedidoScreen(context);
                                          }
                                        },
                                        child: Container(
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "Añadir al carrito",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Calibri-Bold',
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        );
      },
    );
  }
}
