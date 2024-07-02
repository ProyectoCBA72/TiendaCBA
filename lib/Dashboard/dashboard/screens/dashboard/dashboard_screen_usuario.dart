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
                                    const EventosUsuario(),
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
                                    const EntregadoUsuario(),
                                    const SizedBox(height: defaultPadding),
                                    const CanceladoUsuario(),
                                    const SizedBox(height: defaultPadding),
                                    const FacturaUsuario(),
                                    const SizedBox(height: defaultPadding),
                                    const DevolucionUsuario(),
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
