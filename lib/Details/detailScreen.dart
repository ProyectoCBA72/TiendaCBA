// ignore_for_file: file_names, avoid_print, unnecessary_null_comparison, use_build_context_synchronously

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

/// Esta clase representa una pantalla que muestra los detalles de un producto.
///
/// La clase extiende [StatefulWidget] y tiene un único campo requerido, [producto],
/// que es un objeto [ProductoModel] que contiene la información del producto.
/// Los detalles del producto incluyen imágenes, nombre, descripción, precio y un
/// botón para compartir el producto a través de las redes sociales. Además,
/// se permite al usuario marcar un producto como favorito.
class DetailsScreen extends StatefulWidget {
  /// El producto cuyos detalles se mostrarán en la pantalla.
  final ProductoModel producto;

  /// Crea una instancia de [DetailsScreen] con el producto especificado.
  ///
  /// [producto] es un objeto [ProductoModel] que contiene la información del producto.
  const DetailsScreen({super.key, required this.producto});

  /// Crea el estado asociado a [DetailsScreen].
  ///
  /// El estado asociado a [DetailsScreen] es [_DetailsScreenState].
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // URL de la imagen principal
  /// URL de la imagen principal del producto.
  String mainImageUrl = ''; // URL de la imagen principal del producto.

  var _count = 0; // Contador interno utilizado en la pantalla.

  /// Variable booleana que indica si el producto es favorito.
  bool _isFavorite = false;

  /// Lista de URL de miniaturas de imágenes del producto.
  ///
  /// Cada URL representa una miniatura de una imagen del producto.
  List<String> thumbnailUrls = [];

  @override

  /// Se llama al método [initState] de la clase padre y luego se carga las imágenes del producto.
  ///
  /// Este método se llama cuando se crea el estado, es decir, cuando se crea la instancia de la
  /// clase [_DetailsScreenState]. En este método se llama al método [_loadImages] para cargar
  /// las imágenes del producto.
  @override
  void initState() {
    // Se llama al método [initState] de la clase padre.
    super.initState();

    // Se carga las imágenes del producto.
    _loadImages();
  }

  // Verificar si el producto es favorito.
  /// Verifica si el producto especificado está en los favoritos del usuario especificado.
  ///
  /// El [productoId] es el ID del producto a verificar.
  /// El [userId] es el ID del usuario a verificar.
  ///
  /// Devuelve [true] si el producto está en los favoritos, [false] de lo contrario.
  /// Si no se encuentran favoritos o la lista está vacía, devuelve [false].
  Future<bool> isProductFavorite(int productoId, int userId) async {
    // Obtiene la lista de favoritos del usuario
    final favoritos = await getFavoritos();

    // Verifica si la lista de favoritos es nula o está vacía
    if (favoritos.isEmpty || favoritos == null) {
      // Devuelve false si no hay favoritos o la lista está vacía
      return false;
    }

    // Verifica si algún elemento de la lista cumple con la condición de coincidir con el producto y el usuario
    return favoritos.any((favorito) =>
        favorito.producto.id == productoId && favorito.usuario == userId);
  }

  /// Carga las imágenes del producto y actualiza el estado de la UI.
  ///
  /// Este método obtiene todas las imágenes del producto y actualiza el estado de la UI
  /// con las imágenes relacionadas al producto.
  void _loadImages() async {
    // Obtiene todas las imágenes del producto
    final allImagenes = await getImagenProductos();

    // Actualiza el estado de la UI con las imágenes relacionadas al producto
    setState(() {
      // Traemos las url de las imágenes relacionadas al producto
      thumbnailUrls = allImagenes
          .where((imagen) => imagen.producto.id == widget.producto.id)
          .map((imagen) => imagen.imagen)
          .toList();

      // Usamos la primera imagen que esté dentro de la lista en caso de mezclar,
      // o bien, puedes usar thumbnailUrls.shuffle(); para mezclar las imágenes.
      mainImageUrl = thumbnailUrls.first;
    });
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
    // Directiva para obtener la lista de favoritos
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
          final String url = "$sourceApi/api/favoritos/${favoriteToRemove.id}/";

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
          // Imprime un mensaje si no se encontró el favorito para eliminar
          print('No se encontró el favorito para eliminar.');
        }
      } catch (e) {
        // Imprime un mensaje de error si hay un error al buscar el favorito
        print('Error al buscar el favorito: $e');
      }
    }
  }

// Futuro para agregar al carrito ya sea crear pedido y aux o solo aux
  Future addProductPedido(UsuarioModel usuario, ProductoModel producto) async {
    // Obtener la lista de pedidos
    final pedidos = await getPedidos();
    // Obtener la lista de auxPedidos
    final auxPedidos = await getAuxPedidos();

    if (pedidos.isNotEmpty) {
      // Si la lista de pedidos no es vacía, buscamos el pedido que el usuario ya tiene, puede ser nulo.
      final pedidoPendiente = pedidos
          .where((pedido) =>
              pedido.usuario.id == usuario.id &&
              pedido.estado == "PENDIENTE" &&
              pedido.pedidoConfirmado == false)
          .firstOrNull;

      // Obtener los números de los pedidos
      final pedidoNumbers =
          pedidos.map((pedido) => pedido.numeroPedido).toList();

      // Buscamos el número máximo de los pedidos.
      final int anteriorPedido =
          pedidoNumbers.reduce((max, current) => max > current ? max : current);

      if (pedidoPendiente != null) {
        // Filtramos los auxPedidos que pertenecen al pedido pendiente del usuario
        final auxPedidosUsuario = auxPedidos
            .where((auxPedido) => auxPedido.pedido.id == pedidoPendiente.id)
            .toList();

        if (auxPedidosUsuario.isNotEmpty) {
          // Verificamos si el producto ya ha sido añadido
          final isProductAdded = auxPedidosUsuario.any(
              (auxPedidoUsuario) => auxPedidoUsuario.producto == producto.id);

          if (!isProductAdded) {
            // Si el producto no se ha añadido
            if (producto.exclusivo == false) {
              // Agregamos si el producto no es exclusivo
              print('Producto no exclusivo');
              addAuxPedido(producto, pedidoPendiente.id);
            } else if (producto.exclusivo && auxPedidosUsuario.isNotEmpty) {
              // Añadir el producto exclusivo si ya hay uno o más productos añadidos
              print('Producto exclusivo, agregado si ya hay más productos');
              addAuxPedido(producto, pedidoPendiente.id);
            } else {
              // Producto exclusivo, debe añadir otro producto antes. modal
              productoExclusivo(context);
            }
          } else {
            isProductAddedModal(context);
            print('El producto ya se añadió');
          }
        } else {
          // Si no hay auxPedidos agregamos el producto
          if (producto.exclusivo == false) {
            // Agregamos si el producto no es exclusivo
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
        // Crear un nuevo pedido si no hay pedido pendiente
        await addPedido(anteriorPedido, usuario.id);
        final pedidosNuevo = await getPedidos();
        final pedidoPendiente = pedidosNuevo
            .where((pedido) =>
                pedido.usuario.id == usuario.id &&
                pedido.estado == "PENDIENTE" &&
                pedido.pedidoConfirmado == false)
            .firstOrNull;

        if (producto.exclusivo == false) {
          // Agregamos si el producto no es exclusivo
          print('Producto no exclusivo');
          addAuxPedido(producto, pedidoPendiente!.id);
        } else {
          productoExclusivo(context);
        }

        print('Pedido pendiente es nulo, se crea otro pedido.');
      }
    } else {
      // En caso de que la lista sea vacía, crear el pedido y el aux del mismo.
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
        // Agregamos si el producto no es exclusivo
        print('Producto no exclusivo');
        addAuxPedido(producto, pedidoPendiente!.id);
      } else {
        productoExclusivo(context);
      }
      print('Lista vacía, creando el primer pedido.');
    }
  }

  /// Método para agregar un nuevo pedido.
  ///
  /// Este método envía una solicitud POST a la API para agregar un nuevo pedido.
  /// Los datos del pedido incluyen el número del pedido, si es un pedido grupal,
  /// el estado del pedido, si ha sido entregado, si el pedido ha sido confirmado
  /// y el ID del usuario al que pertenece el pedido.
  ///
  /// Parámetros requeridos:
  /// - `anteriorPedido`: El número del pedido anterior.
  /// - `userID`: El ID del usuario al que pertenece el pedido.
  Future addPedido(int anteriorPedido, int userID) async {
    // URL de la API para agregar un nuevo pedido
    final String url = "$sourceApi/api/pedidos/";
    // Cabeceras de la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };
    // Datos del pedido
    final body = {
      'numeroPedido': anteriorPedido + 1, // Número del pedido
      'grupal': false, // Indica si es un pedido grupal
      'estado': 'PENDIENTE', // Estado del pedido
      'entregado': false, // Indica si el pedido ha sido entregado
      'pedidoConfirmado': false, // Indica si el pedido ha sido confirmado
      'usuario': userID // ID del usuario al que pertenece el pedido
    };

    // Envía una solicitud POST a la API con los datos del pedido
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Verifica el estado de la respuesta y imprime un mensaje de éxito o error
    if (response.statusCode == 201) {
      print('Datos enviados correctamente (Nuevo pedido)');
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

  /// Agrega un nuevo auxiliar de pedido a la API.
  ///
  /// Esta función envía una solicitud POST a la API para agregar un nuevo auxiliar
  /// de pedido. Los datos del auxiliar incluyen la cantidad, el precio, el ID del
  /// producto y el ID del pedido al que pertenece el auxiliar.
  ///
  /// Parámetros requeridos:
  /// - `producto`: El modelo del producto al que pertenece el auxiliar.
  /// - `pedidoPendienteID`: El ID del pedido al que pertenece el auxiliar.
  Future addAuxPedido(ProductoModel producto, int pedidoPendienteID) async {
    // URL de la API para agregar un nuevo auxiliar de pedido
    final String url = "$sourceApi/api/aux-pedidos/";

    // Cabeceras de la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Datos del auxiliar de pedido
    final body = {
      'cantidad': 1, // Cantidad del producto en el auxiliar
      'precio': producto.precio, // Precio del producto en el auxiliar
      'producto': producto.id, // ID del producto en el auxiliar
      'pedido': pedidoPendienteID, // ID del pedido al que pertenece el auxiliar
    };

    // Envía una solicitud POST a la API con los datos del auxiliar de pedido
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Verifica el estado de la respuesta y imprime un mensaje de éxito o error
    if (response.statusCode == 201) {
      print('Datos enviados correctamente (auxPedido nuevo)');
      _countPedidos();
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

  /// Futuro para contar el número de pedidos auxiliares pendientes del usuario actual.
  ///
  /// Obtiene los pedidos auxiliares y cuenta cuántos de ellos están en estado "PENDIENTE"
  /// y no están confirmados, y pertenecen al usuario actual. Luego actualiza el estado
  /// con el conteo y notifica al controlador de la tienda.
  ///
  /// @return Un Future que completa cuando el conteo ha sido realizado y el estado actualizado.
  Future _countPedidos() async {
    // Obtener los pedidos auxiliares actuales
    final auxPedidos = await getAuxPedidos();

    // Obtener el usuario autenticado
    final usuario =
        Provider.of<AppState>(context, listen: false).usuarioAutenticado;

    var count = 0;

    // Verificar si el usuario está definido
    if (usuario != null) {
      // Contar los pedidos auxiliares pendientes y no confirmados del usuario actual
      count = auxPedidos
          .where((auxPedido) =>
              auxPedido.pedido.estado == "PENDIENTE" &&
              auxPedido.pedido.pedidoConfirmado == false &&
              auxPedido.pedido.usuario.id == usuario.id)
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
    // Obtener el producto actual
    final producto = widget.producto;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        // Obtener el usuario autenticado
        final usuarioAutenticado = appState.usuarioAutenticado;
        return Scaffold(
          body: LayoutBuilder(builder: (context, responsive) {
            // Si la resolución es menor a 900px
            if (responsive.maxWidth <= 900) {
              // Verificar el precio del producto si esta en oferta y establecer el diseño de la impresión
              var row = producto.precioOferta != 0
                  ? Row(
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
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "\$${formatter.format(producto.precio)}",
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
                                          // Abrir modal de imagen ampliada
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
                                                  // Cambiar la imagen principal
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
                                  // Nombre del producto
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
                                  // Información del Precio
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
                                      // Variable que muestra el precio del producto
                                      row,
                                    ],
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  // Si el usuario es aprendiz presenta el precio correspondiente al rol
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 == "APRENDIZ")
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
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 == "APRENDIZ")
                                      const SizedBox(height: defaultPadding),
                                  // Si el usuario es funcionario presenta el precio correspondiente al rol
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 ==
                                        "FUNCIONARIO")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            'Precio Funcionario',
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
                                            "\$${formatter.format(producto.precioFuncionario)}",
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
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 ==
                                        "FUNCIONARIO")
                                      const SizedBox(height: defaultPadding),
                                  // Si el usuario es instructor presenta el precio correspondiente al rol
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 == "INSTRUCTOR")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            'Precio Instructor',
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
                                            "\$${formatter.format(producto.precioInstructor)}",
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
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 == "INSTRUCTOR")
                                      const SizedBox(height: defaultPadding),
                                  // Descripción del producto
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
                                  // Características del producto
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
                    // Barra de navegación inferior
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
                              // Añadir a favoritos
                              if (usuarioAutenticado != null)
                                FutureBuilder<bool>(
                                  future: isProductFavorite(
                                      producto.id,
                                      usuarioAutenticado
                                          .id), // Obtener el estado del favorito
                                  builder: (context, snapshot) {
                                    // Manejo de los diferentes estados de la aplicación
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    }
                                    // Si hay un error
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ));
                                    }

                                    // Si se obtuvo el estado del favorito
                                    _isFavorite = snapshot.data ?? false;

                                    return Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () async {
                                          try {
                                            // Actualizar el estado del favorito
                                            if (_isFavorite) {
                                              await removeFavoritos(
                                                usuarioAutenticado.id,
                                                producto.id,
                                              );
                                            } else {
                                              await addFavorite(
                                                  usuarioAutenticado.id);
                                            }
                                            // Actualizar el estado del favorito
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
                                // Si no hay un usuario autenticado
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Modal de inicio de sesión
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
                              // Compartir por WhatsApp
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    // Mensaje para compartir el producto y verifica si este esta en oferta
                                    String text = producto.precioOferta != 0
                                        ? "${producto.nombre} X ${producto.unidadMedida} a \$${formatter.format(producto.precioOferta)} (precio original \$${formatter.format(producto.precio)}). Visite los espacios virtuales del Centro de Biotecnología Agropecuaria. Si usted es miembro de nuestra comunidad, habrá beneficios especiales."
                                        : "${producto.nombre} X ${producto.unidadMedida} a \$${formatter.format(producto.precio)}. Visite los espacios virtuales del Centro de Biotecnología Agropecuaria. Si usted es miembro de nuestra comunidad, habrá beneficios especiales.";
                                    // Si el dispositivo es Android o iOS, se puede compartir a varias plataformas
                                    if (UniversalPlatform.isAndroid ||
                                        UniversalPlatform.isIOS) {
                                      Share.share(text);
                                      // Si el dispositivo no es Android o iOS, se puede compartir a WhatsApp
                                    } else {
                                      modalCompartirWhatsappProducto(
                                          context, text);
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
                              // Aniadir al carrito
                              Expanded(
                                flex: 3, // Este botón ocupará más espacio
                                child: GestureDetector(
                                  onTap: () {
                                    // Verificar si hay un usuario autenticado
                                    if (usuarioAutenticado != null) {
                                      addProductPedido(
                                          usuarioAutenticado, producto);
                                      // Si no hay un usuario autenticado, se redirige a la pantalla de inicio de sesión
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
              // Vista por defecto
            } else {
              // Verificar el precio del producto si esta en oferta y establecer el diseño de la impresión
              var row = producto.precioOferta != 0
                  ? Row(
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
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "\$${formatter.format(producto.precio)}",
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
                                        // Llama a la modal de ampliación
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
                                                // Cambiar la imagen principal
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
                                  // Nombre del producto
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
                                  // Información del Precio
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
                                      // Variable que contiene el precio del producto
                                      row
                                    ],
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  // Información del Precio Aprendiz
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 == "APRENDIZ")
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
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 == "APRENDIZ")
                                      const SizedBox(height: defaultPadding),
                                  // Información del Precio Funcionario
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 ==
                                        "FUNCIONARIO")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            'Precio Funcionario',
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
                                            "\$${formatter.format(producto.precioFuncionario)}",
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
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 ==
                                        "FUNCIONARIO")
                                      const SizedBox(height: defaultPadding),
                                  // Información del Precio Instructor
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 == "INSTRUCTOR")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            'Precio Instructor',
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
                                            "\$${formatter.format(producto.precioInstructor)}",
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
                                  if (usuarioAutenticado != null)
                                    if (usuarioAutenticado.rol2 == "INSTRUCTOR")
                                      const SizedBox(height: defaultPadding),
                                  // Descripción del Producto
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
                                  // Características del Producto
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
                          // Barra Inferior
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
                                    // Botón de Favoritos
                                    // Verificar si el usuario ha iniciado sesión
                                    if (usuarioAutenticado != null)
                                      FutureBuilder<bool>(
                                        future: isProductFavorite(
                                            producto.id,
                                            usuarioAutenticado
                                                .id), // Obtener la lista de favoritos
                                        builder: (context, snapshot) {
                                          // Verificar el estado de la petición
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.white,
                                            ));
                                          }
                                          // Verificar si hay un error
                                          if (snapshot.hasError) {
                                            return const Center(
                                                child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ));
                                          }
                                          // Verificar si hay favoritos
                                          _isFavorite = snapshot.data ?? false;

                                          return Flexible(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () async {
                                                try {
                                                  // Agregar o quitar de favoritos
                                                  if (_isFavorite) {
                                                    await removeFavoritos(
                                                      usuarioAutenticado.id,
                                                      producto.id,
                                                    );
                                                  } else {
                                                    await addFavorite(
                                                        usuarioAutenticado.id);
                                                  }
                                                  // lanza una excepción si hay un error
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
                                    // Verificar si el usuario no ha iniciado sesión
                                    else
                                      Flexible(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Modal para iniciar sesión
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
                                    // Botón de compartir
                                    Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Variable con el mensaje para compartir y a su vez verifica si el precio del producto tiene oferta
                                          String text = producto.precioOferta !=
                                                  0
                                              ? "${producto.nombre} X ${producto.unidadMedida} a \$${formatter.format(producto.precioOferta)} (precio original \$${formatter.format(producto.precio)}). Visite los espacios virtuales del Centro de Biotecnología Agropecuaria. Si usted es miembro de nuestra comunidad, habrá beneficios especiales."
                                              : "${producto.nombre} X ${producto.unidadMedida} a \$${formatter.format(producto.precio)}. Visite los espacios virtuales del Centro de Biotecnología Agropecuaria. Si usted es miembro de nuestra comunidad, habrá beneficios especiales.";

                                          // Verificar si el dispositivo es Android o iOS, comparte el mensaje a diferentes aplicativos
                                          if (UniversalPlatform.isAndroid ||
                                              UniversalPlatform.isIOS) {
                                            Share.share(text);
                                            // Comparte el mensaje a WhatsApp si el dispositivo no es Android o iOS
                                          } else {
                                            modalCompartirWhatsappProducto(
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
                                    // Botón de Añadir al carrito
                                    Expanded(
                                      flex: 3, // Este botón ocupará más espacio
                                      child: GestureDetector(
                                        onTap: () {
                                          // Verificar si el usuario ha iniciado sesión
                                          if (usuarioAutenticado != null) {
                                            // Añadir al carrito
                                            addProductPedido(
                                                usuarioAutenticado, producto);
                                            // Verificar si el usuario no ha iniciado sesión
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
