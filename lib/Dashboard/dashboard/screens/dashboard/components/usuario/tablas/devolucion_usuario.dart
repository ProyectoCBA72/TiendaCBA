// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/Usuario/pdfDevolucionUsuario.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';

/// Clase que representa la pantalla de devoluciones de un usuario.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_DevolucionUsuarioState] para manejar los datos de la pantalla.
///
/// Parámetros requeridos para la construcción del widget:
///
/// - [auxPedido]: La lista de pedidos del usuario a mostrar.
class DevolucionUsuario extends StatefulWidget {
  /// La lista de pedidos del usuario a mostrar.
  final List<AuxPedidoModel> auxPedido;

  final UsuarioModel usuario;

  /// Constructor de la clase DevolucionUsuario.
  ///
  /// Recibe una lista de pedidos del usuario y los almacena en el campo [auxPedido].
  const DevolucionUsuario(
      {super.key, required this.auxPedido, required this.usuario});

  /// Devuelve el estado de la clase DevolucionUsuario.
  @override
  State<DevolucionUsuario> createState() => _DevolucionUsuarioState();
}

class _DevolucionUsuarioState extends State<DevolucionUsuario> {
  /// Lista que almacena los pedidos del usuario.
  ///
  /// Esta lista se utiliza para mostrar los pedidos del usuario en la pantalla de devoluciones.
  List<AuxPedidoModel> _devoluciones = [];

  /// Lista que almacena los productos de la tienda.
  ///
  /// Esta lista se utiliza para mostrar los productos en la pantalla de devoluciones.
  List<ProductoModel> listaProductos = [];

  /// Lista que almacena las devoluciones.
  ///
  /// Esta lista se utiliza para mostrar las devoluciones en la pantalla de devoluciones.
  List<DevolucionesModel> listaDevoluciones = [];

  /// Lista de objetos [UsuarioModel] que representan los vendedores del punto de venta.
  List<UsuarioModel> listaUsuarios = [];

  /// Fuente de datos para la grilla de devoluciones.
  ///
  /// Esta variable se utiliza para mostrar los datos de las devoluciones en la pantalla de devoluciones.
  late DevolucionUsuarioDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Inicializa el estado del widget.
  ///
  /// Se llama automáticamente cuando se crea el widget. En este método, se inicializan
  /// las variables y se llama a los métodos necesarios para cargar los datos.
  @override
  void initState() {
    super.initState();

    // Inicializa la fuente de datos para la grilla de devoluciones
    _dataGridSource = DevolucionUsuarioDataGridSource(
      devoluciones: _devoluciones,
      listaProductos: listaProductos,
      listaDevoluciones: listaDevoluciones,
      listaUsuarios: listaUsuarios,
    );

    // Actualiza la lista de devoluciones con los pedidos recibidos del widget
    _devoluciones = widget.auxPedido;

    // Carga los datos necesarios para mostrar las devoluciones
    _loadData();
  }

  /// Carga los datos necesarios para mostrar las devoluciones.
  ///
  /// Esto incluye obtener los productos y las devoluciones de la API y asignarlos
  /// a las variables [listaProductos] y [listaDevoluciones], respectivamente.
  /// Luego, se actualiza [_dataGridSource] en el siguiente frame de la interfaz de usuario.
  Future<void> _loadData() async {
    // Obtiene los productos de la API
    List<ProductoModel> productosCargados = await getProductos();

    // Obtiene las devoluciones de la API
    List<DevolucionesModel> devolucionesCargadas = await getDevoluciones();

    // Obtiene los usuarios de la API
    List<UsuarioModel> usuariosCargados = await getUsuarios();

    // Asigna los productos, las devoluciones y los usuarios a las variables correspondientes
    listaProductos = productosCargados;
    listaDevoluciones = devolucionesCargadas;
    listaUsuarios = usuariosCargados;

    if (mounted) {
      // Actualiza _dataGridSource en el siguiente frame de la interfaz de usuario
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializa _dataGridSource con los datos de las devoluciones, productos y pedidos
          _dataGridSource = DevolucionUsuarioDataGridSource(
            devoluciones: _devoluciones,
            listaProductos: listaProductos,
            listaDevoluciones: listaDevoluciones,
            listaUsuarios: listaUsuarios,
          );
        });
      });
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
          // Título de la grilla de devoluciones
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
          // Grilla de devoluciones
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
                source: _dataGridSource, // Fuente de datos
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
                // Columnas de la grilla
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
          // Botón para imprimir el reporte
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
                            builder: (context) => PdfDevolucionUsuarioScreen(
                                usuario: widget.usuario, registro: registros)));
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Crea un botón con el texto dado y la función onPressed dada.
  ///
  /// El botón tiene un borde redondeado, un degradado de colores y sombra.
  /// El texto del botón tiene un estilo con fuente negrita y tamaño específico.
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
  Widget _buildButton(String text, VoidCallback onPressed) {
    // Crea un contenedor con un ancho de 200 píxeles y una decoración personalizada.
    return Container(
      width: 200,
      decoration: BoxDecoration(
        // Establece un borde redondeado de 10 píxeles.
        borderRadius: BorderRadius.circular(10),
        // Establece un degradado de colores.
        gradient: const LinearGradient(
          colors: [
            botonClaro,
            botonOscuro,
          ],
        ),
        // Establece una sombra con un color y un borde redondeado.
        boxShadow: const [
          BoxShadow(
            color: botonSombra,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      // Crea un Material con un color transparente y un hijo InkWell.
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // Establece la función onTap para ejecutar cuando se presione el botón.
          onTap: onPressed,
          // Establece un borde redondeado de 10 píxeles.
          borderRadius: BorderRadius.circular(10),
          // Establece un relleno simétrico verticalmente de 10 píxeles.
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            // Centra el texto dentro del botón.
            child: Center(
              // Muestra el texto con un estilo específico.
              child: Text(
                text,
                style: const TextStyle(
                  // Establece el color del texto como background1.
                  color: background1,
                  // Establece el tamaño del texto a 13 píxeles.
                  fontSize: 13,
                  // Establece la fuente como Calibri-Bold en negrita.
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
}

// Crea una fuente de datos para la tabla de devoluciones.
class DevolucionUsuarioDataGridSource extends DataGridSource {
  /// Obtiene el número de venta de una devolución.
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
    // Inicializa una cadena vacía para almacenar el número de venta.
    String numeroVenta = "";

    // Recorre la lista de devoluciones buscando la devolución correspondiente.
    for (var devolucion in devoluciones) {
      // Verifica si el número de pedido de la devolución coincide con el buscado.
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Obtiene el número de venta de la factura asociada a la devolución.
        numeroVenta = devolucion.factura.numero.toString();
        // Salta el bucle para evitar buscar más devoluciones.
        break;
      }
    }

    // Devuelve el número de venta encontrado o una cadena vacía.
    return numeroVenta;
  }

  /// Obtiene el nombre de un producto dado su identificador auxiliar.
  ///
  /// El método recibe el identificador auxiliar del producto y una lista de
  /// productos. Recorre la lista de productos buscando el producto que
  /// corresponda al identificador auxiliar especificado. Si encuentra un
  /// producto que coincide con el identificador auxiliar, obtiene el nombre del
  /// producto y lo devuelve como una cadena. Si no encuentra ningún producto que
  /// coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - productoAxiliar: El identificador auxiliar del producto a buscar.
  /// - productos: La lista de productos en la que buscar el producto.
  ///
  /// Retorna:
  /// - Una cadena con el nombre del producto, si se encuentra un producto que
  ///   coincide con el identificador auxiliar.
  /// - Una cadena vacía si no se encuentra ningún producto que coincida con el
  ///   identificador auxiliar.
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    // Inicializa una cadena vacía para almacenar el nombre del producto.
    String productName = "";

    // Recorre la lista de productos buscando el producto correspondiente.
    for (var producto in productos) {
      // Verifica si el identificador auxiliar del producto coincide con el buscado.
      if (producto.id == productoAxiliar) {
        // Obtiene el nombre del producto.
        productName = producto.nombre;
        // Salta el bucle para evitar buscar más productos.
        break;
      }
    }

    // Devuelve el nombre del producto encontrado o una cadena vacía.
    return productName;
  }

  /// Obtiene la fecha de venta de una devolución dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la devolución y una lista de
  /// devoluciones. Recorre la lista de devoluciones buscando la devolución que
  /// corresponda al número de pedido especificado. Si encuentra una devolución que
  /// coincide con el número de pedido, obtiene la fecha de venta de la factura
  /// asociada y la devuelve como una cadena. Si no encuentra ninguna devolución
  /// que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - Una cadena con la fecha de venta de la factura asociada a la devolución
  ///   encontrada, si se encuentra una devolución que coincide con el número de
  ///   pedido.
  /// - Una cadena vacía si no se encuentra ninguna devolución que coincida con
  ///   el número de pedido.
  String fechaVentaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    // Inicializa una cadena vacía para almacenar la fecha de venta.
    String fechaVenta = "";

    // Recorre la lista de devoluciones buscando la devolución correspondiente.
    for (var devolucion in devoluciones) {
      // Verifica si el número de pedido de la devolución coincide con el buscado.
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Obtiene la fecha de venta de la factura asociada a la devolución.
        fechaVenta = devolucion.factura.fecha;
        // Salta el bucle para evitar buscar más devoluciones.
        break;
      }
    }

    // Devuelve la fecha de venta de la devolución encontrada o una cadena vacía.
    return fechaVenta;
  }

  /// Obtiene el medio de pago de una devolución dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la devolución y una lista de
  /// devoluciones. Recorre la lista de devoluciones buscando la devolución que
  /// corresponda al número de pedido especificado. Si encuentra una devolución que
  /// coincide con el número de pedido, obtiene el medio de pago de la factura
  /// asociada y la devuelve como una cadena. Si no encuentra ninguna devolución
  /// que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - Una cadena con el medio de pago de la factura asociada a la devolución
  ///   encontrada, si se encuentra una devolución que coincide con el número de
  ///   pedido.
  /// - Una cadena vacía si no se encuentra ninguna devolución que coincida con
  ///   el número de pedido.
  String medioVentaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    // Inicializa una cadena vacía para almacenar el medio de pago.
    String medioVenta = "";

    // Recorre la lista de devoluciones buscando la devolución correspondiente.
    for (var devolucion in devoluciones) {
      // Verifica si el número de pedido de la devolución coincide con el buscado.
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Obtiene el medio de pago de la factura asociada a la devolución.
        medioVenta = devolucion.factura.medioPago.nombre;
        // Salta el bucle para evitar buscar más devoluciones.
        break;
      }
    }

    // Devuelve el medio de pago de la devolución encontrada o una cadena vacía.
    return medioVenta;
  }

  /// Obtiene la fecha de una devolución dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la devolución y una lista de
  /// devoluciones. Recorre la lista de devoluciones buscando la devolución que
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
    // Inicializa una cadena vacía para almacenar la fecha de la devolución.
    String fechaDevolucion = "";

    // Recorre la lista de devoluciones buscando la devolución correspondiente.
    for (var devolucion in devoluciones) {
      // Verifica si el número de pedido de la devolución coincide con el buscado.
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Obtiene la fecha de la devolución.
        fechaDevolucion = devolucion.fecha;
        // Salta el bucle para evitar buscar más devoluciones.
        break;
      }
    }

    // Devuelve la fecha de la devolución encontrada o una cadena vacía.
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
        var usuario = usuarios.firstWhere(
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

  // Lista de datos de pedido
  DevolucionUsuarioDataGridSource({
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

  // Lista de datos
  List<DataGridRow> _devolucionData = [];

  // Celdas
  @override
  List<DataGridRow> get rows => _devolucionData;

  // Retorna la lista de datos
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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formatea el valor a moneda
                  : i == 4 || i == 8
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Formatea la fecha
                      : row.getCells()[i].value.toString()), // Muestra el valor
        ),
    ]);
  }
}
