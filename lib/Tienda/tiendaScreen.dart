// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Auth/authScreen.dart';
import 'package:tienda_app/Carrito/carritoScreen.dart';
import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/Home/profileCard.dart';
import 'package:tienda_app/Models/categoriaModel.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/pedidoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';
import 'package:tienda_app/cardProducts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';

import '../Models/auxPedidoModel.dart';

class TiendaScreen extends StatefulWidget {
  const TiendaScreen({super.key});

  @override
  State<TiendaScreen> createState() => _TiendaScreenState();
}

class _TiendaScreenState extends State<TiendaScreen> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _countPedidos();
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

  Future openCarScreen(UsuarioModel usuario) async {
    final pedidos = await getPedidos();
    if (pedidos != null) {
      final pedidoPendiente = pedidos
          .where((pedido) =>
              pedido.usuario.id == usuario.id &&
              pedido.estado == "PENDIENTE" &&
              pedido.pedidoConfirmado == false)
          .firstOrNull;

      if (pedidoPendiente != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CarritoScreen()));
      } else {
        modalPedidosIsEmpy(context);
      }
    } else {
      modalPedidosIsEmpy(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  onPressed: () {},
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
                                      )))),
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
                              // Contenedor que envuelve un botón de búsqueda.
                              color: primaryColor,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.chat,
                                    color: Colors.white,
                                  )))),
                    if (Responsive.isMobile(context))
                      SpeedDial(
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
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        )))),
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
                                                if (usuarioAutenticado !=
                                                    null) {
                                                  openCarScreen(
                                                      usuarioAutenticado);
                                                } else {
                                                  _InicioSesion(context);
                                                }
                                              } else {
                                                _InicioSesion(context);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.shopping_cart,
                                              color: Colors.white,
                                            )))),
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
                                        )))),
                          ),
                        ],
                      ),
                    const SizedBox(width: 20),
                    const ProfileCard(),
                  ],
                ),
              ),
              const Positioned(
                top: 130,
                left: 0,
                right: 0,
                bottom: 0,
                child: BodyTienda(),
              ),
            ],
          ),
        );
      });
    });
  }

  void modalPedidosIsEmpy(BuildContext context) {
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

class BodyTienda extends StatefulWidget {
  const BodyTienda({
    super.key,
  });

  @override
  State<BodyTienda> createState() => _BodyTiendaState();
}

class _BodyTiendaState extends State<BodyTienda> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategorias(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Sin categorias'));
        } else {
          final categorias = snapshot.data!;
          return DefaultTabController(
            // Longitud de las pestañas basada en la cantidad de categorías.

            length: categorias.length,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  // Contenedor que alberga la barra de pestañas.
                  child: TabBar(
                    indicatorColor: primaryColor,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    tabs: categorias
                        .map(
                          (categotia) => Container(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 4, top: 4),
                            // Contenedor que alberga el ícono y el nombre de la categoría.
                            child: Column(
                              children: [
                                SvgPicture.network(
                                  categotia.icono,
                                  height: 24.0,
                                  width: 24.0,
                                  colorFilter: const ColorFilter.mode(
                                      primaryColor, BlendMode.srcIn),
                                  placeholderBuilder: (BuildContext context) =>
                                      const CircularProgressIndicator(),
                                ),
                                Text(
                                  categotia.nombre,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: categorias.map((categoria) {
                      return Container(
                          padding: const EdgeInsets.all(15),
                          child: BodyTabBar(categoria: categoria));
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class BodyTabBar extends StatefulWidget {
  final CategoriaModel categoria;
  const BodyTabBar({super.key, required this.categoria});

  @override
  State<BodyTabBar> createState() => _BodyTabBarState();
}

class _BodyTabBarState extends State<BodyTabBar> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImagenProductos(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ImagenProductoModel>> snapshotImagenes) {
        if (snapshotImagenes.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final allImages = snapshotImagenes.data!;
          return FutureBuilder(
            future: getProductos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay productos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                );
              } else {
                // Lista de los productos que son de la categoria y esta activos.
                List<ProductoModel> productosFiltrados;
                if (widget.categoria.nombre == "Destacados") {
                  productosFiltrados = productos
                      .where(
                          (producto) => producto.destacado && producto.estado)
                      .toList();
                } else {
                  productosFiltrados = productos
                      .where((producto) =>
                          producto.categoria.id == widget.categoria.id &&
                          producto.estado)
                      .toList();
                }
                return GridView.builder(
                  itemCount: productosFiltrados.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // Número de columnas basado en el tipo de dispositivo.
                      crossAxisCount: Responsive.isMobile(context)
                          ? 1
                          : Responsive.isTablet(context)
                              ? 3
                              : 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20),
                  itemBuilder: (context, index) {
                    final producto = productosFiltrados[index];
                    List<String> imagenesProducto = allImages
                        .where((imagen) => imagen.producto.id == producto.id)
                        .map((imagen) => imagen.imagen)
                        .toList();
                    return CardProducts(
                      producto: producto,
                      imagenes: imagenesProducto,
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
}
