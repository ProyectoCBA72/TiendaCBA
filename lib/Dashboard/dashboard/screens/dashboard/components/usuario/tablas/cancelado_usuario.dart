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
import 'package:tienda_app/pdf/Usuario/pdfCanceladoUsuario.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';

/// Esta clase representa un widget de estado que muestra una tabla de pedidos cancelados de un usuario.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_CanceladoUsuarioState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan los pedidos cancelados del usuario.
class CanceladoUsuario extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] representando los pedidos cancelados del usuario.
  final List<AuxPedidoModel> auxPedido;

  final UsuarioModel usuario;

  /// Construye un nuevo objeto [CanceladoUsuario].
  ///
  /// Los parámetros obligatorios son:
  ///
  /// - [key] es la clave de la widget.
  /// - [auxPedido] es la lista de pedidos cancelados del usuario.
  const CanceladoUsuario(
      {super.key, required this.auxPedido, required this.usuario});

  /// Crea un nuevo estado [_CanceladoUsuarioState] para manejar los datos de la pantalla.
  @override
  State<CanceladoUsuario> createState() => _CanceladoUsuarioState();
}

class _CanceladoUsuarioState extends State<CanceladoUsuario> {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos cancelados del usuario.
  List<AuxPedidoModel> _pedidos = [];

  /// Lista de objetos [ProductoModel] que contienen la información de los productos.
  ///
  /// Esta lista se utiliza para obtener el nombre de los productos en la tabla.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [PuntoVentaModel] que contienen la información de los puntos de venta.
  ///
  /// Esta lista se utiliza para obtener el nombre de los puntos de venta en la tabla.
  List<PuntoVentaModel> listaPuntosVenta = [];

  /// Objeto [CanceladoUsuarioDataGridSource] que se utiliza para definir las columnas y las filas de la tabla.
  ///
  /// El objeto se inicializa en el método [initState].
  late CanceladoUsuarioDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Se llama automáticamente cuando se inicializa el estado de la pantalla.
  ///
  /// En este método, se inicializa [_dataGridSource] y se carga los datos de los pedidos y los puntos de venta.
  @override
  void initState() {
    super.initState();

    // Inicializa _dataGridSource con los datos de los pedidos y los puntos de venta
    _dataGridSource = CanceladoUsuarioDataGridSource(
        pedidos: _pedidos,
        listaProductos: listaProductos,
        listaPuntosVenta: listaPuntosVenta);

    // Asigna los pedidos recibidos como parámetro a la variable _pedidos
    _pedidos = widget.auxPedido;

    // Llama a _loadData para cargar los datos de los productos y los puntos de venta
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

    // Asigna los productos cargados a la variable listaProductos
    listaProductos = productosCargados;

    // Carga los puntos de venta
    List<PuntoVentaModel> puntosCargados = await getPuntosVenta();

    // Asigna los puntos de venta cargados a la variable listaPuntosVenta
    listaPuntosVenta = puntosCargados;

    if (mounted) {
      // Actualiza _dataGridSource en el siguiente frame de la interfaz de usuario
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializa _dataGridSource con los datos de los pedidos, productos y puntos de venta
          _dataGridSource = CanceladoUsuarioDataGridSource(
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
          // Título de la tabla
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
                // Define las columnas de la tabla
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
                            builder: (context) => PdfCanceladoUsuarioScreen(
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

// Modelos de datos para las producciones por año
class CanceladoUsuarioDataGridSource extends DataGridSource {
  /// Retorna el nombre del producto según su identificador.
  ///
  /// Argumentos:
  ///   - productoAxiliar: Identificador del producto.
  ///   - productos: Lista de objetos de tipo [ProductoModel].
  ///
  /// Retorna el nombre del producto, o una cadena vacía si no se encuentra el producto.
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

  /// Retorna el nombre del punto de venta según su identificador.
  ///
  /// Argumentos:
  ///   - punto: Identificador del punto de venta.
  ///   - puntosVenta: Lista de objetos de tipo [PuntoVentaModel].
  ///
  /// Retorna el nombre del punto de venta, o una cadena vacía si no se encuentra el punto de venta.
  String puntoNombre(int punto, List<PuntoVentaModel> puntosVenta) {
    // Variable para almacenar el nombre del punto de venta
    String puntoName = "";

    // Recorre la lista de puntos de venta
    for (var puntoVenta in puntosVenta) {
      // Si el identificador del punto de venta coincide con el argumento
      if (puntoVenta.id == punto) {
        // Asigna el nombre del punto de venta a la variable
        puntoName = puntoVenta.nombre;
        // Salta del bucle
        break;
      }
    }

    // Retorna el nombre del punto de venta
    return puntoName;
  }

  // Lista de datos de pedido
  CanceladoUsuarioDataGridSource({
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

  // Lista de datos
  List<DataGridRow> _pedidoData = [];

  // Retorna la lista de datos
  @override
  List<DataGridRow> get rows => _pedidoData;

  // Retorna el valor de una celda
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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formatea el valor a moneda
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
