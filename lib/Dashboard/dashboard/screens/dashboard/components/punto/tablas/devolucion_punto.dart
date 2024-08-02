// ignore_for_file: use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Dashboard/controllers/MenuAppController.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/modalsDashboard.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/main/main_screen_usuario.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/Punto/pdfDevolucionPunto.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';
import 'package:tienda_app/responsive.dart';
import 'package:tienda_app/source.dart';
import 'package:http/http.dart' as http;

/// Un widget de estado que representa la vista de devoluciones de un punto de venta.
///
/// Esta clase extiende [StatefulWidget] y proporciona un estado asociado
/// [_DevolucionPuntoState]. Tiene una lista de [AuxPedidoModel] que representa
/// las devoluciones del punto de venta.
class DevolucionPunto extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representan las devoluciones del punto de venta.
  final List<AuxPedidoModel> auxPedido;

  final UsuarioModel usuario;

  /// Crea un nuevo widget de estado de devoluciones para un punto de venta.
  ///
  /// El parámetro [auxPedido] es una lista de objetos [AuxPedidoModel] que
  /// representan las devoluciones del punto de venta.
  const DevolucionPunto(
      {super.key, required this.auxPedido, required this.usuario});

  /// Crea un nuevo estado asociado al widget [DevolucionPunto].
  ///
  /// Devuelve un objeto [_DevolucionPuntoState] que maneja los datos de la pantalla.
  @override
  State<DevolucionPunto> createState() => _DevolucionPuntoState();
}

class _DevolucionPuntoState extends State<DevolucionPunto> {
  /// Lista de objetos [AuxPedidoModel] que representan las devoluciones del punto de venta.
  List<AuxPedidoModel> _devoluciones = [];

  /// Lista de objetos [ProductoModel] que representan los productos del punto de venta.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [DevolucionesModel] que representan las devoluciones del punto de venta.
  List<DevolucionesModel> listaDevoluciones = [];

  /// Lista de objetos [UsuarioModel] que representan los vendedores del punto de venta.
  List<UsuarioModel> listaUsuarios = [];

  /// Un [DataGridSource] que proporciona los datos para la tabla de devoluciones.
  late DevolucionPuntoDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Se llama cuando se inicia el estado.
  ///
  /// Crea un nuevo [DataGridSource] con los datos de las devoluciones, productos y pedidos.
  /// Luego, se copia la lista de devoluciones recibida en el constructor en el campo [_devoluciones].
  /// Finalmente, se llama a [_loadData] para cargar los datos necesarios.
  @override
  void initState() {
    super.initState();

    // Crea un nuevo DataGridSource con los datos de las devoluciones, productos y pedidos.
    _dataGridSource = DevolucionPuntoDataGridSource(
        devoluciones: _devoluciones,
        listaProductos: listaProductos,
        listaDevoluciones: listaDevoluciones,
        listaUsuarios: listaUsuarios);

    // Copia la lista de devoluciones recibida en el constructor en el campo [_devoluciones].
    _devoluciones = widget.auxPedido;

    // Carga los datos necesarios para mostrar la tabla de devoluciones.
    _loadData();
  }

  /// Carga los datos necesarios para mostrar la tabla de devoluciones.
  ///
  /// Primero, obtiene la lista de productos y la lista de devoluciones de la API
  /// y las asigna a las variables [listaProductos] y [listaDevoluciones],
  /// respectivamente.
  ///
  /// Luego, actualiza [_dataGridSource] en el siguiente frame de la interfaz de usuario.
  Future<void> _loadData() async {
    // Obtiene los productos de la API y los asigna a la variable [listaProductos]
    List<ProductoModel> productosCargados = await getProductos();
    listaProductos = productosCargados;

    // Obtiene las devoluciones de la API y los asigna a la variable [listaDevoluciones]
    List<DevolucionesModel> devolucionesCargadas = await getDevoluciones();
    listaDevoluciones = devolucionesCargadas;

    // Obtiene los usuarios de la API y los asigna a la variable [listaUsuarios]
    List<UsuarioModel> usuariosCargados = await getUsuarios();
    listaUsuarios = usuariosCargados;

    if (mounted) {
      // Actualiza _dataGridSource en el siguiente frame de la interfaz de usuario
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializa _dataGridSource con los datos de las devoluciones, productos y pedidos
          _dataGridSource = DevolucionPuntoDataGridSource(
              devoluciones: _devoluciones,
              listaProductos: listaProductos,
              listaDevoluciones: listaDevoluciones,
              listaUsuarios: listaUsuarios);
        });
      });
    }
  }

  /// Función asíncrona para cambiar el estado de una devolución.
  ///
  /// Esta función recibe una lista de [DataGridRow] que representan las devoluciones
  /// que se desean cambiar de estado. Recorre la lista de devoluciones cargadas
  /// desde la API y verifica si el número de factura de cada devolución coincide
  /// con alguna de las devoluciones pasadas como argumento. Si el número de factura
  /// coincide y la devolución no ha sido procesada previamente, se agrega a la lista
  /// [devolucionEditar].
  ///
  /// Luego, se recorre la lista de devoluciones a editar y se llama a la API para
  /// actualizar el estado de cada devolución a "procesada". Si la respuesta del
  /// servidor es exitosa, se muestra un mensaje de éxito y se navega a la pantalla
  /// principal de usuario. Si la respuesta indica un error, se muestra un mensaje de
  /// error.
  ///
  /// Los parámetros son:
  ///
  /// * `devoluciones`: Lista de [DataGridRow] que representan las devoluciones
  ///   que se desean cambiar de estado.
  Future cambiarDevolucion(List<DataGridRow> devoluciones) async {
    // Lista para almacenar las devoluciones a editar
    List<DevolucionesModel> devolucionEditar = [];
    String url;

    // Obtiene las devoluciones cargadas desde la API
    List<DevolucionesModel> devolucionesCargadas = await getDevoluciones();

    // Utilizamos un Set para almacenar los números de factura ya procesados
    Set<String> facturasProcesadas = {};

    // Variable para controlar si el mensaje ya ha sido mostrado
    bool mensajeMostrado = false;

    // Verificación inicial para determinar si alguna devolución ya ha sido procesada
    for (var dev in devoluciones) {
      // Obtiene el número de factura de la fila actual
      String numeroFactura = dev.getCells()[0].value;

      // Verificamos si la devolución ya ha sido procesada
      bool devolucionEstado = devolucionesCargadas.any((devolucion) =>
          devolucion.estado == true &&
          numeroFactura == devolucion.factura.numero.toString());

      // Si la devolución ya ha sido procesada, mostramos un mensaje de error y salimos del ciclo
      if (devolucionEstado) {
        if (!mensajeMostrado) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'No se puede editar una devolución que ya ha sido procesada.'),
            ),
          );
          // Marcamos que el mensaje ya ha sido mostrado
          mensajeMostrado = true;
        }

        return;
      } else {
        // Si ninguna devolución ya ha sido procesada, continuar con la operación
        for (var devolucion in devolucionesCargadas) {
          if (!facturasProcesadas.contains(numeroFactura) &&
              numeroFactura == devolucion.factura.numero.toString()) {
            // Agrega la devolución a la lista de devoluciones a editar
            devolucionEditar.add(devolucion);
            // Agregamos el número de factura al Set
            facturasProcesadas.add(numeroFactura);
          }
        }
      }
    }

    // Variable para controlar el estado de las solicitudes
    bool allSuccessful = true;

    // Recorre la lista de devoluciones a editar
    for (var editar in devolucionEditar) {
      // Genera la URL de la solicitud PUT
      url = "$sourceApi/api/devoluciones/${editar.id}/";

      // Define los encabezados de la solicitud
      final headers = {
        'Content-Type': 'application/json',
      };

      // Define el cuerpo de la solicitud
      final body = {
        "fecha": editar.fecha.toString(),
        "estado": true,
        "factura": editar.factura.id
      };

      // Realiza la solicitud PUT
      final response = await http.put(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      // Si la solicitud falla, marcamos allSuccessful como false
      if (response.statusCode != 200) {
        allSuccessful = false;

        // Muestra un mensaje de error si la respuesta indica un error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al editar registros: ${response.statusCode}.'),
          ),
        );
      }
    }

    // Si todas las solicitudes fueron exitosas
    if (allSuccessful) {
      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Devoluciones actualizadas correctamente.'),
        ),
      );

      // Navega a la pantalla principal de usuario
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => MenuAppController()),
            ],
            child: const MainScreenUsuario(),
          ),
        ),
      );
    }
  }

  /// Se llama automáticamente cuando se elimina el widget.
  ///
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por el widget.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos adicionales.
  @override
  void dispose() {
    // Llama al método [dispose] del widget base
    super.dispose();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titulo de la tabla
          Text(
            "Devoluciones",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Contenedor de la tabla
          SizedBox(
            height: 300,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SfDataGrid(
                verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
                frozenRowsCount: 0,
                showVerticalScrollbar: true,
                defaultColumnWidth: 200,
                shrinkWrapColumns: true,
                shrinkWrapRows: true,
                rowsPerPage: 10,
                source: _dataGridSource, // Asigna la fuente de datos a la tabla
                selectionMode: SelectionMode.multiple,
                showCheckboxColumn: true,
                allowSorting: true,
                allowFiltering: true,
                // Cambia la firma del callback
                onSelectionChanged: (List<DataGridRow> addedRows,
                    List<DataGridRow> removedRows) {
                  setState(() {
                    // Añadir filas a la lista de registros seleccionados
                    registros.addAll(addedRows);

                    // Eliminar filas de la lista de registros seleccionados
                    for (var row in removedRows) {
                      registros.remove(row);
                    }
                  });
                },
                // Columnas de la tabla
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'Número Venta',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Número Venta'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Usuario',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Usuario'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Número Pedido',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Número Pedido'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Producto',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Producto'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Fecha Venta',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Venta'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Valor Pedido',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Valor Pedido'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Medio Pago',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Medio Pago'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Vendedor',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Vendedor'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Fecha Devolución',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Devolución'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Estado Devolución',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Estado Devolución'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Botón para imprimir o cambiar el estado de las devoluciones
          if (!Responsive.isMobile(context))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('Imprimir Reporte', () {
                  if (registros.isEmpty) {
                    noHayPDFModal(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfDevolucionPuntoScreen(
                                usuario: widget.usuario, registro: registros)));
                  }
                }),
                const SizedBox(
                  width: defaultPadding,
                ),
                _buildButton('Cambiar Estado', () {
                  if (registros.isEmpty) {
                    operacionFallidaModal(context);
                  } else {
                    cambiarDevolucion(registros);
                  }
                }),
              ],
            ),
          if (Responsive.isMobile(context))
            Center(
              child: Column(
                children: [
                  _buildButton('Imprimir Reporte', () {
                    if (registros.isEmpty) {
                      noHayPDFModal(context);
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfDevolucionPuntoScreen(
                                  usuario: widget.usuario,
                                  registro: registros)));
                    }
                  }),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  _buildButton('Cambiar Estado', () {
                    if (registros.isEmpty) {
                      operacionFallidaModal(context);
                    } else {
                      cambiarDevolucion(registros);
                    }
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Construye un botón con el texto dado y la función de presionar dada.
  ///
  /// El botón tiene un diseño con bordes redondeados y un gradiente de colores.
  /// Al presionar el botón se llama a la función [onPressed].
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará al presionar el botón.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      // Decoración del botón con bordes redondeados y gradiente de colores
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            botonClaro, // Verde más claro
            botonOscuro, // Verde más oscuro
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: botonSombra, // Verde más claro para sombra
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Color de fondo transparente
        child: InkWell(
          onTap: onPressed, // Función a ejecutar al presionar el botón
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10), // Padding vertical
            child: Center(
              child: Text(
                text, // Texto del botón
                style: const TextStyle(
                  color: background1, // Color del texto
                  fontSize: 13, // Tamaño de fuente
                  fontWeight: FontWeight.bold, // Fuente en negrita
                  fontFamily: 'Calibri-Bold', // Fuente Calibri
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Clase que define la fuente de datos de la tabla de devoluciones del punto.
class DevolucionPuntoDataGridSource extends DataGridSource {
  /// Obtiene el número de venta de una devolución dado su número de pedido.
  ///
  /// El método recibe el número de pedido y una lista de devoluciones.
  /// Recorre la lista de devoluciones buscando la devolución que corresponda
  /// al número de pedido especificado. Si encuentra una devolución que
  /// coincide con el número de pedido, obtiene el número de venta de la factura
  /// asociada a esa devolución y lo devuelve como una cadena. Si no encuentra
  /// ninguna devolución que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - Una cadena con el número de venta de la factura asociada a la devolución,
  ///   si se encuentra una devolución que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna devolución que coincida con
  ///   el número de pedido.
  String numeroVentaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    String numeroVenta = "";

    for (var devolucion in devoluciones) {
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        numeroVenta = devolucion.factura.numero.toString();
      }
    }

    return numeroVenta;
  }

  /// Obtiene el nombre del producto dado su id.
  ///
  /// El método recibe el id del producto y una lista de productos.
  /// Recorre la lista de productos buscando el producto que corresponda
  /// al id especificado. Si encuentra un producto que coincide con el id,
  /// obtiene el nombre del producto y lo devuelve como una cadena. Si no encuentra
  /// ningún producto que coincida con el id, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - productoAxiliar: El id del producto a buscar.
  /// - productos: La lista de productos en la que buscar el producto.
  ///
  /// Retorna:
  /// - Una cadena con el nombre del producto correspondiente al id,
  ///   si se encuentra un producto que coincida con el id.
  /// - Una cadena vacía si no se encuentra ningún producto que coincida con
  ///   el id.
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    // Cadena para almacenar el nombre del producto
    String productName = "";

    // Recorremos la lista de productos
    for (var producto in productos) {
      // Verificamos si el id del producto coincide con el id especificado
      if (producto.id == productoAxiliar) {
        // Si hay coincidencia, obtenemos el nombre del producto y salimos del bucle
        productName = producto.nombre;
        break;
      }
    }

    // Retornamos el nombre del producto o una cadena vacía si no se encontró ninguno
    return productName;
  }

  /// Obtiene la fecha de venta de una devolución dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la devolución y una lista de
  /// devoluciones. Recorre la lista de devoluciones buscando la devolución que
  /// corresponda al número de pedido especificado. Si encuentra una devolución que
  /// coincide con el número de pedido, obtiene la fecha de la factura asociada a
  /// esa devolución y la devuelve como una cadena. Si no encuentra ninguna
  /// devolución que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - Una cadena con la fecha de la factura asociada a la devolución encontrada,
  ///   si se encuentra una devolución que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna devolución que coincida con
  ///   el número de pedido.
  String fechaVentaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    // Cadena para almacenar la fecha de venta de la devolución
    String fechaVenta = "";

    // Recorremos la lista de devoluciones buscando la devolución correspondiente
    for (var devolucion in devoluciones) {
      // Verificamos si el número de pedido de la devolución coincide con el
      // número de pedido especificado
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Si hay coincidencia, obtenemos la fecha de la factura asociada a la
        // devolución y salimos del bucle
        fechaVenta = devolucion.factura.fecha;
        break;
      }
    }

    // Retornamos la fecha de venta de la devolución encontrada o una cadena vacía si
    // no se encontró ninguna devolución que coincida con el número de pedido
    return fechaVenta;
  }

  /// Obtiene el medio de pago de una devolución dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la devolución y una lista de
  /// devoluciones. Recorre la lista de devoluciones buscando la devolución que
  /// corresponda al número de pedido especificado. Si encuentra una devolución que
  /// coincide con el número de pedido, obtiene el medio de pago de la factura
  /// asociada a esa devolución y lo devuelve como una cadena. Si no encuentra
  /// ninguna devolución que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - Una cadena con el medio de pago de la factura asociada a la devolución,
  ///   si se encuentra una devolución que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna devolución que coincida con
  ///   el número de pedido.
  String medioVentaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    // Cadena para almacenar el medio de pago de la devolución
    String medioVenta = "";

    // Recorremos la lista de devoluciones buscando la devolución correspondiente
    for (var devolucion in devoluciones) {
      // Verificamos si el número de pedido de la devolución coincide con el
      // número de pedido especificado
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Si hay coincidencia, obtenemos el medio de pago de la factura asociada a
        // la devolución y salimos del bucle
        medioVenta = devolucion.factura.medioPago.nombre;
        break;
      }
    }

    // Retornamos el medio de pago de la devolución encontrada o una cadena vacía si
    // no se encontró ninguna devolución que coincida con el número de pedido
    return medioVenta;
  }

  /// Obtiene la fecha de devolución dado el número de pedido.
  ///
  /// El método recorre la lista de devoluciones buscando la devolución que
  /// corresponda al número de pedido especificado. Si encuentra una devolución que
  /// coincide con el número de pedido, obtiene la fecha de la devolución y la
  /// devuelve como una cadena. Si no encuentra ninguna devolución que coincida,
  /// devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - Una cadena con la fecha de la devolución encontrada, si se encuentra una
  ///   devolución que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna devolución que coincida con
  ///   el número de pedido.
  String fechaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    // Cadena para almacenar la fecha de la devolución
    String fechaDevolucion = "";

    // Recorremos la lista de devoluciones buscando la devolución correspondiente
    for (var devolucion in devoluciones) {
      // Verificamos si el número de pedido de la devolución coincide con el
      // número de pedido especificado
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Si hay coincidencia, obtenemos la fecha de la devolución y salimos del bucle
        fechaDevolucion = devolucion.fecha;
        break;
      }
    }

    // Retornamos la fecha de la devolución encontrada o una cadena vacía si no se
    // encontró ninguna devolución que coincida con el número de pedido
    return fechaDevolucion;
  }

  /// Obtiene el estado de devolución dado el número de pedido.
  ///
  /// El método recorre la lista de devoluciones buscando la devolución que
  /// corresponda al número de pedido especificado. Si encuentra una devolución que
  /// coincide con el número de pedido, obtiene su estado de devolución y lo devuelve.
  /// Si no encuentra ninguna devolución que coincida, devuelve false.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - El estado de devolución de la devolución encontrada, si se encuentra una
  ///   devolución que coincida con el número de pedido.
  /// - False si no se encuentra ninguna devolución que coincida con el número de
  ///   pedido.
  bool estadoDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    // Inicializa un booleano falso para almacenar el estado de devolución.
    bool estadoDevolucion = false;

    // Recorre la lista de devoluciones buscando la devolución correspondiente.
    for (var devolucion in devoluciones) {
      // Verifica si el número de pedido de la devolución coincide con el buscado.
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Obtiene el estado de devolución de la devolución.
        estadoDevolucion = devolucion.estado;
        // Salta el bucle para evitar buscar más devoluciones.
        break;
      }
    }

    // Devuelve el estado de devolución encontrado o falso.
    return estadoDevolucion;
  }

  /// Obtiene el nombre del vendedor de una devolución dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la devolución y una lista de
  /// usuarios y devoluciones. Recorre la lista de devoluciones buscando la
  /// devolución que corresponda al número de pedido especificado. Si encuentra
  /// una devolución que coincide con el número de pedido, busca el usuario
  /// vendedor en la lista de usuarios y obtiene su nombre. Si no encuentra
  /// ninguna devolución que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - usuarios: La lista de usuarios en la que buscar el usuario vendedor.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - Una cadena con el nombre del vendedor de la devolución encontrada, si se
  ///   encuentra una devolución que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna devolución que coincida con
  ///   el número de pedido.
  String nombreVendedor(int numeroPedido, List<UsuarioModel> usuarios,
      List<DevolucionesModel> devoluciones) {
    // Inicializa una cadena vacía para almacenar el nombre del vendedor.
    String vendedor = "";

    // Recorre la lista de facturas buscando la factura correspondiente.
    for (var devolucion in devoluciones) {
      // Verifica si el número de pedido de la factura coincide con el buscado.
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Busca el usuario vendedor en la lista de usuarios.
        UsuarioModel? usuario = usuarios.firstWhere(
            (usuario) => usuario.id == devolucion.factura.usuarioVendedor);
        // Obtiene el nombre del usuario vendedor.
        vendedor = "${usuario.nombres} ${usuario.apellidos}";
        // Salta el bucle para evitar buscar más facturas.
        break;
      }
    }

    // Devuelve el nombre del vendedor de la factura encontrada o una cadena vacía.
    return vendedor;
  }

  /// Crea un objeto de fuente de datos para la grilla de devoluciones.
  DevolucionPuntoDataGridSource({
    required List<AuxPedidoModel> devoluciones,
    required List<ProductoModel> listaProductos,
    required List<DevolucionesModel> listaDevoluciones,
    required List<UsuarioModel> listaUsuarios,
  }) {
    _devolucionData = devoluciones.map<DataGridRow>((devolucion) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Número Venta',
            value: numeroVentaDevolucion(
                devolucion.pedido.numeroPedido, listaDevoluciones)),
        DataGridCell<String>(
            columnName: 'Usuario',
            value:
                "${devolucion.pedido.usuario.nombres} ${devolucion.pedido.usuario.apellidos}"),
        DataGridCell<int>(
            columnName: 'Número Pedido', value: devolucion.pedido.numeroPedido),
        DataGridCell<String>(
            columnName: 'Producto',
            value: productoNombre(devolucion.producto, listaProductos)),
        DataGridCell<String>(
            columnName: 'Fecha Venta',
            value: fechaVentaDevolucion(
                devolucion.pedido.numeroPedido, listaDevoluciones)),
        DataGridCell<int>(columnName: 'Valor Pedido', value: devolucion.precio),
        DataGridCell<String>(
            columnName: 'Medio Pago',
            value: medioVentaDevolucion(
                devolucion.pedido.numeroPedido, listaDevoluciones)),
        DataGridCell<String>(
            columnName: 'Vendedor',
            value: nombreVendedor(devolucion.pedido.numeroPedido, listaUsuarios,
                listaDevoluciones)),
        DataGridCell<String>(
            columnName: 'Fecha Devolución',
            value: fechaDevolucion(
                devolucion.pedido.numeroPedido, listaDevoluciones)),
        DataGridCell<String>(
            columnName: 'Estado Devolución',
            value: estadoDevolucion(
                    devolucion.pedido.numeroPedido, listaDevoluciones)
                ? "Cancelado"
                : "Pendiente"),
      ]);
    }).toList();
  }

  // Lista de filas de la grilla
  List<DataGridRow> _devolucionData = [];

  // Celdas de la grilla
  @override
  List<DataGridRow> get rows => _devolucionData;

  // retorna el valor de la celda
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/pagos.svg",
                height: 30,
                width: 30,
                colorFilter:
                    const ColorFilter.mode(Colors.deepPurple, BlendMode.srcIn),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(row.getCells()[0].value.toString()),
              ),
            ],
          ),
        ),
      ),
      for (int i = 1; i < row.getCells().length; i++)
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: (row.getCells()[i].value is Widget)
              ? row.getCells()[i].value
              : Text(i == 5
                  ? "\$${formatter.format(row.getCells()[i].value)}" // formato de moneda
                  : i == 4 || i == 8
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // formato de fecha
                      : row.getCells()[i].value.toString()), // formato de texto
        ),
    ]);
  }
}
