// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/inventarioModel.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/Punto/pdfBodegaPunto.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';
import 'package:tienda_app/responsive.dart';

/// Un widget de estado que representa la vista de la bodega de un punto de venta.
///
/// Esta clase extiende [StatefulWidget] y proporciona un estado asociado
/// [_BodegaPuntoState]. Tiene una lista de [InventarioModel] que representa
/// los inventarios de la bodega del punto de venta.
class BodegaPunto extends StatefulWidget {
  /// La lista de inventarios de la bodega del punto de venta.
  ///
  /// Esta lista contiene objetos de tipo [InventarioModel] que representan
  /// los inventarios de la bodega del punto de venta.
  final List<InventarioModel> inventarioLista;

  final UsuarioModel usuario;

  /// Crea un nuevo widget de estado de la bodega de un punto de venta.
  ///
  /// Toma como parámetro obligatorio la lista de inventarios de la bodega
  /// del punto de venta.
  const BodegaPunto(
      {super.key, required this.inventarioLista, required this.usuario});

  @override
  State<BodegaPunto> createState() => _BodegaPuntoState();
}

class _BodegaPuntoState extends State<BodegaPunto> {
  /// La lista de inventarios de la bodega del punto de venta.
  ///
  /// Esta lista contiene objetos de tipo [InventarioModel] que representan
  /// los inventarios de la bodega del punto de venta.
  List<InventarioModel> _bodegas = [];

  /// La lista de producciones de la bodega del punto de venta.
  ///
  /// Esta lista contiene objetos de tipo [ProduccionModel] que representan
  /// las producciones de la bodega del punto de venta.
  List<ProduccionModel> listaProducciones = [];

  /// El origen de datos del datagrid de la bodega del punto de venta.
  ///
  /// Este objeto contiene la fuente de datos para el datagrid de la bodega
  /// del punto de venta, incluyendo los inventarios y las producciones.
  late BodegaPuntoDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Inicializa el estado del widget.
  ///
  /// Este método es llamado cuando se crea el widget y se establece su estado.
  /// Aquí, inicializamos el objeto [_dataGridSource] con la lista de inventarios
  /// de la bodega del punto de venta y cargamos los datos de las producciones.
  @override
  void initState() {
    super.initState();
    // Inicializa el objeto [_dataGridSource] con la lista de inventarios
    // de la bodega del punto de venta y las producciones
    _dataGridSource = BodegaPuntoDataGridSource(
        bodegas: _bodegas, listaProducciones: listaProducciones);
    _bodegas = widget.inventarioLista;
    // Carga los datos de las producciones de la bodega del punto de venta
    _loadData();
  }

  /// Carga los datos de las producciones de la bodega del punto de venta.
  ///
  /// Esto se hace llamando a la función [getProducciones] de la API
  /// y asignando los resultados a la variable [_producciones].
  /// Luego, se actualiza [_dataGridSource] en el siguiente frame de la interfaz de usuario.
  Future<void> _loadData() async {
    // Obtener las producciones de la bodega del punto de venta
    // de la API
    List<ProduccionModel> produccionesCargadas = await getProducciones();

    // Asignar las producciones a la variable listaProducciones
    listaProducciones = produccionesCargadas;

    if (mounted) {
      // Actualizar _dataGridSource en el siguiente frame de la interfaz de usuario
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializar _dataGridSource con los datos de las producciones y los inventarios
          _dataGridSource = BodegaPuntoDataGridSource(
              bodegas: _bodegas, listaProducciones: listaProducciones);
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
          // Titulo tabla
          Text(
            "Inventario",
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
                source: _dataGridSource, // Asignar _dataGridSource
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
                // Cargar columnas
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'Producto',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Producto'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Número Producción',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Número Producción'),
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
                    columnName: 'Cantidad Enviada',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Cantidad Enviada'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Cantidad Llegada',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Cantidad Llegada'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Cantidad Bodega',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Cantidad Bodega'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Fecha Inventario',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Inventario'),
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
          // Botón para imprimir o añadir un nuevo reporte
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
                            builder: (context) => PdfBodegaPuntoScreen(
                                usuario: widget.usuario, registro: registros)));
                  }
                }),
                const SizedBox(
                  width: defaultPadding,
                ),
                _buildButton('Añadir Reporte', () {}),
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
                              builder: (context) => PdfBodegaPuntoScreen(
                                  usuario: widget.usuario,
                                  registro: registros)));
                    }
                  }),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  _buildButton('Añadir Reporte', () {}),
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

/// Clase que define los datos de la fuente de datos de la tabla
class BodegaPuntoDataGridSource extends DataGridSource {
  /// Obtiene el número de producción de un inventario dado su identificador.
  ///
  /// El método recibe el identificador de la producción y una lista de producciones.
  /// Recorre la lista de producciones buscando la producción que corresponda al
  /// identificador especificado. Si encuentra una producción que coincide con el
  /// identificador, obtiene el número de la producción y lo devuelve como una
  /// cadena. Si no encuentra ninguna producción que coincida, devuelve una cadena
  /// vacía.
  ///
  /// Parámetros:
  /// - produccionId: El identificador de la producción a buscar.
  /// - producciones: La lista de producciones en la que buscar la producción.
  ///
  /// Retorna:
  /// - Una cadena con el número de la producción, si se encuentra una producción que
  ///   coincide con el identificador.
  /// - Una cadena vacía si no se encuentra ninguna producción que coincida con el
  ///   identificador.
  String numeroProduccionInventario(
      int produccionId, List<ProduccionModel> producciones) {
    // Inicializa la variable produccionNumero como una cadena vacía
    String produccionNumero = "";

    // Recorre la lista de producciones buscando la producción que corresponda al
    // identificador especificado
    for (var produccion in producciones) {
      // Si el identificador de la producción coincide con el produccionId proporcionado
      if (produccion.id == produccionId) {
        // Asigna el número de la producción a la variable produccionNumero
        produccionNumero = produccion.numero.toString();
        // Detiene el bucle for y devuelve el número de la producción
        break;
      }
    }

    // Devuelve el número de la producción o una cadena vacía si no se encuentra la
    // producción asociada al identificador
    return produccionNumero;
  }

  /// Obtiene el nombre de la unidad de producción asociada a una producción dada su
  /// identificador.
  ///
  /// El método recibe el identificador de la producción y una lista de producciones.
  /// Recorre la lista de producciones buscando la producción que corresponda al
  /// identificador especificado. Si encuentra una producción que coincide con el
  /// identificador, obtiene el nombre de la unidad de producción asociada a la
  /// producción y lo devuelve como una cadena. Si no encuentra ninguna
  /// producción que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - produccionId: El identificador de la producción a buscar.
  /// - producciones: La lista de producciones en la que buscar la producción.
  ///
  /// Retorna:
  /// - Una cadena con el nombre de la unidad de producción, si se encuentra una
  ///   producción que coincide con el identificador.
  /// - Una cadena vacía si no se encuentra ninguna producción que coincida con el
  ///   identificador.
  String unidadProduccionInventario(
      int produccionId, List<ProduccionModel> producciones) {
    // Inicializa la variable produccionUnidad como una cadena vacía
    String produccionUnidad = "";

    // Recorre la lista de producciones buscando la producción que corresponda al
    // identificador especificado
    for (var produccion in producciones) {
      // Si el identificador de la producción coincide con el produccionId proporcionado
      if (produccion.id == produccionId) {
        // Obtiene el nombre de la unidad de producción asociada a la producción y lo
        // asigna a la variable produccionUnidad
        produccionUnidad = produccion.unidadProduccion.nombre;
        // Detiene el bucle for y devuelve el nombre de la unidad de producción
        break;
      }
    }

    // Devuelve el nombre de la unidad de producción o una cadena vacía si no se encuentra la
    // producción asociada al identificador
    return produccionUnidad;
  }

  /// Obtiene la cantidad de producción asociada a un identificador de producción.
  ///
  /// El método recibe el identificador de la producción y una lista de producciones.
  /// Recorre la lista de producciones buscando la producción que corresponda al
  /// identificador especificado. Si encuentra una producción que coincide con el
  /// identificador, obtiene la cantidad de producción y lo devuelve como una cadena.
  /// Si no encuentra ninguna producción que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - produccionId: El identificador de la producción a buscar.
  /// - producciones: La lista de producciones en la que buscar la producción.
  ///
  /// Retorna:
  /// - Una cadena con la cantidad de producción, si se encuentra una
  ///   producción que coincide con el identificador.
  /// - Una cadena vacía si no se encuentra ninguna producción que coincida con el
  ///   identificador.
  String cantidadProduccionInventario(
      int produccionId, List<ProduccionModel> producciones) {
    // Inicializa la variable produccionCantidad como una cadena vacía
    String produccionCantidad = "";

    // Recorre la lista de producciones buscando la producción que corresponda al
    // identificador especificado
    for (var produccion in producciones) {
      // Si el identificador de la producción coincide con el produccionId proporcionado
      if (produccion.id == produccionId) {
        // Obtiene la cantidad de producción y lo asigna a la variable produccionCantidad
        produccionCantidad = produccion.cantidad.toString();
        // Detiene el bucle for y devuelve la cantidad de producción
        break;
      }
    }

    // Devuelve la cantidad de producción o una cadena vacía si no se encuentra la
    // producción asociada al identificador
    return produccionCantidad;
  }

  // Crea una fuente de datos para la grilla de bodegas
  BodegaPuntoDataGridSource(
      {required List<InventarioModel> bodegas,
      required List<ProduccionModel> listaProducciones}) {
    _bodegaData = bodegas.map<DataGridRow>((bodega) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Producto', value: bodega.bodega.producto.nombre),
        DataGridCell<String>(
            columnName: 'Número Producción',
            value: numeroProduccionInventario(
                bodega.produccion, listaProducciones)),
        DataGridCell<String>(
            columnName: 'Unidad Producción',
            value: unidadProduccionInventario(
                bodega.produccion, listaProducciones)),
        DataGridCell<String>(
            columnName: 'Cantidad Enviada',
            value: cantidadProduccionInventario(
                bodega.produccion, listaProducciones)),
        DataGridCell<int>(columnName: 'Cantidad Llegada', value: bodega.stock),
        DataGridCell<int>(
            columnName: 'Cantidad Bodega', value: bodega.bodega.cantidad),
        DataGridCell<String>(
            columnName: 'Fecha Inventario', value: bodega.fecha),
        DataGridCell<String>(
            columnName: 'Punto Venta', value: bodega.bodega.puntoVenta.nombre),
      ]);
    }).toList();
  }

  // Lista de filas de la grilla
  List<DataGridRow> _bodegaData = [];

  // Asigna la lista de filas a la grilla
  @override
  List<DataGridRow> get rows => _bodegaData;

  // retorna el estilo de la grilla
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
                "assets/icons/bodega.svg",
                height: 30,
                width: 30,
                colorFilter:
                    const ColorFilter.mode(Colors.brown, BlendMode.srcIn),
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
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: (row.getCells()[i].value is Widget)
              ? row.getCells()[i].value
              : Text(i == 6
                  ? formatFechaHora(row
                      .getCells()[i]
                      .value
                      .toString()) // Formato de fecha y hora
                  : row.getCells()[i].value.toString()), // Otros valores
        ),
    ]);
  }
}
