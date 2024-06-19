// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/cards_anuncio_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/cards_categoria_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/cards_produccion_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/cards_productos_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/reporte_costosAgno_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/reporte_costosMes_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/reporte_produccionAgno_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/reporte_produccionMes_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/reporte_recibidoAgno_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/reporte_recibidoMes_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/reporte_ventasAgno_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/reporte_ventasMes_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/tablas/eventos_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/tablas/produccion_recibida_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/tablas/produccion_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/visitado_details.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';
import 'components/header.dart';
import 'components/favorito_details.dart';

// Vista donde se llaman todos los componentes del dashboard y tambien direcciona estos componentes para que
// tengan diferentes comportamientos al momento de adaptarlos a diferentes dispositivos

class DashboardScreenUnidad extends StatefulWidget {
  const DashboardScreenUnidad({super.key});

  @override
  State<DashboardScreenUnidad> createState() => _DashboardScreenUnidadState();
}

class _DashboardScreenUnidadState extends State<DashboardScreenUnidad> {
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
                                  const CardsProduccionUnidad(),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            // Contenedor que alberga la barra de pestañas.
                                            child: Builder(builder: (context) {
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
                                                          _selectedItem = index;
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
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  _selectedItem == 0
                                      ? const ReporteCostoProduccionAgnoUnidad()
                                      : _selectedItem == 1
                                          ? const ReporteCostoProduccionMesUnidad()
                                          : _selectedItem == 2
                                              ? const ReporteProductosMasVendidosAgnoUnidad()
                                              : _selectedItem == 3
                                                  ? const ReporteProductosMasVendidosMesUnidad()
                                                  : _selectedItem == 4
                                                      ? const ReporteProduccionAgnoUnidad()
                                                      : _selectedItem == 5
                                                          ? const ReporteProduccionMesUnidad()
                                                          : _selectedItem == 6
                                                              ? const ReporteRecibidoAgnoUnidad()
                                                              : _selectedItem ==
                                                                      7
                                                                  ? const ReporteRecibidoMesUnidad()
                                                                  : const ReporteCostoProduccionAgnoUnidad(),
                                  const SizedBox(height: defaultPadding),
                                  const Divider(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  const CardsCategoriaUnidad(),
                                  const SizedBox(height: defaultPadding),
                                  const Divider(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  const CardsProductoUnidad(),
                                  const SizedBox(height: defaultPadding),
                                  const Divider(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: defaultPadding),
                                  const CardsAnuncioUnidad(),
                                  const SizedBox(height: defaultPadding),
                                  const EventosUnidad(),
                                  const SizedBox(height: defaultPadding),
                                  const ProduccionUnidad(),
                                  const SizedBox(height: defaultPadding),
                                  const ProduccionRecibidaUnidad(),
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
  }
}
