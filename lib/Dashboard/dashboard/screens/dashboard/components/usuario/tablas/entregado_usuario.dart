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
import 'package:tienda_app/pdf/Usuario/pdfEntregadoUsuario.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';

/// Esta clase representa un widget de estado que muestra una tabla de pedidos entregados de un usuario.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_EntregadoUsuarioState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan los pedidos entregados del usuario.
class EntregadoUsuario extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representa los pedidos entregados del usuario.
  final List<AuxPedidoModel> auxPedido;

  final UsuarioModel usuario;

  /// Construye un widget [EntregadoUsuario] con la lista de pedidos entregados del usuario.
  ///
  /// Los parámetros obligatorios son:
  ///
  /// - [auxPedido]: Lista de objetos [AuxPedidoModel] que representan los pedidos entregados del usuario.
  const EntregadoUsuario(
      {super.key, required this.auxPedido, required this.usuario});

  /// Crea un estado [_EntregadoUsuarioState] para manejar los datos de la pantalla.
  @override
  State<EntregadoUsuario> createState() => _EntregadoUsuarioState();
}

class _EntregadoUsuarioState extends State<EntregadoUsuario> {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos entregados del usuario.
  List<AuxPedidoModel> _pedidos = [];

  /// Lista de objetos [ProductoModel] que representa los productos disponibles en el sistema.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [PuntoVentaModel] que representa los puntos de venta disponibles en el sistema.
  List<PuntoVentaModel> listaPuntosVenta = [];

  /// Fuente de datos para la tabla de pedidos entregados del usuario.
  ///
  /// Se inicializa en el método [initState] y se utiliza para mostrar los datos de la tabla.
  late EntregadoUsuarioDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Método llamado cuando se inicializa el estado de la pantalla.
  ///
  /// Aquí se inicializa [_dataGridSource] con los datos proporcionados en el constructor
  /// y se cargan los datos necesarios para mostrar la tabla.
  @override
  void initState() {
    super.initState();

    // Inicializa _dataGridSource con los datos proporcionados en el constructor
    _dataGridSource = EntregadoUsuarioDataGridSource(
        pedidos: _pedidos,
        listaProductos: listaProductos,
        listaPuntosVenta: listaPuntosVenta);

    // Actualiza _pedidos con los datos proporcionados en el constructor
    _pedidos = widget.auxPedido;

    // Carga los datos necesarios para mostrar la tabla
    _loadData();
  }

  /// Carga los datos necesarios para mostrar la tabla de pedidos entregados del usuario.
  ///
  /// Esto incluye obtener los productos y los puntos de venta de la API y asignarlos
  /// a las variables [listaProductos] y [listaPuntosVenta], respectivamente.
  /// Luego, se actualiza [_dataGridSource] en el siguiente frame de la interfaz de usuario.
  Future<void> _loadData() async {
    // Obtiene los productos de la API
    List<ProductoModel> productosCargados = await getProductos();

    // Obtiene los puntos de venta de la API
    List<PuntoVentaModel> puntosCargados = await getPuntosVenta();

    // Asigna los productos y los puntos de venta a las variables correspondientes
    listaProductos = productosCargados;
    listaPuntosVenta = puntosCargados;

    if (mounted) {
      // Ahora inicializa _dataGridSource después de cargar los datos
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializa _dataGridSource con los datos de los pedidos, productos y puntos de venta
          _dataGridSource = EntregadoUsuarioDataGridSource(
              pedidos: _pedidos,
              listaProductos: listaProductos,
              listaPuntosVenta: listaPuntosVenta);
        });
      });
    }
  }

  /// Libera los recursos utilizados por el widget.
  ///
  /// Se llama automáticamente cuando el widget se elimina del árbol de widgets.
  /// Libera los recursos utilizados por el widget.
  ///
  /// Llama al método [dispose] del widget base para liberar recursos adicionales.
  @override
  void dispose() {
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
            "Pedidos Entregados",
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
                // Establece las columnas de la tabla
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
                            builder: (context) => PdfEntregadoUsuarioScreen(
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

  /// Construye un botón con el texto proporcionado y la función de presionado.
  ///
  /// El botón tiene un borde redondeado, un gradiente de colores y sombra.
  /// El texto del botón está centrado y tiene un estilo específico.
  ///
  /// [text]: Texto del botón.
  /// [onPressed]: Función de presionado del botón.
  /// Retorna un [Widget] que representa el botón.
  Widget _buildButton(String text, VoidCallback onPressed) {
    // Construye el botón con el texto y la función de presionado proporcionados.
    return Container(
      width: 200, // Ancho del botón
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Radio del borde redondeado
        gradient: const LinearGradient(
          colors: [
            botonClaro, // Color de fondo claro del botón
            botonOscuro, // Color de fondo oscuro del botón
          ],
        ), // Gradiente de colores del botón
        boxShadow: const [
          BoxShadow(
            color: botonSombra, // Color de la sombra del botón
            blurRadius: 5, // Radio de la sombra del botón
            offset: Offset(0, 3), // Desplazamiento de la sombra del botón
          ),
        ], // Sombra del botón
      ),
      child: Material(
        color: Colors.transparent, // Color transparente del Material
        child: InkWell(
          onTap: onPressed, // Función de presionado del botón
          borderRadius: BorderRadius.circular(10), // Radio del borde redondeado
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10), // Padding vertical del child del InkWell
            child: Center(
              child: Text(
                text, // Texto del botón
                style: const TextStyle(
                  color: background1, // Color del texto del botón
                  fontSize: 13, // Tamaño del texto del botón
                  fontWeight: FontWeight.bold, // Peso del texto del botón
                  fontFamily: 'Calibri-Bold', // Fuente del texto del botón
                ), // Estilo del texto del botón
              ), // Texto del botón
            ), // Centrado del texto del botón
          ), // Padding del InkWell
        ), // Material
      ), // Material
    ); // Container
  }
}

class EntregadoUsuarioDataGridSource extends DataGridSource {
  /// Obtiene el nombre del producto a partir de su id.
  ///
  /// El método recorre la lista de productos y busca el producto con el id
  /// proporcionado. Si encuentra el producto, devuelve el nombre del producto,
  /// de lo contrario, devuelve una cadena vacía.
  ///
  /// @param productoAxiliar el id del producto a buscar
  /// @param productos la lista de productos disponibles
  /// @return el nombre del producto o una cadena vacía si no se encuentra el producto
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    // Inicializar el nombre del producto como una cadena vacía
    String productName = "";

    // Recorrer cada producto en la lista de productos
    for (var producto in productos) {
      // Verificar si el id del producto coincide con el id proporcionado
      if (producto.id == productoAxiliar) {
        // Si hay coincidencia, asignar el nombre del producto y salir del bucle
        productName = producto.nombre;
        break;
      }
    }

    // Devolver el nombre del producto
    return productName;
  }

  /// Obtiene el nombre del punto de venta a partir de su id.
  ///
  /// El método recorre la lista de puntos de venta y busca el punto de venta con el id
  /// proporcionado. Si encuentra el punto de venta, devuelve el nombre del punto de venta,
  /// de lo contrario, devuelve una cadena vacía.
  ///
  /// @param punto el id del punto de venta a buscar
  /// @param puntosVenta la lista de puntos de venta disponibles
  /// @return el nombre del punto de venta o una cadena vacía si no se encuentra el punto de venta
  String puntoNombre(int punto, List<PuntoVentaModel> puntosVenta) {
    // Inicializar el nombre del punto de venta como una cadena vacía
    String puntoName = "";

    // Recorrer cada punto de venta en la lista de puntos de venta
    for (var puntoVenta in puntosVenta) {
      // Verificar si el id del punto de venta coincide con el id proporcionado
      if (puntoVenta.id == punto) {
        // Si hay coincidencia, asignar el nombre del punto de venta y salir del bucle
        puntoName = puntoVenta.nombre;
        break;
      }
    }

    // Devolver el nombre del punto de venta
    return puntoName;
  }

  // Lista de pedidos
  EntregadoUsuarioDataGridSource({
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

  // Celdas
  @override
  List<DataGridRow> get rows => _pedidoData;

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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formatear el precio
                  : i == 5 || i == 6
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Formatear la fecha
                      : row
                          .getCells()[i]
                          .value
                          .toString()), // Formatear los demás valores
        ),
    ]);
  }
}
