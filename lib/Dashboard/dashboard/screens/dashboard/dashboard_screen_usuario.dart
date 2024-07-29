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
          shrinkWrap: true,
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
                    // Division izquierda
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          // Card de pedidos del usuario
                          CardsPedidoUsuario(
                            usuario: usuarioAutenticado!,
                          ),
                          const SizedBox(height: defaultPadding),
                          // Tabla de los eventos del usuario
                          FutureBuilder(
                              future: getBoletas(), // Obtiene las boletas
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
                                    'Error al cargar inscripciones: ${snapshotBoleta.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra un texto 'No se encontraron boletas' si no hay datos
                                } else if (snapshotBoleta.data == null) {
                                  return const Text(
                                    'No se encontraron inscripciones',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra las boletas del usuario
                                } else {
                                  List<BoletaModel> boletaUsuario =
                                      []; // Lista para almacenar las boletas del usuario

                                  boletaUsuario.addAll(snapshotBoleta.data!
                                      .where((boleta) =>
                                          boleta.usuario ==
                                          usuarioAutenticado
                                              .id)); // Filtra las boletas del usuario

                                  return EventosUsuario(
                                    boletas: boletaUsuario,
                                    usuario: usuarioAutenticado,
                                  );
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de los pedidos pendientes
                          FutureBuilder(
                              future: getAuxPedidos(), // Obtiene los pedidos
                              builder: (context,
                                  AsyncSnapshot<List<AuxPedidoModel>>
                                      snapshotAuxiliar) {
                                // Muestra el indicador de carga mientras los datos se cargan
                                if (snapshotAuxiliar.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                } else if (snapshotAuxiliar.hasError) {
                                  return Text(
                                    'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra un texto 'No se encontraron pedidos' si no hay datos
                                } else if (snapshotAuxiliar.data == null) {
                                  return const Text(
                                    'No se encontraron pedidos',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra los pedidos pendientes
                                } else {
                                  List<AuxPedidoModel> pedidosPendientes =
                                      []; // Lista para almacenar los pedidos pendientes

                                  pedidosPendientes.addAll(
                                      snapshotAuxiliar.data!.where((auxiliar) =>
                                          auxiliar.pedido.estado ==
                                              "PENDIENTE" &&
                                          auxiliar.pedido.pedidoConfirmado &&
                                          auxiliar.pedido.usuario.id ==
                                              usuarioAutenticado
                                                  .id)); // Filtra los pedidos pendientes del usuario
                                  return PendienteUsuario(
                                    auxPedido: pedidosPendientes,
                                    usuario: usuarioAutenticado,
                                  );
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de los pedidos entregados
                          FutureBuilder(
                              future: getAuxPedidos(), // Obtiene los pedidos
                              builder: (context,
                                  AsyncSnapshot<List<AuxPedidoModel>>
                                      snapshotAuxiliar) {
                                // Muestra el indicador de carga mientras los datos se cargan
                                if (snapshotAuxiliar.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                } else if (snapshotAuxiliar.hasError) {
                                  return Text(
                                    'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra un texto 'No se encontraron pedidos' si no hay datos
                                } else if (snapshotAuxiliar.data == null) {
                                  return const Text(
                                    'No se encontraron pedidos',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra los pedidos entregados
                                } else {
                                  List<AuxPedidoModel> pedidosEntregados =
                                      []; // Lista para almacenar los pedidos entregados

                                  pedidosEntregados.addAll(
                                      snapshotAuxiliar.data!.where((auxiliar) =>
                                          auxiliar.pedido.estado ==
                                              "COMPLETADO" &&
                                          auxiliar.pedido.entregado &&
                                          auxiliar.pedido.usuario.id ==
                                              usuarioAutenticado
                                                  .id)); // Filtra los pedidos entregados del usuario
                                  return EntregadoUsuario(
                                    auxPedido: pedidosEntregados,
                                    usuario: usuarioAutenticado,
                                  );
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          // Tabla de los pedidos cancelados
                          FutureBuilder(
                              future: getAuxPedidos(), // Obtiene los pedidos
                              builder: (context,
                                  AsyncSnapshot<List<AuxPedidoModel>>
                                      snapshotAuxiliar) {
                                // Muestra el indicador de carga mientras los datos se cargan
                                if (snapshotAuxiliar.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                } else if (snapshotAuxiliar.hasError) {
                                  return Text(
                                    'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra un texto 'No se encontraron pedidos' si no hay datos
                                } else if (snapshotAuxiliar.data == null) {
                                  return const Text(
                                    'No se encontraron pedidos',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra los pedidos cancelados
                                } else {
                                  List<AuxPedidoModel> pedidosCancelados =
                                      []; // Lista para almacenar los pedidos cancelados

                                  pedidosCancelados.addAll(
                                      snapshotAuxiliar.data!.where((auxiliar) =>
                                          auxiliar.pedido.estado ==
                                              "CANCELADO" &&
                                          auxiliar.pedido.usuario.id ==
                                              usuarioAutenticado
                                                  .id)); // Filtra los pedidos cancelados del usuario
                                  return CanceladoUsuario(
                                    auxPedido: pedidosCancelados,
                                    usuario: usuarioAutenticado,
                                  );
                                }
                              }),
                          const SizedBox(height: defaultPadding),
                          FutureBuilder(
                              future: getFacturas(), // Obtiene las facturas
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
                                    'Error al cargar ventas: ${snapshotFactura.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra un texto 'No se encontraron ventas' si no hay datos
                                } else if (snapshotFactura.data == null) {
                                  return const Text(
                                    'No se encontraron ventas',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra las ventas
                                } else {
                                  return FutureBuilder(
                                      future:
                                          getAuxPedidos(), // Obtiene los pedidos
                                      builder: (context,
                                          AsyncSnapshot<List<AuxPedidoModel>>
                                              snapshotAuxiliar) {
                                        // Muestra el indicador de carga mientras los datos se cargan
                                        if (snapshotAuxiliar.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                        } else if (snapshotAuxiliar.hasError) {
                                          return Text(
                                            'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Muestra un texto 'No se encontraron pedidos' si no hay datos
                                        } else if (snapshotAuxiliar.data ==
                                            null) {
                                          return const Text(
                                            'No se encontraron pedidos',
                                            textAlign: TextAlign.center,
                                          );
                                          // Muestra las ventas
                                        } else {
                                          List<AuxPedidoModel> pedidosFacturas =
                                              []; // Lista para almacenar las facturas

                                          // Obtiene los pedidos correspondientes a las facturas del usuario
                                          for (var f = 0;
                                              f < snapshotFactura.data!.length;
                                              f++) {
                                            pedidosFacturas.addAll(
                                                snapshotAuxiliar.data!.where(
                                                    (pedido) =>
                                                        snapshotFactura.data![f]
                                                                .pedido.id ==
                                                            pedido.pedido.id &&
                                                        snapshotFactura
                                                                .data![f]
                                                                .pedido
                                                                .usuario
                                                                .id ==
                                                            usuarioAutenticado
                                                                .id));
                                          }

                                          return FacturaUsuario(
                                            auxPedido: pedidosFacturas,
                                            usuario: usuarioAutenticado,
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
                                  AsyncSnapshot<List<DevolucionesModel>>
                                      snapshotDevolucion) {
                                // Muestra el indicador de carga mientras los datos se cargan
                                if (snapshotDevolucion.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                  // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                } else if (snapshotDevolucion.hasError) {
                                  return Text(
                                    'Error al cargar devoluciones: ${snapshotDevolucion.error}',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra un texto 'No se encontraron devoluciones' si no hay datos
                                } else if (snapshotDevolucion.data == null) {
                                  return const Text(
                                    'No se encontraron devoluciones',
                                    textAlign: TextAlign.center,
                                  );
                                  // Muestra las devoluciones
                                } else {
                                  return FutureBuilder(
                                      future:
                                          getAuxPedidos(), // Obtiene los pedidos
                                      builder: (context,
                                          AsyncSnapshot<List<AuxPedidoModel>>
                                              snapshotAuxiliar) {
                                        // Muestra el indicador de carga mientras los datos se cargan
                                        if (snapshotAuxiliar.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                          // Muestra el mensaje de error si ocurre un problema al cargar los datos
                                        } else if (snapshotAuxiliar.hasError) {
                                          return Text(
                                            'Error al cargar pedidos: ${snapshotAuxiliar.error}',
                                            textAlign: TextAlign.center,
                                          );
                                          // Muestra un texto 'No se encontraron pedidos' si no hay datos
                                        } else if (snapshotAuxiliar.data ==
                                            null) {
                                          return const Text(
                                            'No se encontraron pedidos',
                                            textAlign: TextAlign.center,
                                          );
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
                                            pedidosDevueltos.addAll(snapshotAuxiliar
                                                .data!
                                                .where((pedido) =>
                                                    snapshotDevolucion
                                                            .data![d]
                                                            .factura
                                                            .pedido
                                                            .id ==
                                                        pedido.pedido.id &&
                                                    snapshotDevolucion
                                                            .data![d]
                                                            .factura
                                                            .pedido
                                                            .usuario
                                                            .id ==
                                                        usuarioAutenticado.id));
                                          }

                                          return DevolucionUsuario(
                                            auxPedido: pedidosDevueltos,
                                            usuario: usuarioAutenticado,
                                          );
                                        }
                                      });
                                }
                              }),
                          // Si la pantalla no es de escritorio, muestra la sección de visitados y favoritos
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
