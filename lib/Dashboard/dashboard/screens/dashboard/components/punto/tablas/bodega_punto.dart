// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/bodegaModel.dart';
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
  final List<BodegaModel> inventarioLista;

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
  /// Esta lista contiene objetos de tipo [BodegaModel] que representan
  /// los inventarios de la bodega del punto de venta.
  ///
  /// El campo [_bodegas] es privado y representa la lista de inventarios
  /// de la bodega del punto de venta.
  ///
  /// Este campo es de tipo [List<BodegaModel>] y se inicializa vacío.
  ///
  /// Este campo se utiliza para almacenar y acceder a los datos de las bodegas
  /// del punto de venta.
  ///
  /// Este campo es una propiedad privada y no se debe modificar directamente,
  /// ya que su valor se carga en el método [initState].
  List<BodegaModel> _bodegas = [];

  /// La lista de producciones de la bodega del punto de venta.
  ///
  /// Esta lista contiene objetos de tipo [ProduccionModel] que representan
  /// las producciones de la bodega del punto de venta.
  List<ProduccionModel> listaProducciones = [];

  /// La lista de inventarios de la bodega del punto de venta.
  List<InventarioModel> listaInventarios = [];

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
    // de la bodega del punto de venta, las producciones, lo que hay actualmente en bodega.
    _dataGridSource = BodegaPuntoDataGridSource(
        bodegas: _bodegas,
        listaProducciones: listaProducciones,
        listaInventarios: listaInventarios);
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

    // Obtener los inventarios de la API
    List<InventarioModel> inventariosCargados = await getInventario();

    // Asignar las producciones a la variable listaProducciones
    listaProducciones = produccionesCargadas;

    // Asignar los inventarios a la variable [_listaInventarios]
    listaInventarios = inventariosCargados;

    if (mounted) {
      // Actualizar _dataGridSource en el siguiente frame de la interfaz de usuario
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializar _dataGridSource con los datos de las producciones, los inventarios y las bodegas
          _dataGridSource = BodegaPuntoDataGridSource(
              bodegas: _bodegas,
              listaProducciones: listaProducciones,
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
  /// Obtiene el número de producción asociado a un identificador de producción dada una lista de producciones.
  ///
  /// El método recibe el identificador de la producción y una lista de producciones.
  /// Recorre la lista de producciones buscando la producción que corresponda al
  /// identificador especificado. Si encuentra una producción que coincide con el
  /// identificador, obtiene el número de la producción y lo devuelve como una cadena.
  /// Si no encuentra ninguna producción que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - bodegaId: El identificador de la bodega a buscar.
  /// - producciones: La lista de producciones en la que buscar la producción.
  /// - inventarios: La lista de inventarios en la que buscar el número de producción.
  ///
  /// Retorna:
  /// - Una cadena con el número de la producción, si se encuentra una producción que
  ///   coincide con el identificador de bodega.
  /// - Una cadena vacía si no se encuentra ninguna producción que coincida con el
  ///   identificador de bodega.
  String numeroProduccionInventario(int bodegaId,
      List<ProduccionModel> producciones, List<InventarioModel> inventarios) {
    // Filtra los inventarios que corresponden a la bodega especificada
    List<InventarioModel> inventariosBodega = inventarios
        .where((inventario) => inventario.bodega.id == bodegaId)
        .toList();

    // Si no hay inventarios para la bodega especificada, devuelve una cadena vacía
    if (inventariosBodega.isEmpty) {
      return "";
    }

    // Ordena los inventarios por fecha en orden descendente (del más reciente al más antiguo)
    inventariosBodega.sort((a, b) => b.fecha.compareTo(a.fecha));

    // Toma el inventario más reciente
    InventarioModel inventarioReciente = inventariosBodega.first;

    // Busca la producción asociada al inventario más reciente
    var produccionReciente = producciones
        .where((produccion) => produccion.id == inventarioReciente.produccion);

    var produccionRecienteNumero =
        produccionReciente.firstOrNull?.numero.toString();

    if (produccionRecienteNumero != null) {
      // Devuelve el número de producción o una cadena vacía si no se encuentra la producción
      return produccionRecienteNumero.toString();
    } else {
      return "";
    }
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
  /// - inventarios: La lista de inventarios en la que buscar la producción asociada a la bodega.
  ///
  /// Retorna:
  /// - Una cadena con el nombre de la unidad de producción, si se encuentra una
  ///   producción que coincide con el identificador.
  /// - Una cadena vacía si no se encuentra ninguna producción que coincida con el
  ///   identificador.
  ///
  /// NOTA: Este método recorre las listas de producciones e inventarios para buscar la producción
  ///       y el inventario correspondientes a la bodega.
  String unidadProduccionInventario(int bodegaId,
      List<ProduccionModel> producciones, List<InventarioModel> inventarios) {
    // Filtra los inventarios que corresponden a la producción especificada
    List<InventarioModel> inventariosProduccion = inventarios
        .where((inventario) => inventario.bodega.id == bodegaId)
        .toList();

    // Si no hay inventarios para la producción especificada, devuelve una cadena vacía
    if (inventariosProduccion.isEmpty) {
      return "";
    }

    // Ordena los inventarios por fecha en orden descendente (del más reciente al más antiguo)
    inventariosProduccion.sort((a, b) => b.fecha.compareTo(a.fecha));

    // Toma el inventario más reciente
    InventarioModel inventarioReciente = inventariosProduccion.first;

    // Busca la producción asociada al inventario más reciente
    var produccionReciente = producciones
        .where((produccion) => produccion.id == inventarioReciente.produccion);

    var produccionRecienteNombreUnidad =
        produccionReciente.firstOrNull?.unidadProduccion.nombre;

    if (produccionRecienteNombreUnidad != null) {
      // Devuelve el nombre de la unidad de producción o una cadena vacía si no se encuentra la producción
      return produccionRecienteNombreUnidad;
    } else {
      return "";
    }
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
  /// - inventarios: La lista de inventarios en la que buscar la producción asociada a la bodega.
  ///
  /// Retorna:
  /// - Una cadena con la cantidad de producción, si se encuentra una producción que
  ///   coincide con el identificador.
  /// - Una cadena vacía si no se encuentra ninguna producción que coincida con el
  ///   identificador.
  ///
  /// NOTA: Este método recorre las listas de producciones e inventarios para buscar la producción
  ///       y el inventario correspondientes a la bodega.
  String cantidadProduccionInventario(int bodegaId,
      List<ProduccionModel> producciones, List<InventarioModel> inventarios) {
    // Filtra los inventarios que corresponden a la producción especificada
    List<InventarioModel> inventariosProduccion = inventarios
        .where((inventario) => inventario.bodega.id == bodegaId)
        .toList();

    // Si no hay inventarios para la producción especificada, devuelve una cadena vacía
    if (inventariosProduccion.isEmpty) {
      return "";
    }

    // Ordena los inventarios por fecha en orden descendente (del más reciente al más antiguo)
    inventariosProduccion.sort((a, b) => b.fecha.compareTo(a.fecha));

    // Toma el inventario más reciente
    InventarioModel inventarioReciente = inventariosProduccion.first;

    // Busca la producción asociada al inventario más reciente
    var produccionReciente = producciones
        .where((produccion) => produccion.id == inventarioReciente.produccion);

    var produccionRecienteCantidad = produccionReciente.firstOrNull?.cantidad;

    if (produccionRecienteCantidad != null) {
      // Devuelve la cantidad de producción o una cadena vacía si no se encuentra la producción

      return produccionRecienteCantidad.toString();
    } else {
      return "";
    }
  }

  int stockInventario(int bodegaId, List<InventarioModel> inventarios) {
    // Filtra los inventarios que corresponden a la bodega especificada
    List<InventarioModel> inventariosBodega = inventarios
        .where((inventario) => inventario.bodega.id == bodegaId)
        .toList();

    // Si no hay inventarios para la bodega especificada, devuelve 0
    if (inventariosBodega.isEmpty) {
      return 0;
    }

    // Ordena los inventarios por fecha en orden descendente (del más reciente al más antiguo)
    inventariosBodega.sort((a, b) => b.fecha.compareTo(a.fecha));

    // Toma el inventario más reciente
    InventarioModel inventarioReciente = inventariosBodega.first;

    // Devuelve la cantidad de stock del inventario más reciente
    return inventarioReciente.stock;
  }

  String fechaInventario(int bodegaId, List<InventarioModel> inventarios) {
    // Filtra los inventarios que corresponden a la bodega especificada
    List<InventarioModel> inventariosBodega = inventarios
        .where((inventario) => inventario.bodega.id == bodegaId)
        .toList();

    // Si no hay inventarios para la bodega especificada, devuelve una cadena vacía
    if (inventariosBodega.isEmpty) {
      return "";
    }

    // Ordena los inventarios por fecha en orden descendente (del más reciente al más antiguo)
    inventariosBodega.sort((a, b) => b.fecha.compareTo(a.fecha));

    // Toma el inventario más reciente
    InventarioModel inventarioReciente = inventariosBodega.first;

    // Devuelve la fecha del inventario más reciente
    return inventarioReciente.fecha;
  }

  // Crea una fuente de datos para la grilla de bodegas
  BodegaPuntoDataGridSource(
      {required List<BodegaModel> bodegas,
      required List<ProduccionModel> listaProducciones,
      required List<InventarioModel> listaInventarios}) {
    _bodegaData = bodegas.map<DataGridRow>((bodega) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Producto', value: bodega.producto.nombre),
        DataGridCell<String>(
            columnName: 'Número Producción',
            value: numeroProduccionInventario(
                bodega.id, listaProducciones, listaInventarios)),
        DataGridCell<String>(
            columnName: 'Unidad Producción',
            value: unidadProduccionInventario(
                bodega.id, listaProducciones, listaInventarios)),
        DataGridCell<String>(
            columnName: 'Cantidad Enviada',
            value: cantidadProduccionInventario(
                bodega.id, listaProducciones, listaInventarios)),
        DataGridCell<int>(
            columnName: 'Cantidad Llegada',
            value: stockInventario(bodega.id, listaInventarios)),
        DataGridCell<int>(
            columnName: 'Cantidad Bodega', value: bodega.cantidad),
        DataGridCell<String>(
            columnName: 'Fecha Inventario',
            value: fechaInventario(bodega.id, listaInventarios)),
        DataGridCell<String>(
            columnName: 'Punto Venta', value: bodega.puntoVenta.nombre),
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
