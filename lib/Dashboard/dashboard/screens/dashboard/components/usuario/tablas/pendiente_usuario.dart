// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

/// Esta clase representa un widget de estado que muestra una tabla de pedidos pendientes de un usuario.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_PendienteUsuarioState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan los pedidos pendientes del usuario.
class PendienteUsuario extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos pendientes del usuario.
  final List<AuxPedidoModel> auxPedido;

  /// Constructor para crear un widget de estado [PendienteUsuario].
  ///
  /// El parámetro [auxPedido] es requerido y representa los pedidos pendientes del usuario.
  const PendienteUsuario({super.key, required this.auxPedido});

  /// Sobrecarga del método [createState] para crear un estado [_PendienteUsuarioState].
  ///
  /// Devuelve una nueva instancia de [_PendienteUsuarioState].
  @override
  State<PendienteUsuario> createState() => _PendienteUsuarioState();
}

class _PendienteUsuarioState extends State<PendienteUsuario> {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos pendientes del usuario.
  List<AuxPedidoModel> _pedidos = [];

  /// Lista de objetos [ProductoModel] que representa los productos disponibles en la tienda.
  ///
  /// Esta lista se utiliza para obtener el nombre de los productos en la tabla de pedidos pendientes.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [PuntoVentaModel] que representa los puntos de venta disponibles en la tienda.
  ///
  /// Esta lista se utiliza para obtener el nombre del punto de venta en la tabla de pedidos pendientes.
  List<PuntoVentaModel> listaPuntosVenta = [];

  /// Fuente de datos para la tabla de pedidos pendientes.
  ///
  /// Se utiliza para mostrar los datos de los pedidos pendientes en la tabla.
  late PendienteUsuarioDataGridSource _dataGridSource;

  @override

  /// Se llama cuando se crea el estado para la primera vez.
  ///
  /// Inicializa el estado de la tabla de pedidos pendientes.
  /// Configura la fuente de datos [_dataGridSource] con los datos de los pedidos pendientes,
  /// los productos y los puntos de venta. Luego, actualiza los pedidos pendientes con los
  /// que se creó el widget. Finalmente, llama a [_loadData] para cargar los datos de los productos
  /// y los puntos de venta.
  @override
  void initState() {
    super.initState();

    // Configura la fuente de datos con los datos iniciales
    _dataGridSource = PendienteUsuarioDataGridSource(
      pedidos: _pedidos,
      listaProductos: listaProductos,
      listaPuntosVenta: listaPuntosVenta,
    );

    // Actualiza los pedidos pendientes con los que se creó el widget
    _pedidos = widget.auxPedido;

    // Carga los datos de los productos y los puntos de venta
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
          _dataGridSource = PendienteUsuarioDataGridSource(
            pedidos: _pedidos,
            listaProductos: listaProductos,
            listaPuntosVenta: listaPuntosVenta,
          );
        });
      });
    }
  }

  /// Se llama automáticamente cuando se elimina el widget.
  ///
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por el
  /// widget.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos
  /// adicionales.
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
          // Titulo de la tabla de pedidos pendientes
          Text(
            "Pedidos Pendientes",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Cuerpo de la tabla de pedidos pendientes
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
                  GridColumn(
                    allowSorting: false,
                    allowFiltering: false,
                    columnName: 'Eliminar Producto',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(''),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Botones de accion de la tabla de pedidos pendientes
          if (!Responsive.isMobile(context))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('Imprimir Reporte', () {}),
                const SizedBox(
                  width: defaultPadding,
                ),
                _buildButton('Cancelar Pedido', () {}),
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
                  _buildButton('Cancelar Pedido', () {}),
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
      width: 200, // Ancho del contenedor
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(10), // Borde redondeado con un radio de 10
        gradient: const LinearGradient(
          colors: [
            // Gradiente de color
            botonClaro, // Color de fondo claro
            botonOscuro, // Color de fondo oscuro
          ],
        ),
        boxShadow: const [
          // Sombra
          BoxShadow(
            color: botonSombra, // Color de sombra
            blurRadius: 5, // Radio de la sombra
            offset: Offset(0, 3), // Desplazamiento en x e y de la sombra
          ),
        ],
      ),
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
                  fontFamily: 'Calibri-Bold', // Fuente en negrita
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PendienteUsuarioDataGridSource extends DataGridSource {
  /// Obtiene el nombre del producto dado su identificador.
  ///
  /// El método recorre la lista de productos y busca el producto con el
  /// identificador proporcionado. Si lo encuentra, devuelve el nombre del
  /// producto.
  ///
  /// @param productoAxiliar Identificador del producto.
  /// @param productos Lista de productos.
  /// @return El nombre del producto correspondiente al identificador, o una
  /// cadena vacía si no se encuentra.
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    // Inicializar el nombre del producto como una cadena vacía
    String productName = "";

    // Recorrer la lista de productos
    for (var producto in productos) {
      // Verificar si el identificador del producto coincide con el
      // productoAxiliar
      if (producto.id == productoAxiliar) {
        // Si coincide, asignar el nombre del producto y salir del bucle
        productName = producto.nombre;
        break;
      }
    }

    // Devolver el nombre del producto
    return productName;
  }

  /// Obtiene el nombre del punto de venta dado su identificador.
  ///
  /// El método recorre la lista de puntos de venta y busca el punto de venta con el
  /// identificador proporcionado. Si lo encuentra, devuelve el nombre del
  /// punto de venta.
  ///
  /// @param punto Identificador del punto de venta.
  /// @param puntosVenta Lista de puntos de venta.
  /// @return El nombre del punto de venta correspondiente al identificador, o una
  /// cadena vacía si no se encuentra.
  String puntoNombre(int punto, List<PuntoVentaModel> puntosVenta) {
    // Inicializar el nombre del punto de venta como una cadena vacía
    String puntoName = "";

    // Recorrer la lista de puntos de venta
    for (var puntoVenta in puntosVenta) {
      // Verificar si el identificador del punto de venta coincide con el
      // punto
      if (puntoVenta.id == punto) {
        // Si coincide, asignar el nombre del punto de venta y salir del bucle
        puntoName = puntoVenta.nombre;
        break;
      }
    }

    // Devolver el nombre del punto de venta
    return puntoName;
  }

  // DataGridSource para la tabla de pedidos pendientes
  PendienteUsuarioDataGridSource({
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
        DataGridCell<Widget>(
            columnName: 'Eliminar Producto',
            value: ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primaryColor)),
              child: const Text("Eliminar Producto"),
            )),
      ]);
    }).toList();
  }

  // DataGridRow para la tabla de pedidos pendientes
  List<DataGridRow> _pedidoData = [];

  /// Obtiene las filas de datos de la grilla.
  @override
  List<DataGridRow> get rows => _pedidoData;

  // Retorna la lista de datos
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
                "assets/icons/pendiente.svg",
                height: 30,
                width: 30,
                colorFilter:
                    const ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn),
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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formateo de precios
                  : i == 5 || i == 6
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Formateo de fechas
                      : row.getCells()[i].value.toString()), // Celdas restantes
        ),
    ]);
  }
}
