// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/metodoForm.dart';
import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

/// Esta clase representa un widget de estado que muestra una tabla de pedidos pendientes de un punto de venta.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_PendientePuntoState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan los pedidos pendientes del punto de venta.
class PendientePunto extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representa los pedidos pendientes del punto de venta.
  final List<AuxPedidoModel> auxPedido;

  /// Crea un nuevo objeto [PendientePunto].
  ///
  /// El parámetro [auxPedido] es obligatorio y representa los pedidos pendientes del punto de venta.
  const PendientePunto({super.key, required this.auxPedido});

  /// Crea y devuelve un estado [_PendientePuntoState] para manejar los datos de la pantalla.
  ///
  /// Este método es obligatorio y se utiliza para crear un estado
  /// que herede de [State<PendientePunto>].
  @override
  State<PendientePunto> createState() => _PendientePuntoState();
}

class _PendientePuntoState extends State<PendientePunto> {
  /// Lista de objetos [AuxPedidoModel] que representan los pedidos pendientes del punto de venta.
  List<AuxPedidoModel> _pedidos = [];

  /// Lista de objetos [ProductoModel] que representan los productos disponibles.
  ///
  /// Esta lista se utiliza para obtener el nombre del producto en la tabla de datos.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [PuntoVentaModel] que representan los puntos de venta disponibles.
  ///
  /// Esta lista se utiliza para obtener el nombre del punto de venta en la tabla de datos.
  List<PuntoVentaModel> listaPuntosVenta = [];

  /// Fuente de datos para la tabla de pedidos pendientes del punto de venta.
  ///
  /// Se inicializa en [initState] utilizando los datos proporcionados a través del widget [PendientePunto].
  late PendientePuntoDataGridSource _dataGridSource;

  @override

  /// Se llama cuando se crea el estado para la primera vez.
  ///
  /// Se utiliza para inicializar los datos de la tabla y cargar los datos asociados al punto de venta.
  @override
  void initState() {
    super.initState();

    // Inicializa _dataGridSource con los datos de los pedidos, productos y puntos de venta
    _dataGridSource = PendientePuntoDataGridSource(
      pedidos: _pedidos,
      listaProductos: listaProductos,
      listaPuntosVenta: listaPuntosVenta,
    );

    // Asigna los pedidos del widget al atributo _pedidos
    _pedidos = widget.auxPedido;

    // Carga los datos asociados al punto de venta
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

    // Actualiza _dataGridSource en el siguiente frame de la interfaz de usuario
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Inicializa _dataGridSource con los datos de los pedidos, productos y puntos de venta
        _dataGridSource = PendientePuntoDataGridSource(
          pedidos: _pedidos,
          listaProductos: listaProductos,
          listaPuntosVenta: listaPuntosVenta,
        );
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
            "Pedidos Pendientes",
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
          // Botones  de acción para entegar el pedido, cancelar el pedido o imprimir el reporte
          if (!Responsive.isMobile(context))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('Imprimir Reporte', () {}),
                const SizedBox(
                  width: defaultPadding,
                ),
                _buildButton('Entregar Pedido', () {
                  metodoModal(context);
                }),
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
                  _buildButton('Entregar Pedido', () {
                    metodoModal(context);
                  }),
                ],
              ),
            ),
          const SizedBox(
            height: defaultPadding,
          ),
          Center(
            child: Column(
              children: [
                _buildButton('Cancelar Pedido', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Muestra un diálogo para seleccionar el método de pago.
///
/// Este método muestra un diálogo con un formulario para seleccionar el método de pago.
/// Luego, cuando el usuario acepta la opción "Finalizar Entrega", se cierra el diálogo
/// y se muestra otro diálogo para confirmar el pago.
///
/// [context] es el contexto de la aplicación donde se mostrará el diálogo.
void metodoModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Método de pago"), // Título del diálogo
        content:
            const MetodoForm(), // Contenido del diálogo (formulario para seleccionar el método de pago)
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Finalizar Entrega", () {
                  // Al aceptar la opción "Finalizar Entrega", se cierra el diálogo
                  // y se muestra otro diálogo para confirmar el pago
                  Navigator.pop(context);
                  pagoConfirmadoModal(context);
                }),
              ),
            ],
          ),
        ],
      );
    },
  );
}

/// Muestra un diálogo para confirmar el pago.
///
/// Este método muestra un diálogo con dos botones: "Imprimir Recibo" y "Ir al inicio".
/// Al hacer clic en "Imprimir Recibo", se cierra el diálogo.
/// Al hacer clic en "Ir al inicio", se navega al inicio de la aplicación.
///
/// [context] es el contexto de la aplicación donde se mostrará el diálogo.
void pagoConfirmadoModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Pago Confirmado"), // Título del diálogo
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "¡Gracias por utilizar nuestros servicios!", // Mensaje de confirmación del pago
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            ClipOval(
              child: Container(
                width: 100, // Ajusta el tamaño según sea necesario
                height: 100, // Ajusta el tamaño según sea necesario
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Image.asset(
                  "assets/img/logo.png",
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Imprimir Recibo", () {
                  // Al hacer clic en "Imprimir Recibo", se cierra el diálogo
                  Navigator.pop(context);
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Ir al inicio", () {
                  // Al hacer clic en "Ir al inicio", se navega al inicio de la aplicación
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      );
    },
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
    // Ancho fijo del botón
    width: 200,

    // Decoración del contenedor con un borde redondeado, un gradiente de colores y una sombra
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10), // Borde redondeado
      gradient: const LinearGradient(
        colors: [
          botonClaro, // Color claro del gradiente
          botonOscuro, // Color oscuro del gradiente
        ],
      ), // Gradiente de colores
      boxShadow: const [
        BoxShadow(
          color: botonSombra, // Color de la sombra
          blurRadius: 5, // Radio de desfoque de la sombra
          offset: Offset(0, 3), // Desplazamiento de la sombra
        ),
      ], // Sombra
    ),

    // Contenido del contenedor, un Material con un color de fondo transparente
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed, // Función a ejecutar al presionar el botón
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10), // Padding vertical
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

/// Clase que define la fuente de datos para la grilla de pedidos pendientes.
class PendientePuntoDataGridSource extends DataGridSource {
  /// Obtiene el nombre de un producto a partir de su ID.
  ///
  /// Recibe dos parámetros: el ID del producto y una lista de productos.
  /// Retorna el nombre del producto con el ID especificado.
  ///
  /// El método itera sobre la lista de productos hasta que encuentra el producto
  /// con el ID especificado, y retorna su nombre.
  ///
  /// Si el producto no se encuentra en la lista, retorna una cadena vacía.
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

  /// Obtiene el nombre de un punto de venta a partir de su ID.
  ///
  /// Recibe dos parámetros: el ID del punto de venta y una lista de puntos
  /// de venta.
  /// Retorna el nombre del punto de venta con el ID especificado.
  ///
  /// El método itera sobre la lista de puntos de venta hasta encontrar el
  /// punto con el ID especificado, y retorna su nombre.
  ///
  /// Si el punto de venta no se encuentra en la lista, retorna una cadena vacía.
  String puntoNombre(int punto, List<PuntoVentaModel> puntosVenta) {
    String puntoName = "";

    // Recorremos la lista de puntos de venta buscando el punto con el ID
    // especificado
    for (var puntoVenta in puntosVenta) {
      // Verificamos si el ID del punto de venta coincide con el ID especificado
      if (puntoVenta.id == punto) {
        // Si hay coincidencia, almacenamos el nombre del punto de venta y
        // salimos del bucle
        puntoName = puntoVenta.nombre;
        break;
      }
    }

    // Retornamos el nombre del punto de venta encontrado o una cadena vacía si
    // no se encontró ningún punto de venta que coincida con el ID especificado
    return puntoName;
  }

  /// Crea una fuente de datos para la grilla de pedidos pendientes.
  PendientePuntoDataGridSource({
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

  // Lista de pedidos
  List<DataGridRow> _pedidoData = [];

  // Obtiene la lista de pedidos
  @override
  List<DataGridRow> get rows => _pedidoData;

  // Retorna los valores de las celdas
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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formato de moneda
                  : i == 5 || i == 6
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Fecha Encargo y Fecha Entrega
                      : row.getCells()[i].value.toString()), // Otros valores
        ),
    ]);
  }
}
