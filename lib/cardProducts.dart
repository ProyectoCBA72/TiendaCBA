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

import 'Details/sourceDetails/modalsCardAndDetails.dart';

/// Representa un widget de tarjeta de producto.
///
/// Consiste en un [StatefulWidget] que muestra una tarjeta con las imágenes
/// del producto y algunos detalles del mismo. El widget acepta dos parámetros,
/// [producto] y [imagenes], que son obligatorios.
class CardProducts extends StatefulWidget {
  /// Lista de imágenes del producto.
  ///
  /// Es una lista de [String] que contiene las rutas de las imágenes del producto.
  final List<String> imagenes;

  /// Objeto del producto.
  ///
  /// Es un objeto del tipo [ProductoModel] que contiene los detalles del producto.
  final ProductoModel producto;

  /// Crea un nuevo widget de tarjeta de producto.
  ///
  /// El parámetro [producto] es obligatorio y debe ser una instancia de
  /// [ProductoModel]. El parámetro [imagenes] es obligatorio y debe ser una
  /// lista de [String] que contenga las rutas de las imágenes del producto.
  const CardProducts({
    Key? key,
    required this.producto,
    required this.imagenes,
  }) : super(key: key);

  @override
  _CardProductsState createState() => _CardProductsState();
}

class _CardProductsState extends State<CardProducts> {
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

  // variable para almacenar si el producto ya fue añadido. por defecto es false
  bool _isAdded = false;

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
    _loadImages();

    // Obtiene el número de pedidos del producto
    _countPedidos();

    // Obtiene el estado de favorito del producto
    _initializeFavoriteAndAddedState();
  }

  /// Inicializa el estado del widget relacionado con el estado de favorito.
  ///
  /// Este método obtiene el usuario autenticado, verifica si el producto es favorito
  /// y actualiza el estado correspondiente.
  Future<void> _initializeFavoriteAndAddedState() async {
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

      bool isAdded =
          await isProductAdded(widget.producto.id, usuarioAutenticado.id);

      // Actualiza el estado correspondiente
      setState(() {
        _isFavorite = isFavorite;
        _isAdded = isAdded;
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

  Future isProductAdded(
    int productoID,
    int userID,
  ) async {
    final auxPedidos = await getAuxPedidos();

    if (auxPedidos.isNotEmpty) {
      return auxPedidos.any((auxPedido) =>
          auxPedido.pedido.estado == "PENDIENTE" &&
          !auxPedido.pedido.pedidoConfirmado &&
          auxPedido.pedido.usuario.id == userID &&
          auxPedido.producto == productoID);
    } else {
      return false;
    }
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
  void _loadImages() {
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
              addAuxPedido(producto, pedidoPendiente.id, usuario);
            } else if (producto.exclusivo && auxPedidosUsuario.isNotEmpty) {
              // Añadir el producto exclusivo si ya hay uno o más productos añadidos
              print('Producto exclusivo, agregado si ya hay más productos');
              addAuxPedido(producto, pedidoPendiente.id, usuario);
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
            addAuxPedido(producto, pedidoPendiente.id, usuario);
          } else if (producto.exclusivo && auxPedidosUsuario.isNotEmpty) {
            // Añadir el producto exclusivo si ya hay uno o más productos añadidos
            addAuxPedido(producto, pedidoPendiente.id, usuario);
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
          addAuxPedido(producto, pedidoPendiente!.id, usuario);
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
        addAuxPedido(producto, pedidoPendiente!.id, usuario);
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
    final puntoVenta = Provider.of<PuntoVentaProvider>(context, listen: false).puntoVenta;
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
      'usuario': userID,
      'puntoVenta': puntoVenta!.id
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
  Future addAuxPedido(ProductoModel producto, int pedidoPendienteID,
      UsuarioModel usuario) async {
    // URL del API para agregar el pedido auxiliar
    final String url = "$sourceApi/api/aux-pedidos/";
    final headers = {
      'Content-Type': 'application/json',
    };

    // vafirbale para colocar le precio dependiendo del rol del usuario.
    int precio;

    // condicional para verificar que rol tiene el usuario

    if (usuario.rol2 == "APRENDIZ") {
      precio = producto.precioAprendiz;
    } else if (usuario.rol2 == "FUNCIONARIO") {
      precio = producto.precioFuncionario;
    } else if (usuario.rol2 == "INSTRUCTOR") {
      precio = producto.precioInstructor;

      // EN CASO DE NO TENER ROL 2 ES EL PRECIO POR DEFECTO, EXTERNO...
    } else {
      precio = producto.precio;
    }

    // Datos del pedido auxiliar: cantidad, precio, producto y pedido pendiente
    final body = {
      'cantidad': 1,
      'precio': precio,
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
      setState(() {
        _isAdded = true;
      });
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

  /// Construye el widget que representa un producto en la UI.
  ///
  /// Este widget muestra una imagen del producto, y permite al usuario
  /// interactuar con el producto para verlo en detalle, marcarlo como favorito,
  /// o añadirlo al carrito de compras. Además, muestra información del producto
  /// como nombre y precio, y maneja estados de autenticación del usuario.
  ///
  /// @param context El contexto de la aplicación.
  /// @return Un widget construido que representa un producto.
  Widget build(BuildContext context) {
    final ProductoModel producto = widget.producto;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final usuarioAutenticado = appState.usuarioAutenticado;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            onTap: () {
              // Añadir a visitas
              if (usuarioAutenticado != null) {
                isProductVisitado(producto.id, usuarioAutenticado.id);
              }
              // Pantalla de detalles
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
                                            inicioSesion(context);
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
                                        icon: _isAdded
                                            ? const Icon(Icons.check,
                                                color: Colors.white)
                                            : const Icon(Icons.shopping_cart,
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
        );
      },
    );
  }
}
