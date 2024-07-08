// ignore_for_file: prefer_final_fields, file_names, use_super_parameters, library_private_types_in_public_api, unnecessary_null_comparison, avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:tienda_app/Auth/authScreen.dart';
import 'package:tienda_app/Details/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Details/sourceDetails/modalsCardAndDetails.dart';
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

/// Widget que representa una tarjeta de producto.
///
/// Es un [StatefulWidget] que muestra una tarjeta con las imágenes
/// del producto y algunos detalles del mismo. El widget acepta dos parámetros,
/// [imagenes] y [producto], que son obligatorios.
class ProductoCard extends StatefulWidget {
  /// Lista de imágenes del producto.
  final List<String> imagenes;

  /// Modelo del producto.
  final ProductoModel producto;

  /// Constructor del widget.
  ///
  /// Toma dos parámetros necesarios: [imagenes] y [producto].
  const ProductoCard({Key? key, required this.imagenes, required this.producto})
      : super(key: key);

  @override
  _ProductoCardState createState() => _ProductoCardState();
}

class _ProductoCardState extends State<ProductoCard> {
  /// Índice de la imagen actualmente mostrada.
  int _currentImageIndex = 0;

  /// Contador de tiempo para la animación de cambio de imagen.
  Timer? _timer;

  /// Lista de rutas de las imágenes del producto.
  List<String> _images = [];

  /// Variable booleana que indica si el producto está en oferta.
  ///
  /// El valor por defecto es `true`.
  bool _isOnSale = true;

  /// Variable booleana que indica si el producto está marcado como favorito.
  ///
  /// El valor por defecto es `false`.
  bool _isFavorite = false;

  /// Contador de veces que se ha visitado el producto.
  int _count = 0;

  /// Objeto del usuario actual.
  ///
  /// Es de tipo [UsuarioModel] y se utiliza para obtener el estado de favorito del producto.
  UsuarioModel? _usuario;
  @override

  /// Inicializa el estado del widget.
  ///
  /// Se llama automáticamente cuando se crea el widget. En este método, se
  /// inicializan las variables y se llama a los métodos necesarios para cargar
  /// las imágenes y obtener el estado de favorito del producto.
  @override
  void initState() {
    super.initState();

    // Inicializa el estado del widget.
    // Dado que las imágenes pueden tardar en cargar, se llama a _initialize() para
    // cargar las imágenes. Además, se llama a _countPedidos() para obtener el
    // número de pedidos del producto y _initializeFavoriteState() para obtener
    // el estado de favorito del producto.
    _initialize();
  }

  /// Inicializa el estado del widget.
  ///
  /// Se llama automáticamente cuando se crea el widget. En este método, se
  /// inicializan las variables y se llama a los métodos necesarios para cargar
  /// las imágenes y obtener el estado de favorito del producto.
  ///
  /// Este método se encarga de obtener el usuario autenticado, cargar las imágenes
  /// del producto, obtener el número de pedidos del producto y el estado de favorito
  /// del producto.
  Future<void> _initialize() async {
    // Obtiene el usuario autenticado
    _usuario = Provider.of<AppState>(context, listen: false).usuarioAutenticado;

    // Carga las imágenes del producto
    await _loadImages();

    // Obtiene el número de pedidos del producto
    _countPedidos();

    // Obtiene el estado de favorito del producto
    _initializeFavoriteState();
  }

  /// Inicializa el estado del widget relacionado con el estado de favorito.
  ///
  /// Este método obtiene el usuario autenticado, verifica si el producto es favorito
  /// y actualiza el estado correspondiente.
  Future<void> _initializeFavoriteState() async {
    // Obtiene el usuario autenticado
    final usuarioAutenticado =
        Provider.of<AppState>(context, listen: false).usuarioAutenticado;

    // Verifica si el usuario autenticado no es nulo
    if (usuarioAutenticado != null) {
      // Verifica si el producto es favorito
      bool isFavorite = await isProductFavorite(
        widget.producto.id,
        usuarioAutenticado.id,
      );

      // Actualiza el estado correspondiente
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  @override

  /// Limpia los recursos utilizados por el widget.
  ///
  /// Cancela el temporizador [_timer] y llama al método [dispose] del widget base.
  /// Además, llama al método [_countPedidos] para obtener el número de pedidos del
  /// producto antes de finalizar la limpieza.
  @override
  void dispose() {
    // Cancela el temporizador si está activo
    _timer?.cancel();

    // Llama al método [dispose] del widget base
    super.dispose();

    // Llama al método [_countPedidos] para obtener el número de pedidos del producto
    _countPedidos();
  }

// Verificar si el producto es favorito.
  /// Verifica si el producto especificado está en los favoritos del usuario especificado.
  ///
  /// El [productoId] es el ID del producto a verificar.
  /// El [userId] es el ID del usuario a verificar.
  /// Devuelve [true] si el producto está en los favoritos, [false] de lo contrario.
  /// Si no se encuentran favoritos o la lista está vacía, devuelve [false].
  Future<bool> isProductFavorite(int productoId, int userId) async {
    // Obtiene la lista de favoritos del usuario
    final favoritos = await getFavoritos();

    // Verifica si la lista de favoritos es nula o está vacía
    if (favoritos == null || favoritos.isEmpty) {
      return false; // Devuelve false si no hay favoritos o la lista está vacía
    }

    // Verifica si algún elemento de la lista cumple con la condición de coincidir con el producto y el usuario
    return favoritos.any((favorito) =>
        favorito.producto.id == productoId && favorito.usuario == userId);
  }

// Verificar si el produto ya esta en visitados.  y hacer el post en caso de que no.
  /// Verifica si el producto especificado ha sido visitado por el usuario especificado.
  ///
  /// El [productoId] es el ID del producto a verificar.
  /// El [userId] es el ID del usuario a verificar.
  /// Si el producto no ha sido visitado, se registra el visitado.
  Future isProductVisitado(int productoId, int userId) async {
    // Obtiene la lista de visitados del usuario
    final visitados = await getVisitados();

    // Verifica si la lista de visitados es nula o está vacía
    if (visitados.isNotEmpty) {
      // Busca un visitado que coincida con el producto y el usuario
      final visitado = visitados
          .where((visitado) =>
              visitado.producto.id == productoId && visitado.usuario == userId)
          .firstOrNull;

      // Si no se encuentra un visitado para el producto y el usuario, se registra uno nuevo
      if (visitado == null) {
        addVisitado(userId, productoId);
      }
    } else {
      // Si la lista de visitados está vacía, se registra un nuevo visitado
      addVisitado(userId, productoId);
    }
  }

  // funcion para agregar a visitado
  /// Agrega un visitado para el usuario y el producto especificados.
  ///
  /// El [usuario] es el ID del usuario a asociar al visitado.
  /// El [productoId] es el ID del producto a asociar al visitado.
  /// Si la operación de inserción es exitosa, se imprime 'Datos enviados correctamente'.
  /// Si hay un error en la operación de inserción, se imprime 'Error al enviar datos: {estadoHTTP}'.
  Future addVisitado(int usuario, int productoId) async {
    // Construye la dirección URL de la API
    final String url = "$sourceApi/api/visitados/";

    // Define los encabezados de la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Define el cuerpo de la solicitud (JSON)
    final body = {
      'usuario': usuario,
      'producto': productoId,
    };

    // Envía una solicitud POST a la API con los datos del visitado
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Verifica el estado de la respuesta HTTP
    if (response.statusCode == 201) {
      // Imprime un mensaje de éxito si la operación de inserción es exitosa
      print('Datos enviados correctamente');
    } else {
      // Imprime un mensaje de error si hay un error en la operación de inserción
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

//  Añadir a favoritos
  /// Agrega un producto al favorito del usuario especificado.
  ///
  /// El [usuario] es el ID del usuario a asociar al favorito.
  /// Si la operación de inserción es exitosa, el estado del favorito se actualiza y se imprime 'Datos enviados correctamente'.
  /// Si hay un error en la operación de inserción, se imprime 'Error al enviar datos: {estadoHTTP}'.
  Future addFavorite(int usuario) async {
    // Construye la dirección URL de la API
    final String url = "$sourceApi/api/favoritos/";

    // Define los encabezados de la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Define el cuerpo de la solicitud (JSON)
    final body = {
      'usuario': usuario,
      'producto': widget.producto.id,
    };

    // Envía una solicitud POST a la API con los datos del favorito
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Verifica el estado de la respuesta HTTP
    if (response.statusCode == 201) {
      // Actualiza el estado del favorito en la interfaz de usuario y muestra un mensaje de éxito
      setState(() {
        _isFavorite = true;
      });
      print('Datos enviados correctamente');
    } else {
      // Muestra un mensaje de error si hay un error en la operación de inserción
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

// Remover de favoritos
  /// Función para eliminar un favorito específico basado en el ID del usuario y el ID del producto.
  ///
  /// El [idUser] es el ID del usuario a asociar al favorito.
  /// El [idProducto] es el ID del producto a asociar al favorito.
  /// Si la operación de eliminación es exitosa, el estado del favorito se actualiza y se imprime 'Datos eliminados correctamente'.
  /// Si hay un error en la operación de eliminación, se imprime 'Error al eliminar datos: {estadoHTTP}'.
  Future<void> removeFavoritos(int idUser, int idProducto) async {
    // Inicializa la URL de la API
    final String url;

    // Obtiene la lista de favoritos
    List<FavoritoModel> favoritos = await getFavoritos();

    // Busca el favorito específico basado en idUser y idProducto
    if (favoritos != null) {
      try {
        // Busca el favorito específico en la lista de favoritos
        final favoriteToRemove = favoritos
            .where((favorito) =>
                favorito.usuario == idUser &&
                favorito.producto.id == idProducto)
            .firstOrNull;

        // Verifica si se encontró un favorito para eliminar
        if (favoriteToRemove != null) {
          // Construye la URL con el ID del favorito específico que quieres eliminar
          url = "$sourceApi/api/favoritos/${favoriteToRemove.id}/";

          // Define los encabezados de la solicitud
          final headers = {
            'Content-Type': 'application/json',
          };

          // Envía una solicitud DELETE a la API con el ID del favorito específico
          final response = await http.delete(
            Uri.parse(url),
            headers: headers,
          );

          // Verifica el estado de la respuesta HTTP
          if (response.statusCode == 204) {
            // Actualiza el estado del favorito en la interfaz de usuario y muestra un mensaje de éxito
            setState(() {
              _isFavorite = false;
            });
            print('Datos eliminados correctamente');
          } else {
            // Muestra un mensaje de error si hay un error en la operación de eliminación
            print('Error al eliminar datos: ${response.statusCode}');
          }
        } else {
          // Muestra un mensaje de error si no se encontró el favorito para eliminar
          print('No se encontró el favorito para eliminar.');
        }
      } catch (e) {
        // Muestra un mensaje de error si hay un error al buscar el favorito
        print('Error al buscar el favorito: $e');
      }
    }
  }

  /// Carga las imágenes asociadas al widget.
  ///
  /// Este método asigna la lista de imágenes proporcionadas por el widget
  /// a la variable [_images].
  ///
  /// No devuelve nada.
  Future<void> _loadImages() async {
    // Asigna la lista de imágenes proporcionadas por el widget a la variable _images
    _images = widget.imagenes;
  }

  /// Futuro para agregar al carrito ya sea creando un nuevo pedido y aux o solo el aux.
  Future addProductPedido(UsuarioModel usuario, ProductoModel producto) async {
    // Obtener los pedidos actuales y los pedidos auxiliares
    final pedidos = await getPedidos();
    final auxPedidos = await getAuxPedidos();

    if (pedidos.isNotEmpty) {
      // Si la lista de pedidos no está vacía, buscar el pedido pendiente del usuario, si existe.
      final pedidoPendiente = pedidos
          .where((pedido) =>
              pedido.usuario.id == usuario.id &&
              pedido.estado == "PENDIENTE" &&
              pedido.pedidoConfirmado == false)
          .firstOrNull;

      // Obtener los números de los pedidos
      final pedidoNumbers =
          pedidos.map((pedido) => pedido.numeroPedido).toList();

      // Buscar el número máximo de los pedidos
      final int anteriorPedido =
          pedidoNumbers.reduce((max, current) => max > current ? max : current);

      if (pedidoPendiente != null) {
        // Obtener los pedidos auxiliares del usuario
        final auxPedidosUsuario = auxPedidos
            .where((auxPedido) => auxPedido.pedido.id == pedidoPendiente.id)
            .toList();

        if (auxPedidosUsuario.isNotEmpty) {
          // Verificar si el producto ya ha sido añadido
          final isProductAdded = auxPedidosUsuario.any(
              (auxPedidoUsuario) => auxPedidoUsuario.producto == producto.id);

          if (!isProductAdded) {
            // Si el producto no ha sido añadido
            if (producto.exclusivo == false) {
              // Agregar el producto si no es exclusivo
              print('Producto no exclusivo');
              addAuxPedido(producto, pedidoPendiente.id);
            } else if (producto.exclusivo && auxPedidosUsuario.isNotEmpty) {
              // Añadir el producto exclusivo si ya hay uno o más productos añadidos
              print('Producto exclusivo, agregado si ya hay más productos');
              addAuxPedido(producto, pedidoPendiente.id);
            } else {
              // Producto exclusivo, debe añadir otro producto antes. Mostrar modal
              productoExclusivo(context);
            }
          } else {
            // Mostrar modal si el producto ya ha sido añadido
            isProductAddedModal(context);
            print('El producto ya se añadió');
          }
        } else {
          // Si no hay pedidos auxiliares, agregar el producto
          if (producto.exclusivo == false) {
            // Agregar el producto si no es exclusivo
            print('Producto no exclusivo');
            addAuxPedido(producto, pedidoPendiente.id);
          } else if (producto.exclusivo && auxPedidosUsuario.isNotEmpty) {
            // Añadir el producto exclusivo si ya hay uno o más productos añadidos
            addAuxPedido(producto, pedidoPendiente.id);
            print('Producto exclusivo, agregado si ya hay más productos');
          } else {
            productoExclusivo(context);
          }
        }
      } else {
        // Crear un nuevo pedido si no existe un pedido pendiente
        await addPedido(anteriorPedido, usuario.id);
        final pedidosNuevo = await getPedidos();
        final pedidoPendiente = pedidosNuevo
            .where((pedido) =>
                pedido.usuario.id == usuario.id &&
                pedido.estado == "PENDIENTE" &&
                pedido.pedidoConfirmado == false)
            .firstOrNull;

        if (producto.exclusivo == false) {
          // Agregar el producto si no es exclusivo
          print('Producto no exclusivo');
          addAuxPedido(producto, pedidoPendiente!.id);
        } else {
          productoExclusivo(context);
        }

        print('Pedido pendiente es nulo, se crea otro pedido.');
      }
    } else {
      // Si la lista de pedidos está vacía, crear el primer pedido y su aux
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
        // Agregar el producto si no es exclusivo
        print('Producto no exclusivo');
        addAuxPedido(producto, pedidoPendiente!.id);
      } else {
        productoExclusivo(context);
      }
      print('Lista vacía, creando el primer pedido.');
    }
  }

  /// Futuro para agregar un nuevo pedido a la base de datos.
  ///
  /// Toma el número del pedido anterior y el ID del usuario, y crea un nuevo pedido con estos datos.
  ///
  /// @param anteriorPedido El número del pedido anterior.
  /// @param userID El ID del usuario.
  /// @return Un Future que completa cuando el pedido ha sido añadido.
  Future addPedido(int anteriorPedido, int userID) async {
    final String url = "$sourceApi/api/pedidos/";
    final headers = {
      'Content-Type': 'application/json',
    };

    // Datos del pedido: número de pedido, usuario, y estado del pedido
    final body = {
      'numeroPedido': anteriorPedido + 1,
      'grupal': false,
      'estado': 'PENDIENTE',
      'entregado': false,
      'pedidoConfirmado': false,
      'usuario': userID
    };

    // Enviar la solicitud POST para agregar el nuevo pedido
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Verificar la respuesta de la solicitud
    if (response.statusCode == 201) {
      print('Datos enviados correctamente (Pedido nuevo)');
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

  /// Futuro para agregar un producto al pedido auxiliar.
  ///
  /// Toma el modelo del producto y el ID del pedido pendiente, y crea un nuevo pedido auxiliar con estos datos.
  ///
  /// @param producto El modelo del producto que se va a añadir.
  /// @param pedidoPendienteID El ID del pedido pendiente.
  /// @return Un Future que completa cuando el pedido auxiliar ha sido añadido.
  Future addAuxPedido(ProductoModel producto, int pedidoPendienteID) async {
    // URL del API para agregar el pedido auxiliar
    final String url = "$sourceApi/api/aux-pedidos/";
    final headers = {
      'Content-Type': 'application/json',
    };

    // Datos del pedido auxiliar: cantidad, precio, producto y pedido pendiente
    final body = {
      'cantidad': 1,
      'precio': producto.precio,
      'producto': producto.id,
      'pedido': pedidoPendienteID
    };

    // Enviar la solicitud POST para agregar el nuevo pedido auxiliar
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Verificar la respuesta de la solicitud
    if (response.statusCode == 201) {
      print('Datos enviados correctamente (auxPedido nuevo)');
      _countPedidos();
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

  /// Inicia un temporizador que cambia el índice de la imagen actual cada 3 segundos.
  ///
  /// Cada vez que el temporizador se activa, se actualiza el estado del widget
  /// para mostrar la siguiente imagen en la lista de imágenes. El índice de la imagen
  /// se incrementa en uno y se reinicia a 0 cuando alcanza el final de la lista.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  /// Futuro para contar el número de pedidos auxiliares pendientes del usuario actual.
  ///
  /// Obtiene los pedidos auxiliares y cuenta cuántos de ellos están en estado "PENDIENTE"
  /// y no están confirmados, y pertenecen al usuario actual. Luego actualiza el estado
  /// con el conteo y notifica al controlador de la tienda.
  ///
  /// @return Un Future que completa cuando el conteo ha sido realizado y el estado actualizado.
  Future<void> _countPedidos() async {
    // Obtener los pedidos auxiliares actuales
    final auxPedidos = await getAuxPedidos();
    var count = 0;

    // Verificar si el usuario está definido
    if (_usuario != null) {
      // Contar los pedidos auxiliares pendientes y no confirmados del usuario actual
      count = auxPedidos
          .where((auxPedido) =>
              auxPedido.pedido.estado == "PENDIENTE" &&
              auxPedido.pedido.pedidoConfirmado == false &&
              auxPedido.pedido.usuario.id == _usuario!.id)
          .length;
    } else {
      count = 0;
    }

    // Actualizar el estado del widget y notificar al controlador de la tienda
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _count = count;
      });
      // Notificar al controlador de la tienda del nuevo conteo
      Provider.of<Tiendacontroller>(context, listen: false).updateCount(_count);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductoModel producto = widget.producto;

    // Construye el widget dependiendo del estado de la aplicación.
    return Consumer<AppState>(builder: (context, appState, _) {
      final usuarioAutenticado = appState.usuarioAutenticado;

      return Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 400,
          height: 200,
          child: InkWell(
            onTap: () {
              // Añadir a visitas si el usuario está autenticado.
              if (usuarioAutenticado != null) {
                isProductVisitado(producto.id, usuarioAutenticado.id);
              }
              // Navegar a la pantalla de detalles del producto.
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
                // Mostrar imagen del producto si está disponible.
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
                                  // Mostrar botón de favoritos si el usuario está autenticado.
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
                                    // Mostrar botón de inicio de sesión si el usuario no está autenticado.
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
                                  // Botón del carrito de compras (sin funcionalidad específica).
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
                                  // Información del producto (nombre, precio, estado de oferta).
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
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            if (_isOnSale)
                                              const Text(
                                                "¡Oferta!",
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

  /// Muestra un diálogo de alerta para indicar que el usuario debe iniciar sesión
  /// antes de agregar un producto a favoritos.
  ///
  /// El diálogo muestra una imagen circular del logo de la aplicación y dos botones:
  /// uno para cancelar y otro para iniciar sesión.
  ///
  /// [context]: el contexto del widget actual.
  void _InicioSesion(BuildContext context) {
    // Muestra un diálogo de alerta
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Título del diálogo
          title: const Text("¿Quiere agregar a favoritos?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Texto de descripción
              const Text("¡Para agregar a favoritos debe iniciar sesión!"),
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
                // Botón para cancelar
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Cancelar", () {
                    Navigator.pop(context);
                  }),
                ),
                // Botón para iniciar sesión
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Iniciar Sesión", () {
                    // Navega a la pantalla de inicio de sesión
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

  /// Construye un botón con el texto y la función de llamada proporcionados.
  ///
  /// El botón tiene un estilo y sombra personalizados. El texto del botón
  /// está centrado verticalmente y tiene un estilo específico.
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se llamará cuando se presione
  /// el botón.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200, // Ancho del botón
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Radio del borde redondeado
        gradient: const LinearGradient(
          // Gradiente de color
          colors: [
            botonClaro, // Color inicial del gradiente
            botonOscuro, // Color final del gradiente
          ],
        ),
        boxShadow: const [
          // Sombra del botón
          BoxShadow(
            color: botonSombra, // Color de la sombra
            blurRadius: 5, // Radio de la sombra
            offset: Offset(0, 3), // Posición de la sombra
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Color de fondo transparente
        child: InkWell(
          onTap: onPressed, // Función de llamada cuando se presiona el botón
          borderRadius: BorderRadius.circular(10), // Radio del borde redondeado
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10), // Padding vertical
            child: Center(
              child: Text(
                text, // Texto del botón
                style: const TextStyle(
                  color: background1, // Color del texto
                  fontSize: 13, // Tamaño de fuente
                  fontWeight: FontWeight.bold, // Peso de fuente
                  fontFamily: 'Calibri-Bold', // Familia de fuente
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
