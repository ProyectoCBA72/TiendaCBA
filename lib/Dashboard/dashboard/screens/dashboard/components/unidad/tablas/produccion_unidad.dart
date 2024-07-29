// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/Unidad/pdfProduccionUnidad.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';
import 'package:tienda_app/responsive.dart';

/// Esta clase representa un widget de estado [ProduccionUnidad], que es un
/// widget de pantalla que muestra una tabla de datos con información de producción.
///
/// El widget [ProduccionUnidad] toma una lista de [ProduccionModel] como
/// parámetro en su constructor. Esta lista se utiliza para inicializar el
/// estado de la pantalla y se muestra en la tabla de datos.
class ProduccionUnidad extends StatefulWidget {
  /// La lista de [ProduccionModel] que se va a mostrar en la tabla de datos.
  ///
  /// Esta lista debe ser proporcionada al crear una instancia de [ProduccionUnidad].
  final List<ProduccionModel> producciones;

  final UsuarioModel usuario;

  /// Construye un nuevo widget [ProduccionUnidad].
  ///
  /// El parámetro [producciones] es la lista de [ProduccionModel] que se
  /// va a mostrar en la tabla de datos.
  const ProduccionUnidad(
      {super.key, required this.producciones, required this.usuario});

  /// Crea un nuevo estado para este widget.
  ///
  /// Este método devuelve una instancia de la clase [_ProduccionUnidadState].
  @override
  State<ProduccionUnidad> createState() => _ProduccionUnidadState();
}

class _ProduccionUnidadState extends State<ProduccionUnidad> {
  /// La lista de [ProduccionModel] que se va a mostrar en la tabla de datos.
  ///
  /// Se utiliza para inicializar el estado de la pantalla.
  List<ProduccionModel> _producciones = [];

  /// La lista de [ProductoModel] utilizada para obtener nombres de productos.
  ///
  /// Se utiliza para inicializar el estado de la pantalla.
  List<ProductoModel> listaProductos = [];

  /// Fuente de datos para la tabla de datos.
  ///
  /// Se utiliza para inicializar el estado de la pantalla.
  late ProduccionUnidadDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Inicializa el estado del widget.
  ///
  /// Se llama cuando se crea una nueva instancia de este widget. Inicializa
  /// [_dataGridSource] con las producciones y los productos dados en los
  /// parámetros del constructor, y luego carga los datos necesarios para
  /// mostrar la tabla de datos.
  @override
  void initState() {
    super.initState();

    // Inicializa _dataGridSource con las producciones y los productos dados
    // en los parámetros del constructor.
    _dataGridSource = ProduccionUnidadDataGridSource(
        producciones: _producciones, listaProductos: listaProductos);

    // Asigna las producciones dadas en los parámetros del constructor a la
    // variable _producciones.
    _producciones = widget.producciones;

    // Carga los datos necesarios para mostrar la tabla de datos.
    _loadData();
  }

  /// Carga los datos necesarios para mostrar la tabla de datos.
  ///
  /// Obtiene los productos de la API y luego actualiza las variables
  /// [_listaProductos] y [_dataGridSource] con los datos recibidos.
  Future<void> _loadData() async {
    // Obtiene los productos de la API
    List<ProductoModel> productosCargados = await getProductos();

    // Actualiza la lista de productos con los productos cargados
    listaProductos = productosCargados;

    if (mounted) {
      // Ahora inicializa _dataGridSource después de cargar los datos
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Actualiza _dataGridSource con los datos de las producciones y los productos
          _dataGridSource = ProduccionUnidadDataGridSource(
              producciones: _producciones, listaProductos: listaProductos);
        });
      });
    }
  }

  /// Llama al método [super.dispose] para liberar los recursos utilizados por el widget.
  ///
  /// Este método se llama automáticamente cuando se elimina el widget.
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por el widget.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos adicionales.
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
            "Producciones",
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
                source: _dataGridSource, // Carga los datos de las producciones
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
                    columnName: 'Unidad Producción',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Unidad Producción'),
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
                    columnName: 'Fecha Producción',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Producción'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Fecha Vencimiento',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Vencimiento'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Costo Producción',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Costo Producción'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Fecha Despacho',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Despacho'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Estado Producción',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Estado Producción'),
                    ),
                  ),
                  GridColumn(
                    allowSorting: false,
                    allowFiltering: false,
                    columnName: 'Editar',
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
          // Botón de imprimir y anñadir producción
          if (!Responsive.isMobile(context))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('Imprimir Reporte', () {
                  if (registros.isEmpty) {
                    noHayPDFModal(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfProduccionUnidadScreen(
                                usuario: widget.usuario, registro: registros)));
                  }
                }),
                const SizedBox(
                  width: defaultPadding,
                ),
                _buildButton('Añadir Producción', () {}),
              ],
            ),
          if (Responsive.isMobile(context))
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
                              builder: (context) => PdfProduccionUnidadScreen(
                                  usuario: widget.usuario,
                                  registro: registros)));
                    }
                  }),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  _buildButton('Añadir Producción', () {}),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Método que construye un botón con un texto y un método de presión.
  ///
  /// El método toma dos parámetros: [text], que es el texto del botón, y
  /// [onPressed], que es el método que se ejecutará cuando se presione el
  /// botón. Devuelve un [Container] con un fondo de gradiente y sombra que
  /// contiene un [Material] con un [InkWell] que ejecuta el método de presión
  /// cuando se presiona el botón. El texto del botón se muestra en el centro
  /// del [InkWell] y está estilizado con un color de fondo y estilo de fuente
  /// específicos.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      // Ancho del botón
      width: 200,
      // Decoración del contenedor con un borde redondeado, un gradiente y una sombra
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            botonClaro, // Verde más claro
            botonOscuro, // Verde más oscuro
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: botonSombra, // Verde más claro para sombra
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      // Contenedor para el Material
      child: Material(
        // El color de fondo del Material es transparente
        color: Colors.transparent,
        // Contenedor para el InkWell
        child: InkWell(
          // Método de presión del InkWell
          onTap: onPressed,
          // Borde redondeado del InkWell
          borderRadius: BorderRadius.circular(10),
          // Contenedor para el texto del botón
          child: Padding(
            // Padding vertical del texto del botón
            padding: const EdgeInsets.symmetric(vertical: 10),
            // Centrar el texto del botón
            child: Center(
              // Texto del botón con estilo específico
              child: Text(
                text,
                style: const TextStyle(
                  color: background1, // Color de fondo del texto
                  fontSize: 13, // Tamaño del texto
                  fontWeight: FontWeight.bold, // Estilo del texto
                  fontFamily: 'Calibri-Bold', // Fuente del texto
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Clase que define los datos de la tabla de producción
class ProduccionUnidadDataGridSource extends DataGridSource {
  /// Obtiene el nombre del producto asociado a un identificador de producto.
  ///
  /// El método recibe el identificador del producto y una lista de productos.
  /// Recorre la lista de productos buscando el producto que coincide con
  /// el identificador proporcionado. Si encuentra un producto que coincide,
  /// devuelve el nombre del producto. Si no encuentra ningún producto que
  /// coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - productoId: El identificador del producto a buscar.
  /// - productos: La lista de productos en la que buscar el producto.
  ///
  /// Retorna:
  /// - El nombre del producto, si se encuentra un producto que coincide con
  ///   el identificador proporcionado.
  /// - Una cadena vacía si no se encuentra ningún producto que coincida con el
  ///   identificador proporcionado.
  String productoNombre(int productoId, List<ProductoModel> productos) {
    // Inicializa la variable productName como una cadena vacía
    String productName = "";

    // Recorre la lista de productos buscando el producto que coincide con el productoId proporcionado
    for (var producto in productos) {
      // Si el identificador del producto coincide con el productoId proporcionado
      if (producto.id == productoId) {
        // Asigna el nombre del producto a la variable productName
        productName = producto.nombre;
        // Detiene el bucle for y devuelve el nombre del producto
        break;
      }
    }

    // Devuelve el nombre del producto o una cadena vacía si no se encuentra el producto asociado al productoId proporcionado
    return productName;
  }

  /// Crea una instancia de la clase [ProduccionUnidadDataGridSource].
  ///
  /// Recibe dos listas de objetos de tipo [ProduccionModel] y
  /// [ProductoModel] como argumentos. Crea una lista de objetos de tipo
  ProduccionUnidadDataGridSource(
      {required List<ProduccionModel> producciones,
      required List<ProductoModel> listaProductos}) {
    _produccionData = producciones.map<DataGridRow>((produccion) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'Número', value: produccion.numero),
        DataGridCell<String>(
            columnName: 'Unidad Producción',
            value: produccion.unidadProduccion.nombre),
        DataGridCell<String>(
            columnName: 'Producto',
            value: productoNombre(produccion.producto, productos)),
        DataGridCell<int>(columnName: 'Cantidad', value: produccion.cantidad),
        DataGridCell<String>(
            columnName: 'Fecha Producción', value: produccion.fechaProduccion),
        DataGridCell<String>(
            columnName: 'Fecha Vencimiento',
            value: produccion.fechaVencimiento),
        DataGridCell<int>(
            columnName: 'Costo Producción', value: produccion.costoProduccion),
        DataGridCell<String>(
            columnName: 'Fecha Despacho', value: produccion.fechaDespacho),
        DataGridCell<String>(
            columnName: 'Estado Producción', value: produccion.estado),
        DataGridCell<Widget>(
            columnName: 'Editar',
            value: ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primaryColor)),
              child: const Text("Editar"),
            )),
      ]);
    }).toList();
  }

  // Lista de objetos de tipo DataGridRow
  List<DataGridRow> _produccionData = [];

  // Celdas de la tabla
  @override
  List<DataGridRow> get rows => _produccionData;

  // retorna el valor de la celda
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
                "assets/icons/trabajo.svg",
                height: 30,
                width: 30,
                colorFilter:
                    const ColorFilter.mode(Colors.lime, BlendMode.srcIn),
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
              : Text(i == 6
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formato Moneda
                  : i == 4 || i == 5 || i == 7
                      ? formatFechaHora(
                          row.getCells()[i].value.toString()) // Formato Fecha
                      : row.getCells()[i].value.toString()), // Formato Texto
        ),
    ]);
  }
}
