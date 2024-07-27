// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/unidad/cards_anuncio_unidad.dart';
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
import 'package:tienda_app/Models/boletaModel.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
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
  /// Representa el índice del elemento seleccionado en la pantalla.
  ///
  /// Es un valor opcional que puede ser nulo. Se utiliza para indicar el índice del tab
  /// seleccionado en la pantalla del dashboard. Por defecto, es nulo.
  /// Este valor se utiliza para controlar el comportamiento de la pantalla al
  /// adaptarla a diferentes dispositivos y tamaños de pantalla.
  ///
  /// Ejemplo de uso:
  ///   // Obtener el valor del índice seleccionado
  ///   int? selectedIndex = _selectedItem;
  ///
  ///   // Establecer un nuevo valor para el índice seleccionado
  ///   _selectedItem = 2;
  ///
  /// Nota: Este valor no se debe modificar directamente, ya que puede causar
  /// comportamientos inesperados en la pantalla. Utiliza los métodos proporcionados
  /// para cambiar el valor de este índice.
  ///
  /// Ver: [DashboardScreenUnidad._scrollToNextTab], [DashboardScreenUnidad._scrollToPreviousTab]
  int? _selectedItem;

  /// Navega hacia la siguiente pestaña en la pantalla del dashboard y actualiza el valor
  /// del índice seleccionado.
  ///
  /// Utiliza el [DefaultTabController.of] para obtener el controlador de la pestaña actual y
  /// luego llama al método [animateTo] para navegar a la siguiente pestaña.
  ///
  /// Luego actualiza el valor de [_selectedItem] con el nuevo índice de la pestaña.
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
                          // Sección de cards de producción
                          CardsProduccionUnidad(
                            usuario: usuarioAutenticado!,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Sección de estadísticas si la pantalla es de escritorio
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
                            const SizedBox(
                              height: defaultPadding,
                            ),
                          if (!Responsive.isMobile(context))
                            // Contenedor que alberga el contenido de la pestaña.
                            _selectedItem == 0
                                ? ReporteCostoProduccionAgnoUnidad(
                                    usuario: usuarioAutenticado,
                                  )
                                : _selectedItem == 1
                                    ? ReporteCostoProduccionMesUnidad(
                                        usuario: usuarioAutenticado,
                                      )
                                    : _selectedItem == 2
                                        ? ReporteProductosMasVendidosAgnoUnidad(
                                            usuario: usuarioAutenticado,
                                          )
                                        : _selectedItem == 3
                                            ? ReporteProductosMasVendidosMesUnidad(
                                                usuario: usuarioAutenticado,
                                              )
                                            : _selectedItem == 4
                                                ? ReporteProduccionAgnoUnidad(
                                                    usuario: usuarioAutenticado,
                                                  )
                                                : _selectedItem == 5
                                                    ? ReporteProduccionMesUnidad(
                                                        usuario:
                                                            usuarioAutenticado,
                                                      )
                                                    : _selectedItem == 6
                                                        ? ReporteRecibidoAgnoUnidad(
                                                            usuario:
                                                                usuarioAutenticado,
                                                          )
                                                        : _selectedItem == 7
                                                            ? ReporteRecibidoMesUnidad(
                                                                usuario:
                                                                    usuarioAutenticado,
                                                              )
                                                            : ReporteCostoProduccionAgnoUnidad(
                                                                usuario:
                                                                    usuarioAutenticado,
                                                              ),
                          if (!Responsive.isMobile(context))
                            const SizedBox(height: defaultPadding),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Cartas de productos
                          const CardsProductoUnidad(),
                          const SizedBox(height: defaultPadding),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Cartas de anuncios
                          CardsAnuncioUnidad(
                            usuario: usuarioAutenticado,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Tabla de anuncios
                          FutureBuilder(
                              future: getBoletas(), // Obtiene las boletas
                              builder: (context,
                                  AsyncSnapshot<List<BoletaModel>>
                                      snapshotBoleta) {
                                // Muestra un CircularProgressIndicator mientras se obtienen las boletas
                                if (snapshotBoleta.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Muestra un mensaje de error si ocurre un problema al cargar las boletas
                                } else if (snapshotBoleta.hasError) {
                                  return Text(
                                    'Error al cargar inscripciones: ${snapshotBoleta.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra un mensaje de que no se encontraron boletas
                                } else if (snapshotBoleta.data == null) {
                                  return const Text(
                                    'No se encontraron inscripciones',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra el contenido de las boletas
                                } else {
                                  List<BoletaModel> boletaUnidad =
                                      []; // Lista de boletas

                                  boletaUnidad.addAll(snapshotBoleta.data!
                                      .where((boleta) =>
                                          boleta.anuncio.usuario
                                              .unidadProduccion ==
                                          usuarioAutenticado
                                              .unidadProduccion)); // Filtra las boletas por la unidad de usuario

                                  return EventosUnidad(
                                    boletas: boletaUnidad,
                                    usuario: usuarioAutenticado,
                                  );
                                }
                              }),
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
                                  List<ProduccionModel> produccionUnidad = [];

                                  produccionUnidad.addAll(snapshotProduccion
                                      .data!
                                      .where((produccion) =>
                                          produccion.unidadProduccion.id ==
                                          usuarioAutenticado
                                              .unidadProduccion)); // Filtra las producciones por la unidad de usuario

                                  return ProduccionUnidad(
                                    producciones: produccionUnidad,
                                    usuario: usuarioAutenticado,
                                  );
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de producciones recibidas
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
                                  List<ProduccionModel>
                                      produccionRecibidaUnidad = [];

                                  produccionRecibidaUnidad.addAll(
                                      snapshotProduccion.data!.where((produccion) =>
                                          produccion.unidadProduccion.id ==
                                          usuarioAutenticado
                                              .unidadProduccion)); // Filtra las producciones por la unidad de usuario

                                  return ProduccionRecibidaUnidad(
                                    producciones: produccionRecibidaUnidad,
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
