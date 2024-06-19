// ignore_for_file: no_leading_underscores_for_local_identifiers, use_super_parameters

import 'package:flutter/material.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/usuario/card_pedido_usuario.dart';
import 'package:tienda_app/Dashboard/listas/CardsPedidosLider.dart';
import 'package:tienda_app/Models/pedidoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

// Vista donde se llamarán las cards superiores de conteo de pedidos y se organizan para que se adapten a todos los dispositivos

class CardsPedidoUsuario extends StatelessWidget {
  // Definición de la variable usuario que será recibida como parámetro
  final UsuarioModel usuario;

  // Constructor de la clase, usando super.key para la clave del widget y required para el usuario
  const CardsPedidoUsuario({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    // Obtención del tamaño de la pantalla actual
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Fila con el título del panel
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Panel Usuarios",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontFamily: 'Calibri-Bold'),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding), // Espacio vertical
        // Widget Responsive que adapta el contenido según el tamaño de la pantalla
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
            usuario: usuario,
          ),
          tablet: FileInfoCardGridView(
            usuario: usuario,
          ),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
            usuario: usuario,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  // Definición de la variable usuario que será recibida como parámetro
  final UsuarioModel usuario;

  // Constructor de la clase con parámetros opcionales y required para el usuario

  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.usuario,
  }) : super(key: key);

  // Definición de las variables de configuración de la cuadrícula
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPedidos(), // Llamada futura para obtener pedidos
        builder: (context, AsyncSnapshot<List<PedidoModel>> snapshotPedido) {
          // Manejo de los diferentes estados de la conexión
          if (snapshotPedido.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Muestra un indicador de carga
          } else if (snapshotPedido.hasError) {
            return Text('Error al cargar pedidos: ${snapshotPedido.error}');
          } else if (snapshotPedido.data == null) {
            return const Text('No se encontraron pedidos');
          } else {
            // Variables para contabilizar los pedidos
            int pedidos = 0;
            int pedidosPendientes = 0;
            int pedidosCancelados = 0;
            int pedidosEntregados = 0;

            // Conteo de los diferentes tipos de pedidos
            for (var r = 0; r < snapshotPedido.data!.length; r++) {
              if (snapshotPedido.data![r].usuario.id == usuario.id) {
                if (snapshotPedido.data![r].estado == "PENDIENTE" &&
                    snapshotPedido.data![r].pedidoConfirmado) {
                  pedidosPendientes++;
                } else if (snapshotPedido.data![r].estado == "CANCELADO") {
                  pedidosCancelados++;
                } else if (snapshotPedido.data![r].estado == "COMPLETADO" &&
                    snapshotPedido.data![r].entregado) {
                  pedidosEntregados++;
                }

                pedidos++;
              }
            }

            // Creación de la lista de widgets de PedidoLider con los datos calculados
            List pedidosCardUsuario = [
              PedidoLider(
                title: "Pedidos",
                svgSrc: "assets/icons/pedido.svg",
                totalReservas: pedidos.toString(),
                color: primaryColor,
                percentage: pedidos,
              ),
              PedidoLider(
                title: "Entregados",
                svgSrc: "assets/icons/check.svg",
                totalReservas: pedidosEntregados.toString(),
                color: Colors.green,
                percentage: pedidosEntregados,
              ),
              PedidoLider(
                title: "Cancelados",
                svgSrc: "assets/icons/cancel.svg",
                totalReservas: pedidosCancelados.toString(),
                color: Colors.red,
                percentage: pedidosCancelados,
              ),
              PedidoLider(
                title: "Pendientes",
                svgSrc: "assets/icons/pendiente.svg",
                totalReservas: pedidosPendientes.toString(),
                color: const Color(0xFF007EE5),
                percentage: pedidosPendientes,
              ),
            ];

            // Construcción de la cuadrícula con los widgets de PedidoLider
            return GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Evita el scroll de la cuadrícula
              shrinkWrap: true,
              itemCount: pedidosCardUsuario.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) =>
                  CardPedidoUsuario(info: pedidosCardUsuario[index]),
            );
          }
        });
  }
}
