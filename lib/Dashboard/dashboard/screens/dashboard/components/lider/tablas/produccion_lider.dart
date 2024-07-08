// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Widget de estado que representa la tabla de producciones de un líder.
///
/// Esta clase extiende [StatefulWidget] y proporciona un estado asociado
/// [_ProduccionLiderState]. Tiene una lista de [ProduccionModel] que representa
/// las producciones del líder.
///
/// El constructor [ProduccionLider] recibe una lista de [ProduccionModel] a través
/// del parámetro [producciones], que contiene los datos de las producciones.
///
/// El método [createState] crea un estado [_ProduccionLiderState] para manejar los datos de la pantalla.
class ProduccionLider extends StatefulWidget {
  /// Lista de [ProduccionModel] que representa las producciones del líder.
  final List<ProduccionModel> producciones;

  /// Constructor de [ProduccionLider].
  ///
  /// El parámetro [producciones] es obligatorio y debe ser una lista de objetos
  /// [ProduccionModel] que representan las producciones del líder.
  const ProduccionLider({super.key, required this.producciones});

  @override

  /// Crea un estado [_ProduccionLiderState] para manejar los datos de la pantalla.
  State<ProduccionLider> createState() => _ProduccionLiderState();
}

class _ProduccionLiderState extends State<ProduccionLider> {
  /// Lista de objetos [ProduccionModel] que representan las producciones del líder.
  ///
  /// Esta lista se utiliza para mostrar los datos en la tabla de producciones.
  List<ProduccionModel> _producciones = [];

  /// Lista de objetos [ProductoModel] que representan los productos disponibles.
  ///
  /// Esta lista se utiliza para obtener los nombres de los productos en la tabla de producciones.
  List<ProductoModel> listaProductos = [];

  /// Objeto [ProduccionLiderDataGridSource] que contiene los datos de las producciones
  /// utilizados para mostrar la tabla de producciones en la pantalla.
  ///
  /// Este objeto se inicializa en el método [initState] y se actualiza cada vez que se
  /// recibe un nuevo objeto [ProduccionLider] a través de la propiedad [widget].
  late ProduccionLiderDataGridSource _dataGridSource;

  @override

  /// Método [initState] que se ejecuta al inicio de la creación del widget.
  ///
  /// En este método se inicializa el objeto [_dataGridSource] con los datos de las
  /// producciones recibidas a través de la propiedad [widget]. Además, se asigna la
  /// lista de producciones recibida a la variable [_producciones] y se llama al
  /// método [_loadData] para cargar los datos necesarios para la pantalla.
  @override
  void initState() {
    super.initState();

    // Inicializa _dataGridSource con los datos de las producciones recibidas
    _dataGridSource = ProduccionLiderDataGridSource(
        producciones: _producciones, listaProductos: listaProductos);

    // Asigna la lista de producciones recibida a la variable _producciones
    _producciones = widget.producciones;

    // Carga los datos necesarios para la pantalla
    _loadData();
  }

  /// Método [_loadData] que se encarga de cargar los datos necesarios para la pantalla.
  ///
  /// Este método obtiene la lista de productos utilizando la función [getProductos] y
  /// asigna la lista obtenida a la variable [listaProductos]. Luego, se actualiza
  /// [_dataGridSource] en el siguiente frame de la interfaz de usuario utilizando
  /// [SchedulerBinding.instance.addPostFrameCallback].
  Future<void> _loadData() async {
    // Obtiene la lista de productos de la API
    List<ProductoModel> productosCargados = await getProductos();

    // Asigna la lista de productos obtenida a la variable listaProductos
    listaProductos = productosCargados;

    // Actualiza _dataGridSource en el siguiente frame de la interfaz de usuario
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Inicializa _dataGridSource con los datos de las producciones y los productos
        _dataGridSource = ProduccionLiderDataGridSource(
            producciones: _producciones, listaProductos: listaProductos);
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
          // Título de la tabla
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
          // Tabla de producciones
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
                source: _dataGridSource, // Inicializa _dataGridSource
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
                    columnName: 'Ver',
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

  /// Construye un botón con el texto dado y la función onPressed dada.
  ///
  /// El botón tiene un ancho fijo de 200 píxeles y un estilo que incluye un
  /// degradado de colores, un borde redondeado y una sombra. El texto del
  /// botón está centrado verticalmente y tiene un estilo específico.
  ///
  /// Parámetros:
  ///   - [text]: El texto que se mostrará en el botón.
  ///   - [onPressed]: La acción que se ejecutará cuando el botón es presionado.
  ///
  /// Retorna:
  ///   Un [Widget] que representa el botón construido.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200, // Ancho fijo del botón.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Radio del borde redondeado.
        gradient: const LinearGradient(
          // Estilo de degradado de colores.
          colors: [
            botonClaro, // Color inicial del degradado.
            botonOscuro, // Color final del degradado.
          ],
        ),
        boxShadow: const [
          // Estilo de sombra.
          BoxShadow(
            color: botonSombra, // Color de la sombra.
            blurRadius: 5, // Radio de la sombra.
            offset: Offset(0, 3), // Posición de la sombra.
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Color transparente para el material.
        child: InkWell(
          onTap: onPressed, // Acción que se ejecutará al presionar el botón.
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

// Clase que define los datos de la grilla
class ProduccionLiderDataGridSource extends DataGridSource {
  /// Obtiene el nombre del producto a partir de su id.
  ///
  /// Esta función recorre la lista de productos y busca el producto con el id
  /// proporcionado. Si lo encuentra, devuelve el nombre del producto. Si no lo
  /// encuentra, devuelve una cadena vacía.
  ///
  /// Parameters:
  ///   - productoId: El id del producto a buscar.
  ///   - productos: La lista de productos a través de la cual buscar el nombre.
  ///
  /// Returns:
  ///   - El nombre del producto si se encuentra, o una cadena vacía si no se
  ///     encuentra.
  String productoNombre(int productoId, List<ProductoModel> productos) {
    // Inicializar variable con nombre del producto vacío.
    String productName = "";

    // Recorrer la lista de productos.
    for (var producto in productos) {
      // Verificar si el id del producto es igual al id proporcionado.
      if (producto.id == productoId) {
        // Si es igual, guardar el nombre del producto en la variable y salir del bucle.
        productName = producto.nombre;
        break;
      }
    }

    // Devolver el nombre del producto.
    return productName;
  }

  // Crea un objeto de tipo DataGridRow para cada producción.
  ProduccionLiderDataGridSource(
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
            columnName: 'Ver',
            value: ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primaryColor)),
              child: const Text("Ver"),
            )),
      ]);
    }).toList();
  }

  // Lista de datos de la grilla
  List<DataGridRow> _produccionData = [];

  // Metodo para obtener los datos de la grilla
  @override
  List<DataGridRow> get rows => _produccionData;

  // Retorna un objeto de tipo DataGridRow para cada línea
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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formato de moneda
                  : i == 4 || i == 5 || i == 7
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Formato de fecha y hora
                      : row.getCells()[i].value.toString()), // Texto Normal
        ),
    ]);
  }
}
