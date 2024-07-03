// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                                    CardsPedidoUsuario(
                                      usuario: usuarioAutenticado!,
                                    ),
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
                                            List<BoletaModel> boletaUsuario =
                                                [];

                                            boletaUsuario = snapshotBoleta.data!
                                                .where((boleta) =>
                                                    boleta.usuario ==
                                                    usuarioAutenticado.id)
                                                .toList();

                                            return EventosUsuario(
                                              boletas: boletaUsuario,
                                            );
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getAuxPedidos(),
                                        builder: (context,
                                            AsyncSnapshot<List<AuxPedidoModel>>
                                                snapshotAuxiliar) {
                                          if (snapshotAuxiliar
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotAuxiliar
                                              .hasError) {
                                            return Text(
                                                'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                          } else if (snapshotAuxiliar.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron pedidos');
                                          } else {
                                            List<AuxPedidoModel>
                                                pedidosPendientes = [];

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
                                                .toList();
                                            return PendienteUsuario(
                                              auxPedido: pedidosPendientes,
                                            );
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getAuxPedidos(),
                                        builder: (context,
                                            AsyncSnapshot<List<AuxPedidoModel>>
                                                snapshotAuxiliar) {
                                          if (snapshotAuxiliar
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotAuxiliar
                                              .hasError) {
                                            return Text(
                                                'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                          } else if (snapshotAuxiliar.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron pedidos');
                                          } else {
                                            List<AuxPedidoModel>
                                                pedidosEntregados = [];

                                            pedidosEntregados = snapshotAuxiliar
                                                .data!
                                                .where((auxiliar) =>
                                                    auxiliar.pedido.estado ==
                                                        "COMPLETADO" &&
                                                    auxiliar.pedido.entregado &&
                                                    auxiliar.pedido.usuario
                                                            .id ==
                                                        usuarioAutenticado.id)
                                                .toList();
                                            return EntregadoUsuario(
                                              auxPedido: pedidosEntregados,
                                            );
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getAuxPedidos(),
                                        builder: (context,
                                            AsyncSnapshot<List<AuxPedidoModel>>
                                                snapshotAuxiliar) {
                                          if (snapshotAuxiliar
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotAuxiliar
                                              .hasError) {
                                            return Text(
                                                'Error al cargar pedidos: ${snapshotAuxiliar.error}');
                                          } else if (snapshotAuxiliar.data ==
                                              null) {
                                            return const Text(
                                                'No se encontraron pedidos');
                                          } else {
                                            List<AuxPedidoModel>
                                                pedidosCancelados = [];

                                            pedidosCancelados = snapshotAuxiliar
                                                .data!
                                                .where((auxiliar) =>
                                                    auxiliar.pedido.estado ==
                                                        "CANCELADO" &&
                                                    auxiliar.pedido.usuario
                                                            .id ==
                                                        usuarioAutenticado.id)
                                                .toList();
                                            return CanceladoUsuario(
                                              auxPedido: pedidosCancelados,
                                            );
                                          }
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future: getFacturas(),
                                        builder: (context,
                                            AsyncSnapshot<List<FacturaModel>>
                                                snapshotFactura) {
                                          if (snapshotFactura.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshotFactura.hasError) {
                                            return Text(
                                                'Error al cargar ventas: ${snapshotFactura.error}');
                                          } else if (snapshotFactura.data ==
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
                                                        pedidosFacturas = [];

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
                                                        pedidosDevueltos = [];

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
