import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:http/http.dart' as http;
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/source.dart';

class Tiendacontroller extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void updateCount(int newCount) {
    _count = newCount;
    notifyListeners();
  }
}

class PuntoVentaProvider with ChangeNotifier {
  PuntoVentaModel? _puntoVenta;

  PuntoVentaModel? get puntoVenta => _puntoVenta;

  void setPuntoVenta(PuntoVentaModel puntoVenta) {
    _puntoVenta = puntoVenta;
    notifyListeners();
  }

  Future<void> updatePuntoVenta(
      PuntoVentaModel puntoVenta, BuildContext context) async {
    // Obtener los pedidos auxiliares.
    final auxPedidos = await getAuxPedidos();
    final usuarioAutenticado =
        Provider.of<AppState>(context, listen: false).usuarioAutenticado;

    // Verificar si el usuario está autenticado.
    if (usuarioAutenticado == null) {
      return;
    }

    _puntoVenta = puntoVenta;

    // Filtrar los pedidos auxiliares del usuario autenticado.
    final auxPedidosUsuario = auxPedidos
        .where((item) =>
            !item.pedido.pedidoConfirmado &&
            item.pedido.usuario.id == usuarioAutenticado.id)
        .toList();

    final headers = {'Content-Type': 'application/json'};

    // Actualizar el pedido con el nuevo punto de venta si hay pedidos auxiliares.
    if (auxPedidosUsuario.isNotEmpty) {
      // Eliminar los pedidos auxiliares.
      for (var item in auxPedidosUsuario) {
        final url = "$sourceApi/api/aux-pedidos/${item.id}/";
        final response = await http.delete(Uri.parse(url), headers: headers);
        if (response.statusCode != 204) {
          print(
              "Error eliminando el pedido ${item.id}: ${response.statusCode}");
        }
      }

      final auxPedidoCualquiera = auxPedidosUsuario.first;

      final body = {
        'numeroPedido': auxPedidoCualquiera.pedido.numeroPedido,
        'grupal': false,
        'estado': 'PENDIENTE',
        'entregado': false,
        'pedidoConfirmado': false,
        'usuario': usuarioAutenticado.id,
        'puntoVenta': puntoVenta.id
      };

      final response = await http.put(
        Uri.parse('$sourceApi/api/pedidos/${auxPedidoCualquiera.pedido.id}/'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        print('Error al actualizar el punto en el pedido');
      }

      // Mostrar el modal de eliminación de productos en el pedido.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cambiar punto de venta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "¡Una vez cambiado el punto de venta los productos que tenia en el pedido se eliminaran!.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                // Muestra una imagen circular del logo de la aplicación
                ClipOval(
                  child: Container(
                    width: 100, // Ajusta el tamaño según sea necesario
                    height: 100, // Ajusta el tamaño según sea necesario
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: Image.asset(
                      "assets/img/logo.png",
                      fit: BoxFit.cover, // Ajusta la imagen al contenedor
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: _buildButton("Aceptar", () {
                      // Cierra el diálogo cuando se hace clic en el botón de aceptar
                      Navigator.pop(context);
                      // Navega a la pantalla de la tienda
                    }),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    // Notificar a los widgets que dependen de este provider.
    notifyListeners();
  }
}

Widget _buildButton(String text, VoidCallback onPressed) {
  return Container(
    width: 200,
    // The button has a linear gradient
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        colors: [
          botonClaro, // The light color of the gradient
          botonOscuro, // The dark color of the gradient
        ],
      ),
      // The button has a shadow
      boxShadow: const [
        BoxShadow(
          color: botonSombra,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    // The button contains a Material widget
    child: Material(
      color: Colors.transparent, // The Material widget has a transparent color
      child: InkWell(
        onTap:
            onPressed, // The InkWell widget triggers the `onPressed` callback
        borderRadius:
            BorderRadius.circular(10), // The InkWell widget has rounded corners
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical:
                  10), // The padding between the text and the button's edge
          child: Center(
            child: Text(
              text, // The text displayed on the button
              style: const TextStyle(
                color: background1, // The color of the text
                fontSize: 13, // The font size of the text
                fontWeight: FontWeight.bold, // The font weight of the text
                fontFamily: 'Calibri-Bold', // The font family of the text
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
