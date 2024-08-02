// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Auth/authScreen.dart';
import 'package:tienda_app/Buscador/searchDelegate.dart';
import 'package:tienda_app/Carrito/carritoScreen.dart';
import 'package:tienda_app/Chatbot/chatBot.dart';
import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/Home/profileCard.dart';
import 'package:tienda_app/Models/bodegaModel.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/pedidoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/Tienda/bodyTienda.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';
import '../Models/auxPedidoModel.dart';

/// Pantalla principal de la tienda.
///
/// Esta clase define la pantalla principal de la tienda, que se encarga de
/// mostrar los productos disponibles y permitir al usuario realizar compras.
class TiendaScreen extends StatefulWidget {
  /// Construye una nueva instancia de [TiendaScreen].
  ///
  /// El parámetro [key] es opcional y se utiliza para identificar de forma única
  /// este widget en el árbol de widgets.
  const TiendaScreen({super.key});

  /// Crea el estado inicial para esta pantalla.
  ///
  /// Cuando se crea una nueva instancia de [TiendaScreen], se llama a este método
  /// para crear el estado inicial correspondiente. En este caso, se crea una
  /// instancia de [_TiendaScreenState].
  @override
  State<TiendaScreen> createState() => _TiendaScreenState();
}

class _TiendaScreenState extends State<TiendaScreen> {
  /// Cantidad de pedidos pendientes.
  ///
  /// Almacena la cantidad de pedidos pendientes que tiene el usuario.
  int _count = 0;

  late Future<void> initData;

// lista para llenar con productos e imagenes
  late Future<List<dynamic>> futureDataSearch;

  int? puntoVentaID;

  /// Inicializa el estado de la pantalla.
  ///
  /// Se llama a esta función cuando se crea una nueva instancia de esta clase.
  /// Aquí se inicializa el estado de la pantalla, incluyendo la llamada a [_countPedidos]
  /// para obtener la cantidad de pedidos pendientes del usuario.
  @override
  void initState() {
    // Llama al método initState de la superclase
    super.initState();
    // Obtiene la cantidad de pedidos pendientes del usuario
    futureDataSearch = loadData();
    initData = _initializeData();
  }

  /// Actualiza la cantidad de pedidos pendientes.
  ///
  /// Recupera los pedidos auxiliares y cuenta cuántos de ellos están en estado "PENDIENTE"
  /// y no están confirmados, y pertenecen al usuario actual. Luego actualiza el estado
  /// con el conteo y notifica al controlador de la tienda.
  ///
  /// Esta función se llama en [initState] para obtener la cantidad de pedidos pendientes
  /// del usuario al inicio de la pantalla.
  ///
  /// No devuelve nada.
  Future _countPedidos() async {
    // Obtiene los pedidos auxiliares actuales
    final auxPedidos = await getAuxPedidos();

    // Obtiene el usuario actual de la aplicación
    final usuario =
        Provider.of<AppState>(context, listen: false).usuarioAutenticado;

    // Inicializa el conteo en 0
    var count = 0;

    // Verifica si el usuario está definido
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

    // Actualiza el estado del widget y notificar al controlador de la tienda
    setState(() {
      _count = count;
    });
    Provider.of<Tiendacontroller>(context, listen: false).updateCount(_count);
  }

  Future<void> _initializeData() async {
    await _countPedidos();
    await loadPuntoVenta();
  }

  Future loadPuntoVenta() async {
    final usuario =
        Provider.of<AppState>(context, listen: false).usuarioAutenticado;
    if (usuario != null) {
      final pedidos = await getPedidos();
      final puntosVenta = await getPuntosVenta();

      final pedidoPendiente = pedidos
          .where((pedido) =>
              pedido.usuario.id == usuario.id &&
              pedido.estado == "PENDIENTE" &&
              pedido.pedidoConfirmado == false)
          .firstOrNull;

      if (pedidoPendiente != null) {
        final puntoVenta = puntosVenta
            .where((item) => item.id == pedidoPendiente.puntoVenta)
            .first;

        setState(() {
          Provider.of<PuntoVentaProvider>(context, listen: false)
              .setPuntoVenta(puntoVenta);
        });
      }
    }
  }

  /// Abre la pantalla de carrito si el usuario tiene al menos un pedido pendiente.
  ///
  /// Recupera los pedidos y verifica si el usuario tiene al menos un pedido pendiente.
  /// Si es así, se navega a la pantalla de carrito. Si no, se muestra un mensaje de alerta.
  ///
  /// [usuario] es el usuario para el que se desea verificar los pedidos.
  ///
  /// No devuelve nada.
  Future openCarScreen(UsuarioModel usuario) async {
    // Obtiene los pedidos
    final pedidos = await getPedidos();

    // Verifica si hay pedidos
    if (pedidos != null) {
      // Busca un pedido pendiente del usuario
      final pedidoPendiente = pedidos
          .where((pedido) =>
              pedido.usuario.id == usuario.id &&
              pedido.estado == "PENDIENTE" &&
              pedido.pedidoConfirmado == false)
          .firstOrNull;

      // Si hay un pedido pendiente, navega a la pantalla de carrito
      if (pedidoPendiente != null) {
        setState(() {
          puntoVentaID = pedidoPendiente.puntoVenta;
        });
        final puntoVenta =
            Provider.of<PuntoVentaProvider>(context, listen: false).puntoVenta;
        // Navegar a la pantalla de carrito y esperar el resultado
        // de tal manera que al regresar tengamos el estado del contador recargado.
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CarritoScreen(
                    puntoVenta: puntoVenta!,
                  )),
        );

        // Si el resultado es 'refresh', actualizar el contador de pedidos
        if (result == 'refresh') {
          _countPedidos();
        }
      } else {
        // Si no hay pedidos pendientes, muestra un mensaje de alerta
        modalPedidosIsEmpy(context);
      }
    } else {
      // Si no hay pedidos, muestra un mensaje de alerta
      modalPedidosIsEmpy(context);
    }
  }

  // carga de los datos para pasar añ buscador.
  Future<List<dynamic>> loadData() async {
    return Future.wait([
      getProductos(),
      getImagenProductos(),
      getBodegas(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    /// Constructor del widget que construye la interfaz principal de la tienda.
    /// Utiliza [Consumer] para escuchar cambios en [AppState] y [Tiendacontroller].
    return Consumer<AppState>(builder: (context, appState, _) {
      final usuarioAutenticado = appState.usuarioAutenticado;

      return Consumer<Tiendacontroller>(
          builder: (context, tiendaController, _) {
        final count = tiendaController.count;

        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 40,
                left: 20,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        // Coloca aquí tu imagen de logo
                        child: Image.asset('assets/img/logo.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: Row(
                  children: [
                    if (!Responsive.isMobile(context))
                      ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          child: Container(
                              // Contenedor que envuelve un botón de búsqueda.
                              color: primaryColor,
                              child: IconButton(
                                  onPressed: () {
                                    showSearch(
                                      context: context,
                                      delegate: SearchProductoDelegate(
                                          futureDataSearch),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  )))),
                    if (!Responsive.isMobile(context))
                      const SizedBox(width: 20),
                    if (!Responsive.isMobile(context))
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            child: Container(
                              // Contenedor que envuelve un botón de búsqueda.
                              color: primaryColor,
                              child: IconButton(
                                onPressed: () {
                                  if (usuarioAutenticado != null) {
                                    openCarScreen(usuarioAutenticado);
                                  } else {
                                    _InicioSesion(context);
                                  }
                                },
                                icon: const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(4)),
                              constraints: const BoxConstraints(
                                  minWidth: 12, minHeight: 12),
                              child: Text(
                                count.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 9),
                              ),
                            ),
                          )
                        ],
                      ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(width: 20),
                    if (!Responsive.isMobile(context))
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        child: Container(
                          // Contenedor que envuelve un botón del chat.
                          color: primaryColor,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    if (Responsive.isMobile(context))
                      SpeedDial(
                        renderOverlay: false,
                        icon: Icons.add,
                        activeIcon: Icons.close,
                        direction: SpeedDialDirection.down,
                        children: [
                          SpeedDialChild(
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: Container(
                                // Contenedor que envuelve un botón de búsqueda.
                                color: primaryColor,
                                child: IconButton(
                                  onPressed: () {
                                    showSearch(
                                      context: context,
                                      delegate: SearchProductoDelegate(
                                          futureDataSearch),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SpeedDialChild(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  child: Container(
                                    // Contenedor que envuelve un botón de búsqueda.
                                    color: primaryColor,
                                    child: IconButton(
                                      onPressed: () {
                                        if (usuarioAutenticado != null) {
                                          openCarScreen(usuarioAutenticado);
                                        } else {
                                          _InicioSesion(context);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(4)),
                                    constraints: const BoxConstraints(
                                        minWidth: 12, minHeight: 12),
                                    child: Text(
                                      count.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 9),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SpeedDialChild(
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: Container(
                                // Contenedor que envuelve un botón de búsqueda.
                                color: primaryColor,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.chat,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(width: 20),
                    const ProfileCard(),
                  ],
                ),
              ),
              Positioned(
                top: 130,
                left: 0,
                right: 0,
                bottom: 0,
                child: FutureBuilder(
                  future: initData,
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return const BodyTienda();
                    }
                  },
                ),
              ),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChatBot()),
                      );
                    },
                    child: const Icon(Icons.support_agent),
                  )),
            ],
          ),
        );
      });
    });
  }

  /// Muestra un diálogo de alerta que avisa al usuario que su carrito está vacío
  /// y le pide que agregue un producto para continuar.
  ///
  /// El diálogo contiene un título, un mensaje, una imagen y un botón de aceptar.
  /// Si el usuario hace clic en el botón de aceptar, se cierra el diálogo.
  ///
  /// Parámetros:
  ///
  ///   - `context` (BuildContext): El contexto de la aplicación.
  void modalPedidosIsEmpy(BuildContext context) {
    // Muestra un diálogo de alerta
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("¿Quiere acceder al carrito?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  "¡Para acceder al carrito debes tener al menos un pedido pendiente agrega un producto para continuar!"),
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
                  child: _buildButton("Aceptar", () {
                    // Cierra el diálogo cuando se hace clic en el botón de aceptar
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

  /// Muestra un diálogo de alerta para indicar que el usuario debe iniciar sesión
  /// antes de acceder al carrito.
  ///
  /// El diálogo muestra una imagen circular del logo de la aplicación y dos botones:
  /// uno para cancelar y otro para iniciar sesión.
  ///
  /// [context]: el contexto del widget actual.
  void _InicioSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("¿Quiere acceder al carrito?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("¡Para acceder al carrito debe iniciar sesión!"),
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
                  child: _buildButton("Cancelar", () {
                    Navigator.pop(context);
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Iniciar Sesión", () {
                    // Navega a la pantalla de inicio de sesión
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Construye un botón con el texto proporcionado y la función de presionar.
  ///
  /// El botón tiene un ancho fijo de 200 píxeles y una apariencia personalizada
  /// con un borde redondeado y un gradiente de colores. También tiene una sombra.
  ///
  /// El [text] es el texto que se mostrará en el botón.
  /// El [onPressed] es la función que se ejecutará cuando se presione el botón.
  Widget _buildButton(String text, VoidCallback onPressed) {
    // Construye el widget del botón con el texto y la función de presionar.
    return Container(
      width: 200, // Ancho fijo del botón.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Borde redondeado.
        gradient: const LinearGradient(
          colors: [
            botonClaro, // Color claro del gradiente.
            botonOscuro, // Color oscuro del gradiente.
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: botonSombra, // Color de la sombra.
            blurRadius: 5, // Radio de desfoque de la sombra.
            offset: Offset(0, 3), // Desplazamiento de la sombra.
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Color transparente para el Material.
        child: InkWell(
          onTap: onPressed, // Función de presionar.
          borderRadius:
              BorderRadius.circular(10), // Radio del borde redondeado.
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10), // Padding vertical.
            child: Center(
              child: Text(
                text, // Texto del botón.
                style: const TextStyle(
                  color: background1, // Color del texto.
                  fontSize: 13, // Tamaño de fuente.
                  fontWeight: FontWeight.bold, // Peso de fuente.
                  fontFamily: 'Calibri-Bold', // Fuente.
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
