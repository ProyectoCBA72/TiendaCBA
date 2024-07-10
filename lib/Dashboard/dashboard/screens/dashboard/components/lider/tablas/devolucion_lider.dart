// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Widget de estado que representa la vista de devoluciones de un líder.
///
/// Esta clase extiende [StatefulWidget] y proporciona un estado asociado
/// [_DevolucionLiderState]. Tiene una lista de [AuxPedidoModel] que representa
/// las devoluciones del líder.
class DevolucionLider extends StatefulWidget {
  /// Lista de pedidos de devolución.
  ///
  /// Esta lista es necesaria para mostrar las devoluciones del líder en la tabla.
  final List<AuxPedidoModel> auxPedido;

  /// Constructor que recibe la lista de pedidos de devolución.
  ///
  /// El parámetro [auxPedido] es obligatorio y debe ser proporcionado.
  const DevolucionLider({super.key, required this.auxPedido});

  /// Sobrecarga del método [createState].
  ///
  /// Este método devuelve una instancia de [_DevolucionLiderState] que se utiliza
  /// para manejar los datos de la pantalla.
  @override
  State<DevolucionLider> createState() => _DevolucionLiderState();
}

class _DevolucionLiderState extends State<DevolucionLider> {
  /// Lista de devoluciones del líder.
  ///
  /// Es una lista de objetos [AuxPedidoModel] que representan las devoluciones del líder.
  List<AuxPedidoModel> _devoluciones = [];

  /// Lista de productos.
  ///
  /// Es una lista de objetos [ProductoModel] que representan los productos utilizados en las devoluciones.
  List<ProductoModel> listaProductos = [];

  /// Lista de devoluciones.
  ///
  /// Es una lista de objetos [DevolucionesModel] que representan las devoluciones realizadas por el líder.
  List<DevolucionesModel> listaDevoluciones = [];

  /// Fuente de datos para la tabla de devoluciones.
  ///
  /// Es un objeto [DevolucionLiderDataGridSource] que se utiliza para proporcionar los datos necesarios para la tabla de devoluciones.
  late DevolucionLiderDataGridSource _dataGridSource;

  @override

  /// Método que se ejecuta cuando el estado del widget se inicializa.
  ///
  /// En este método se configura la fuente de datos [_dataGridSource] con los datos
  /// iniciales y se carga los datos necesarios para la pantalla.
  @override
  void initState() {
    super.initState();

    // Inicializa la fuente de datos [_dataGridSource] con los datos iniciales.
    _dataGridSource = DevolucionLiderDataGridSource(
        devoluciones: _devoluciones,
        listaProductos: listaProductos,
        listaDevoluciones: listaDevoluciones);

    // Asigna los pedidos de devolución recibidos como parámetro al estado [_devoluciones].
    _devoluciones = widget.auxPedido;

    // Carga los datos necesarios para la pantalla.
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

    // Asigna los productos y las devoluciones a las variables correspondientes
    listaProductos = productosCargados;
    listaDevoluciones = devolucionesCargadas;

    if (mounted) {
      // Actualiza _dataGridSource en el siguiente frame de la interfaz de usuario
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializa _dataGridSource con los datos de las devoluciones, productos y pedidos
          _dataGridSource = DevolucionLiderDataGridSource(
              devoluciones: _devoluciones,
              listaProductos: listaProductos,
              listaDevoluciones: listaDevoluciones);
        });
      });
    }
  }

  /// Se llama automáticamente cuando se elimina el widget.
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por el widget.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos adicionales.
  @override
  void dispose() {
    // Libera los recursos utilizados por la operación si es necesario
    // Este método se debe llamar para liberar los recursos utilizados por el widget.
    // Se debe llamar al método [dispose] del padre para liberar recursos adicionales.
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
          // Titulo de las tablas
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
          // Tabla
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
                source: _dataGridSource, // Asigna la fuente de datos
                selectionMode: SelectionMode.multiple,
                showCheckboxColumn: true,
                allowSorting: true,
                allowFiltering: true,
                // Columnas
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
          // Botón de impresión
          Center(
            child: Column(
              children: [
                _buildButton('Imprimir Reporte', () {}),
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
      width: 200, // Ancho fijo del botón.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Border redondeado.
        gradient: const LinearGradient(
          // Gradiente de colores.
          colors: [
            botonClaro, // Color claro del gradiente.
            botonOscuro, // Color oscuro del gradiente.
          ],
        ),
        boxShadow: const [
          // Sombra del botón.
          BoxShadow(
            color: botonSombra, // Color de la sombra.
            blurRadius: 5, // Radio de desfoque de la sombra.
            offset: Offset(0, 3), // Desplazamiento de la sombra.
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Color transparente para el Material.
        child: InkWell(
          onTap: onPressed, // Función de presionar.
          borderRadius:
              BorderRadius.circular(10), // Radio del borde redondeado.
          child: Padding(
            // Padding vertical.
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                text, // Texto del botón.
                style: const TextStyle(
                  color: background1, // Color del texto.
                  fontSize: 13, // Tamaño de fuente.
                  fontWeight: FontWeight.bold, // Peso de fuente.
                  fontFamily: 'Calibri-Bold', // Fuente.
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fuente de datos para la tabla de devoluciones.
class DevolucionLiderDataGridSource extends DataGridSource {
  /// Obtiene el número de venta de una devolución dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la devolución y una lista de
  /// devoluciones. Recorre la lista de devoluciones buscando la devolución que
  /// corresponda al número de pedido especificado. Si encuentra una devolución que
  /// coincide con el número de pedido, obtiene el número de venta y lo devuelve como
  /// una cadena. Si no encuentra ninguna devolución que coincida, devuelve una
  /// cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - Una cadena con el número de venta de la devolución encontrada, si se encuentra
  ///   una devolución que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna devolución que coincida con el
  ///   número de pedido.
  String numeroVentaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    String numeroVenta = "";

    // Recorremos la lista de devoluciones buscando la devolución correspondiente
    for (var devolucion in devoluciones) {
      // Verificamos si el número de pedido de la devolución coincide con el
      // número de pedido especificado
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Si hay coincidencia, obtenemos el número de venta de la factura asociada a
        // la devolución y salimos del bucle
        numeroVenta = devolucion.factura.numero.toString();
        break;
      }
    }

    // Retornamos el número de venta de la devolución encontrada o una cadena vacía si
    // no se encontró ninguna devolución que coincida con el número de pedido
    return numeroVenta;
  }

  /// Obtiene el nombre de un producto dado su identificador auxiliar.
  ///
  /// El método recibe el identificador auxiliar del producto y una lista de
  /// productos. Recorre la lista de productos buscando el producto que
  /// corresponda al identificador auxiliar especificado. Si encuentra un
  /// producto que coincide con el identificador auxiliar, obtiene su nombre y
  /// lo devuelve como una cadena. Si no encuentra ningún producto que
  /// coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - productoAxiliar: El identificador auxiliar del producto a buscar.
  /// - productos: La lista de productos en la que buscar el producto.
  ///
  /// Retorna:
  /// - Una cadena con el nombre del producto encontrado, si se encuentra un
  ///   producto que coincida con el identificador auxiliar.
  /// - Una cadena vacía si no se encuentra ningún producto que coincida con
  ///   el identificador auxiliar.
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    // Inicializamos una cadena vacía para almacenar el nombre del producto.
    String productName = "";

    // Recorremos la lista de productos buscando el producto correspondiente.
    for (var producto in productos) {
      // Verificamos si el identificador auxiliar del producto coincide con el buscado.
      if (producto.id == productoAxiliar) {
        // Si hay coincidencia, obtenemos el nombre del producto y salimos del bucle.
        productName = producto.nombre;
        break;
      }
    }

    // Retornamos el nombre del producto encontrado o una cadena vacía si no se encontró ninguno.
    return productName;
  }

  /// Obtiene la fecha de venta de una devolución dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la devolución y una lista de
  /// devoluciones. Recorre la lista de devoluciones buscando la devolución que
  /// corresponda al número de pedido especificado. Si encuentra una devolución que
  /// coincide con el número de pedido, obtiene la fecha de venta de la factura
  /// asociada a esa devolución y la devuelve como una cadena. Si no encuentra
  /// ninguna devolución que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - Una cadena con la fecha de venta de la factura asociada a la devolución,
  ///   si se encuentra una devolución que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna devolución que coincida con
  ///   el número de pedido.
  String fechaVentaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    // Inicializamos una cadena vacía para almacenar la fecha de venta.
    String fechaVenta = "";

    // Recorremos la lista de devoluciones buscando la devolución correspondiente.
    for (var devolucion in devoluciones) {
      // Verificamos si el número de pedido de la devolución coincide con el buscado.
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Si hay coincidencia, obtenemos la fecha de venta de la factura y salimos del bucle.
        fechaVenta = devolucion.factura.fecha;
        break;
      }
    }

    // Retornamos la fecha de venta encontrada o una cadena vacía si no se encontró ninguna.
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
    // Inicializamos una cadena vacía para almacenar el medio de pago.
    String medioVenta = "";

    // Recorremos la lista de devoluciones buscando la devolución correspondiente.
    for (var devolucion in devoluciones) {
      // Verificamos si el número de pedido de la devolución coincide con el buscado.
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Si hay coincidencia, obtenemos el medio de pago de la factura y salimos del bucle.
        medioVenta = devolucion.factura.medioPago.nombre;
      }
    }

    // Devolvemos el medio de pago encontrado o una cadena vacía.
    return medioVenta;
  }

  /// Obtiene la fecha de devolución de una devolución dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la devolución y una lista de
  /// devoluciones. Recorre la lista de devoluciones buscando la devolución que
  /// corresponda al número de pedido especificado. Si encuentra una devolución que
  /// coincide con el número de pedido, obtiene la fecha de la devolución y la
  /// devuelve como una cadena. Si no encuentra alguna devolución que coincida,
  /// devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la devolución a buscar.
  /// - devoluciones: La lista de devoluciones en la que buscar la devolución.
  ///
  /// Retorna:
  /// - Una cadena con la fecha de la devolución encontrada, si se encuentra una
  ///   devolución que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra alguna devolución que coincida con
  ///   el número de pedido.
  String fechaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    // Inicializamos una cadena vacía para almacenar la fecha de devolución.
    String fechaDevolucion = "";

    // Recorremos la lista de devoluciones buscando la devolución correspondiente.
    for (var devolucion in devoluciones) {
      // Verificamos si el número de pedido de la devolución coincide con el buscado.
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Si hay coincidencia, obtenemos la fecha de la devolución y salimos del bucle.
        fechaDevolucion = devolucion.fecha;
      }
    }

    // Devolvemos la fecha de devolución encontrada o una cadena vacía.
    return fechaDevolucion;
  }

  /// Obtiene el estado de devolución dado el número de pedido.
  ///
  /// El método recorre la lista de devoluciones buscando la devolución que
  /// corresponda al número de pedido especificado. Si encuentra una devolución que
  /// coincida con el número de pedido, obtiene su estado de devolución y lo devuelve.
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
    bool estadoDevolucion = false;

    // Recorremos la lista de devoluciones buscando la devolución correspondiente.
    for (var devolucion in devoluciones) {
      // Verificamos si el número de pedido de la devolución coincide con el buscado.
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        // Obtenemos el estado de devolución de la devolución.
        estadoDevolucion = devolucion.estado;
        // Salimos del bucle para evitar buscar más devoluciones.
        break;
      }
    }

    // Devolvemos el estado de devolución encontrado o false si no se encontró ninguna
    // devolución que coincida con el número de pedido.
    return estadoDevolucion;
  }

  /// Crea una fuente de datos para la tabla de devoluciones
  DevolucionLiderDataGridSource({
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

  // Lista de filas de la tabla
  List<DataGridRow> _devolucionData = [];

  // Filas de la tabla
  @override
  List<DataGridRow> get rows => _devolucionData;

  // Retorna el valor de una celda
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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formato Moneda
                  : i == 4 || i == 7
                      ? formatFechaHora(
                          row.getCells()[i].value.toString()) // Formato Fecha
                      : row.getCells()[i].value.toString()), // Texto normal
        ),
    ]);
  }
}
