// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

/// Un widget de estado que representa la vista de devoluciones de un punto de venta.
///
/// Esta clase extiende [StatefulWidget] y proporciona un estado asociado
/// [_DevolucionPuntoState]. Tiene una lista de [AuxPedidoModel] que representa
/// las devoluciones del punto de venta.
class DevolucionPunto extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representan las devoluciones del punto de venta.
  final List<AuxPedidoModel> auxPedido;

  /// Crea un nuevo widget de estado de devoluciones para un punto de venta.
  ///
  /// El parámetro [auxPedido] es una lista de objetos [AuxPedidoModel] que
  /// representan las devoluciones del punto de venta.
  const DevolucionPunto({super.key, required this.auxPedido});

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

  /// Un [DataGridSource] que proporciona los datos para la tabla de devoluciones.
  late DevolucionPuntoDataGridSource _dataGridSource;

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
        listaDevoluciones: listaDevoluciones);

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

    // Actualiza _dataGridSource en el siguiente frame de la interfaz de usuario
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Inicializa _dataGridSource con los datos de las devoluciones, productos y pedidos
        _dataGridSource = DevolucionPuntoDataGridSource(
            devoluciones: _devoluciones,
            listaProductos: listaProductos,
            listaDevoluciones: listaDevoluciones);
      });
    });
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
                _buildButton('Imprimir Reporte', () {}),
                const SizedBox(
                  width: defaultPadding,
                ),
                _buildButton('Cambiar Estado', () {}),
              ],
            ),
          if (Responsive.isMobile(context))
            Center(
              child: Column(
                children: [
                  _buildButton('Imprimir Reporte', () {}),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  _buildButton('Cambiar Estado', () {}),
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

  /// Crea un objeto de fuente de datos para la grilla de devoluciones.
  DevolucionPuntoDataGridSource({
    required List<AuxPedidoModel> devoluciones,
    required List<ProductoModel> listaProductos,
    required List<DevolucionesModel> listaDevoluciones,
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
        alignment: Alignment.center,
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
                  : i == 4 || i == 7
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // formato de fecha
                      : row.getCells()[i].value.toString()), // formato de texto
        ),
    ]);
  }
}
