// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Esta clase representa un widget de estado que muestra una tabla de pedidos cancelados de un punto de venta.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_CanceladoPuntoState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan los pedidos cancelados del punto de venta.
class CanceladoPunto extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos cancelados del punto de venta.
  ///
  /// Esta lista se utiliza para almacenar todos los pedidos cancelados
  /// que se han generado en la aplicación.
  /// Los elementos de esta lista son de tipo [AuxPedidoModel].
  final List<AuxPedidoModel> auxPedido;

  /// Constructor que recibe la lista de pedidos cancelados del punto de venta.
  ///
  /// El parámetro [auxPedido] es una lista de objetos [AuxPedidoModel]
  /// que representan los pedidos cancelados del punto de venta.
  const CanceladoPunto({super.key, required this.auxPedido});

  @override

  /// Crea y devuelve un estado [_CanceladoPuntoState] para manejar los datos de la pantalla.
  ///
  /// Este método es obligatorio y se utiliza para crear un estado
  /// que herede de [State<CanceladoPunto>].
  State<CanceladoPunto> createState() => _CanceladoPuntoState();
}

class _CanceladoPuntoState extends State<CanceladoPunto> {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos cancelados del punto de venta.
  ///
  /// Esta lista se utiliza para almacenar todos los pedidos cancelados
  /// que se han generado en la aplicación.
  List<AuxPedidoModel> _pedidos = [];

  /// Lista de objetos [ProductoModel] que representan los productos disponibles.
  ///
  /// Esta lista se utiliza para almacenar todos los productos
  /// que se han registrado en la aplicación.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [PuntoVentaModel] que representan los puntos de venta disponibles.
  ///
  /// Esta lista se utiliza para almacenar todos los puntos de venta
  /// que se han registrado en la aplicación.
  List<PuntoVentaModel> listaPuntosVenta = [];

  /// Origen de datos para la tabla de pedidos cancelados.
  ///
  /// Este objeto se utiliza para proporcionar los datos a la tabla
  /// de pedidos cancelados.
  late CanceladoPuntoDataGridSource _dataGridSource;

  @override

  /// Inicializa el estado.
  ///
  /// Se llama automáticamente cuando se crea el widget. En este método, se
  /// inicializan las variables y se llama a los métodos necesarios para cargar
  /// los datos.
  ///
  /// Se llama a [super.initState()] para asegurarse de que se ejecutan
  /// todos los inicializadores heredados. Luego, se crea el objeto
  /// [_dataGridSource] con los datos iniciales, y se actualiza [_pedidos]
  /// con los datos del widget. Finalmente, se llama a [_loadData] para cargar
  /// los datos de los puntos de venta y productos.
  @override
  void initState() {
    super.initState();
    _dataGridSource = CanceladoPuntoDataGridSource(
        pedidos: _pedidos,
        listaProductos: listaProductos,
        listaPuntosVenta: listaPuntosVenta);
    _pedidos = widget.auxPedido;
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
      // Actualiza _dataGridSource en el siguiente frame de la interfaz de usuario
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializa _dataGridSource con los datos de los pedidos, productos y puntos de venta
          _dataGridSource = CanceladoPuntoDataGridSource(
              pedidos: _pedidos,
              listaProductos: listaProductos,
              listaPuntosVenta: listaPuntosVenta);
        });
      });
    }
  }

  /// Se llama automáticamente cuando se elimina el widget.
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
          //Titulo de la tabla
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
                source: _dataGridSource, // Asigna el objeto _dataGridSource
                selectionMode: SelectionMode.multiple,
                showCheckboxColumn: true,
                allowSorting: true,
                allowFiltering: true,
                // Crea una grilla de columnas
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

  /// Construye un botón con el texto y el método pasados como parámetros.
  ///
  /// El botón tiene un estilo y sombra personalizada. El texto del botón está
  /// centrado verticalmente y tiene un estilo específico. Cuando se presiona el
  /// botón, se llama al método [onPressed].
  ///
  /// Parámetros:
  /// - [text] (String): texto que se mostrará en el botón.
  /// - [onPressed] (VoidCallback): método que se ejecutará cuando se presione el botón.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200, // Ancho del contenedor del botón.
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(10), // Borde redondeado del contenedor.
        gradient: const LinearGradient(
          // Gradiente de color del fondo.
          colors: [
            botonClaro, // Color inicial del gradiente.
            botonOscuro, // Color final del gradiente.
          ],
        ),
        boxShadow: const [
          // Sombra del botón.
          BoxShadow(
            color: botonSombra, // Color de la sombra.
            blurRadius: 5, // Radio de la sombra.
            offset: Offset(0, 3), // Desplazamiento de la sombra.
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Color transparente del material.
        child: InkWell(
          onTap: onPressed, // Función que se ejecuta al presionar el botón.
          borderRadius:
              BorderRadius.circular(10), // Borde redondeado del botón.
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical:
                    10), // Espacio vertical entre el texto y los bordes del botón.
            child: Center(
              child: Text(
                text, // Texto que se mostrará en el botón.
                style: const TextStyle(
                  color: background1, // Color del texto.
                  fontSize: 13, // Tamaño de la fuente.
                  fontWeight: FontWeight.bold, // Peso de la fuente.
                  fontFamily: 'Calibri-Bold', // Fuente del texto.
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Carga los datos de los pedidos, productos y puntos de venta.
class CanceladoPuntoDataGridSource extends DataGridSource {
  /// Obtiene el nombre del producto a partir de su ID.
  ///
  /// Esta función recorre la lista de [productos] y busca el producto con el ID
  /// [productoAxiliar]. Si lo encuentra, devuelve el nombre del producto.
  ///
  /// Parámetros:
  /// - productoAxiliar: el ID del producto a buscar.
  /// - productos: la lista de productos en la que se va a buscar el nombre.
  ///
  /// Retorna:
  /// - El nombre del producto encontrado, o una cadena vacía si no se encuentra.
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    // Variable para almacenar el nombre del producto.
    String productName = "";

    // Recorremos la lista de productos.
    for (var producto in productos) {
      // Si encontramos el producto con el ID proporcionado, obtenemos su nombre.
      if (producto.id == productoAxiliar) {
        productName = producto.nombre;
        break; // Salimos del bucle.
      }
    }

    // Retornamos el nombre del producto encontrado.
    return productName;
  }

  /// Obtiene el nombre del punto de venta a partir de su ID.
  ///
  /// Esta función recorre la lista de [puntosVenta] y busca el punto de venta con el ID
  /// [punto]. Si lo encuentra, devuelve el nombre del punto de venta.
  ///
  /// Parámetros:
  /// - punto: el ID del punto de venta a buscar.
  /// - puntosVenta: la lista de puntos de venta en la que se va a buscar el nombre.
  ///
  /// Retorna:
  /// - El nombre del punto de venta encontrado, o una cadena vacía si no se encuentra.
  String puntoNombre(int punto, List<PuntoVentaModel> puntosVenta) {
    // Variable para almacenar el nombre del punto de venta.
    String puntoName = "";

    // Recorremos la lista de puntos de venta.
    for (var puntoVenta in puntosVenta) {
      // Si encontramos el punto de venta con el ID proporcionado, obtenemos su nombre.
      if (puntoVenta.id == punto) {
        puntoName = puntoVenta.nombre;
        break; // Salimos del bucle.
      }
    }

    // Retornamos el nombre del punto de venta encontrado.
    return puntoName;
  }

  /// Carga los datos de los pedidos, productos y puntos de venta.
  CanceladoPuntoDataGridSource({
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

  // Lista de datos de los pedidos.
  List<DataGridRow> _pedidoData = [];

  // Carga los datos de los pedidos.
  @override
  List<DataGridRow> get rows => _pedidoData;

  // Retorna el valor de la celda.
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
                  ? "\$${row.getCells()[i].value}" // Convierte el valor a moneda
                  : row.getCells()[i].value.toString()), // Muestra el valor
        ),
    ]);
  }
}
