// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/inventarioModel.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/Unidad/pdfRecibidoUnidad.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';

/// Esta clase representa un widget de estado que muestra una tabla de producciones recibidas de una unidad.
///
/// Este widget recibe una lista de objetos [ProduccionModel] a través del parámetro
/// [producciones], que contiene los datos de las producciones recibidas.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_ProduccionRecibidaUnidadState] para manejar los datos de la pantalla.
class ProduccionRecibidaUnidad extends StatefulWidget {
  final List<ProduccionModel> producciones;

  final UsuarioModel usuario;

  /// Constructor de la clase [ProduccionRecibidaUnidad].
  ///
  /// Recibe una lista de objetos [ProduccionModel] a través del parámetro [producciones].
  /// Este parámetro es obligatorio.
  const ProduccionRecibidaUnidad(
      {super.key, required this.producciones, required this.usuario});

  @override
  State<ProduccionRecibidaUnidad> createState() =>
      _ProduccionRecibidaUnidadState();
}

class _ProduccionRecibidaUnidadState extends State<ProduccionRecibidaUnidad> {
  /// Lista de objetos [ProduccionModel] que representan las producciones recibidas.
  List<ProduccionModel> _producciones = [];

  /// Lista de objetos [ProductoModel] que representan los productos disponibles.
  ///
  /// Esta lista se utiliza para obtener el nombre del producto a partir de su id.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [InventarioModel] que representan los inventarios disponibles.
  ///
  /// Esta lista se utiliza para obtener la cantidad del producto a partir de su id.
  List<InventarioModel> listaInventarios = [];

  /// Origen de datos para la tabla de producciones recibidas.
  ///
  /// Este objeto se utiliza para obtener los datos y configurar la tabla.
  late ProduccionRecibidaUnidadDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Inicializa el estado del widget.
  ///
  /// Se llama automáticamente cuando se crea el widget. En este método, se
  /// inicializan las variables y se llama al método [_loadData] para cargar los
  /// datos necesarios para mostrar la tabla de producciones recibidas.
  @override
  void initState() {
    super.initState();

    // Inicializa _dataGridSource con los datos de las producciones, productos y inventarios
    _dataGridSource = ProduccionRecibidaUnidadDataGridSource(
        producciones: _producciones,
        listaProductos: listaProductos,
        listaInventarios: listaInventarios);

    // Asigna las producciones recibidas del widget a la variable local
    _producciones = widget.producciones;

    // Llama al método para cargar los datos necesarios para mostrar la tabla
    _loadData();
  }

  /// Carga los datos de los productos y los inventarios.
  ///
  /// Esto se hace llamando a las funciones [getProductos] y [getInventario]
  /// y asignando los resultados a las variables [listaProductos] y
  /// [listaInventarios], respectivamente. Luego, se actualiza [_dataGridSource]
  /// en el siguiente frame de la interfaz de usuario.
  Future<void> _loadData() async {
    // Carga los productos
    List<ProductoModel> productosCargados = await getProductos();

    // Carga los inventarios
    List<InventarioModel> inventariosCargados = await getInventario();

    // Asigna los productos y los inventarios a las variables correspondientes
    listaProductos = productosCargados;
    listaInventarios = inventariosCargados;

    if (mounted) {
      // Ahora inicializa _dataGridSource después de cargar los datos
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializa _dataGridSource con los datos de las producciones, productos y inventarios
          _dataGridSource = ProduccionRecibidaUnidadDataGridSource(
              producciones: _producciones,
              listaProductos: listaProductos,
              listaInventarios: listaInventarios);
        });
      });
    }
  }

  /// Se llama automáticamente cuando se elimina el widget.
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por el widget.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos adicionales.
  @override
  void dispose() {
    // Llama al método [dispose] del widget base para liberar recursos adicionales
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
            "Producciones Recibidas",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Contenedor principal para el gráfico
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
                    columnName: 'Fecha Recibido',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Recibido'),
                    ),
                  ),
                  GridColumn(
                    allowSorting: false,
                    allowFiltering: false,
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
                            builder: (context) => PdfRecibidoUnidadScreen(
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
      width: 200, // Ancho del botón
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
      ), // Decoración del contenedor
      child: Material(
        color: Colors.transparent, // Color transparente para el Material
        child: InkWell(
          onTap: onPressed, // Función de presionar
          borderRadius: BorderRadius.circular(10), // Radio del borde redondeado
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10), // Padding vertical
            child: Center(
              child: Text(
                text, // Texto del botón
                style: const TextStyle(
                  color: background1, // Color del texto
                  fontSize: 13, // Tamaño de fuente
                  fontWeight: FontWeight.bold, // Peso de fuente
                  fontFamily: 'Calibri-Bold', // Fuente
                ),
              ),
            ),
          ),
        ),
      ), // Contenido del contenedor
    );
  }
}

// Clase que define la fuente de datos de la tabla
class ProduccionRecibidaUnidadDataGridSource extends DataGridSource {
  /// Obtiene el nombre de un producto dado su identificador.
  ///
  /// El método recibe el identificador del producto y una lista de productos.
  /// Recorre la lista de productos buscando el producto que corresponda al
  /// identificador especificado. Si encuentra un producto que coincide con
  /// el identificador, obtiene el nombre del producto y lo devuelve como una
  /// cadena. Si no encuentra ningún producto que coincida, devuelve una cadena
  /// vacía.
  ///
  /// Parámetros:
  /// - productoId: El identificador del producto a buscar.
  /// - productos: La lista de productos en la que buscar el producto.
  ///
  /// Retorna:
  /// - Una cadena con el nombre del producto, si se encuentra un producto que
  ///   coincide con el identificador.
  /// - Una cadena vacía si no se encuentra ningún producto que coincida con el
  ///   identificador.
  String productoNombre(int productoId, List<ProductoModel> productos) {
    // Inicializa la variable productName como una cadena vacía
    String productName = "";

    // Recorre la lista de productos buscando el producto que coincide con el
    // identificador especificado
    for (var producto in productos) {
      // Si el identificador del producto coincide con el productoId proporcionado
      if (producto.id == productoId) {
        // Asigna el nombre del producto a la variable productName
        productName = producto.nombre;
        // Detiene el bucle for y devuelve el nombre del producto
        break;
      }
    }

    // Devuelve el nombre del producto o una cadena vacía si no se encuentra el producto
    return productName;
  }

  /// Obtiene la fecha en la que se recibió el inventario asociado a una producción.
  ///
  /// El método recibe el identificador de la producción y una lista de inventarios.
  /// Recorre la lista de inventarios buscando el inventario que corresponda a la
  /// producción especificada. Si encuentra un inventario que coincide con
  /// la producción, obtiene la fecha del inventario y la devuelve como una
  /// cadena. Si no encuentra ningún inventario que coincida, devuelve una cadena
  /// vacía.
  ///
  /// Parámetros:
  /// - produccionId: El identificador de la producción a buscar.
  /// - inventarios: La lista de inventarios en la que buscar el inventario.
  ///
  /// Retorna:
  /// - Una cadena con la fecha del inventario, si se encuentra un inventario que
  ///   coincide con la producción.
  /// - Una cadena vacía si no se encuentra ningún inventario que coincida con la
  ///   producción.
  String fechaInventarioRecibido(
      int produccionId, List<InventarioModel> inventarios) {
    // Inicializa la variable fechaRecibido como una cadena vacía
    String fechaRecibido = "";

    // Recorre la lista de inventarios buscando el inventario que coincide con la
    // producción especificada
    for (var inventario in inventarios) {
      // Si el identificador de la producción del inventario coincide con el
      // produccionId proporcionado
      if (inventario.produccion == produccionId) {
        // Asigna la fecha del inventario a la variable fechaRecibido
        fechaRecibido = inventario.fecha;
        // Detiene el bucle for y devuelve la fecha del inventario
        break;
      }
    }

    // Devuelve la fecha del inventario o una cadena vacía si no se encuentra el
    // inventario asociado a la producción
    return fechaRecibido;
  }

  String puntoVentaInventario(
      int produccionId, List<InventarioModel> inventarios) {
    String nombrePuntoVenta = "";

    for (var inventario in inventarios) {
      if (inventario.produccion == produccionId) {
        nombrePuntoVenta = inventario.bodega.puntoVenta.nombre;
        break;
      }
    }

    return nombrePuntoVenta;
  }

  // Definición de la fuente de datos
  ProduccionRecibidaUnidadDataGridSource(
      {required List<ProduccionModel> producciones,
      required List<ProductoModel> listaProductos,
      required List<InventarioModel> listaInventarios}) {
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
        DataGridCell<String>(
            columnName: 'Fecha Recibido',
            value: fechaInventarioRecibido(produccion.id, listaInventarios)),
        DataGridCell<String>(
            columnName: 'Punto Venta',
            value: puntoVentaInventario(produccion.id, inventarios)),
      ]);
    }).toList();
  }

  // Lista de datos
  List<DataGridRow> _produccionData = [];

  // Obtene los datos de la tabla
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
                    const ColorFilter.mode(Colors.teal, BlendMode.srcIn),
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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formato para moneda
                  : i == 4 || i == 5 || i == 7 || i == 9
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Formato para fecha
                      : row
                          .getCells()[i]
                          .value
                          .toString()), // Cualquier otro caso
        ),
    ]);
  }
}
