// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/cards_anuncio_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/cards_pedido_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/cards_productos_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporteProductoDiaPunto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_puntoAgno_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_puntoMes_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_punto_devolucionAgno_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_punto_devolucionMes_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_recibidoAgno_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_recibidoMes_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_vendedores_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_ventasAgno_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_ventasMes_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/tablas/bodega_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/tablas/cancelado_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/tablas/devolucion_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/tablas/entregado_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/tablas/eventos_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/tablas/factura_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/tablas/pendiente_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/visitado_details.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/bodegaModel.dart';
import 'package:tienda_app/Models/boletaModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'components/header.dart';
import 'components/favorito_details.dart';

// Vista donde se llaman todos los componentes del dashboard y tambien direcciona estos componentes para que
// tengan diferentes comportamientos al momento de adaptarlos a diferentes dispositivos

class DashboardScreenPunto extends StatefulWidget {
  const DashboardScreenPunto({super.key});

  @override
  State<DashboardScreenPunto> createState() => _DashboardScreenPuntoState();
}

class _DashboardScreenPuntoState extends State<DashboardScreenPunto> {
  /// Índice del ítem seleccionado en el Dashboard.
  ///
  /// Este valor se utiliza para determinar qué pestaña está seleccionada actualmente
  /// en el Dashboard. Cada índice representa una pestaña diferente. Se utiliza para
  /// mantener la selección de la pestaña entre las actualizaciones del Dashboard.
  ///
  /// El valor predeterminado es nulo, lo que significa que no hay ninguna pestaña seleccionada.
  ///
  /// Este valor se utiliza en el método [_scrollToNextTab] para determinar si se puede
  /// navegar a la siguiente pestaña o no.
  ///
  /// Esta variable es privada y solo se utiliza en esta clase.
  int? _selectedItem;

  /// Navega hacia la siguiente pestaña en la pantalla del dashboard y actualiza el valor
  /// del índice seleccionado.
  ///
  /// Utiliza el [DefaultTabController.of] para obtener el controlador de la pestaña actual y
  /// luego llama al método [animateTo] para navegar a la siguiente pestaña.
  ///
  /// Luego actualiza el valor de [_selectedItem] con el nuevo índice de la pestaña.
  ///
  /// Si el índice actual es menor que el número de pestañas - 1, se navega a la siguiente pestaña.
  void _scrollToNextTab(BuildContext context) {
    // Obtiene el controlador de la pestaña actual
    final tabController = DefaultTabController.of(context);
    // Si el controlador existe y el índice actual es menor que el número de pestañas - 1
    if (tabController != null &&
        tabController.index < tabController.length - 1) {
      // Navega hacia la siguiente pestaña
      tabController.animateTo(tabController.index + 1);
      // Actualiza el valor del índice seleccionado
      setState(() {
        _selectedItem = tabController.index;
      });
    }
  }

  /// Navega hacia la pestaña anterior en la pantalla del dashboard y actualiza el valor
  /// del índice seleccionado.
  ///
  /// Utiliza el [DefaultTabController.of] para obtener el controlador de la pestaña actual y
  /// luego llama al método [animateTo] para navegar a la pestaña anterior.
  ///
  /// Si el índice actual es mayor que 0, se actualiza el valor de [_selectedItem] con el nuevo
  /// índice de la pestaña.
  void _scrollToPreviousTab(BuildContext context) {
    // Obtiene el controlador de la pestaña actual
    final tabController = DefaultTabController.of(context);
    // Si el controlador existe y el índice actual es mayor que 0
    if (tabController != null && tabController.index > 0) {
      // Navega hacia la pestaña anterior
      tabController.animateTo(tabController.index - 1);
      // Actualiza el valor del índice seleccionado
      setState(() {
        _selectedItem = tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene el estado de la aplicación
    return Consumer<AppState>(builder: (context, appState, _) {
      // Si el estado de la aplicación no es nulo y el usuario autenticado no es nulo
      if (appState == null || appState.usuarioAutenticado == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Obtiene el usuario autenticado
      final usuarioAutenticado = appState.usuarioAutenticado;
      return SafeArea(
        child: ListView(
          primary: false,
          padding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 16.0, bottom: 16.0),
          scrollDirection: Axis.vertical,
          children: [
            Column(
              children: [
                // Encabezado
                const Header(),
                const SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contenido principal
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          // Cards de pedidos del punto de venta
                          CardsPedidoPunto(
                            usuario: usuarioAutenticado!,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Estadísticas
                          if (!Responsive.isMobile(context))
                            const Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                          if (!Responsive.isMobile(context))
                            const SizedBox(height: defaultPadding),
                          if (!Responsive.isMobile(context))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Estadísticas",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontFamily: 'Calibri-Bold'),
                                  ),
                                ),
                              ],
                            ),
                          if (!Responsive.isMobile(context))
                            const SizedBox(height: defaultPadding),
                          if (!Responsive.isMobile(context))
                            DefaultTabController(
                                length: 10,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      // Contenedor que alberga la barra de pestañas.
                                      child: Builder(builder: (context) {
                                        return Row(
                                          children: [
                                            // Botón de anterior pestaña.
                                            IconButton(
                                              icon: const Icon(
                                                Icons.arrow_back_ios,
                                                color: primaryColor,
                                              ),
                                              onPressed: () =>
                                                  _scrollToPreviousTab(context),
                                            ),
                                            Expanded(
                                              child: TabBar(
                                                indicatorColor: primaryColor,
                                                isScrollable: true,
                                                tabAlignment:
                                                    TabAlignment.center,
                                                onTap: (index) {
                                                  // Actualiza el índice seleccionado
                                                  setState(() {
                                                    _selectedItem = index;
                                                  });
                                                },
                                                tabs: [
                                                  Tooltip(
                                                    message:
                                                        "Ventas diarias vendedores",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 4,
                                                              top: 4),
                                                      // Contenedor que alberga el ícono y el nombre de la categoría.
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/factura.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            180,
                                                                            160,
                                                                            70),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          const Text(
                                                            "Vendedores",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Tooltip(
                                                    message:
                                                        "Ventas diarias productos",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 4,
                                                              top: 4),
                                                      // Contenedor que alberga el ícono y el nombre de la categoría.
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/factura.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            180,
                                                                            160,
                                                                            70),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          const Text(
                                                            "Productos",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Tooltip(
                                                    message:
                                                        "Productos más vendidos por año",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 4,
                                                              top: 4),
                                                      // Contenedor que alberga el ícono y el nombre de la categoría.
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/productosVendidos.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFF4682B4),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          const Text(
                                                            "Año",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Tooltip(
                                                    message:
                                                        "Productos más vendidos por mes",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 4,
                                                              top: 4),
                                                      // Contenedor que alberga el ícono y el nombre de la categoría.
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/productosVendidos.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFF4682B4),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          const Text(
                                                            "Mes",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Tooltip(
                                                    message:
                                                        "Balance de ventas por año",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 4,
                                                              top: 4),
                                                      // Contenedor que alberga el ícono y el nombre de la categoría.
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ventas.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFF50C878),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          const Text(
                                                            "Año",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Tooltip(
                                                    message:
                                                        "Balance de ventas por mes",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 4,
                                                              top: 4),
                                                      // Contenedor que alberga el ícono y el nombre de la categoría.
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ventas.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFF50C878),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          const Text(
                                                            "Mes",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Tooltip(
                                                    message:
                                                        "Devoluciones por año",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 4,
                                                              top: 4),
                                                      // Contenedor que alberga el ícono y el nombre de la categoría.
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/devoluciones.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFFFF7F50),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          const Text(
                                                            "Año",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Tooltip(
                                                    message:
                                                        "Devoluciones por mes",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 4,
                                                              top: 4),
                                                      // Contenedor que alberga el ícono y el nombre de la categoría.
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/devoluciones.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFFFF7F50),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          const Text(
                                                            "Mes",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Tooltip(
                                                    message:
                                                        "Producciones recibidas por año",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 4,
                                                              top: 4),
                                                      // Contenedor que alberga el ícono y el nombre de la categoría.
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/recibidas.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFFBA55D3),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          const Text(
                                                            "Año",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Tooltip(
                                                    message:
                                                        "Producciones recibidas por mes",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 4,
                                                              top: 4),
                                                      // Contenedor que alberga el ícono y el nombre de la categoría.
                                                      child: Column(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/recibidas.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFFBA55D3),
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          const Text(
                                                            "Mes",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Botón de siguiente pestaña.
                                            IconButton(
                                              icon: const Icon(
                                                Icons.arrow_forward_ios,
                                                color: primaryColor,
                                              ),
                                              onPressed: () =>
                                                  _scrollToNextTab(context),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ],
                                )),
                          if (!Responsive.isMobile(context))
                            const SizedBox(height: defaultPadding),
                          if (!Responsive.isMobile(context))
                            // Contenedor que alberga el contenido de la pestaña.
                            _selectedItem == 0
                                ? ReporteVendedoresPunto(
                                    usuario: usuarioAutenticado)
                                : _selectedItem == 1
                                    ? ReporteProductoDiaPunto(
                                        usuario: usuarioAutenticado,
                                      )
                                    : _selectedItem == 2
                                        ? ReporteProductosMasVendidosAgnoPunto(
                                            usuario: usuarioAutenticado,
                                          )
                                        : _selectedItem == 3
                                            ? ReporteProductosMasVendidosMesPunto(
                                                usuario: usuarioAutenticado,
                                              )
                                            : _selectedItem == 4
                                                ? ReportePuntoVentasAgnoPunto(
                                                    usuario: usuarioAutenticado,
                                                  )
                                                : _selectedItem == 5
                                                    ? ReportePuntoVentasMesPunto(
                                                        usuario:
                                                            usuarioAutenticado,
                                                      )
                                                    : _selectedItem == 6
                                                        ? ReporteDevolucionesPuntoAgnoPunto(
                                                            usuario:
                                                                usuarioAutenticado,
                                                          )
                                                        : _selectedItem == 7
                                                            ? ReporteDevolucionesPuntoMesPunto(
                                                                usuario:
                                                                    usuarioAutenticado,
                                                              )
                                                            : _selectedItem == 8
                                                                ? ReporteRecibidoAgnoPunto(
                                                                    usuario:
                                                                        usuarioAutenticado,
                                                                  )
                                                                : _selectedItem ==
                                                                        9
                                                                    ? ReporteRecibidoMesPunto(
                                                                        usuario:
                                                                            usuarioAutenticado,
                                                                      )
                                                                    : ReporteVendedoresPunto(
                                                                        usuario:
                                                                            usuarioAutenticado),
                          if (!Responsive.isMobile(context))
                            const SizedBox(height: defaultPadding),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Cartas de productos
                          const CardsProductoPunto(),
                          const SizedBox(height: defaultPadding),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Cartas de anuncios
                          CardsAnuncioPunto(
                            usuario: usuarioAutenticado,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Tabla de anuncios
                          FutureBuilder(
                              future: getBoletas(), // Obtener inscripciones
                              builder: (context,
                                  AsyncSnapshot<List<BoletaModel>>
                                      snapshotBoleta) {
                                // Validar estado de la petición
                                if (snapshotBoleta.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotBoleta.hasError) {
                                  return Text(
                                    'Error al cargar inscripciones: ${snapshotBoleta.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si hay datos
                                } else if (snapshotBoleta.data == null) {
                                  return const Text(
                                    'No se encontraron inscripciones',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar datos
                                } else {
                                  List<BoletaModel> boletaPunto =
                                      []; // Lista de boletas

                                  boletaPunto.addAll(snapshotBoleta.data!.where(
                                      (boleta) =>
                                          boleta.anuncio.usuario.puntoVenta ==
                                          usuarioAutenticado
                                              .puntoVenta)); // Filtrar las boletas por el punto de venta

                                  return EventosPunto(
                                    boletas: boletaPunto,
                                    usuario: usuarioAutenticado,
                                  );
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de pedidos pendientes
                          FutureBuilder(
                              future: getPuntosVenta(), // Obtener puntos
                              builder: (context,
                                  AsyncSnapshot<List<PuntoVentaModel>>
                                      snapshotPunto) {
                                // Validar estado de la petición
                                if (snapshotPunto.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotPunto.hasError) {
                                  return Text(
                                    'Error al cargar puntos: ${snapshotPunto.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si hay datos
                                } else if (snapshotPunto.data == null) {
                                  return const Text(
                                    'No se encontraron puntos',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar datos
                                } else {
                                  return FutureBuilder(
                                      future:
                                          getAuxPedidos(), // Obtener pedidos
                                      builder: (context,
                                          AsyncSnapshot<List<AuxPedidoModel>>
                                              snapshotAuxiliar) {
                                        // Validar estado de la petición
                                        if (snapshotAuxiliar.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Validar si hay un error
                                        } else if (snapshotAuxiliar.hasError) {
                                          return Text(
                                            'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Validar si hay datos
                                        } else if (snapshotAuxiliar.data ==
                                            null) {
                                          return const Text(
                                            'No se encontraron pedidos',
                                            textAlign: TextAlign.center,
                                          );
                                          // Mostrar datos
                                        } else {
                                          List<AuxPedidoModel>
                                              pedidosPendientes =
                                              []; // Lista de pedidos

                                          // Obtener pedidos pendientes del punto de venta
                                          for (var p = 0;
                                              p < snapshotPunto.data!.length;
                                              p++) {
                                            pedidosPendientes.addAll(
                                                snapshotAuxiliar
                                                    .data!
                                                    .where((auxiliar) =>
                                                        auxiliar.pedido
                                                                .estado ==
                                                            "PENDIENTE" &&
                                                        auxiliar.pedido
                                                            .pedidoConfirmado &&
                                                        auxiliar.pedido
                                                                .puntoVenta ==
                                                            snapshotPunto
                                                                .data![p].id &&
                                                        usuarioAutenticado
                                                                .puntoVenta ==
                                                            snapshotPunto
                                                                .data![p].id));
                                          }

                                          return PendientePunto(
                                            auxPedido: pedidosPendientes,
                                            usuario: usuarioAutenticado,
                                          );
                                        }
                                      });
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de pedidos entregados
                          FutureBuilder(
                              future: getPuntosVenta(), // Obtener puntos
                              builder: (context,
                                  AsyncSnapshot<List<PuntoVentaModel>>
                                      snapshotPunto) {
                                // Validar estado de la petición
                                if (snapshotPunto.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotPunto.hasError) {
                                  return Text(
                                    'Error al cargar puntos: ${snapshotPunto.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si hay datos
                                } else if (snapshotPunto.data == null) {
                                  return const Text(
                                    'No se encontraron puntos',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar datos
                                } else {
                                  return FutureBuilder(
                                      future:
                                          getAuxPedidos(), // Obtener pedidos
                                      builder: (context,
                                          AsyncSnapshot<List<AuxPedidoModel>>
                                              snapshotAuxiliar) {
                                        // Validar estado de la petición
                                        if (snapshotAuxiliar.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Validar si hay un error
                                        } else if (snapshotAuxiliar.hasError) {
                                          return Text(
                                            'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Validar si hay datos
                                        } else if (snapshotAuxiliar.data ==
                                            null) {
                                          return const Text(
                                            'No se encontraron pedidos',
                                            textAlign: TextAlign.center,
                                          );
                                          // Mostrar datos
                                        } else {
                                          List<AuxPedidoModel>
                                              pedidosEntregados =
                                              []; // Lista de pedidos entregados

                                          // Obtener pedidos entregados del punto de venta
                                          for (var p = 0;
                                              p < snapshotPunto.data!.length;
                                              p++) {
                                            pedidosEntregados.addAll(
                                                snapshotAuxiliar.data!.where(
                                                    (auxiliar) =>
                                                        auxiliar.pedido
                                                                .estado ==
                                                            "COMPLETADO" &&
                                                        auxiliar
                                                            .pedido.entregado &&
                                                        auxiliar.pedido
                                                                .puntoVenta ==
                                                            snapshotPunto
                                                                .data![p].id &&
                                                        usuarioAutenticado
                                                                .puntoVenta ==
                                                            snapshotPunto
                                                                .data![p].id));
                                          }

                                          return EntregadoPunto(
                                            auxPedido: pedidosEntregados,
                                            usuario: usuarioAutenticado,
                                          );
                                        }
                                      });
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de pedidos cancelados
                          FutureBuilder(
                              future: getPuntosVenta(), // Obtener puntos
                              builder: (context,
                                  AsyncSnapshot<List<PuntoVentaModel>>
                                      snapshotPunto) {
                                // Validar estado de la petición
                                if (snapshotPunto.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotPunto.hasError) {
                                  return Text(
                                    'Error al cargar puntos: ${snapshotPunto.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si hay datos
                                } else if (snapshotPunto.data == null) {
                                  return const Text(
                                    'No se encontraron puntos',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar datos
                                } else {
                                  return FutureBuilder(
                                      future:
                                          getAuxPedidos(), // Obtener pedidos
                                      builder: (context,
                                          AsyncSnapshot<List<AuxPedidoModel>>
                                              snapshotAuxiliar) {
                                        // Validar estado de la petición
                                        if (snapshotAuxiliar.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Validar si hay un error
                                        } else if (snapshotAuxiliar.hasError) {
                                          return Text(
                                            'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Validar si hay datos
                                        } else if (snapshotAuxiliar.data ==
                                            null) {
                                          return const Text(
                                            'No se encontraron pedidos',
                                            textAlign: TextAlign.center,
                                          );
                                          // Mostrar datos
                                        } else {
                                          List<AuxPedidoModel>
                                              pedidosCancelados =
                                              []; // Lista de pedidos cancelados

                                          // Obtener pedidos cancelados del punto de venta
                                          for (var p = 0;
                                              p < snapshotPunto.data!.length;
                                              p++) {
                                            pedidosCancelados.addAll(
                                                snapshotAuxiliar.data!.where(
                                                    (auxiliar) =>
                                                        auxiliar.pedido
                                                                .estado ==
                                                            "CANCELADO" &&
                                                        auxiliar.pedido
                                                                .puntoVenta ==
                                                            snapshotPunto
                                                                .data![p].id &&
                                                        usuarioAutenticado
                                                                .puntoVenta ==
                                                            snapshotPunto
                                                                .data![p].id));
                                          }
                                          return CanceladoPunto(
                                            auxPedido: pedidosCancelados,
                                            usuario: usuarioAutenticado,
                                          );
                                        }
                                      });
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de facturas
                          FutureBuilder(
                              future: getPuntosVenta(), // Obtener puntos
                              builder: (context,
                                  AsyncSnapshot<List<PuntoVentaModel>>
                                      snapshotPunto) {
                                // Validar estado de la petición
                                if (snapshotPunto.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotPunto.hasError) {
                                  return Text(
                                    'Error al cargar puntos: ${snapshotPunto.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si hay datos
                                } else if (snapshotPunto.data == null) {
                                  return const Text(
                                    'No se encontraron puntos',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar datos
                                } else {
                                  return FutureBuilder(
                                      future: getFacturas(), // Obtener facturas
                                      builder: (context,
                                          AsyncSnapshot<List<FacturaModel>>
                                              snapshotFactura) {
                                        // Validar estado de la petición
                                        if (snapshotFactura.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Validar si hay un error
                                        } else if (snapshotFactura.hasError) {
                                          return Text(
                                            'Error al cargar ventas: ${snapshotFactura.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Validar si hay datos
                                        } else if (snapshotFactura.data ==
                                            null) {
                                          return const Text(
                                            'No se encontraron ventas',
                                            textAlign: TextAlign.center,
                                          );
                                          // Mostrar datos
                                        } else {
                                          return FutureBuilder(
                                              future:
                                                  getAuxPedidos(), // Obtener pedidos
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          List<AuxPedidoModel>>
                                                      snapshotAuxiliar) {
                                                // Validar estado de la petición
                                                if (snapshotAuxiliar
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                  // Validar si hay un error
                                                } else if (snapshotAuxiliar
                                                    .hasError) {
                                                  return Text(
                                                    'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                                    textAlign: TextAlign.center,
                                                  );
                                                  // Validar si hay datos
                                                } else if (snapshotAuxiliar
                                                        .data ==
                                                    null) {
                                                  return const Text(
                                                    'No se encontraron pedidos',
                                                    textAlign: TextAlign.center,
                                                  );
                                                  // Mostrar datos
                                                } else {
                                                  List<AuxPedidoModel>
                                                      pedidosFacturas =
                                                      []; // Lista de pedidos

                                                  // Obtener las facturas del punto de venta y la información relacionada
                                                  for (var p = 0;
                                                      p <
                                                          snapshotPunto
                                                              .data!.length;
                                                      p++) {
                                                    for (var f = 0;
                                                        f <
                                                            snapshotFactura
                                                                .data!.length;
                                                        f++) {
                                                      pedidosFacturas.addAll(snapshotAuxiliar
                                                          .data!
                                                          .where((pedido) =>
                                                              snapshotFactura
                                                                      .data![f]
                                                                      .pedido
                                                                      .id ==
                                                                  pedido.pedido
                                                                      .id &&
                                                              snapshotPunto
                                                                      .data![p]
                                                                      .id ==
                                                                  usuarioAutenticado
                                                                      .puntoVenta &&
                                                              pedido.pedido
                                                                      .puntoVenta ==
                                                                  snapshotPunto
                                                                      .data![p]
                                                                      .id));
                                                    }
                                                  }

                                                  return FacturaPunto(
                                                    auxPedido: pedidosFacturas,
                                                    usuario: usuarioAutenticado,
                                                  );
                                                }
                                              });
                                        }
                                      });
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de devoluciones
                          FutureBuilder(
                              future: getDevoluciones(), // Obtener devoluciones
                              builder: (context,
                                  AsyncSnapshot<List<DevolucionesModel>>
                                      snapshotDevolucion) {
                                // Validar estado de la petición
                                if (snapshotDevolucion.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotDevolucion.hasError) {
                                  return Text(
                                    'Error al cargar devoluciones: ${snapshotDevolucion.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si hay datos
                                } else if (snapshotDevolucion.data == null) {
                                  return const Text(
                                    'No se encontraron devoluciones',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar datos
                                } else {
                                  return FutureBuilder(
                                      future:
                                          getPuntosVenta(), // Obtener puntos
                                      builder: (context,
                                          AsyncSnapshot<List<PuntoVentaModel>>
                                              snapshotPunto) {
                                        // Validar estado de la petición
                                        if (snapshotPunto.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Validar si hay un error
                                        } else if (snapshotPunto.hasError) {
                                          return Text(
                                            'Error al cargar puntos: ${snapshotPunto.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Validar si hay datos
                                        } else if (snapshotPunto.data == null) {
                                          return const Text(
                                            'No se encontraron puntos',
                                            textAlign: TextAlign.center,
                                          );
                                          // Mostrar datos
                                        } else {
                                          return FutureBuilder(
                                              future:
                                                  getAuxPedidos(), // Obtener pedidos
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          List<AuxPedidoModel>>
                                                      snapshotAuxiliar) {
                                                // Validar estado de la petición
                                                if (snapshotAuxiliar
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                  // Validar si hay un error
                                                } else if (snapshotAuxiliar
                                                    .hasError) {
                                                  return Text(
                                                    'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                                    textAlign: TextAlign.center,
                                                  );
                                                  // Validar si hay datos
                                                } else if (snapshotAuxiliar
                                                        .data ==
                                                    null) {
                                                  return const Text(
                                                    'No se encontraron pedidos',
                                                    textAlign: TextAlign.center,
                                                  );
                                                  // Mostrar datos
                                                } else {
                                                  List<AuxPedidoModel>
                                                      pedidosDevueltos =
                                                      []; // Lista de pedidos

                                                  // Obtener las devoluciones del punto de venta y la información relacionada
                                                  for (var p = 0;
                                                      p <
                                                          snapshotPunto
                                                              .data!.length;
                                                      p++) {
                                                    for (var d = 0;
                                                        d <
                                                            snapshotDevolucion
                                                                .data!.length;
                                                        d++) {
                                                      pedidosDevueltos.addAll(snapshotAuxiliar
                                                          .data!
                                                          .where((pedido) =>
                                                              snapshotDevolucion
                                                                      .data![d]
                                                                      .factura
                                                                      .pedido
                                                                      .id ==
                                                                  pedido.pedido
                                                                      .id &&
                                                              snapshotPunto
                                                                      .data![p]
                                                                      .id ==
                                                                  usuarioAutenticado
                                                                      .puntoVenta &&
                                                              pedido.pedido
                                                                      .puntoVenta ==
                                                                  snapshotPunto
                                                                      .data![p]
                                                                      .id));
                                                    }
                                                  }

                                                  return DevolucionPunto(
                                                    auxPedido: pedidosDevueltos,
                                                    usuario: usuarioAutenticado,
                                                  );
                                                }
                                              });
                                        }
                                      });
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de inventario
                          FutureBuilder(
                              future: getBodegas(), // Obtener inventario
                              builder: (context,
                                  AsyncSnapshot<List<BodegaModel>>
                                      snapshotInventario) {
                                // Validar estado de la petición
                                if (snapshotInventario.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotInventario.hasError) {
                                  return Text(
                                    'Error al cargar inventarios: ${snapshotInventario.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si hay datos
                                } else if (snapshotInventario.data == null) {
                                  return const Text(
                                    'No se encontraron inventarios',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar datos
                                } else {
                                  List<BodegaModel> inventarioPunto =
                                      []; // Lista de inventario>

                                  inventarioPunto.addAll(snapshotInventario
                                      .data!
                                      .where((inventario) =>
                                          inventario.puntoVenta.id ==
                                          usuarioAutenticado
                                              .puntoVenta)); // Filtrar inventario por punto de venta

                                  return BodegaPunto(
                                    inventarioLista: inventarioPunto,
                                    usuario: usuarioAutenticado,
                                  );
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Si el dispositivo no es de escritorio se muestra la sección de favoritos y visitados
                          if (!Responsive.isDesktop(context))
                            Column(
                              children: [
                                VisitadoDetails(
                                  usuario: usuarioAutenticado,
                                ),
                                const SizedBox(height: defaultPadding),
                                const FavoritoDetails(),
                              ],
                            ),
                        ],
                      ),
                    ),
                    // Si el dispositivo es de escritorio se muestra la sección de favoritos y visitados en la parte derecha
                    if (Responsive.isDesktop(context))
                      const SizedBox(width: defaultPadding),
                    // On Mobile means if the screen is less than 850 we don't want to show it
                    if (Responsive.isDesktop(context))
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            VisitadoDetails(
                              usuario: usuarioAutenticado,
                            ),
                            const SizedBox(height: defaultPadding),
                            const FavoritoDetails(),
                          ],
                        ),
                      ),
                  ],
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
