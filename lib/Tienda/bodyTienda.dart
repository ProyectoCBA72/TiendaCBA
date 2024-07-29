import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Models/bodegaModel.dart';
import 'package:tienda_app/Models/categoriaModel.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/sedeModel.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';
import 'package:tienda_app/cardProducts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

/// Representa el cuerpo principal de la pantalla de la tienda.
///
/// Esta clase extiende [StatefulWidget] y se utiliza para mostrar el cuerpo
/// principal de la pantalla de la tienda. Implementa el método [createState]
/// para crear una instancia de [_BodyTiendaState].
class BodyTienda extends StatefulWidget {
  /// Construye un [BodyTienda].
  ///
  /// No requiere argumentos.
  const BodyTienda({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  /// Crea un objeto [State] para este widget.
  ///
  /// Devuelve una instancia de [_BodyTiendaState].
  State<BodyTienda> createState() => _BodyTiendaState();
}

class _BodyTiendaState extends State<BodyTienda> {
  late Future<List<dynamic>> _futureData;

  List<PuntoVentaModel> _dataPuntosVenta = [];
  List<SedeModel> _sedes = [];

  PuntoVentaModel? _puntoInicial;

  @override
  void initState() {
    super.initState();
    _futureData = loadData();
  }

  Future<List<dynamic>> loadData() async {
    final dataPuntosVenta = await Future.wait([getPuntosVenta(), getSedes()]);
    _dataPuntosVenta = dataPuntosVenta[0] as List<PuntoVentaModel>;
    _sedes = dataPuntosVenta[1] as List<SedeModel>;

    if (_dataPuntosVenta.isNotEmpty) {
      final puntoVentaSaved =
          Provider.of<PuntoVentaProvider>(context, listen: false).puntoVenta;

      if (puntoVentaSaved == null) {
        _puntoInicial = _dataPuntosVenta.first;
        Provider.of<PuntoVentaProvider>(context, listen: false)
            .setPuntoVenta(_puntoInicial!);
      } else {
        _puntoInicial = puntoVentaSaved;
        Provider.of<PuntoVentaProvider>(context, listen: false)
            .setPuntoVenta(_puntoInicial!);
      }
    }
    return dataPuntosVenta;
  }

  // Antes de contruir el widget como tal verificamos que todos los datos esteb cargados, correctamente.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return buildContent();
        }
      },
    );
  }

  // Widget de la clase, separado con el fin de solucionar valores nulos en el desarrollo de los futuros
  // (se cargaba primero el widget y despues los valores => valor nulo inesperado)
  Widget buildContent() {
    /// Constructor del estado que construye la interfaz de la tienda
    /// basada en las categorías obtenidas mediante [FutureBuilder].
    return FutureBuilder(
      future: getCategorias(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se carga la información, muestra un indicador de progreso.
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Si ocurre un error durante la carga, muestra un mensaje de error.
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Si no hay datos o los datos están vacíos, muestra un mensaje indicando la ausencia de categorías.
          return const Center(child: Text('Sin categorías'));
        } else {
          // Si hay datos disponibles, construye la interfaz con las pestañas de categorías.
          final categorias = snapshot.data!;
          return DefaultTabController(
            // Configura el controlador de pestañas con la longitud basada en la cantidad de categorías.
            length: categorias.length,
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Elija punto de venta',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: DropdownButton<int>(
                                dropdownColor: background1,
                                isExpanded: true,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                value: _puntoInicial?.id,
                                items: _dataPuntosVenta
                                    .map((PuntoVentaModel item) {
                                  final sedePunto = _sedes.firstWhere(
                                      (sede) => sede.id == item.sede);

                                  return DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.nombre,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        Text(
                                          sedePunto.nombre,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (int? value) {
                                  final puntoVenta = _dataPuntosVenta
                                      .firstWhere((item) => item.id == value);
                                  setState(() => _puntoInicial = puntoVenta);
                                  Provider.of<PuntoVentaProvider>(context,
                                          listen: false)
                                      .updatePuntoVenta(puntoVenta, context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
                          (categoria) => Container(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 4, top: 4),
                            // Contenedor que alberga el ícono y el nombre de la categoría.
                            child: Column(
                              children: [
                                SvgPicture.network(
                                  categoria.icono,
                                  height: 24.0,
                                  width: 24.0,
                                  colorFilter: const ColorFilter.mode(
                                      primaryColor, BlendMode.srcIn),
                                  placeholderBuilder: (BuildContext context) =>
                                      const CircularProgressIndicator(),
                                ),
                                Text(
                                  categoria.nombre,
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
                    // Contenido de las pestañas basado en cada categoría.
                    children: categorias.map((categoria) {
                      return Container(
                          padding: const EdgeInsets.all(15),
                          child: BodyTabBar(
                            categoria: categoria,
                            puntoVenta: _puntoInicial!,
                          ));
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

/// Esta clase representa el cuerpo de la barra de pestañas para cada categoría.
///
/// [categoria] es la categoría seleccionada.
class BodyTabBar extends StatefulWidget {
  /// Categoría seleccionada.
  final CategoriaModel categoria;

  final PuntoVentaModel puntoVenta;

  /// Constructor del widget [BodyTabBar].
  ///
  /// [categoria] es la categoría seleccionada.
  const BodyTabBar({
    super.key,
    required this.categoria,
    required this.puntoVenta,
  });

  @override

  /// Crea un objeto [State] para este widget.
  State<BodyTabBar> createState() => _BodyTabBarState();
}

class _BodyTabBarState extends State<BodyTabBar> {
  @override
  Widget build(BuildContext context) {
    /// Constructor del estado que construye la interfaz de pestañas de productos
    /// basada en la categoría seleccionada y las imágenes de los productos obtenidas.
    return FutureBuilder(
      future: getImagenProductos(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ImagenProductoModel>> snapshotImagenes) {
        if (snapshotImagenes.connectionState == ConnectionState.waiting) {
          // Mientras se cargan las imágenes de productos, muestra un indicador de progreso.
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final allImages = snapshotImagenes.data!;
          return FutureBuilder(
            future: getBodegas(),
            builder: (BuildContext context,
                AsyncSnapshot<List<BodegaModel>> snapshotBodegas) {
              if (snapshotBodegas.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final bodegas = snapshotBodegas.data!;

                return FutureBuilder(
                  future: getProductos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Mientras se cargan los productos, muestra un indicador de progreso.
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      // Si no hay datos de productos o están vacíos, muestra un mensaje indicando la ausencia de productos.
                      return const Center(
                        child: Text(
                          'No hay productos',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      );
                    } else {
                      // Filtra los productos según la categoría seleccionada.
                      final productos = snapshot.data!;

                      final bodegasPunto = bodegas
                          .where((bodega) =>
                              bodega.puntoVenta.id == widget.puntoVenta.id)
                          .toList();

                      final productosDisponibles = productos.where((producto) {
                        return bodegasPunto.any((bodega) =>
                            bodega.producto.id == producto.id &&
                            bodega.cantidad >= 1);
                      }).toList();

                      List<ProductoModel> productosFiltrados;
                      if (widget.categoria.nombre == "Destacados") {
                        productosFiltrados = productosDisponibles
                            .where((producto) =>
                                producto.destacado && producto.estado)
                            .toList();
                      } else {
                        productosFiltrados = productosDisponibles
                            .where((producto) =>
                                producto.categoria.id == widget.categoria.id &&
                                producto.estado)
                            .toList();
                      }
                      if (productosFiltrados.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay productos disponibles en este momento',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
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
                            // Obtiene las imágenes correspondientes al producto actual.

                            List<String> imagenesProducto = allImages
                                .where((imagen) =>
                                    imagen.producto.id == producto.id)
                                .map((imagen) => imagen.imagen)
                                .toList();
                            return CardProducts(
                              producto: producto,
                              imagenes: imagenesProducto,
                            );
                          },
                        );
                      }
                    }
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
