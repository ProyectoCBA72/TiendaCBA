// ignore_for_file: prefer_final_fields, file_names, use_super_parameters, library_private_types_in_public_api, avoid_print, non_constant_identifier_names, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Details/detailScreen.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/favoritoModel.dart';
import 'package:tienda_app/Models/pedidoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/Models/visitadoModel.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/source.dart';
import 'package:http/http.dart' as http;
import 'Auth/authScreen.dart';

class CardProducts extends StatefulWidget {
  final List<String> imagenes;
  final ProductoModel producto;
  const CardProducts({Key? key, required this.producto, required this.imagenes})
      : super(key: key);

  @override
  _CardProductsState createState() => _CardProductsState();
}

class _CardProductsState extends State<CardProducts> {
  int _currentImageIndex = 0;
  Timer? _timer;
  List<String> _images = [];
  bool _isOnSale = true; // Variable que indica si el producto está en oferta
  bool _isFavorite = false;
  int _count = 0;
  @override
  void initState() {
    super.initState();
    _loadImages();
    _countPedidos();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

// Verificar si el producto es favorito.
  Future<bool> isProductFavorite(int productoId, int userId) async {
    final favoritos = await getFavoritos();

    if (favoritos == null || favoritos.isEmpty) {
      return false; // Devuelve false si no hay favoritos o la lista está vacía
    }
    return favoritos.any((favorito) =>
        favorito.producto.id == productoId && favorito.usuario == userId);
  }

// Verificar si el produto ya esta en visitados.  y hacer el post en caso de que no.
  Future isProductVisitado(int productoId, int userId) async {
    final visitados = await getVisitados();

    if (visitados.isNotEmpty) {
      final visitado = visitados
          .where((visitado) =>
              visitado.producto.id == productoId && visitado.usuario == userId)
          .firstOrNull;

      if (visitado == null) {
        // Como es nulo creamos un registro.
        addVisitado(userId, productoId);
      }
    } else {
      // si la lista es vacia creamos el registro
      addVisitado(userId, productoId);
    }
  }

  // funcion para agregar a visitado
  Future addVisitado(int usuario, int productoId) async {
    final String url;

    url = "$sourceApi/api/visitados/";
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = {
      'usuario': usuario,
      'producto': productoId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      print('Datos enviados correctamente');
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
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

  void _loadImages() async {
    _images = widget.imagenes;
  }

  // Futuro para agregar al carrito ya sea crer pedido y aux o solo aux
  Future addProductPedido(UsuarioModel usuario, ProductoModel producto) async {
    final pedidos = await getPedidos();
    final auxPedidos = await getAuxPedidos();
    print('Pedidos $pedidos');
    print('auxpedidos $auxPedidos');
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
          // si no hay aux agregamso el prodiuto.
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
        addPedido(anteriorPedido, usuario.id);
        addAuxPedido(producto, anteriorPedido + 1);
        print('Pedido pendiente es nulo  se crea otro pedido.');
      }
    } // en caso de que la lista sea vacia funcion else... para crear el pedido y el aux del mismo.
    else {
      const int primerPedido = 001000;
      addPedido(primerPedido, usuario.id);
      addAuxPedido(producto, primerPedido + 1);
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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
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
    setState(() {
      _count = count;
    });
    Provider.of<Tiendacontroller>(context, listen: false).updateCount(_count);
  }

  @override
  Widget build(BuildContext context) {
    final ProductoModel producto = widget.producto;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final usuarioAutenticado = appState.usuarioAutenticado;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            onTap: () {
              // Add to visits
              if (usuarioAutenticado != null) {
                isProductVisitado(producto.id, usuarioAutenticado.id);
              }
              // details Screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => DetailsScreen(producto: producto)));
            },
            onHover: (isHovered) {
              if (isHovered) {
                _startTimer();
              } else {
                _timer?.cancel();
              }
            },
            child: Stack(
              children: [
                _images.isNotEmpty
                    ? AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: FadeTransition(
                          key: ValueKey<int>(_currentImageIndex),
                          opacity: const AlwaysStoppedAnimation(1),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    NetworkImage(_images[_currentImageIndex]),
                                fit: BoxFit.fill,
                              ),
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x000005cc),
                                  blurRadius: 30,
                                  offset: Offset(10, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Stack(
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
                                                  CircularProgressIndicator());
                                        }
                                        if (snapshot.hasError) {
                                          return const Center(
                                              child: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ));
                                        }
                                        _isFavorite = snapshot.data ?? false;

                                        return Positioned(
                                          top: 5,
                                          left: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black38,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: IconButton(
                                              icon: _isFavorite
                                                  ? const Icon(Icons.favorite,
                                                      color: Colors.white)
                                                  : const Icon(
                                                      Icons.favorite_border,
                                                      color: Colors.white),
                                              onPressed: () async {
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
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  else
                                    Positioned(
                                      top: 5,
                                      left: 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                              Icons.favorite_border,
                                              color: Colors.white),
                                          onPressed: () {
                                            _InicioSesion(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.shopping_cart,
                                            color: Colors.white),
                                        onPressed: () {
                                          // Acción al presionar el carrito de compra
                                          if (usuarioAutenticado != null) {
                                            addProductPedido(
                                                usuarioAutenticado, producto);
                                          } else {
                                            loginPedidoScreen(context);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 6,
                                    left: 5,
                                    child: Container(
                                      width: 200,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              producto.nombre,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                fontFamily: 'Calibri-Bold',
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              _isOnSale
                                                  ? "\$${formatter.format(
                                                      producto.precioOferta)}"
                                                  : "\$${formatter
                                                      .format(producto.precio)}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: _isOnSale
                                                    ? Colors.white
                                                    : Colors.red,
                                                decoration: _isOnSale
                                                    ? null
                                                    : TextDecoration
                                                        .lineThrough,
                                              ),
                                            ),
                                            if (_isOnSale)
                                              const Text(
                                                "Oferta!",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }

  void _InicioSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("¿Quiere agregar a favoritos?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("¡Para agregar a favoritos, debe iniciar sesión!"),
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
                  child: _buildButton("Cancelar", () {
                    Navigator.pop(context);
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Iniciar Sesión", () {
                    // ignore: prefer_const_constructors
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  void isProductAddedModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("¡Este producto ya está agregado!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("El producto seleccionado ya está en su pedido."),
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
                  child: _buildButton("Aceptar", () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void productoExclusivo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("¿Quiere agregar un producto exclusivo?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  "¡Tenga en cuenta que, para agregar un producto exclusivo como los huevos, tiene que agregar previamente otro producto!"),
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
                  child: _buildButton("Aceptar", () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void loginPedidoScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("¿Quiere agregar un producto a su pedido?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("¡Para agregar un pedido, debe iniciar sesión!"),
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
                  child: _buildButton("Cancelar", () {
                    Navigator.pop(context);
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Iniciar Sesión", () {
                    // ignore: prefer_const_constructors
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }),
                )
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
}
