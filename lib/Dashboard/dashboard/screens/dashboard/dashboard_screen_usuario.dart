// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/usuario/cards_pedido_usuario.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/usuario/tablas/cancelado_usuario.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/usuario/tablas/devolucion_usuario.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/usuario/tablas/entregado_usuario.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/usuario/tablas/eventos_usuario.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/usuario/tablas/factura_usuario.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/usuario/tablas/pendiente_usuario.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/visitado_details.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/boletaModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'components/header.dart';
import 'components/favorito_details.dart';

// Vista donde se llaman todos los componentes del dashboard y tambien direcciona estos componentes para que
// tengan diferentes comportamientos al momento de adaptarlos a diferentes dispositivos

class DashboardScreenUsuario extends StatelessWidget {
  const DashboardScreenUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene el estado de la aplicación
    return Consumer<AppState>(builder: (context, appState, _) {
      // Obtiene el usuario autenticado
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
                // Cuerpo
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divicion izquierda
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
                                    // Card de pedidos del usuario
                                    CardsPedidoUsuario(
                                      usuario: usuarioAutenticado!,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    // Tabla de los eventos del usuario
                                    FutureBuilder(
                                        future:
                                            getBoletas(), // Obtiene las boletas
                                        builder: (context,
                                            AsyncSnapshot<List<BoletaModel>>
                                                snapshotBoleta) {
                                          // Muestra el indicador de carga mientras los datos se cargan
                                          if (snapshotBoleta.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                            // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                          } else if (snapshotBoleta.hasError) {
                                            return Text(
                                                'Error al cargar inscripciones: ${snapshotBoleta.error}');
                                            // Muestra un texto 'No se encontraron boletas' si no hay datos
                                          } else if (snapshotBoleta.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron inscripciones');
                                            // Muestra las boletas del usuario
                                          } else {
                                            List<BoletaModel> boletaUsuario =
                                                []; // Lista para almacenar las boletas del usuario

                                            boletaUsuario = snapshotBoleta.data!
                                                .where((boleta) =>
                                                    boleta.usuario ==
                                                    usuarioAutenticado.id)
                                                .toList(); // Filtra las boletas del usuario

                                            return EventosUsuario(
                                              boletas: boletaUsuario,
                                            );
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    // Tabla de los pedidos pendientes
                                    FutureBuilder(
                                        future:
                                            getAuxPedidos(), // Obtiene los pedidos
                                        builder: (context,
                                            AsyncSnapshot<List<AuxPedidoModel>>
                                                snapshotAuxiliar) {
                                          // Muestra el indicador de carga mientras los datos se cargan
                                          if (snapshotAuxiliar
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                            // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                          } else if (snapshotAuxiliar
                                              .hasError) {
                                            return Text(
                                                'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                            // Muestra un texto 'No se encontraron pedidos' si no hay datos
                                          } else if (snapshotAuxiliar.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron pedidos');
                                            // Muestra los pedidos pendientes
                                          } else {
                                            List<AuxPedidoModel>
                                                pedidosPendientes =
                                                []; // Lista para almacenar los pedidos pendientes

                                            pedidosPendientes = snapshotAuxiliar
                                                .data!
                                                .where((auxiliar) =>
                                                    auxiliar.pedido.estado ==
                                                        "PENDIENTE" &&
                                                    auxiliar.pedido
                                                        .pedidoConfirmado &&
                                                    auxiliar.pedido.usuario
                                                            .id ==
                                                        usuarioAutenticado.id)
                                                .toList(); // Filtra los pedidos pendientes del usuario
                                            return PendienteUsuario(
                                              auxPedido: pedidosPendientes,
                                            );
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    // Tabla de los pedidos entregados
                                    FutureBuilder(
                                        future:
                                            getAuxPedidos(), // Obtiene los pedidos
                                        builder: (context,
                                            AsyncSnapshot<List<AuxPedidoModel>>
                                                snapshotAuxiliar) {
                                          // Muestra el indicador de carga mientras los datos se cargan
                                          if (snapshotAuxiliar
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                            // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                          } else if (snapshotAuxiliar
                                              .hasError) {
                                            return Text(
                                                'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                            // Muestra un texto 'No se encontraron pedidos' si no hay datos
                                          } else if (snapshotAuxiliar.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron pedidos');
                                            // Muestra los pedidos entregados
                                          } else {
                                            List<AuxPedidoModel>
                                                pedidosEntregados =
                                                []; // Lista para almacenar los pedidos entregados

                                            pedidosEntregados = snapshotAuxiliar
                                                .data!
                                                .where((auxiliar) =>
                                                    auxiliar.pedido.estado ==
                                                        "COMPLETADO" &&
                                                    auxiliar.pedido.entregado &&
                                                    auxiliar.pedido.usuario
                                                            .id ==
                                                        usuarioAutenticado.id)
                                                .toList(); // Filtra los pedidos entregados del usuario
                                            return EntregadoUsuario(
                                              auxPedido: pedidosEntregados,
                                            );
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    // Tabla de los pedidos cancelados
                                    FutureBuilder(
                                        future:
                                            getAuxPedidos(), // Obtiene los pedidos
                                        builder: (context,
                                            AsyncSnapshot<List<AuxPedidoModel>>
                                                snapshotAuxiliar) {
                                          // Muestra el indicador de carga mientras los datos se cargan
                                          if (snapshotAuxiliar
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                            // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                          } else if (snapshotAuxiliar
                                              .hasError) {
                                            return Text(
                                                'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                            // Muestra un texto 'No se encontraron pedidos' si no hay datos
                                          } else if (snapshotAuxiliar.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron pedidos');
                                            // Muestra los pedidos cancelados
                                          } else {
                                            List<AuxPedidoModel>
                                                pedidosCancelados =
                                                []; // Lista para almacenar los pedidos cancelados

                                            pedidosCancelados = snapshotAuxiliar
                                                .data!
                                                .where((auxiliar) =>
                                                    auxiliar.pedido.estado ==
                                                        "CANCELADO" &&
                                                    auxiliar.pedido.usuario
                                                            .id ==
                                                        usuarioAutenticado.id)
                                                .toList(); // Filtra los pedidos cancelados del usuario
                                            return CanceladoUsuario(
                                              auxPedido: pedidosCancelados,
                                            );
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future:
                                            getFacturas(), // Obtiene las facturas
                                        builder: (context,
                                            AsyncSnapshot<List<FacturaModel>>
                                                snapshotFactura) {
                                          // Muestra el indicador de carga mientras los datos se cargan
                                          if (snapshotFactura.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                            // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                          } else if (snapshotFactura.hasError) {
                                            return Text(
                                                'Error al cargar ventas: ${snapshotFactura.error}');
                                            // Muestra un texto 'No se encontraron ventas' si no hay datos
                                          } else if (snapshotFactura.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron ventas');
                                            // Muestra las ventas
                                          } else {
                                            return FutureBuilder(
                                                future:
                                                    getAuxPedidos(), // Obtiene los pedidos
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<
                                                                AuxPedidoModel>>
                                                        snapshotAuxiliar) {
                                                  // Muestra el indicador de carga mientras los datos se cargan
                                                  if (snapshotAuxiliar
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                    // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                                  } else if (snapshotAuxiliar
                                                      .hasError) {
                                                    return Text(
                                                        'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                                    // Muestra un texto 'No se encontraron pedidos' si no hay datos
                                                  } else if (snapshotAuxiliar
                                                          .data ==
                                                      null) {
                                                    return const Text(
                                                        'No se encontraron pedidos');
                                                    // Muestra las ventas
                                                  } else {
                                                    List<AuxPedidoModel>
                                                        pedidosFacturas =
                                                        []; // Lista para almacenar las facturas

                                                    // Obtiene los pedidos correspondientes a las facturas del usuario
                                                    for (var f = 0;
                                                        f <
                                                            snapshotFactura
                                                                .data!.length;
                                                        f++) {
                                                      pedidosFacturas = snapshotAuxiliar
                                                          .data!
                                                          .where((pedido) =>
                                                              snapshotFactura
                                                                      .data![f]
                                                                      .pedido
                                                                      .id ==
                                                                  pedido.pedido
                                                                      .id &&
                                                              snapshotFactura
                                                                      .data![f]
                                                                      .pedido
                                                                      .usuario
                                                                      .id ==
                                                                  usuarioAutenticado
                                                                      .id)
                                                          .toList();
                                                    }

                                                    return FacturaUsuario(
                                                      auxPedido:
                                                          pedidosFacturas,
                                                    );
                                                  }
                                                });
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future:
                                            getDevoluciones(), // Obtiene las devoluciones
                                        builder: (context,
                                            AsyncSnapshot<
                                                    List<DevolucionesModel>>
                                                snapshotDevolucion) {
                                          // Muestra el indicador de carga mientras los datos se cargan
                                          if (snapshotDevolucion
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                            // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                          } else if (snapshotDevolucion
                                              .hasError) {
                                            return Text(
                                                'Error al cargar devoluciones: ${snapshotDevolucion.error}');
                                            // Muestra un texto 'No se encontraron devoluciones' si no hay datos
                                          } else if (snapshotDevolucion.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron devoluciones');
                                            // Muestra las devoluciones
                                          } else {
                                            return FutureBuilder(
                                                future:
                                                    getAuxPedidos(), // Obtiene los pedidos
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<
                                                                AuxPedidoModel>>
                                                        snapshotAuxiliar) {
                                                  // Muestra el indicador de carga mientras los datos se cargan
                                                  if (snapshotAuxiliar
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                    // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                                  } else if (snapshotAuxiliar
                                                      .hasError) {
                                                    return Text(
                                                        'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                                    // Muestra un texto 'No se encontraron pedidos' si no hay datos
                                                  } else if (snapshotAuxiliar
                                                          .data ==
                                                      null) {
                                                    return const Text(
                                                        'No se encontraron pedidos');
                                                  } else {
                                                    List<AuxPedidoModel>
                                                        pedidosDevueltos =
                                                        []; // Lista para almacenar las devoluciones

                                                    // Obtiene los pedidos correspondientes a las devoluciones del usuario
                                                    for (var d = 0;
                                                        d <
                                                            snapshotDevolucion
                                                                .data!.length;
                                                        d++) {
                                                      pedidosDevueltos = snapshotAuxiliar
                                                          .data!
                                                          .where((pedido) =>
                                                              snapshotDevolucion
                                                                      .data![d]
                                                                      .factura
                                                                      .pedido
                                                                      .id ==
                                                                  pedido.pedido
                                                                      .id &&
                                                              snapshotDevolucion
                                                                      .data![d]
                                                                      .factura
                                                                      .pedido
                                                                      .usuario
                                                                      .id ==
                                                                  usuarioAutenticado
                                                                      .id)
                                                          .toList();
                                                    }

                                                    return DevolucionUsuario(
                                                      auxPedido:
                                                          pedidosDevueltos,
                                                    );
                                                  }
                                                });
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Si la pantalla no es de escritorio, muestra la sección de visitados y favoritos
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
                    // Si la pantalla es de escritorio, muestra la sección de visitados y favoritos en la parte derecha de la pantalla
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
