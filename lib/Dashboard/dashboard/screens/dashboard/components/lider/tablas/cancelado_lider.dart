// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/Lider/pdfCanceladoLider.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';

/// Esta clase representa un widget de estado que muestra una tabla de pedidos cancelados de un lider.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_CanceladoLiderState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan los pedidos cancelados del lider.
class CanceladoLider extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos cancelados del lider.
  final List<AuxPedidoModel> auxPedido;

  final UsuarioModel usuario;

  /// Constructor del widget.
  ///
  /// Los parámetros obligatorios son:
  /// - [key] clave única del widget.
  /// - [auxPedido] lista de objetos [AuxPedidoModel] que representan los pedidos cancelados del lider.
  const CanceladoLider(
      {super.key, required this.auxPedido, required this.usuario});

  /// Crea un estado [_CanceladoLiderState] para manejar los datos de la pantalla.
  @override
  State<CanceladoLider> createState() => _CanceladoLiderState();
}

class _CanceladoLiderState extends State<CanceladoLider> {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos cancelados del lider.
  List<AuxPedidoModel> _pedidos = [];

  /// Lista de objetos [ProductoModel] que representan los productos de los pedidos cancelados del lider.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [PuntoVentaModel] que representan los puntos de venta de los pedidos cancelados del lider.
  List<PuntoVentaModel> listaPuntosVenta = [];

  /// Origen de datos de la tabla de pedidos cancelados del lider.
  ///
  /// Se inicializa en el método [initState] con los parámetros [_pedidos],
  /// [listaProductos] y [listaPuntosVenta].
  late CanceladoLiderDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Método llamado cuando el widget está listo para ser mostrado en la pantalla.
  ///
  /// Se inicializa [_dataGridSource] con los parámetros [_pedidos],
  /// [listaProductos] y [listaPuntosVenta]. Luego, se actualizan los parámetros
  /// [_pedidos] con los del widget y se llama al método [_loadData] para cargar los
  /// datos iniciales necesarios para la pantalla.
  @override
  void initState() {
    super.initState();

    // Inicializa el origen de datos de la tabla con los parámetros iniciales
    _dataGridSource = CanceladoLiderDataGridSource(
        pedidos: _pedidos,
        listaProductos: listaProductos,
        listaPuntosVenta: listaPuntosVenta);

    // Actualiza los pedidos con los del widget
    _pedidos = widget.auxPedido;

    // Carga los datos iniciales necesarios para la pantalla
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
          _dataGridSource = CanceladoLiderDataGridSource(
              pedidos: _pedidos,
              listaProductos: listaProductos,
              listaPuntosVenta: listaPuntosVenta);
        });
      });
    }
  }

  /// Se llama automáticamente cuando se elimina el widget.
  ///
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por la
  /// operación.
  @override
  void dispose() {
    // Cancela cualquier operación en curso si es necesario.
    // Este método se debe llamar automáticamente cuando se elimina el widget.
    // Se debe llamar a [dispose] para liberar los recursos utilizados por la
    // operación.
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
            "Pedidos Cancelados",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Cuerpo de la tabla
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
                source: _dataGridSource, // Origen de datos
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
          // Botón de impresión
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
                            builder: (context) => PdfCanceladoLiderScreen(
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

  /// Crea un botón con los estilos de diseño especificados.
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
  ///
  /// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200, // Ancho del botón
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Borde redondeado
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
      ), // Decoración del contenedor con un gradiente de color y sombra
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

class CanceladoLiderDataGridSource extends DataGridSource {
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
    // Inicializa una cadena vacía para almacenar el nombre del producto.
    String productName = "";

    // Recorre la lista de productos buscando el producto correspondiente.
    for (var producto in productos) {
      // Verifica si el identificador auxiliar del producto coincide con el buscado.
      if (producto.id == productoAxiliar) {
        // Obtiene el nombre del producto.
        productName = producto.nombre;
        // Detiene el bucle for y devuelve el nombre del producto.
        break;
      }
    }

    // Devuelve el nombre del producto encontrado o una cadena vacía.
    return productName;
  }

  /// Obtiene el nombre de un punto de venta dado su identificador.
  ///
  /// El método recibe el identificador del punto de venta y una lista de
  /// puntos de venta. Recorre la lista de puntos de venta buscando el punto
  /// de venta que corresponda al identificador especificado. Si encuentra un
  /// punto de venta que coincida con el identificador, obtiene su nombre y
  /// lo devuelve como una cadena. Si no encuentra ningún punto de venta que
  /// coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - punto: El identificador del punto de venta a buscar.
  /// - puntosVenta: La lista de puntos de venta en la que buscar el punto.
  ///
  /// Retorna:
  /// - Una cadena con el nombre del punto de venta encontrado, si se encuentra un
  ///   punto de venta que coincida con el identificador.
  /// - Una cadena vacía si no se encuentra ningún punto de venta que coincida con
  ///   el identificador.
  String puntoNombre(int punto, List<PuntoVentaModel> puntosVenta) {
    // Inicializa una cadena vacía para almacenar el nombre del punto de venta.
    String puntoName = "";

    // Recorre la lista de puntos de venta buscando el punto correspondiente.
    for (var puntoVenta in puntosVenta) {
      // Verifica si el identificador del punto de venta coincide con el buscado.
      if (puntoVenta.id == punto) {
        // Obtiene el nombre del punto de venta.
        puntoName = puntoVenta.nombre;
        // Detiene el bucle for y devuelve el nombre del punto de venta.
        break;
      }
    }

    // Devuelve el nombre del punto de venta encontrado o una cadena vacía.
    return puntoName;
  }

  /// Crea una instancia de la clase CanceladoLiderDataGridSource.
  CanceladoLiderDataGridSource({
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

  /// La lista de pedidos.
  List<DataGridRow> _pedidoData = [];

  // Obtener la lista de pedidos.
  @override
  List<DataGridRow> get rows => _pedidoData;

  // Retorna un widget que muestra los valores de las celdas
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
                "assets/icons/cancel.svg",
                height: 30,
                width: 30,
                colorFilter:
                    const ColorFilter.mode(Colors.red, BlendMode.srcIn),
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
                      : row.getCells()[i].value.toString()), // Valores normales
        ),
    ]);
  }
}
