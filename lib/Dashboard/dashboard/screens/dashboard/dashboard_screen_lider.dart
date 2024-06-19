// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/cards_anuncio_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/cards_categoria_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/cards_metodo_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/cards_produccion_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/cards_pedido_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/cards_productos_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/cards_punto_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/cards_sedes_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/cards_unidad_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_costosAgno_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_costosMes_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_produccionAgno_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_produccionMes_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_puntoMes_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_punto_devolucionAgno_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_puntoAgno_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_punto_devolucionMes_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_recibidoAgno_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_recibidoMes_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_ventasAgno_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/reporte_ventasMes_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/tablas/bodega_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/tablas/cancelado_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/tablas/devolucion_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/tablas/entregado_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/tablas/eventos_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/tablas/factura_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/tablas/produccion_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/tablas/usuario_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/visitado_details.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'components/header.dart';
import 'components/favorito_details.dart';

// Vista donde se llaman todos los componentes del dashboard y tambien direcciona estos componentes para que
// tengan diferentes comportamientos al momento de adaptarlos a diferentes dispositivos

class DashboardScreenLider extends StatefulWidget {
  const DashboardScreenLider({super.key});

  @override
  State<DashboardScreenLider> createState() => _DashboardScreenLiderState();
}

class _DashboardScreenLiderState extends State<DashboardScreenLider> {
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
                                    CardsPedidoLider(
                                      usuario: usuarioAutenticado!,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const CardsProduccionLider(),
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
                                        length: 12,
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
                                                                "Costo de producción por año",
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
                                                                    "assets/icons/costoProduccion.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFFCD5C5C),
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
                                                                "Costo de producción por mes",
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
                                                                    "assets/icons/costoProduccion.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFFCD5C5C),
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
                                                                "Producciones despachadas por año",
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
                                                                    "assets/icons/produccion.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFFB8860B),
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
                                                                "Producciones despachadas por mes",
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
                                                                    "assets/icons/produccion.svg",
                                                                    width: 24,
                                                                    height: 24,
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Color(
                                                                            0xFFB8860B),
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
                                        ? const ReporteCostoProduccionAgnoLider()
                                        : _selectedItem == 1
                                            ? const ReporteCostoProduccionMesLider()
                                            : _selectedItem == 2
                                                ? const ReporteProductosMasVendidosAgnoLider()
                                                : _selectedItem == 3
                                                    ? const ReporteProductosMasVendidosMesLider()
                                                    : _selectedItem == 4
                                                        ? const ReportePuntoVentasAgnoLider()
                                                        : _selectedItem == 5
                                                            ? const ReportePuntoVentasMesLider()
                                                            : _selectedItem == 6
                                                                ? const ReporteDevolucionesPuntoAgnoLider()
                                                                : _selectedItem ==
                                                                        7
                                                                    ? const ReporteDevolucionesPuntoMesLider()
                                                                    : _selectedItem ==
                                                                            8
                                                                        ? const ReporteProduccionAgnoLider()
                                                                        : _selectedItem ==
                                                                                9
                                                                            ? const ReporteProduccionMesLider()
                                                                            : _selectedItem == 10
                                                                                ? const ReporteRecibidoAgnoLider()
                                                                                : _selectedItem == 11
                                                                                    ? const ReporteRecibidoMesLider()
                                                                                    : const ReporteCostoProduccionAgnoLider(),
                                    const SizedBox(height: defaultPadding),
                                    const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const CardsCategoriaLider(),
                                    const SizedBox(height: defaultPadding),
                                    const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const CardsProductoLider(),
                                    const SizedBox(height: defaultPadding),
                                    const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const CardsAnuncioLider(),
                                    const SizedBox(height: defaultPadding),
                                    const EventosLider(),
                                    const SizedBox(height: defaultPadding),
                                    const EntregadoLider(),
                                    const SizedBox(height: defaultPadding),
                                    const CanceladoLider(),
                                    const SizedBox(height: defaultPadding),
                                    const CardsMetodoLider(),
                                    const SizedBox(height: defaultPadding),
                                    const FacturaLider(),
                                    const SizedBox(height: defaultPadding),
                                    const DevolucionLider(),
                                    const SizedBox(height: defaultPadding),
                                    const CardsUnidadLider(),
                                    const SizedBox(height: defaultPadding),
                                    const ProduccionLider(),
                                    const SizedBox(height: defaultPadding),
                                    const CardsPuntoLider(),
                                    const SizedBox(height: defaultPadding),
                                    const BodegaLider(),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                      future: getUsuarios(),
                                      builder: (context,
                                          AsyncSnapshot<List<UsuarioModel>>
                                              snapshotUsuario) {
                                        if (snapshotUsuario.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshotUsuario.hasError) {
                                          return Text(
                                              'Error al cargar usuarios: ${snapshotUsuario.error}');
                                        } else if (snapshotUsuario.data ==
                                            null) {
                                          return const Text(
                                              'No se encontraron usuarios');
                                        } else {
                                          return UsuarioLider(
                                            usuarioLista: snapshotUsuario.data!,
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const CardsSedeLider(),
                                    const SizedBox(height: defaultPadding),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (!Responsive.isDesktop(context))
                            const SizedBox(height: defaultPadding),
                          if (!Responsive.isDesktop(context))
                            const Column(
                              children: [
                                VisitadoDetails(),
                                SizedBox(height: defaultPadding),
                                FavoritoDetails(),
                              ],
                            ),
                        ],
                      ),
                    ),
                    if (Responsive.isDesktop(context))
                      const SizedBox(width: defaultPadding),
                    // On Mobile means if the screen is less than 850 we don't want to show it
                    if (Responsive.isDesktop(context))
                      const Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            VisitadoDetails(),
                            SizedBox(height: defaultPadding),
                            FavoritoDetails(),
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
