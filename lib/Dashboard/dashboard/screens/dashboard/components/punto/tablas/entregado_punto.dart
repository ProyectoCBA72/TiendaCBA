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
import 'package:tienda_app/pdf/Punto/pdfEntregadoPunto.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';

/// Esta clase representa un widget de estado que muestra una tabla de pedidos entregados de un punto de venta.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_EntregadoPuntoState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan los pedidos entregados del punto de venta.
class EntregadoPunto extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos entregados del punto de venta.
  final List<AuxPedidoModel> auxPedido;

  final UsuarioModel usuario;

  /// Crea un nuevo widget [EntregadoPunto].
  ///
  /// El parámetro [auxPedido] es obligatorio y debe contener una lista de objetos
  /// [AuxPedidoModel] que representan los pedidos entregados del punto de venta.
  const EntregadoPunto(
      {super.key, required this.auxPedido, required this.usuario});

  /// Crea y devuelve un estado [_EntregadoPuntoState] para manejar los datos de la pantalla.
  ///
  /// Este método es obligatorio y se utiliza para crear un estado
  /// que herede de [State<EntregadoPunto>].
  @override
  State<EntregadoPunto> createState() => _EntregadoPuntoState();
}

class _EntregadoPuntoState extends State<EntregadoPunto> {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos entregados del punto de venta.
  List<AuxPedidoModel> _pedidos = [];

  /// Lista de objetos [ProductoModel] que representan los productos disponibles.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [PuntoVentaModel] que representan los puntos de venta disponibles.
  List<PuntoVentaModel> listaPuntosVenta = [];

  /// Fuente de datos para la tabla de pedidos entregados.
  ///
  /// Este atributo es de tipo [EntregadoPuntoDataGridSource] y se utiliza para
  /// cargar y mostrar los datos de la tabla.
  late EntregadoPuntoDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Inicializa el estado del widget [EntregadoPunto].
  ///
  /// En este método, se llama al método [super.initState] para inicializar el estado
  /// de la clase padre. Luego, se inicializa [_dataGridSource] con los datos
  /// de los pedidos, productos y puntos de venta. Finalmente, se llama al método
  /// [_loadData] para cargar los datos de la tabla.
  @override
  void initState() {
    super.initState();
    // Inicializa [_dataGridSource] con los datos de los pedidos, productos y puntos de venta
    _dataGridSource = EntregadoPuntoDataGridSource(
        pedidos: _pedidos,
        listaProductos: listaProductos,
        listaPuntosVenta: listaPuntosVenta);

    // Obtiene la lista de pedidos entregados del widget [EntregadoPunto]
    _pedidos = widget.auxPedido;

    // Carga los datos de los pedidos, productos y puntos de venta
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
          _dataGridSource = EntregadoPuntoDataGridSource(
              pedidos: _pedidos,
              listaProductos: listaProductos,
              listaPuntosVenta: listaPuntosVenta);
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
          // Cuerpo del reporte
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
                            builder: (context) => PdfEntregadoPuntoScreen(
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

  /// Construye un botón con los estilos de diseño especificados.
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
  ///
  /// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200, // Ancho fijo del botón.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Border redondeado.
        gradient: const LinearGradient(
          colors: [
            botonClaro, // Color claro del gradiente.
            botonOscuro, // Color oscuro del gradiente.
          ],
        ),
        boxShadow: const [
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
            padding:
                const EdgeInsets.symmetric(vertical: 10), // Padding vertical.
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

/// Clase que define la fuente de datos de la tabla
class EntregadoPuntoDataGridSource extends DataGridSource {
  /// Obtiene el nombre del producto correspondiente al ID especificado.
  ///
  /// Argumentos:
  ///   productoAxiliar: El ID del producto a buscar.
  ///   productos: La lista de productos para buscar el nombre.
  ///
  /// Retorna el nombre del producto correspondiente, o una cadena vacía si no se encuentra.
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    String productName = "";

    for (var producto in productos) {
      if (producto.id == productoAxiliar) {
        productName = producto.nombre;
        break;
      }
    }

    return productName;
  }

  /// Obtiene el nombre del punto de venta correspondiente al ID especificado.
  ///
  /// Argumentos:
  ///   punto: El ID del punto de venta a buscar.
  ///   puntosVenta: La lista de puntos de venta para buscar el nombre.
  ///
  /// Retorna el nombre del punto de venta correspondiente, o una cadena vacía si no se encuentra.
  String puntoNombre(int punto, List<PuntoVentaModel> puntosVenta) {
    // Inicializa el nombre del punto de venta como una cadena vacía
    String puntoName = "";

    // Recorre los puntos de venta en la lista
    for (var puntoVenta in puntosVenta) {
      // Si el ID del punto de venta coincide con el ID especificado
      if (puntoVenta.id == punto) {
        // Asigna el nombre del punto de venta y termina el bucle
        puntoName = puntoVenta.nombre;
        break;
      }
    }

    // Retorna el nombre del punto de venta encontrado
    return puntoName;
  }

  // Crea una fuente de datos de la tabla
  EntregadoPuntoDataGridSource({
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

  // Lista de datos de la tabla
  List<DataGridRow> _pedidoData = [];

  // Obtiene la lista de datos de la tabla
  @override
  List<DataGridRow> get rows => _pedidoData;

  // Retorna el valor de las celdas
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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formatea el valor
                  : i == 5 || i == 6
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Formatea la fecha
                      : row.getCells()[i].value.toString()), // Muestra el valor
        ),
    ]);
  }
}
