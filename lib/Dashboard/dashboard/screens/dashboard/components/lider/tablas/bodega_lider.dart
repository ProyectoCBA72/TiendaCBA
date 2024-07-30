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
import 'package:tienda_app/pdf/Lider/pdfBodegaLider.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';

/// Un widget de estado que representa la vista de la bodega de un punto de venta para el lider.
///
/// Esta clase extiende [StatefulWidget] y proporciona un estado asociado
/// [_BodegaLiderState]. Recibe una lista de [InventarioModel] como parámetro para
/// inicializar la vista.
class BodegaLider extends StatefulWidget {
  /// Lista de inventarios que representan la cantidad de productos en cada bodega.
  ///
  /// Esta lista se utiliza para inicializar la vista de la bodega.
  final List<BodegaModel> inventarioLista;

  final UsuarioModel usuario;

  /// Constructor del widget [BodegaLider].
  ///
  /// Toma como parámetro [inventarioLista], que es la lista de inventarios
  /// que representan la cantidad de productos en cada bodega.
  const BodegaLider(
      {super.key, required this.inventarioLista, required this.usuario});

  /// Crea el estado asociado al widget [BodegaLider].
  @override
  State<BodegaLider> createState() => _BodegaLiderState();
}

class _BodegaLiderState extends State<BodegaLider> {
  /// La lista de inventarios de la bodega del punto de venta.
  ///
  /// Esta lista contiene objetos de tipo [BodegaModel] que representan
  /// los inventarios de la bodega del punto de venta.
  ///
  /// **Campo privado**: Este campo es privado y es utilizado para almacenar
  /// la lista de inventarios de la bodega del punto de venta.
  ///
  /// **Tipo**: Este campo es de tipo [List<BodegaModel>].
  ///
  /// **Inicialización**: Este campo se inicializa vacío.
  ///
  /// **Usos**: Este campo se utiliza para almacenar y acceder a los datos de las
  /// bodegas del punto de venta. No se debe modificar directamente, ya que su
  /// valor se carga en el método [initState].
  ///
  /// Esta lista contiene objetos de tipo [BodegaModel] que representan los
  /// inventarios de la bodega del punto de venta. Este campo es privado y
  /// representa la lista de inventarios de la bodega del punto de venta. Este
  /// campo es de tipo [List<BodegaModel>] y se inicializa vacío. Este campo se
  /// utiliza para almacenar y acceder a los datos de las bodegas del punto de
  /// venta. No se debe modificar directamente, ya que su valor se carga en el
  /// método [initState].
  List<BodegaModel> _bodegas = [];

  /// Lista de producciones que contiene la información de los productos en cada bodega.
  ///
  /// Esta lista se inicializa en el estado y se utiliza en la vista de la bodega.
  List<ProduccionModel> listaProducciones = [];

  /// La lista de inventarios de la bodega del punto de venta.
  List<InventarioModel> listaInventarios = [];

  /// Origen de datos de la tabla de la bodega.
  ///
  /// Se inicializa en el estado y se utiliza en la vista de la bodega.
  late BodegaLiderDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Inicializa el estado del widget [BodegaLider].
  ///
  /// Se llama al método base [initState] y se inicializa la variable [_dataGridSource]
  /// con la lista de bodegas y producciones recibidas como parámetro en el constructor.
  /// Luego, se asigna la lista de bodegas recibida en el constructor a la variable [_bodegas].
  /// Finalmente, se llama a [_loadData] para cargar la información de la producción.
  @override
  void initState() {
    super.initState();

    // Inicializa el origen de datos de la tabla de la bodega con los datos de entrada
    _dataGridSource = BodegaLiderDataGridSource(
        bodegas: _bodegas,
        listaProducciones: listaProducciones,
        listaInventarios: listaInventarios);

    // Asigna la lista de bodegas recibida en el constructor a la variable local
    _bodegas = widget.inventarioLista;

    // Carga la información de la producción
    _loadData();
  }

  /// Carga los datos de las producciones.
  ///
  /// Se llama a la función [getProducciones] para obtener la lista de producciones.
  /// Luego, se asigna la lista de producciones recibida a la variable [_listaProducciones].
  /// Finalmente, se actualiza [_dataGridSource] en el siguiente frame de la interfaz de usuario.
  Future<void> _loadData() async {
    // Obtener las producciones de la API
    List<ProduccionModel> produccionesCargadas = await getProducciones();

    // Obtener los inventarios de la API
    List<InventarioModel> inventariosCargados = await getInventario();

    // Asignar las producciones a la variable [_listaProducciones]
    listaProducciones = produccionesCargadas;

    // Asignar los inventarios a la variable [_listaInventarios]
    listaInventarios = inventariosCargados;

    if (mounted) {
      // Actualizar _dataGridSource en el siguiente frame de la interfaz de usuario
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializar _dataGridSource con los datos de las producciones y las bodegas
          _dataGridSource = BodegaLiderDataGridSource(
              bodegas: _bodegas,
              listaProducciones: listaProducciones,
              listaInventarios: listaInventarios);
        });
      });
    }
  }

  @override

  /// Se llama automáticamente cuando se elimina el widget.
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por el widget.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos adicionales.
  void dispose() {
    // Cancela cualquier operación si es necesario.
    // Este método se debe llamar para liberar los recursos utilizados por el widget.
    // Se debe llamar al método [dispose] del padre para liberar recursos adicionales.
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
                source: _dataGridSource, // Origen de datos de la tabla
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
                            builder: (context) => PdfBodegaLiderScreen(
                                usuario: widget.usuario, registro: registros)));
                  }
                }),
                const SizedBox(
                  height: defaultPadding,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Método que construye un botón con un texto y acciones asociadas.
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
    // Componente de botón personalizado con estilo y sombra.
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

class BodegaLiderDataGridSource extends DataGridSource {
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

  /// Crea una instancia de la clase `BodegaLiderDataGridSource`.
  BodegaLiderDataGridSource(
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

  /// La lista de datos de la tabla.
  List<DataGridRow> _bodegaData = [];

  // Getter para obtener la lista de datos de la tabla
  @override
  List<DataGridRow> get rows => _bodegaData;

  // Retorna un objeto `DataGridRow` para cada elemento de la lista de datos
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
                      .toString()) // Formatea la fecha y hora
                  : row
                      .getCells()[i]
                      .value
                      .toString()), // Formatea el resto de valores
        ),
    ]);
  }
}
