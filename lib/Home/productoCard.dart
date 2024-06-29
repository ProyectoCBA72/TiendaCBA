// ignore_for_file: prefer_final_fields, file_names, use_super_parameters, library_private_types_in_public_api, unnecessary_null_comparison, avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:tienda_app/Auth/authScreen.dart';
import 'package:tienda_app/Details/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/favoritoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/visitadoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/source.dart';
import 'package:http/http.dart' as http;

class ProductoCard extends StatefulWidget {
  final List<String> imagenes;
  final ProductoModel producto;
  const ProductoCard({Key? key, required this.imagenes, required this.producto})
      : super(key: key);

  @override
  _ProductoCardState createState() => _ProductoCardState();
}

class _ProductoCardState extends State<ProductoCard> {
  int _currentImageIndex = 0;
  Timer? _timer;
  List<String> _images = [];
  bool _isOnSale = true; // Variable que indica si el producto está en oferta
  bool _isFavorite = false;
  @override
  void initState() {
    super.initState();
    _loadImages();
    _initializeFavoriteState();
  }

  Future<void> _initializeFavoriteState() async {
    final usuarioAutenticado =
        Provider.of<AppState>(context, listen: false).usuarioAutenticado;
    if (usuarioAutenticado != null) {
      bool isFavorite =
          await isProductFavorite(widget.producto.id, usuarioAutenticado.id);
      setState(() {
        _isFavorite = isFavorite;
      });
    }
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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductoModel producto = widget.producto;

    return Consumer<AppState>(builder: (context, appState, _) {
      final usuarioAutenticado = appState.usuarioAutenticado;

      return Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 400,
          height: 200,
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
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Stack(
                                children: [
                                  if (usuarioAutenticado != null)
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
                                                    producto.id);
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
                                                  ? "\$${formatter.format(producto.precioOferta)}"
                                                  : "\$${formatter.format(producto.precio)}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: _isOnSale
                                                    ? Colors.white
                                                    : primaryColor,
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
        ),
      );
    });
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
              const Text("¡Para agregar a favoritos debe iniciar sesión!"),
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
