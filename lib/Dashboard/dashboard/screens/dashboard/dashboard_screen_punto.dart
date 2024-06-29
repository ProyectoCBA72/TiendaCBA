// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/cards_anuncio_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/cards_pedido_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/cards_productos_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_puntoAgno_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_puntoMes_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_punto_devolucionAgno_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_punto_devolucionMes_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_recibidoAgno_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/reporte_recibidoMes_punto.dart';
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
import 'package:tienda_app/Models/boletaModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/inventarioModel.dart';
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
  int? _selectedItem;

  void _scrollToNextTab(BuildContext context) {
    final tabController = DefaultTabController.of(context);
    if (tabController != null &&
        tabController.index < tabController.length - 1) {
      tabController.animateTo(tabController.index + 1);
      setState(() {
        _selectedItem = tabController.index;
      });
    }
  }

  void _scrollToPreviousTab(BuildContext context) {
    final tabController = DefaultTabController.of(context);
    if (tabController != null && tabController.index > 0) {
      tabController.animateTo(tabController.index - 1);
      setState(() {
        _selectedItem = tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, _) {
      if (appState == null || appState.usuarioAutenticado == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

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
                const Header(),
                const SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 1300,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                Column(
                                  children: [
                                    CardsPedidoPunto(
                                      usuario: usuarioAutenticado!,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Estadísticas",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                    fontFamily: 'Calibri-Bold'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    DefaultTabController(
                                        length: 8,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              // Contenedor que alberga la barra de pestañas.
                                              child:
                                                  Builder(builder: (context) {
                                                return Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.arrow_back_ios,
                                                        color: primaryColor,
                                                      ),
                                                      onPressed: () =>
                                                          _scrollToPreviousTab(
                                                              context),
                                                    ),
                                                    Expanded(
                                                      child: TabBar(
                                                        indicatorColor:
                                                            primaryColor,
                                                        isScrollable: true,
                                                        tabAlignment:
                                                            TabAlignment.center,
                                                        onTap: (index) {
                                                          setState(() {
                                                            _selectedItem =
                                                                index;
                                                          });
                                                        },
                                                        tabs: [
                                                          Tooltip(
                                                            message:
                                                                "Productos más vendidos por año",
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 4,
                                                                      top: 4),
                                                              // Contenedor que alberga el ícono y el nombre de la categoría.
                                                              child: Column(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/icons/productosVendidos.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFF4682B4),
                                                                        BlendMode
                                                                            .srcIn),
                                                                  ),
                                                                  const Text(
                                                                    "Año",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
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
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 4,
                                                                      top: 4),
                                                              // Contenedor que alberga el ícono y el nombre de la categoría.
                                                              child: Column(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/icons/productosVendidos.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFF4682B4),
                                                                        BlendMode
                                                                            .srcIn),
                                                                  ),
                                                                  const Text(
                                                                    "Mes",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
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
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 4,
                                                                      top: 4),
                                                              // Contenedor que alberga el ícono y el nombre de la categoría.
                                                              child: Column(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/icons/ventas.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFF50C878),
                                                                        BlendMode
                                                                            .srcIn),
                                                                  ),
                                                                  const Text(
                                                                    "Año",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
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
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 4,
                                                                      top: 4),
                                                              // Contenedor que alberga el ícono y el nombre de la categoría.
                                                              child: Column(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/icons/ventas.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFF50C878),
                                                                        BlendMode
                                                                            .srcIn),
                                                                  ),
                                                                  const Text(
                                                                    "Mes",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
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
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 4,
                                                                      top: 4),
                                                              // Contenedor que alberga el ícono y el nombre de la categoría.
                                                              child: Column(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/icons/devoluciones.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFFFF7F50),
                                                                        BlendMode
                                                                            .srcIn),
                                                                  ),
                                                                  const Text(
                                                                    "Año",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
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
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 4,
                                                                      top: 4),
                                                              // Contenedor que alberga el ícono y el nombre de la categoría.
                                                              child: Column(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/icons/devoluciones.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFFFF7F50),
                                                                        BlendMode
                                                                            .srcIn),
                                                                  ),
                                                                  const Text(
                                                                    "Mes",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
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
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 4,
                                                                      top: 4),
                                                              // Contenedor que alberga el ícono y el nombre de la categoría.
                                                              child: Column(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/icons/recibidas.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFFBA55D3),
                                                                        BlendMode
                                                                            .srcIn),
                                                                  ),
                                                                  const Text(
                                                                    "Año",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
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
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom: 4,
                                                                      top: 4),
                                                              // Contenedor que alberga el ícono y el nombre de la categoría.
                                                              child: Column(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/icons/recibidas.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFFBA55D3),
                                                                        BlendMode
                                                                            .srcIn),
                                                                  ),
                                                                  const Text(
                                                                    "Mes",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
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
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: primaryColor,
                                                      ),
                                                      onPressed: () =>
                                                          _scrollToNextTab(
                                                              context),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(height: defaultPadding),
                                    _selectedItem == 0
                                        ? const ReporteProductosMasVendidosAgnoPunto()
                                        : _selectedItem == 1
                                            ? const ReporteProductosMasVendidosMesPunto()
                                            : _selectedItem == 2
                                                ? const ReportePuntoVentasAgnoPunto()
                                                : _selectedItem == 3
                                                    ? const ReportePuntoVentasMesPunto()
                                                    : _selectedItem == 4
                                                        ? const ReporteDevolucionesPuntoAgnoPunto()
                                                        : _selectedItem == 5
                                                            ? const ReporteDevolucionesPuntoMesPunto()
                                                            : _selectedItem == 6
                                                                ? const ReporteRecibidoAgnoPunto()
                                                                : _selectedItem ==
                                                                        7
                                                                    ? const ReporteRecibidoMesPunto()
                                                                    : const ReporteProductosMasVendidosAgnoPunto(),
                                    const SizedBox(height: defaultPadding),
                                    const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const CardsProductoPunto(),
                                    const SizedBox(height: defaultPadding),
                                    const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const CardsAnuncioPunto(),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getBoletas(),
                                        builder: (context,
                                            AsyncSnapshot<List<BoletaModel>>
                                                snapshotBoleta) {
                                          if (snapshotBoleta.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotBoleta.hasError) {
                                            return Text(
                                                'Error al cargar inscripciones: ${snapshotBoleta.error}');
                                          } else if (snapshotBoleta.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron inscripciones');
                                          } else {
                                            List<BoletaModel> boletaPunto = [];

                                            boletaPunto = snapshotBoleta.data!
                                                .where((boleta) =>
                                                    boleta.anuncio.usuario
                                                        .puntoVenta ==
                                                    usuarioAutenticado
                                                        .puntoVenta)
                                                .toList();

                                            return EventosPunto(
                                              boletas: boletaPunto,
                                            );
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getPuntosVenta(),
                                        builder: (context,
                                            AsyncSnapshot<List<PuntoVentaModel>>
                                                snapshotPunto) {
                                          if (snapshotPunto.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotPunto.hasError) {
                                            return Text(
                                                'Error al cargar puntos: ${snapshotPunto.error}');
                                          } else if (snapshotPunto.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron puntos');
                                          } else {
                                            return FutureBuilder(
                                                future: getAuxPedidos(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<
                                                                AuxPedidoModel>>
                                                        snapshotAuxiliar) {
                                                  if (snapshotAuxiliar
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshotAuxiliar
                                                      .hasError) {
                                                    return Text(
                                                        'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                                  } else if (snapshotAuxiliar
                                                          .data ==
                                                      null) {
                                                    return const Text(
                                                        'No se encontraron pedidos');
                                                  } else {
                                                    List<AuxPedidoModel>
                                                        pedidosPendientes = [];

                                                    for (var p = 0;
                                                        p <
                                                            snapshotPunto
                                                                .data!.length;
                                                        p++) {
                                                      pedidosPendientes = snapshotAuxiliar
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
                                                                      .data![p]
                                                                      .id &&
                                                              usuarioAutenticado
                                                                      .puntoVenta ==
                                                                  snapshotPunto
                                                                      .data![p]
                                                                      .id)
                                                          .toList();
                                                    }

                                                    return PendientePunto(
                                                      auxPedido:
                                                          pedidosPendientes,
                                                    );
                                                  }
                                                });
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getPuntosVenta(),
                                        builder: (context,
                                            AsyncSnapshot<List<PuntoVentaModel>>
                                                snapshotPunto) {
                                          if (snapshotPunto.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotPunto.hasError) {
                                            return Text(
                                                'Error al cargar puntos: ${snapshotPunto.error}');
                                          } else if (snapshotPunto.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron puntos');
                                          } else {
                                            return FutureBuilder(
                                                future: getAuxPedidos(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<
                                                                AuxPedidoModel>>
                                                        snapshotAuxiliar) {
                                                  if (snapshotAuxiliar
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshotAuxiliar
                                                      .hasError) {
                                                    return Text(
                                                        'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                                  } else if (snapshotAuxiliar
                                                          .data ==
                                                      null) {
                                                    return const Text(
                                                        'No se encontraron pedidos');
                                                  } else {
                                                    List<AuxPedidoModel>
                                                        pedidosEntregados = [];

                                                    for (var p = 0;
                                                        p <
                                                            snapshotPunto
                                                                .data!.length;
                                                        p++) {
                                                      pedidosEntregados = snapshotAuxiliar
                                                          .data!
                                                          .where((auxiliar) =>
                                                              auxiliar.pedido
                                                                      .estado ==
                                                                  "COMPLETADO" &&
                                                              auxiliar.pedido
                                                                  .entregado &&
                                                              auxiliar.pedido
                                                                      .puntoVenta ==
                                                                  snapshotPunto
                                                                      .data![p]
                                                                      .id &&
                                                              usuarioAutenticado
                                                                      .puntoVenta ==
                                                                  snapshotPunto
                                                                      .data![p]
                                                                      .id)
                                                          .toList();
                                                    }

                                                    return EntregadoPunto(
                                                      auxPedido:
                                                          pedidosEntregados,
                                                    );
                                                  }
                                                });
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getPuntosVenta(),
                                        builder: (context,
                                            AsyncSnapshot<List<PuntoVentaModel>>
                                                snapshotPunto) {
                                          if (snapshotPunto.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotPunto.hasError) {
                                            return Text(
                                                'Error al cargar puntos: ${snapshotPunto.error}');
                                          } else if (snapshotPunto.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron puntos');
                                          } else {
                                            return FutureBuilder(
                                                future: getAuxPedidos(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<
                                                                AuxPedidoModel>>
                                                        snapshotAuxiliar) {
                                                  if (snapshotAuxiliar
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshotAuxiliar
                                                      .hasError) {
                                                    return Text(
                                                        'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                                  } else if (snapshotAuxiliar
                                                          .data ==
                                                      null) {
                                                    return const Text(
                                                        'No se encontraron pedidos');
                                                  } else {
                                                    List<AuxPedidoModel>
                                                        pedidosCancelados = [];

                                                    for (var p = 0;
                                                        p <
                                                            snapshotPunto
                                                                .data!.length;
                                                        p++) {
                                                      pedidosCancelados = snapshotAuxiliar
                                                          .data!
                                                          .where((auxiliar) =>
                                                              auxiliar.pedido
                                                                      .estado ==
                                                                  "CANCELADO" &&
                                                              auxiliar.pedido
                                                                      .puntoVenta ==
                                                                  snapshotPunto
                                                                      .data![p]
                                                                      .id &&
                                                              usuarioAutenticado
                                                                      .puntoVenta ==
                                                                  snapshotPunto
                                                                      .data![p]
                                                                      .id)
                                                          .toList();
                                                    }
                                                    return CanceladoPunto(
                                                      auxPedido:
                                                          pedidosCancelados,
                                                    );
                                                  }
                                                });
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getPuntosVenta(),
                                        builder: (context,
                                            AsyncSnapshot<List<PuntoVentaModel>>
                                                snapshotPunto) {
                                          if (snapshotPunto.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotPunto.hasError) {
                                            return Text(
                                                'Error al cargar puntos: ${snapshotPunto.error}');
                                          } else if (snapshotPunto.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron puntos');
                                          } else {
                                            return FutureBuilder(
                                                future: getFacturas(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<FacturaModel>>
                                                        snapshotFactura) {
                                                  if (snapshotFactura
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshotFactura
                                                      .hasError) {
                                                    return Text(
                                                        'Error al cargar ventas: ${snapshotFactura.error}');
                                                  } else if (snapshotFactura
                                                          .data ==
                                                      null) {
                                                    return const Text(
                                                        'No se encontraron ventas');
                                                  } else {
                                                    return FutureBuilder(
                                                        future: getAuxPedidos(),
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                    List<
                                                                        AuxPedidoModel>>
                                                                snapshotAuxiliar) {
                                                          if (snapshotAuxiliar
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const CircularProgressIndicator();
                                                          } else if (snapshotAuxiliar
                                                              .hasError) {
                                                            return Text(
                                                                'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                                          } else if (snapshotAuxiliar
                                                                  .data ==
                                                              null) {
                                                            return const Text(
                                                                'No se encontraron pedidos');
                                                          } else {
                                                            List<AuxPedidoModel>
                                                                pedidosFacturas =
                                                                [];

                                                            for (var p = 0;
                                                                p <
                                                                    snapshotPunto
                                                                        .data!
                                                                        .length;
                                                                p++) {
                                                              for (var f = 0;
                                                                  f <
                                                                      snapshotFactura
                                                                          .data!
                                                                          .length;
                                                                  f++) {
                                                                pedidosFacturas = snapshotAuxiliar
                                                                    .data!
                                                                    .where((pedido) =>
                                                                        snapshotFactura.data![f].pedido.id == pedido.pedido.id &&
                                                                        snapshotPunto.data![p].id ==
                                                                            usuarioAutenticado
                                                                                .puntoVenta &&
                                                                        pedido.pedido.puntoVenta ==
                                                                            snapshotPunto.data![p].id)
                                                                    .toList();
                                                              }
                                                            }

                                                            return FacturaPunto(
                                                              auxPedido:
                                                                  pedidosFacturas,
                                                            );
                                                          }
                                                        });
                                                  }
                                                });
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getDevoluciones(),
                                        builder: (context,
                                            AsyncSnapshot<
                                                    List<DevolucionesModel>>
                                                snapshotDevolucion) {
                                          if (snapshotDevolucion
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotDevolucion
                                              .hasError) {
                                            return Text(
                                                'Error al cargar devoluciones: ${snapshotDevolucion.error}');
                                          } else if (snapshotDevolucion.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron devoluciones');
                                          } else {
                                            return FutureBuilder(
                                                future: getPuntosVenta(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<
                                                                PuntoVentaModel>>
                                                        snapshotPunto) {
                                                  if (snapshotPunto
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshotPunto
                                                      .hasError) {
                                                    return Text(
                                                        'Error al cargar puntos: ${snapshotPunto.error}');
                                                  } else if (snapshotPunto
                                                          .data ==
                                                      null) {
                                                    return const Text(
                                                        'No se encontraron puntos');
                                                  } else {
                                                    return FutureBuilder(
                                                        future: getAuxPedidos(),
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                    List<
                                                                        AuxPedidoModel>>
                                                                snapshotAuxiliar) {
                                                          if (snapshotAuxiliar
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const CircularProgressIndicator();
                                                          } else if (snapshotAuxiliar
                                                              .hasError) {
                                                            return Text(
                                                                'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                                          } else if (snapshotAuxiliar
                                                                  .data ==
                                                              null) {
                                                            return const Text(
                                                                'No se encontraron pedidos');
                                                          } else {
                                                            List<AuxPedidoModel>
                                                                pedidosDevueltos =
                                                                [];

                                                            for (var p = 0;
                                                                p <
                                                                    snapshotPunto
                                                                        .data!
                                                                        .length;
                                                                p++) {
                                                              for (var d = 0;
                                                                  d <
                                                                      snapshotDevolucion
                                                                          .data!
                                                                          .length;
                                                                  d++) {
                                                                pedidosDevueltos = snapshotAuxiliar
                                                                    .data!
                                                                    .where((pedido) =>
                                                                        snapshotDevolucion.data![d].factura.pedido.id == pedido.pedido.id &&
                                                                        snapshotPunto.data![p].id ==
                                                                            usuarioAutenticado
                                                                                .puntoVenta &&
                                                                        pedido.pedido.puntoVenta ==
                                                                            snapshotPunto.data![p].id)
                                                                    .toList();
                                                              }
                                                            }

                                                            return DevolucionPunto(
                                                              auxPedido:
                                                                  pedidosDevueltos,
                                                            );
                                                          }
                                                        });
                                                  }
                                                });
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getInventario(),
                                        builder: (context,
                                            AsyncSnapshot<List<InventarioModel>>
                                                snapshotInventario) {
                                          if (snapshotInventario
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotInventario
                                              .hasError) {
                                            return Text(
                                                'Error al cargar inventarios: ${snapshotInventario.error}');
                                          } else if (snapshotInventario.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron inventarios');
                                          } else {
                                            final inventarioPunto =
                                                snapshotInventario.data!
                                                    .where((inventario) =>
                                                        inventario.bodega
                                                            .puntoVenta.id ==
                                                        usuarioAutenticado
                                                            .puntoVenta)
                                                    .toList();

                                            return BodegaPunto(
                                              inventarioLista: inventarioPunto,
                                            );
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (!Responsive.isDesktop(context))
                            const SizedBox(height: defaultPadding),
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
