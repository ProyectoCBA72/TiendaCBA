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

/// Esta clase representa un componente de interfaz de usuario que muestra una tabla
/// con los productos seleccionados en el carrito.
///
/// El componente toma una lista de objetos [AuxPedidoModel] como parámetro y se usa
/// para mostrar los productos en la tabla.
class CarritoTabla extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representan los productos seleccionados
  /// en el carrito.
  final List<AuxPedidoModel> auxPedido;

  /// Constructor del componente [CarritoTabla].
  ///
  /// Toma una lista de objetos [AuxPedidoModel] como parámetro y la asigna al campo
  /// [auxPedido].
  const CarritoTabla({
    super.key,
    required this.auxPedido,
  });

  /// Sobrecarga del método [createState] para crear el estado asociado al componente.
  ///
  /// Devuelve una instancia de la clase [_CarritoTablaState].
  @override
  State<CarritoTabla> createState() => _CarritoTablaState();
}

class _CarritoTablaState extends State<CarritoTabla> {
  /// Variable booleana para almacenar el estado del checkbox.
  /// Su valor predeterminado es falso.
  bool isChecked = false;

  /// Variable para almacenar el índice del elemento seleccionado en un desplegable.
  /// El valor predeterminado es nulo.
  int? _selectedItem;

  /// Variable para almacenar la fecha y hora seleccionadas para la entrega.
  /// El valor predeterminado es la fecha y hora actual.
  DateTime _selectedDateTimeEntrega = DateTime.now();

  List<PuntoDesplegable> metodo = [
    PuntoDesplegable("Portería CBA", 1),
  ];

  /// Esta función permite al usuario seleccionar una fecha y hora para la entrega de los productos.
  /// La fecha y hora seleccionadas se almacenan en la variable _selectedDateTimeEntrega.
  ///
  /// La fecha de entrega no puede ser anterior a la fecha actual, y la hora de entrega
  /// debe ser entre las 9:00 AM y 4:00 PM. Si se selecciona una hora inválida, se muestra un
  /// mensaje de error.
  ///
  /// [BuildContext context] es el contexto del widget tree donde se va a mostrar el
  /// diálogo de selección de fecha y hora.
  Future<void> _selectDateEntrega(BuildContext context) async {
    // Se muestra un diálogo para seleccionar la fecha
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        // Se personaliza el estilo del diálogo para que coincida con el estilo del resto del app
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

    // Si se seleccionó una fecha válida, se muestra un diálogo para seleccionar la hora
    if (pickedDate != null) {
      TimeOfDay? pickedTime;
      bool validTime = false;
      final now = DateTime.now();

      while (!validTime) {
        pickedTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 9, minute: 0),
          builder: (BuildContext context, Widget? child) {
            // Se personaliza el estilo del diálogo para que coincida con el estilo del resto del app
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

        // Si se seleccionó una hora válida, se almacena la fecha y hora en _selectedDateTimeEntrega
        if (pickedTime != null) {
          _selectedDateTimeEntrega = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          // Si se seleccionó la fecha actual y se seleccionó una hora posterior a la hora actual
          // o se seleccionó una fecha posterior a la fecha actual, se considera que la hora es válida
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

          // Si se seleccionó una hora inválida, se muestra un mensaje de error
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

      // Si se seleccionó una hora válida, se notifica al sistema de estado para que se actualice
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

  /// Calcula el total de los productos.
  ///
  /// Toma una lista de [AuxPedidoModel] y calcula el total de los precios de
  /// los productos. Devuelve el total formateado como cadena.
  ///
  /// @param pedidos La lista de aux pedidos.
  /// @return El total formateado como cadena.
  String calcularTotal(List<AuxPedidoModel> pedidos) {
    // Inicializar la variable de suma a 0.0
    double suma = 0.0;

    // Iterar sobre cada aux pedido y sumar su precio
    for (AuxPedidoModel pedido in pedidos) {
      suma += pedido.precio;
    }

    // Formatear el valor total y devolverlo
    final costoFinal = formatter.format(suma); // Formatea el valor
    return costoFinal;
  }

  /// Finaliza un pedido enviando una solicitud PUT a la API.
  ///
  /// Toma la fecha de entrega, el punto de venta, el aux pedido y si es un pedido grupal,
  /// y envía una solicitud PUT a la API para actualizar el estado del pedido. Si la
  /// solicitud es exitosa, navega a la página de inicio y muestra un diálogo con la
  /// información del pedido confirmado. De lo contrario, imprime un mensaje de error.
  ///
  /// @param fechaEntrega La fecha de entrega del pedido.
  /// @param puntoVenta El punto de venta al que pertenece el pedido.
  /// @param pedido El aux pedido que se va a finalizar.
  /// @param grupal Si el pedido es grupal o no.
  Future<void> finalizarPedido(DateTime fechaEntrega, int? puntoVenta,
      AuxPedidoModel pedido, bool grupal) async {
    // Construir la URL para el pedido
    String url = "$sourceApi/api/pedidos/${pedido.pedido.id}/";

    // Construir los encabezados de la solicitud
    final headers = {'Content-Type': 'application/json'};

    // Construir el cuerpo de la solicitud
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

    // Enviar la solicitud PUT a la API
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    // Verificar el estado de la respuesta
    if (response.statusCode == 200) {
      // Navegar a la página de inicio
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
      // Mostrar un diálogo con la información del pedido confirmado
      pedidoConfirmadoModal(context, pedido, pedido.pedido.usuario);
    } else {
      // Imprimir un mensaje de error en caso de que la solicitud no sea exitosa
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
          // Título de confirmación de pedido
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
          // Descripción de los detalles del pedido
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
          // Tabla de detalles del pedido
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
          // Fila de total
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
          // Título de selección de entrega
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
          // Botón de seleccionar entrega
          Center(
            child: _buildButton("Seleccionar Entrega", () {
              _selectDateEntrega(context);
            }),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Texto de fecha y hora de entrega seleccionada
          Text(
            "La entrega de su pedido es para: ${formatFechaHora(_selectedDateTimeEntrega.toString())}",
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Fila de checkbox para pedido grupal
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
          // Título de selección de punto de venta
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
          // DropdownButton de selección de punto de venta
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
          // Botón de finalizar pedido
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
            }),
          ),
        ],
      ),
    );
  }

  /// Construye y devuelve una fila de datos para un pedido específico.
  ///
  /// Esta función devuelve una [DataRow] que contiene celdas de datos relevantes
  /// para mostrar información detallada sobre un pedido, incluyendo el número
  /// de pedido, el nombre del usuario que lo realizó, el nombre del producto,
  /// la unidad de medida del producto, la cantidad pedida, y el precio total.
  ///
  /// Utiliza [FutureBuilder] para obtener de manera asíncrona la información
  /// de los productos necesarios para mostrar los detalles del pedido,
  /// incluyendo la imagen del producto cuando esté disponible.
  ///
  /// Params:
  /// - [pedido]: El modelo del pedido que contiene la información a mostrar.
  /// - [context]: El contexto de construcción del widget en Flutter.
  /// - [index]: El índice de la fila dentro de la tabla de datos.
  ///
  /// Returns:
  /// Una [DataRow] configurada con las celdas de datos correspondientes al pedido.
  DataRow pedidoDataRow(
      AuxPedidoModel pedido, BuildContext context, int index) {
    return DataRow(
      cells: [
        // Celda para la imagen del producto
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
                        // Muestra un indicador de carga mientras se obtienen los productos
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshotProductos.hasError) {
                        // Muestra un mensaje de error si ocurre un problema al obtener los productos
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
                                offset: const Offset(
                                    2, 2), // Desplazamiento de la sombra
                                blurRadius:
                                    3, // Radio de desenfoque de la sombra
                              ),
                            ],
                          ),
                        ));
                      } else if (!snapshotProductos.hasData ||
                          snapshotProductos.data!.isEmpty) {
                        // Maneja el caso donde no hay datos de productos disponibles
                        return Center(
                            child: Text(
                          'No hay producto relacionado.',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontFamily: 'Calibri-Bold',
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(
                                    0.5), // Color y opacidad de la sombra
                                offset: const Offset(
                                    2, 2), // Desplazamiento de la sombra
                                blurRadius:
                                    3, // Radio de desenfoque de la sombra
                              ),
                            ],
                          ),
                        ));
                      } else {
                        // Si se obtienen los productos correctamente, se procede a obtener la imagen del producto
                        return FutureBuilder(
                            future: getImagenProductos(),
                            builder: (context, snapshotImagenes) {
                              if (snapshotImagenes.connectionState ==
                                  ConnectionState.waiting) {
                                // Muestra un indicador de carga mientras se obtienen las imágenes
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshotImagenes.hasError) {
                                // Muestra un mensaje de error si ocurre un problema al obtener las imágenes
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
                                            2), // Desplazamiento de la sombra
                                        blurRadius:
                                            3, // Radio de desenfoque de la sombra
                                      ),
                                    ],
                                  ),
                                ));
                              } else if (!snapshotImagenes.hasData ||
                                  snapshotImagenes.data!.isEmpty) {
                                // Maneja el caso donde no hay imágenes disponibles para el producto
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
                                            2), // Desplazamiento de la sombra
                                        blurRadius:
                                            3, // Radio de desenfoque de la sombra
                                      ),
                                    ],
                                  ),
                                ));
                              } else {
                                // Si se obtiene la imagen correctamente, la muestra recortada y redondeada
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
                // Espacio para el número de pedido
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
        // Celda para el nombre del usuario que realizó el pedido
        DataCell(Text(
          "${pedido.pedido.usuario.nombres} ${pedido.pedido.usuario.apellidos}",
          style: const TextStyle(color: Colors.black),
        )),
        // Celda para el nombre del producto
        DataCell(FutureBuilder(
            future: getProductos(),
            builder: (context, snapshotProductos) {
              if (snapshotProductos.connectionState ==
                  ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se obtienen los productos
                return const Center(child: CircularProgressIndicator());
              } else if (snapshotProductos.hasError) {
                // Muestra un mensaje de error si ocurre un problema al obtener los productos
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
                        offset:
                            const Offset(2, 2), // Desplazamiento de la sombra
                        blurRadius: 3, // Radio de desenfoque de la sombra
                      ),
                    ],
                  ),
                ));
              } else if (!snapshotProductos.hasData ||
                  snapshotProductos.data!.isEmpty) {
                // Maneja el caso donde no hay datos de productos disponibles
                return Center(
                    child: Text(
                  'No hay producto relacionado.',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontFamily: 'Calibri-Bold',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black
                            .withOpacity(0.5), // Color y opacidad de la sombra
                        offset:
                            const Offset(2, 2), // Desplazamiento de la sombra
                        blurRadius: 3, // Radio de desenfoque de la sombra
                      ),
                    ],
                  ),
                ));
              } else {
                // Si se obtienen los productos correctamente, se procede a obtener el nombre del producto
                final producto =
                    productos.firstWhere((prod) => prod.id == pedido.producto);
                return Text(
                  producto.nombre,
                  style: const TextStyle(color: Colors.black),
                );
              }
            })),
        // Celda para la unidad de medida del producto
        DataCell(FutureBuilder(
            future: getProductos(),
            builder: (context, snapshotProductos) {
              if (snapshotProductos.connectionState ==
                  ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se obtienen los productos
                return const Center(child: CircularProgressIndicator());
              } else if (snapshotProductos.hasError) {
                // Muestra un mensaje de error si ocurre un problema al obtener los productos
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
                        offset:
                            const Offset(2, 2), // Desplazamiento de la sombra
                        blurRadius: 3, // Radio de desenfoque de la sombra
                      ),
                    ],
                  ),
                ));
              } else if (!snapshotProductos.hasData ||
                  snapshotProductos.data!.isEmpty) {
                // Maneja el caso donde no hay datos de productos disponibles
                return Center(
                    child: Text(
                  'No hay producto relacionado.',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontFamily: 'Calibri-Bold',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black
                            .withOpacity(0.5), // Color y opacidad de la sombra
                        offset:
                            const Offset(2, 2), // Desplazamiento de la sombra
                        blurRadius: 3, // Radio de desenfoque de la sombra
                      ),
                    ],
                  ),
                ));
              } else {
                // Si se obtienen los productos correctamente, se procede a obtener la unidad de medida del producto
                final producto =
                    productos.firstWhere((prod) => prod.id == pedido.producto);
                return Text(
                  producto.unidadMedida,
                  style: const TextStyle(color: Colors.black),
                );
              }
            })),
        // Celda para la cantidad pedida
        DataCell(Text(
          pedido.cantidad.toString(),
          style: const TextStyle(color: Colors.black),
        )),
        // Celda para el precio total del pedido
        DataCell(Text(
          "\$${formatter.format(pedido.precio)}",
          style: const TextStyle(color: Colors.black),
        )),
      ],
    );
  }

  /// Construye un botón con los estilos de diseño especificados.
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
  ///
  /// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
  Widget _buildButton(String text, VoidCallback onPressed) {
    // Devuelve un contenedor con una decoración circular y un gradiente de color.
    // También tiene sombra y un borde redondeado.
    // El contenedor contiene un widget [Material] que actúa como un botón interactivo.
    // El botón tiene un controlador de eventos [InkWell] que llama a la función [onPressed] cuando se presiona.
    // El [InkWell] tiene un borde redondeado y un padding vertical.
    // El contenido del botón es un texto centrado con un estilo específico.
    return Container(
      width: 200, // Ancho del contenedor
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(10), // Borde redondeado con un radio de 10
        gradient: const LinearGradient(
          colors: [
            botonClaro, // Color de fondo claro
            botonOscuro, // Color de fondo oscuro
          ],
        ), // Gradiente de color
        boxShadow: const [
          BoxShadow(
            color: botonSombra, // Color de sombra
            blurRadius: 5, // Radio de la sombra
            offset: Offset(0, 3), // Desplazamiento en x e y de la sombra
          ),
        ], // Sombra
      ),
      child: Material(
        color: Colors.transparent, // Color de fondo transparente
        child: InkWell(
          onTap: onPressed, // Controlador de eventos al presionar el botón
          borderRadius:
              BorderRadius.circular(10), // Borde redondeado con un radio de 10
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10), // Padding vertical de 10
            child: Center(
              child: Text(
                text, // Texto del botón
                style: const TextStyle(
                  color: background1, // Color del texto
                  fontSize: 13, // Tamaño de fuente
                  fontWeight: FontWeight.bold, // Fuente en negrita
                  fontFamily: 'Calibri-Bold', // Fuente Calibri en negrita
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Muestra un modal de confirmación de pedido.
  ///
  /// Este método muestra un diálogo de alerta con información y opciones para el usuario
  /// después de confirmar un pedido. Incluye la posibilidad de imprimir el recibo o realizar el pago en línea.
  ///
  /// [context] Contexto de la construcción del widget.
  /// [pedido] Detalles del pedido confirmado.
  /// [usuario] Información del usuario que realizó el pedido.
  void pedidoConfirmadoModal(
      BuildContext context, AuxPedidoModel pedido, UsuarioModel usuario) {
    // Muestra un diálogo de alerta en el contexto proporcionado
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Título del diálogo
          title: const Text("Pedido Finalizado"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Mensaje informativo para el usuario
              const Text(
                "¡Gracias por utilizar nuestros servicios! Por el momento, le solicitamos que realice el pago de su pedido en el punto de venta seleccionado. Si prefiere hacerlo en línea, por favor seleccione la opción 'Pago en línea'.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              // Contenedor con la imagen del logo, recortado en forma circular
              ClipOval(
                child: Container(
                  width: 100, // Ajusta el tamaño según sea necesario
                  height: 100, // Ajusta el tamaño según sea necesario
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor, // Color del fondo del logo
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
            // Botones de acción dentro del diálogo
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                // Botón para imprimir el recibo
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Imprimir Recibo", () {
                    // Navega a la pantalla de PDF del recibo
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfPageConstanciaPedidoScreen(
                                usuario: usuario, pedido: pedido)));
                  }),
                ),
                // Botón para realizar el pago en línea
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Pago en línea", () {
                    // Navega a la página principal para el pago en línea
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

  /// Muestra un diálogo de alerta para informar al usuario sobre la necesidad de completar
  /// los campos requeridos.
  ///
  /// Este método muestra un diálogo con un mensaje informativo y un botón para aceptar el mensaje.
  ///
  /// [context] es el contexto de la aplicación donde se mostrará el diálogo.
  void camposrequeridosModal(BuildContext context) {
    // Muestra un diálogo con el contenido personalizado.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Título del diálogo
          title: const Text("Campos Requeridos"),
          // Contenido del diálogo
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Mensaje informativo para el usuario
              const Text(
                "¡Es importante completar los campos de hora y fecha de entrega, así como el punto de venta, ya que son requeridos para finalizar el pedido!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              // Contenedor con la imagen del logo, recortado en forma circular
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
          // Botones de acción dentro del diálogo
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  // Botón para aceptar el mensaje
                  child: _buildButton("Aceptar", () {
                    // Cierra el diálogo
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
