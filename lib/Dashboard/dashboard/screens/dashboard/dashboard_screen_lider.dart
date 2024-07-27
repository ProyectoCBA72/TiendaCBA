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
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/boletaModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/inventarioModel.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
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
  /// Representa el índice del elemento seleccionado en la pantalla del dashboard.
  ///
  /// Este valor se utiliza para determinar la pestaña actualmente seleccionada en el Dashboard.
  /// Si no se ha seleccionado ningún elemento, este valor será nulo.
  /// El valor inicial se inicializa en nulo.
  ///
  /// El tipo de dato de este atributo es `int?` (opcional), lo que significa que puede ser `null`.
  /// Se utiliza para almacenar un entero que puede ser nulo.
  ///
  /// Este atributo se utiliza para mantener el estado de la pantalla del Dashboard y se actualiza
  /// cada vez que el usuario cambia de pestaña.
  ///
  /// Este atributo se declara como privado y no se puede modificar desde fuera de la clase.
  /// Sólo se puede acceder a este atributo mediante los métodos de la clase.
  ///
  /// El nombre de este atributo se utiliza para hacer referencia a él en otros métodos de la clase.
  int? _selectedItem; // Indice del elemento seleccionado en el dashboard

  /// Navega hacia la siguiente pestaña en la pantalla del dashboard y actualiza el valor
  /// del índice seleccionado.
  ///
  /// Utiliza el [DefaultTabController.of] para obtener el controlador de la pestaña actual y
  /// luego llama al método [animateTo] para navegar a la siguiente pestaña.
  ///
  /// Luego actualiza el valor de [_selectedItem] con el nuevo índice de la pestaña.
  ///
  /// El parámetro [context] es el contexto de la construcción de la pantalla.
  /// Es obligatorio para poder obtener el controlador de la pestaña actual.
  void _scrollToNextTab(BuildContext context) {
    // Obtiene el controlador de la pestaña actual
    final tabController = DefaultTabController.of(context);
    // Si el controlador existe y el índice actual es menor que el último índice de la pestaña
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
  ///
  /// El parámetro [context] es el contexto de la construcción de la pantalla.
  /// Es obligatorio para poder obtener el controlador de la pestaña actual.
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
    // Carga el estado del aplicativo
    return Consumer<AppState>(builder: (context, appState, _) {
      // Carga el usuario autenticado
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
                          // Cartas de pedidos de la sede
                          CardsPedidoLider(
                            usuario: usuarioAutenticado!,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Cartas de producciones de la sede
                          CardsProduccionLider(
                            usuario: usuarioAutenticado,
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
                                length: 12,
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
                                                        "Costo de producción por año",
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
                                                            "assets/icons/costoProduccion.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFFCD5C5C),
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
                                                        "Costo de producción por mes",
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
                                                            "assets/icons/costoProduccion.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFFCD5C5C),
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
                                                        "Producciones despachadas por año",
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
                                                            "assets/icons/produccion.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFFB8860B),
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
                                                        "Producciones despachadas por mes",
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
                                                            "assets/icons/produccion.svg",
                                                            width: 24,
                                                            height: 24,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color(
                                                                        0xFFB8860B),
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
                                ? ReporteCostoProduccionAgnoLider(
                                    usuario: usuarioAutenticado,
                                  )
                                : _selectedItem == 1
                                    ? ReporteCostoProduccionMesLider(
                                        usuario: usuarioAutenticado,
                                      )
                                    : _selectedItem == 2
                                        ? ReporteProductosMasVendidosAgnoLider(
                                            usuario: usuarioAutenticado,
                                          )
                                        : _selectedItem == 3
                                            ? ReporteProductosMasVendidosMesLider(
                                                usuario: usuarioAutenticado,
                                              )
                                            : _selectedItem == 4
                                                ? ReportePuntoVentasAgnoLider(
                                                    usuario: usuarioAutenticado,
                                                  )
                                                : _selectedItem == 5
                                                    ? ReportePuntoVentasMesLider(
                                                        usuario:
                                                            usuarioAutenticado,
                                                      )
                                                    : _selectedItem == 6
                                                        ? ReporteDevolucionesPuntoAgnoLider(
                                                            usuario:
                                                                usuarioAutenticado,
                                                          )
                                                        : _selectedItem == 7
                                                            ? ReporteDevolucionesPuntoMesLider(
                                                                usuario:
                                                                    usuarioAutenticado,
                                                              )
                                                            : _selectedItem == 8
                                                                ? ReporteProduccionAgnoLider(
                                                                    usuario:
                                                                        usuarioAutenticado,
                                                                  )
                                                                : _selectedItem ==
                                                                        9
                                                                    ? ReporteProduccionMesLider(
                                                                        usuario:
                                                                            usuarioAutenticado,
                                                                      )
                                                                    : _selectedItem ==
                                                                            10
                                                                        ? ReporteRecibidoAgnoLider(
                                                                            usuario:
                                                                                usuarioAutenticado,
                                                                          )
                                                                        : _selectedItem ==
                                                                                11
                                                                            ? ReporteRecibidoMesLider(
                                                                                usuario: usuarioAutenticado,
                                                                              )
                                                                            : ReporteCostoProduccionAgnoLider(
                                                                                usuario: usuarioAutenticado,
                                                                              ),
                          if (!Responsive.isMobile(context))
                            const SizedBox(height: defaultPadding),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Cartas de categorías
                          const CardsCategoriaLider(),
                          const SizedBox(height: defaultPadding),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Cartas de productos
                          const CardsProductoLider(),
                          const SizedBox(height: defaultPadding),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Cartas de anuncios
                          CardsAnuncioLider(
                            usuario: usuarioAutenticado,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Tabla de anuncios
                          FutureBuilder(
                              future: getBoletas(), // Cargar inscripciones
                              builder: (context,
                                  AsyncSnapshot<List<BoletaModel>>
                                      snapshotBoleta) {
                                // Cargar inscripciones
                                if (snapshotBoleta.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotBoleta.hasError) {
                                  return Text(
                                    'Error al cargar inscripciones: ${snapshotBoleta.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si no hay inscripciones
                                } else if (snapshotBoleta.data == null) {
                                  return const Text(
                                    'No se encontraron inscripciones',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar las inscripciones
                                } else {
                                  List<BoletaModel> boletaSede =
                                      []; // Lista para las boletas de la sede

                                  boletaSede.addAll(snapshotBoleta.data!.where(
                                      (boleta) =>
                                          boleta.anuncio.usuario.sede ==
                                          usuarioAutenticado
                                              .sede)); // Filtra las boletas por la sede

                                  return EventosLider(
                                    boletas: boletaSede,
                                    usuario: usuarioAutenticado,
                                  );
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de pedidos entregados
                          FutureBuilder(
                              future: getPuntosVenta(), // Cargar puntos
                              builder: (context,
                                  AsyncSnapshot<List<PuntoVentaModel>>
                                      snapshotPunto) {
                                // Cargar puntos
                                if (snapshotPunto.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotPunto.hasError) {
                                  return Text(
                                    'Error al cargar puntos: ${snapshotPunto.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si no hay puntos
                                } else if (snapshotPunto.data == null) {
                                  return const Text(
                                    'No se encontraron puntos',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar los puntos
                                } else {
                                  return FutureBuilder(
                                      future: getAuxPedidos(), // Cargar pedidos
                                      builder: (context,
                                          AsyncSnapshot<List<AuxPedidoModel>>
                                              snapshotAuxiliar) {
                                        // Cargar pedidos
                                        if (snapshotAuxiliar.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Validar si hay un error
                                        } else if (snapshotAuxiliar.hasError) {
                                          return Text(
                                            'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Validar si no hay pedidos
                                        } else if (snapshotAuxiliar.data ==
                                            null) {
                                          return const Text(
                                            'No se encontraron pedidos',
                                            textAlign: TextAlign.center,
                                          );
                                          // Mostrar los pedidos
                                        } else {
                                          List<AuxPedidoModel>
                                              pedidosEntregados =
                                              []; // Lista para los pedidos

                                          // Obtener los pedidos entregados de los puntos de venta correspondientes a la sede
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
                                                                .sede ==
                                                            snapshotPunto
                                                                .data![p]
                                                                .sede));
                                          }

                                          return EntregadoLider(
                                            usuario: usuarioAutenticado,
                                            auxPedido: pedidosEntregados,
                                          );
                                        }
                                      });
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de pedidos cancelados
                          FutureBuilder(
                              future: getPuntosVenta(), // Cargar puntos
                              builder: (context,
                                  AsyncSnapshot<List<PuntoVentaModel>>
                                      snapshotPunto) {
                                // Cargar puntos
                                if (snapshotPunto.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotPunto.hasError) {
                                  return Text(
                                    'Error al cargar puntos: ${snapshotPunto.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si no hay puntos
                                } else if (snapshotPunto.data == null) {
                                  return const Text(
                                    'No se encontraron puntos',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar los puntos
                                } else {
                                  return FutureBuilder(
                                      future: getAuxPedidos(), // Cargar pedidos
                                      builder: (context,
                                          AsyncSnapshot<List<AuxPedidoModel>>
                                              snapshotAuxiliar) {
                                        // Cargar pedidos
                                        if (snapshotAuxiliar.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Validar si hay un error
                                        } else if (snapshotAuxiliar.hasError) {
                                          return Text(
                                            'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Validar si no hay pedidos
                                        } else if (snapshotAuxiliar.data ==
                                            null) {
                                          return const Text(
                                            'No se encontraron pedidos',
                                            textAlign: TextAlign.center,
                                          );
                                          // Mostrar los pedidos
                                        } else {
                                          List<AuxPedidoModel>
                                              pedidosCancelados =
                                              []; // Lista para los pedidos

                                          // Obtener los pedidos cancelados de los puntos de venta correspondientes a la sede
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
                                                                .sede ==
                                                            snapshotPunto
                                                                .data![p]
                                                                .sede));
                                          }
                                          return CanceladoLider(
                                            auxPedido: pedidosCancelados,
                                            usuario: usuarioAutenticado,
                                          );
                                        }
                                      });
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Metodo de pago
                          const CardsMetodoLider(),
                          const SizedBox(height: defaultPadding),
                          // Tabla de facturas
                          FutureBuilder(
                              future: getPuntosVenta(), // Obtener los puntos
                              builder: (context,
                                  AsyncSnapshot<List<PuntoVentaModel>>
                                      snapshotPunto) {
                                // Cargar puntos
                                if (snapshotPunto.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Validar si hay un error
                                } else if (snapshotPunto.hasError) {
                                  return Text(
                                    'Error al cargar puntos: ${snapshotPunto.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Validar si no hay puntos
                                } else if (snapshotPunto.data == null) {
                                  return const Text(
                                    'No se encontraron puntos',
                                    textAlign: TextAlign.center,
                                  );
                                  // Mostrar los puntos
                                } else {
                                  return FutureBuilder(
                                      future: getFacturas(), // Obtener facturas
                                      builder: (context,
                                          AsyncSnapshot<List<FacturaModel>>
                                              snapshotFactura) {
                                        // Cargar facturas
                                        if (snapshotFactura.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Validar si hay un error
                                        } else if (snapshotFactura.hasError) {
                                          return Text(
                                            'Error al cargar ventas: ${snapshotFactura.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Validar si no hay facturas
                                        } else if (snapshotFactura.data ==
                                            null) {
                                          return const Text(
                                            'No se encontraron ventas',
                                            textAlign: TextAlign.center,
                                          );
                                          // Mostrar las facturas
                                        } else {
                                          return FutureBuilder(
                                              future:
                                                  getAuxPedidos(), // Obtener pedidos
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          List<AuxPedidoModel>>
                                                      snapshotAuxiliar) {
                                                // Cargar pedidos
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
                                                  // Validar si no hay pedidos
                                                } else if (snapshotAuxiliar
                                                        .data ==
                                                    null) {
                                                  return const Text(
                                                    'No se encontraron pedidos',
                                                    textAlign: TextAlign.center,
                                                  );
                                                  // Mostrar los pedidos
                                                } else {
                                                  List<AuxPedidoModel>
                                                      pedidosFacturas =
                                                      []; // Lista para los pedidos

                                                  // Obtener las facturas de los puntos de venta correspondientes a la sede
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
                                                                      .sede ==
                                                                  usuarioAutenticado
                                                                      .sede &&
                                                              pedido.pedido
                                                                      .puntoVenta ==
                                                                  snapshotPunto
                                                                      .data![p]
                                                                      .id));
                                                    }
                                                  }

                                                  return FacturaLider(
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
                              future:
                                  getDevoluciones(), // Obtiene las devoluciones
                              builder: (context,
                                  AsyncSnapshot<List<DevolucionesModel>>
                                      snapshotDevolucion) {
                                // Muestra un CircularProgressIndicator mientras se obtienen las devoluciones
                                if (snapshotDevolucion.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Muestra un mensaje de error si ocurre un problema al cargar las devoluciones
                                } else if (snapshotDevolucion.hasError) {
                                  return Text(
                                    'Error al cargar devoluciones: ${snapshotDevolucion.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra un mensaje de que no se encontraron devoluciones
                                } else if (snapshotDevolucion.data == null) {
                                  return const Text(
                                    'No se encontraron devoluciones',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra el contenido de las devoluciones
                                } else {
                                  return FutureBuilder(
                                      future:
                                          getPuntosVenta(), // Obtiene los puntos de venta
                                      builder: (context,
                                          AsyncSnapshot<List<PuntoVentaModel>>
                                              snapshotPunto) {
                                        // Muestra un CircularProgressIndicator mientras se obtienen los puntos de venta
                                        if (snapshotPunto.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Muestra un mensaje de error si ocurre un problema al cargar los puntos de venta
                                        } else if (snapshotPunto.hasError) {
                                          return Text(
                                            'Error al cargar puntos: ${snapshotPunto.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Muestra un mensaje de que no se encontraron puntos de venta
                                        } else if (snapshotPunto.data == null) {
                                          return const Text(
                                            'No se encontraron puntos',
                                            textAlign: TextAlign.center,
                                          );
                                          // Muestra el contenido de los puntos de venta
                                        } else {
                                          return FutureBuilder(
                                              future:
                                                  getAuxPedidos(), // Obtiene los pedidos
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          List<AuxPedidoModel>>
                                                      snapshotAuxiliar) {
                                                // Muestra un CircularProgressIndicator mientras se obtienen los pedidos
                                                if (snapshotAuxiliar
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                  // Muestra un mensaje de error si ocurre un problema al cargar los pedidos
                                                } else if (snapshotAuxiliar
                                                    .hasError) {
                                                  return Text(
                                                    'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                                    textAlign: TextAlign.center,
                                                  );
                                                  // Muestra un mensaje de que no se encontraron pedidos
                                                } else if (snapshotAuxiliar
                                                        .data ==
                                                    null) {
                                                  return const Text(
                                                    'No se encontraron pedidos',
                                                    textAlign: TextAlign.center,
                                                  );
                                                  // Muestra el contenido de los pedidos
                                                } else {
                                                  List<AuxPedidoModel>
                                                      pedidosDevueltos =
                                                      []; // Lista para los pedidos

                                                  // Obtener las devoluciones de los puntos de venta correspondientes a la sede
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
                                                                      .sede ==
                                                                  usuarioAutenticado
                                                                      .sede &&
                                                              pedido.pedido
                                                                      .puntoVenta ==
                                                                  snapshotPunto
                                                                      .data![p]
                                                                      .id));
                                                    }
                                                  }

                                                  return DevolucionLider(
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
                          // Cartas de las unidades de producción
                          const CardsUnidadLider(),
                          const SizedBox(height: defaultPadding),
                          // Tabla de producciones
                          FutureBuilder(
                              future:
                                  getProducciones(), // Obtiene las producciones
                              builder: (context,
                                  AsyncSnapshot<List<ProduccionModel>>
                                      snapshotProduccion) {
                                // Muestra un CircularProgressIndicator mientras se obtienen las producciones
                                if (snapshotProduccion.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Muestra un mensaje de error si ocurre un problema al cargar las producciones
                                } else if (snapshotProduccion.hasError) {
                                  return Text(
                                    'Error al cargar producciones: ${snapshotProduccion.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra un mensaje de que no se encontraron producciones
                                } else if (snapshotProduccion.data == null) {
                                  return const Text(
                                    'No se encontraron producciones',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra el contenido de las producciones
                                } else {
                                  List<ProduccionModel> produccionSede = [];

                                  produccionSede.addAll(snapshotProduccion.data!
                                      .where((produccion) =>
                                          produccion.unidadProduccion.sede.id ==
                                          usuarioAutenticado
                                              .sede)); // Filtra las producciones por la sede de usuario

                                  return ProduccionLider(
                                    producciones: produccionSede,
                                    usuario: usuarioAutenticado,
                                  );
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Cartas de los puntos de venta
                          const CardsPuntoLider(),
                          const SizedBox(height: defaultPadding),
                          // Tabla de inventarios
                          FutureBuilder(
                              future:
                                  getInventario(), // Obtiene los inventarios
                              builder: (context,
                                  AsyncSnapshot<List<InventarioModel>>
                                      snapshotInventario) {
                                // Muestra un CircularProgressIndicator mientras se obtienen los inventarios
                                if (snapshotInventario.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Muestra un mensaje de error si ocurre un problema al cargar los inventarios
                                } else if (snapshotInventario.hasError) {
                                  return Text(
                                    'Error al cargar inventarios: ${snapshotInventario.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra un mensaje de que no se encontraron inventarios
                                } else if (snapshotInventario.data == null) {
                                  return const Text(
                                    'No se encontraron inventarios',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra el contenido de los inventarios
                                } else {
                                  List<InventarioModel> inventarioSede = [];

                                  inventarioSede.addAll(snapshotInventario.data!
                                      .where((inventario) =>
                                          inventario.bodega.puntoVenta.sede ==
                                          usuarioAutenticado
                                              .sede)); // Filtra los inventarios por la sede de usuario

                                  return BodegaLider(
                                    usuario: usuarioAutenticado,
                                    inventarioLista: inventarioSede,
                                  );
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de usuarios
                          FutureBuilder(
                            future: getUsuarios(), // Obtiene los usuarios
                            builder: (context,
                                AsyncSnapshot<List<UsuarioModel>>
                                    snapshotUsuario) {
                              // Muestra un CircularProgressIndicator mientras se obtienen los usuarios
                              if (snapshotUsuario.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                                // Muestra un mensaje de error si ocurre un problema al cargar los usuarios
                              } else if (snapshotUsuario.hasError) {
                                return Text(
                                  'Error al cargar usuarios: ${snapshotUsuario.error}',
                                  textAlign: TextAlign.center,
                                );
                                // Muestra un mensaje de que no se encontraron usuarios
                              } else if (snapshotUsuario.data == null) {
                                return const Text(
                                  'No se encontraron usuarios',
                                  textAlign: TextAlign.center,
                                );
                                // Muestra el contenido de los usuarios
                              } else {
                                return UsuarioLider(
                                  usuarioLista: snapshotUsuario.data!,
                                  usuario: usuarioAutenticado,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: defaultPadding),
                          // Cartas de las sedes
                          const CardsSedeLider(),
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
