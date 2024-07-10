// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Esta clase representa un widget de estado que muestra una tabla de pedidos entregados de un lider.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_EntregadoLiderState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan los pedidos entregados del lider.
class EntregadoLider extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos entregados del lider.
  final List<AuxPedidoModel> auxPedido;

  /// Constructor del widget que recibe la lista de pedidos entregados del lider.
  ///
  /// Parámetros:
  /// - [key]: La [Key] del widget.
  /// - [auxPedido]: La lista de objetos [AuxPedidoModel] que representan los pedidos entregados del lider.
  const EntregadoLider({super.key, required this.auxPedido});

  /// Crea y devuelve el estado [_EntregadoLiderState] para manejar los datos de la pantalla.
  @override
  State<EntregadoLider> createState() => _EntregadoLiderState();
}

class _EntregadoLiderState extends State<EntregadoLider> {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos entregados del lider.
  List<AuxPedidoModel> _pedidos = [];

  /// Lista de objetos [ProductoModel] que representan los productos disponibles.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [PuntoVentaModel] que representan los puntos de venta disponibles.
  List<PuntoVentaModel> listaPuntosVenta = [];

  /// Fuente de datos del [SfDataGrid] que muestra la tabla de pedidos entregados del lider.
  ///
  /// Es de tipo [EntregadoLiderDataGridSource] y se inicializa en el método [initState].
  late EntregadoLiderDataGridSource _dataGridSource;

  @override

  /// Se llama cuando se crea el estado para la primera vez y solo una vez.
  ///
  /// Se utiliza para inicializar los atributos del estado.
  @override
  void initState() {
    super.initState();

    // Inicializa _dataGridSource con los datos de los pedidos, productos y puntos de venta
    _dataGridSource = EntregadoLiderDataGridSource(
        pedidos: _pedidos,
        listaProductos: listaProductos,
        listaPuntosVenta: listaPuntosVenta);

    // Asigna los pedidos del parámetro widget a _pedidos
    _pedidos = widget.auxPedido;

    // Llama a la función _loadData para cargar los datos de los productos y los puntos de venta
    _loadData();
  }

  /// Carga los datos de los productos y los puntos de venta.
  ///
  /// Esto se hace llamando a las funciones [getProductos] y [getPuntosVenta]
  /// y asignando los resultados a las variables [listaProductos] y
  /// [listaPuntosVenta], respectivamente. Luego, se actualiza [_dataGridSource]
  /// en el siguiente frame de la interfaz de usuario.
  Future<void> _loadData() async {
    // Carga los productos
    List<ProductoModel> productosCargados = await getProductos();

    // Carga los puntos de venta
    List<PuntoVentaModel> puntosCargados = await getPuntosVenta();

    // Asigna los productos y los puntos de venta a las variables correspondientes
    listaProductos = productosCargados;
    listaPuntosVenta = puntosCargados;

    if (mounted) {
      // Ahora inicializa _dataGridSource después de cargar los datos
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializa _dataGridSource con los datos de los pedidos, productos y puntos de venta
          _dataGridSource = EntregadoLiderDataGridSource(
              pedidos: _pedidos,
              listaProductos: listaProductos,
              listaPuntosVenta: listaPuntosVenta);
        });
      });
    }
  }

  /// Libera los recursos utilizados por el widget.
  ///
  /// Esto se llama automáticamente cuando se elimina el widget de la interfaz de usuario.
  /// Es necesario llamar a [super.dispose] para liberar los recursos utilizados por el widget base.
  @override
  void dispose() {
    // Cancela cualquier operación si es necesario
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
          // Título del reporte
          Text(
            "Pedidos Entregados",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Tabla de pedidos entregados
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
                // Columnas
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
                    columnName: 'Producto',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Producto'),
                    ),
                  ),
                  GridColumn(
                    width: 140,
                    columnName: 'Cantidad',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Cantidad'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Precio',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Precio'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Fecha Encargo',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Encargo'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Fecha Entrega',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Entrega'),
                    ),
                  ),
                  GridColumn(
                    width: 140,
                    columnName: 'Grupal',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Grupal'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Punto Venta',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Punto Venta'),
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

  /// Crea un botón con los estilos de diseño especificados.
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
  ///
  /// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      // Ancho del botón
      width: 200,

      // Decoración del contenedor con un gradiente de color y sombra
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

      // Contenido del contenedor, un widget [Material] con un estilo específico
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
}

/// Clase que define la fuente de datos de la tabla de pedidos
class EntregadoLiderDataGridSource extends DataGridSource {
  /// Devuelve el nombre del producto correspondiente al [productoAxiliar] en la lista de [productos].
  ///
  /// Si no se encuentra el producto con el [productoAxiliar] dado, se devuelve una cadena vacía.
  ///
  /// [productoAxiliar] es el identificador del producto auxiliar.
  /// [productos] es la lista de productos en la aplicación.
  /// Retorna el nombre del producto correspondiente al [productoAxiliar] en la lista de [productos].
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    // Inicializa la variable [productName] con una cadena vacía
    String productName = "";

    // Itera sobre cada producto en la lista [productos]
    for (var producto in productos) {
      // Si el id del producto actual es igual al [productoAxiliar] dado
      if (producto.id == productoAxiliar) {
        // Asigna el nombre del producto al [productName]
        productName = producto.nombre;
        // Termina el bucle
        break;
      }
    }

    // Retorna el nombre del producto
    return productName;
  }

  /// Devuelve el nombre del punto de venta correspondiente al [punto] en la lista de [puntosVenta].
  ///
  /// Si no se encuentra el punto de venta con el [punto] dado, se devuelve una cadena vacía.
  ///
  /// [punto] es el identificador del punto de venta.
  /// [puntosVenta] es la lista de puntos de venta en la aplicación.
  /// Retorna el nombre del punto de venta correspondiente al [punto] en la lista de [puntosVenta].
  String puntoNombre(int punto, List<PuntoVentaModel> puntosVenta) {
    // Inicializa la variable [puntoName] con una cadena vacía
    String puntoName = "";

    // Itera sobre cada punto de venta en la lista [puntosVenta]
    for (var puntoVenta in puntosVenta) {
      // Si el id del punto de venta actual es igual al [punto] dado
      if (puntoVenta.id == punto) {
        // Asigna el nombre del punto de venta al [puntoName]
        puntoName = puntoVenta.nombre;
        // Termina el bucle
        break;
      }
    }

    // Retorna el nombre del punto de venta
    return puntoName;
  }

  // Definición de la fuente de datos
  EntregadoLiderDataGridSource({
    required List<AuxPedidoModel> pedidos,
    required List<ProductoModel> listaProductos,
    required List<PuntoVentaModel> listaPuntosVenta,
  }) {
    _pedidoData = pedidos.map<DataGridRow>((pedido) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Número', value: pedido.pedido.numeroPedido.toString()),
        DataGridCell<String>(
            columnName: 'Usuario',
            value:
                "${pedido.pedido.usuario.nombres} ${pedido.pedido.usuario.apellidos}"),
        DataGridCell<String>(
            columnName: 'Producto',
            value: productoNombre(pedido.producto, productos)),
        DataGridCell<String>(
            columnName: 'Cantidad', value: pedido.cantidad.toString()),
        DataGridCell<int>(columnName: 'Precio', value: pedido.precio),
        DataGridCell<String>(
            columnName: 'Fecha Encargo', value: pedido.pedido.fechaEncargo),
        DataGridCell<String>(
            columnName: 'Fecha Entrega', value: pedido.pedido.fechaEntrega),
        DataGridCell<String>(
            columnName: 'Grupal', value: pedido.pedido.grupal ? "Si" : "No"),
        DataGridCell<String>(
            columnName: 'Punto Venta',
            value: puntoNombre(pedido.pedido.puntoVenta, listaPuntosVenta)),
      ]);
    }).toList();
  }

  // Lista de pedidos
  List<DataGridRow> _pedidoData = [];

  // Asignación de la fuente de datos
  @override
  List<DataGridRow> get rows => _pedidoData;

  // Retorna el valor de la celda
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
                "assets/icons/check.svg",
                height: 30,
                width: 30,
                colorFilter:
                    const ColorFilter.mode(Colors.green, BlendMode.srcIn),
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
              : Text(i == 4
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formato de moneda
                  : i == 5 || i == 6
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Formato de fecha
                      : row.getCells()[i].value.toString()), // Celda normal
        ),
    ]);
  }
}
