// ignore_for_file: non_constant_identifier_names, use_full_hex_values_for_flutter_colors, use_build_context_synchronously, file_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/pdf_constancia_pedido_screen.dart';
import 'package:tienda_app/source.dart';
import 'package:http/http.dart' as http;

class CarritoTabla extends StatefulWidget {
  final List<AuxPedidoModel> auxPedido;

  const CarritoTabla({super.key, required this.auxPedido});

  @override
  State<CarritoTabla> createState() => _CarritoTablaState();
}

class _CarritoTablaState extends State<CarritoTabla> {
  bool isChecked = false; // Variable para almacenar el estado del checkbox

  int? _selectedItem;

  DateTime _selectedDateTimeEntrega = DateTime.now();

  List<PuntoDesplegable> metodo = [
    PuntoDesplegable("Portería CBA", 1),
  ];

  Future<void> _selectDateEntrega(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryColor,
            colorScheme: const ColorScheme.light(primary: primaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime;
      bool validTime = false;
      final now = DateTime.now();

      while (!validTime) {
        pickedTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 9, minute: 0),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: primaryColor,
                colorScheme: const ColorScheme.light(primary: primaryColor),
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
          _selectedDateTimeEntrega = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          if (pickedDate.year == now.year &&
              pickedDate.month == now.month &&
              pickedDate.day == now.day) {
            if ((pickedTime.hour > now.hour ||
                    (pickedTime.hour == now.hour &&
                        pickedTime.minute > now.minute)) &&
                pickedTime.hour >= 9 &&
                pickedTime.hour <= 16 &&
                !(pickedTime.hour == 16 && pickedTime.minute > 0)) {
              validTime = true;
            }
          } else {
            if (pickedTime.hour >= 9 &&
                pickedTime.hour <= 16 &&
                !(pickedTime.hour == 16 && pickedTime.minute > 0)) {
              validTime = true;
            }
          }

          if (!validTime) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Por favor, seleccione una hora válida.'),
              ),
            );
          }
        } else {
          break;
        }
      }

      if (pickedTime != null && validTime) {
        setState(() {
          _selectedDateTimeEntrega = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime!.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  String calcularTotal(List<AuxPedidoModel> pedidos) {
    double suma = 0.0;
    for (AuxPedidoModel pedido in pedidos) {
      suma += pedido.precio;
    }
    final costoFinal = formatter.format(suma); // Formatea el valor
    return costoFinal;
  }

  Future<void> finalizarPedido(DateTime fechaEntrega, int? puntoVenta,
      AuxPedidoModel pedido, bool grupal) async {
    String url = "";

    url = "$sourceApi/api/pedidos/${pedido.pedido.id}/";

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      "numeroPedido": pedido.pedido.numeroPedido,
      "fechaEncargo": DateTime.now().toString(),
      "fechaEntrega": fechaEntrega.toString(),
      "grupal": grupal,
      "estado": pedido.pedido.estado,
      "entregado": pedido.pedido.entregado,
      "puntoVenta": puntoVenta,
      "pedidoConfirmado": true,
      "usuario": pedido.pedido.usuario.id
    });
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
      pedidoConfirmadoModal(context, pedido, pedido.pedido.usuario);
    } else {
      print('Error al actualizar el pedido: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: Color(0xFFFF2F0F2),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Confirmación de pedido",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Text(
            "A continuación verá los detalles de su pedido hasta el momento, le pedimos que por favor verificar. A su vez, dependiendo de sus preferencias, complete los siguientes campos.",
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingRowHeight: 48.0,
                  dividerThickness: 2.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  columnSpacing: defaultPadding,
                  columns: const [
                    DataColumn(
                      label: Text(
                        "Número",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Usuario",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Producto",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Medida",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Cantidad",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Precio",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                  rows: List.generate(
                    widget.auxPedido.length,
                    (index) =>
                        pedidoDataRow(widget.auxPedido[index], context, index),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "Total",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontFamily: 'Calibri-Bold',
                        color: Colors.grey,
                      ),
                ),
              ),
              Flexible(
                child: Text(
                  "\$${calcularTotal(widget.auxPedido)}",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontFamily: 'Calibri-Bold',
                        color: Colors.grey,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Center(
            child: Text(
              "Seleccione hora y fecha de entrega *",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Center(
              child: _buildButton("Seleccionar Entrega", () {
            _selectDateEntrega(context);
          })),
          const SizedBox(
            height: defaultPadding,
          ),
          Text(
            "La entrega de su pedido es para: ${twoDigits(_selectedDateTimeEntrega.day)}-${twoDigits(_selectedDateTimeEntrega.month)}-${_selectedDateTimeEntrega.year} ${twoDigits(_selectedDateTimeEntrega.hour)}:${twoDigits(_selectedDateTimeEntrega.minute)}",
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¿El pedido es grupal?",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 10,
              ),
              Checkbox(
                value: isChecked, // Estado actual del checkbox
                onChanged: (bool? newValue) {
                  // Función que se ejecuta cuando el usuario cambia el estado del checkbox
                  setState(() {
                    // Actualiza el estado del widget
                    isChecked = newValue ??
                        false; // Cambia el estado del checkbox al nuevo valor
                  });
                },
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Center(
            child: Text(
              "Seleccione punto de venta *",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [
                    botonClaro,
                    botonOscuro,
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: botonSombra,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<dynamic>(
                  alignment: Alignment.center,
                  value: _selectedItem,
                  iconEnabledColor: background1,
                  hint: const Text(
                    'Seleccionar',
                    style: TextStyle(
                      color: background1,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Calibri-Bold',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  items: metodo.map((dynamic value) {
                    return DropdownMenuItem<dynamic>(
                      value: value.valor,
                      child: Center(
                        child: Text(
                          value.nombre,
                          style: const TextStyle(
                            color: background1,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Calibri-Bold',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedItem = newValue;
                    });
                  },
                  dropdownColor: primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Center(
              child: _buildButton("Finalizar Pedido", () {
            if (_selectedItem == null ||
                _selectedDateTimeEntrega == DateTime.now()) {
              camposrequeridosModal(context);
            } else {
              Navigator.pop(context);
              finalizarPedido(_selectedDateTimeEntrega, _selectedItem,
                  widget.auxPedido[0], isChecked);
            }
          })),
        ],
      ),
    );
  }

  DataRow pedidoDataRow(
      AuxPedidoModel pedido, BuildContext context, int index) {
    return DataRow(
      cells: [
        DataCell(
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FutureBuilder(
                    future: getProductos(),
                    builder: (context, snapshotProductos) {
                      if (snapshotProductos.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshotProductos.hasError) {
                        return Center(
                            child: Text(
                          'Error: ${snapshotProductos.error}',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontFamily: 'Calibri-Bold',
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(
                                    0.5), // Color y opacidad de la sombra
                                offset: const Offset(2,
                                    2), // Desplazamiento de la sombra (horizontal, vertical)
                                blurRadius:
                                    3, // Radio de desenfoque de la sombra
                              ),
                            ],
                          ),
                        ));
                      } else if (!snapshotProductos.hasData ||
                          snapshotProductos.data!.isEmpty) {
                        return Center(
                            child: Text(
                          'No hay producto relaciondo error.',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontFamily: 'Calibri-Bold',
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(
                                    0.5), // Color y opacidad de la sombra
                                offset: const Offset(2,
                                    2), // Desplazamiento de la sombra (horizontal, vertical)
                                blurRadius:
                                    3, // Radio de desenfoque de la sombra
                              ),
                            ],
                          ),
                        ));
                      } else {
                        return FutureBuilder(
                            future: getImagenProductos(),
                            builder: (context, snapshotImagenes) {
                              if (snapshotImagenes.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshotImagenes.hasError) {
                                return Center(
                                    child: Text(
                                  'Error: ${snapshotImagenes.error}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                    fontFamily: 'Calibri-Bold',
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(
                                            0.5), // Color y opacidad de la sombra
                                        offset: const Offset(2,
                                            2), // Desplazamiento de la sombra (horizontal, vertical)
                                        blurRadius:
                                            3, // Radio de desenfoque de la sombra
                                      ),
                                    ],
                                  ),
                                ));
                              } else if (!snapshotImagenes.hasData ||
                                  snapshotImagenes.data!.isEmpty) {
                                return Center(
                                    child: Text(
                                  'Sin Imagen',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                    fontFamily: 'Calibri-Bold',
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(
                                            0.5), // Color y opacidad de la sombra
                                        offset: const Offset(2,
                                            2), // Desplazamiento de la sombra (horizontal, vertical)
                                        blurRadius:
                                            3, // Radio de desenfoque de la sombra
                                      ),
                                    ],
                                  ),
                                ));
                              } else {
                                final imagenesTotal = snapshotImagenes.data!;

                                final imagenProd = imagenesTotal.firstWhere(
                                    (imagen) =>
                                        imagen.producto.id == pedido.producto);
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                    image: NetworkImage(imagenProd.imagen),
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              }
                            });
                      }
                    }),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(
                    "${pedido.pedido.numeroPedido}",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(Text(
          "${pedido.pedido.usuario.nombres} ${pedido.pedido.usuario.apellidos}",
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(FutureBuilder(
            future: getProductos(),
            builder: (context, snapshotProductos) {
              if (snapshotProductos.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshotProductos.hasError) {
                return Center(
                    child: Text(
                  'Error: ${snapshotProductos.error}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontFamily: 'Calibri-Bold',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black
                            .withOpacity(0.5), // Color y opacidad de la sombra
                        offset: const Offset(2,
                            2), // Desplazamiento de la sombra (horizontal, vertical)
                        blurRadius: 3, // Radio de desenfoque de la sombra
                      ),
                    ],
                  ),
                ));
              } else if (!snapshotProductos.hasData ||
                  snapshotProductos.data!.isEmpty) {
                return Center(
                    child: Text(
                  'No hay producto relaciondo error.',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontFamily: 'Calibri-Bold',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black
                            .withOpacity(0.5), // Color y opacidad de la sombra
                        offset: const Offset(2,
                            2), // Desplazamiento de la sombra (horizontal, vertical)
                        blurRadius: 3, // Radio de desenfoque de la sombra
                      ),
                    ],
                  ),
                ));
              } else {
                final producto =
                    productos.firstWhere((prod) => prod.id == pedido.producto);
                return Text(
                  producto.nombre,
                  style: const TextStyle(color: Colors.black),
                );
              }
            })),
        DataCell(FutureBuilder(
            future: getProductos(),
            builder: (context, snapshotProductos) {
              if (snapshotProductos.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshotProductos.hasError) {
                return Center(
                    child: Text(
                  'Error: ${snapshotProductos.error}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontFamily: 'Calibri-Bold',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black
                            .withOpacity(0.5), // Color y opacidad de la sombra
                        offset: const Offset(2,
                            2), // Desplazamiento de la sombra (horizontal, vertical)
                        blurRadius: 3, // Radio de desenfoque de la sombra
                      ),
                    ],
                  ),
                ));
              } else if (!snapshotProductos.hasData ||
                  snapshotProductos.data!.isEmpty) {
                return Center(
                    child: Text(
                  'No hay producto relaciondo error.',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontFamily: 'Calibri-Bold',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black
                            .withOpacity(0.5), // Color y opacidad de la sombra
                        offset: const Offset(2,
                            2), // Desplazamiento de la sombra (horizontal, vertical)
                        blurRadius: 3, // Radio de desenfoque de la sombra
                      ),
                    ],
                  ),
                ));
              } else {
                final producto =
                    productos.firstWhere((prod) => prod.id == pedido.producto);
                return Text(
                  producto.unidadMedida,
                  style: const TextStyle(color: Colors.black),
                );
              }
            })),
        DataCell(Text(
          pedido.cantidad.toString(),
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          "\$${formatter.format(pedido.precio)}",
          style: const TextStyle(color: Colors.black),
        )),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            botonClaro,
            botonOscuro,
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: botonSombra,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: background1,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Calibri-Bold',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pedidoConfirmadoModal(
      BuildContext context, AuxPedidoModel pedido, UsuarioModel usuario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pedido Finalizado"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "¡Gracias por utilizar nuestros servicios! Por el momento, le solicitamos que realice el pago de su pedido en el punto de venta seleccionado. Si prefiere hacerlo en línea, por favor seleccione la opción 'Pago en línea'.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
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
                  child: _buildButton("Imprimir Recibo", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfPageConstanciaPedidoScreen(
                                usuario: usuario, pedido: pedido)));
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Pago en línea", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void camposrequeridosModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Campos Requeridos"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "¡Es importante completar los campos de hora y fecha de entrega, así como el punto de venta, ya que son requeridos para finalizar el pedido!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
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
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class PuntoDesplegable {
  final String? nombre;
  final int? valor;

  PuntoDesplegable(this.nombre, this.valor);
}
