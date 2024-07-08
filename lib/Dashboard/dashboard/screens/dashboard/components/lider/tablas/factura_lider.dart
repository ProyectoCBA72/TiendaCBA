// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Esta clase representa un widget de estado que muestra una tabla de facturas de un líder.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_FacturaLiderState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan las facturas del líder.
class FacturaLider extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representan las facturas del líder.
  final List<AuxPedidoModel> auxPedido;

  /// Constructor que recibe la lista de facturas del líder.
  ///
  /// Parámetros:
  /// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan las facturas del líder.
  const FacturaLider({super.key, required this.auxPedido});

  /// Crea un estado [_FacturaLiderState] para manejar los datos de la pantalla.
  @override
  State<FacturaLider> createState() => _FacturaLiderState();
}

class _FacturaLiderState extends State<FacturaLider> {
  /// Lista de objetos [AuxPedidoModel] que representan las facturas del líder.
  List<AuxPedidoModel> _facturas = [];

  /// Lista de objetos [ProductoModel] que representan los productos.
  ///
  /// Esta lista se utiliza para obtener el nombre de los productos en la tabla de facturas.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [FacturaModel] que representan las facturas.
  ///
  /// Esta lista se utiliza para obtener el nombre del punto de venta en la tabla de facturas.
  List<FacturaModel> listaFacturas = [];

  /// Origen de datos para la tabla de facturas.
  ///
  /// Este origen de datos se utiliza para obtener los datos para mostrar en la tabla de facturas.
  late FacturaLiderDataGridSource _dataGridSource;

  @override

  /// Se llama cuando se crea el estado [State] para la primera vez.
  ///
  /// En este método se inicializan las variables [_dataGridSource] y [_facturas]
  /// con los datos proporcionados por el widget y se llama a [_loadData] para
  /// cargar los datos necesarios para mostrar la tabla de facturas.
  @override
  void initState() {
    super.initState();

    // Inicializa el origen de datos de la tabla de facturas con los datos
    // proporcionados por el widget.
    _dataGridSource = FacturaLiderDataGridSource(
        facturas: _facturas,
        listaProductos: listaProductos,
        listaFacturas: listaFacturas);

    // Asigna las facturas proporcionadas por el widget a la variable [_facturas].
    _facturas = widget.auxPedido;

    // Llama a [_loadData] para cargar los datos necesarios para mostrar la
    // tabla de facturas.
    _loadData();
  }

  /// Carga los datos necesarios para mostrar la tabla de facturas.
  ///
  /// Este método obtiene los productos y las facturas de la API y luego
  /// actualiza las variables [_listaProductos] y [_listaFacturas] con los
  /// datos recibidos. Finalmente, actualiza [_dataGridSource] en el siguiente
  /// frame de la interfaz de usuario.
  Future<void> _loadData() async {
    // Obtiene los productos de la API
    List<ProductoModel> productosCargados = await getProductos();

    // Obtiene las facturas de la API
    List<FacturaModel> facturasCargadas = await getFacturas();

    // Asigna los productos y las facturas a las variables correspondientes
    listaProductos = productosCargados;
    listaFacturas = facturasCargadas;

    // Ahora inicializa _dataGridSource después de cargar los datos
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Inicializa _dataGridSource con los datos de las facturas, productos y pedidos
        _dataGridSource = FacturaLiderDataGridSource(
            facturas: _facturas,
            listaProductos: listaProductos,
            listaFacturas: listaFacturas);
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
          // Título del reporte
          Text(
            "Ventas",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Tabla de facturas
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
                source: _dataGridSource, // Origen de datos de la tabla
                selectionMode: SelectionMode.multiple,
                showCheckboxColumn: true,
                allowSorting: true,
                allowFiltering: true,
                // Columnas de la tabla
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'Número',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Número'),
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
                _buildButton('Imprimir Reporte', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye un botón con los estilos de diseño especificados.
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
  ///
  /// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      // Decoración del contenedor con un gradiente de color y sombra
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
      // Contenido del contenedor, un widget [Material] con un estilo específico
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                text, // Texto del botón
                style: const TextStyle(
                  // Estilo del texto
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
}

// Clase que define los datos de la tabla
class FacturaLiderDataGridSource extends DataGridSource {
  /// Obtiene el número de venta de una factura dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la factura y una lista de facturas.
  /// Recorre la lista de facturas buscando la factura que corresponda al
  /// número de pedido especificado. Si encuentra una factura que coincide con
  /// el número de pedido, obtiene el número de venta y lo devuelve como una
  /// cadena. Si no encuentra ninguna factura que coincida, devuelve una cadena
  /// vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la factura a buscar.
  /// - facturas: La lista de facturas en la que buscar la factura.
  ///
  /// Retorna:
  /// - Una cadena con el número de venta de la factura encontrada, si se encuentra
  ///   una factura que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna factura que coincida con el
  ///   número de pedido.
  String numeroVentaFactura(int numeroPedido, List<FacturaModel> facturas) {
    // Inicializa una cadena vacía para almacenar el número de venta.
    String numeroVenta = "";

    // Recorre la lista de facturas buscando la factura correspondiente.
    for (var factura in facturas) {
      // Verifica si el número de pedido de la factura coincide con el buscado.
      if (factura.pedido.numeroPedido == numeroPedido) {
        // Obtiene el número de venta de la factura.
        numeroVenta = factura.numero.toString();
      }
    }

    // Devuelve el número de venta encontrado o una cadena vacía.
    return numeroVenta;
  }

  /// Obtiene el nombre de un producto dado su id.
  ///
  /// El método recibe el id del producto y una lista de productos.
  /// Recorre la lista de productos buscando el producto que corresponda al
  /// id especificado. Si encuentra un producto que coincide con
  /// el id, obtiene el nombre del producto y lo devuelve como una
  /// cadena. Si no encuentra ningún producto que coincida con el
  /// id, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - productoAxiliar: El id del producto a buscar.
  /// - productos: La lista de productos en la que buscar el producto.
  ///
  /// Retorna:
  /// - Una cadena con el nombre del producto encontrado, si se encuentra
  ///   un producto que coincida con el id.
  /// - Una cadena vacía si no se encuentra ningún producto que coincida con el
  ///   id.
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    // Inicializa una cadena vacía para almacenar el nombre del producto.
    String productName = "";

    // Recorre la lista de productos buscando el producto correspondiente.
    for (var producto in productos) {
      // Verifica si el id del producto coincide con el buscado.
      if (producto.id == productoAxiliar) {
        // Obtiene el nombre del producto.
        productName = producto.nombre;
        // Salta el bucle para no buscar más productos.
        break;
      }
    }

    // Devuelve el nombre del producto encontrado o una cadena vacía.
    return productName;
  }

  /// Obtiene la fecha de venta de una factura dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la factura y una lista de facturas.
  /// Recorre la lista de facturas buscando la factura que corresponda al
  /// número de pedido especificado. Si encuentra una factura que coincide con
  /// el número de pedido, obtiene la fecha de venta de la factura y la devuelve
  /// como una cadena. Si no encuentra ninguna factura que coincida, devuelve una
  /// cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la factura a buscar.
  /// - facturas: La lista de facturas en la que buscar la factura.
  ///
  /// Retorna:
  /// - Una cadena con la fecha de venta de la factura encontrada, si se encuentra
  ///   una factura que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna factura que coincida con el
  ///   número de pedido.
  String fechaVentaFactura(int numeroPedido, List<FacturaModel> facturas) {
    String fechaVenta = "";

    for (var factura in facturas) {
      if (factura.pedido.numeroPedido == numeroPedido) {
        fechaVenta = factura.fecha;
      }
    }

    return fechaVenta;
  }

  /// Obtiene el medio de pago de una factura dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la factura y una lista de facturas.
  /// Recorre la lista de facturas buscando la factura que corresponda al
  /// número de pedido especificado. Si encuentra una factura que coincide con
  /// el número de pedido, obtiene el medio de pago de la factura y lo devuelve
  /// como una cadena. Si no encuentra ninguna factura que coincida, devuelve una
  /// cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la factura a buscar.
  /// - facturas: La lista de facturas en la que buscar la factura.
  ///
  /// Retorna:
  /// - Una cadena con el medio de pago de la factura encontrada, si se encuentra
  ///   una factura que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna factura que coincida con el
  ///   número de pedido.
  String medioVentaFactura(int numeroPedido, List<FacturaModel> facturas) {
    String medioVenta = "";

    for (var factura in facturas) {
      if (factura.pedido.numeroPedido == numeroPedido) {
        medioVenta = factura.medioPago.nombre;
      }
    }

    return medioVenta;
  }

  // Crea un objeto de tipo FacturaLiderDataGridSource.
  FacturaLiderDataGridSource({
    required List<AuxPedidoModel> facturas,
    required List<ProductoModel> listaProductos,
    required List<FacturaModel> listaFacturas,
  }) {
    _facturaData = facturas.map<DataGridRow>((factura) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Número',
            value:
                numeroVentaFactura(factura.pedido.numeroPedido, listaFacturas)),
        DataGridCell<String>(
            columnName: 'Usuario',
            value:
                "${factura.pedido.usuario.nombres} ${factura.pedido.usuario.apellidos}"),
        DataGridCell<int>(
            columnName: 'Número Pedido', value: factura.pedido.numeroPedido),
        DataGridCell<String>(
            columnName: 'Producto',
            value: productoNombre(factura.producto, listaProductos)),
        DataGridCell<String>(
            columnName: 'Fecha Venta',
            value:
                fechaVentaFactura(factura.pedido.numeroPedido, listaFacturas)),
        DataGridCell<int>(columnName: 'Valor Pedido', value: factura.precio),
        DataGridCell<String>(
            columnName: 'Medio Pago',
            value:
                medioVentaFactura(factura.pedido.numeroPedido, listaFacturas)),
      ]);
    }).toList();
  }

  // Crea una lista de DataGridRow para mostrar en la tabla.
  List<DataGridRow> _facturaData = [];

  // Obtiene una lista de DataGridRow para mostrar en la tabla.
  @override
  List<DataGridRow> get rows => _facturaData;

  // Retorna una instancia de DataGridRowAdapter para mostrar en la tabla.
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
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formato de moneda
                  : i == 4
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Formateo de fecha
                      : row.getCells()[i].value.toString()), // Texto Normal
        ),
    ]);
  }
}
