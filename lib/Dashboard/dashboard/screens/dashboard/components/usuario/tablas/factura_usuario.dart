// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/Usuario/pdfFacturaUsuario.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';

/// Clase [FacturaUsuario] que representa una pantalla de la aplicación para
/// mostrar las facturas de un usuario.
///
/// Esta clase define una pantalla de la aplicación que muestra las facturas de
/// un usuario. Se utiliza para mostrar una lista de facturas de un usuario
/// determinado.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido]: La lista de pedidos del usuario a mostrar.
class FacturaUsuario extends StatefulWidget {
  /// La lista de pedidos del usuario a mostrar.
  ///
  /// Este atributo es requerido y debe ser una lista de objetos [AuxPedidoModel].
  final List<AuxPedidoModel> auxPedido;

  final UsuarioModel usuario;

  /// Constructor de [FacturaUsuario].
  ///
  /// El constructor toma una lista de pedidos del usuario a mostrar y
  /// almacena en el atributo [auxPedido].
  const FacturaUsuario(
      {super.key, required this.auxPedido, required this.usuario});

  /// Crea el estado para [FacturaUsuario].
  ///
  /// Este método crea un estado [_FacturaUsuarioState] para manejar los datos
  /// de la pantalla.
  @override
  State<FacturaUsuario> createState() => _FacturaUsuarioState();
}

class _FacturaUsuarioState extends State<FacturaUsuario> {
  /// La lista de pedidos del usuario a mostrar.
  ///
  /// Esta variable almacena la lista de pedidos del usuario a mostrar.
  List<AuxPedidoModel> _facturas = [];

  /// La lista de productos.
  ///
  /// Esta variable almacena la lista de productos utilizada para mostrar los
  /// nombres de los productos en la pantalla de facturas.
  List<ProductoModel> listaProductos = [];

  /// La lista de facturas.
  ///
  /// Esta variable almacena la lista de facturas utilizada para mostrar los
  /// detalles de las facturas en la pantalla de facturas.
  List<FacturaModel> listaFacturas = [];

  /// Lista de objetos [UsuarioModel] que representan los vendedores.
  List<UsuarioModel> listaUsuarios = [];

  /// El origen de datos de la cuadrícula de facturas del usuario.
  ///
  /// Este objeto es utilizado para definir la estructura y los datos de la
  /// cuadrícula de facturas del usuario.
  late FacturaUsuarioDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Método de inicialización de estado.
  ///
  /// Este método se llama cuando se crea el estado [_FacturaUsuarioState].
  /// Inicializa la fuente de datos de la cuadrícula de facturas del usuario,
  /// establece la lista de facturas y llama a [_loadData] para cargar los datos
  /// necesarios.
  @override
  void initState() {
    super.initState();

    // Inicializa la fuente de datos de la cuadrícula de facturas del usuario
    _dataGridSource = FacturaUsuarioDataGridSource(
      facturas: _facturas,
      listaProductos: listaProductos,
      listaFacturas: listaFacturas,
      listaUsuarios: listaUsuarios,
    );

    // Establece la lista de facturas a la lista de pedidos del usuario
    _facturas = widget.auxPedido;

    // Carga los datos necesarios para mostrar las facturas
    _loadData();
  }

  /// Carga los datos necesarios para mostrar las facturas.
  ///
  /// Este método obtiene los productos y las facturas de la API y luego
  /// actualiza las variables [_listaProductos] y [_listaFacturas] con los
  /// datos recibidos. Finalmente, actualiza [_dataGridSource] en el siguiente
  /// frame de la interfaz de usuario.
  Future<void> _loadData() async {
    // Obtiene los productos de la API
    List<ProductoModel> productosCargados = await getProductos();

    // Obtiene las facturas de la API
    List<FacturaModel> facturasCargadas = await getFacturas();

    // Obtiene los usuarios de la API
    List<UsuarioModel> usuariosCargados = await getUsuarios();

    // Asigna los productos, las facturas y los usuarios a las variables correspondientes
    listaProductos = productosCargados;
    listaFacturas = facturasCargadas;
    listaUsuarios = usuariosCargados;

    if (mounted) {
      // Ahora inicializa _dataGridSource después de cargar los datos
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializa _dataGridSource con los datos de las facturas, productos y pedidos
          _dataGridSource = FacturaUsuarioDataGridSource(
            facturas: _facturas,
            listaProductos: listaProductos,
            listaFacturas: listaFacturas,
            listaUsuarios: listaUsuarios,
          );
        });
      });
    }
  }

  /// Libera los recursos utilizados por el widget.
  ///
  /// Este método se llama automáticamente cuando el widget se elimina del
  /// árbol de widgets. Libera los recursos utilizados por el widget.
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
          // Titulo Tabla
          Text(
            "Compras",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Cuerpo Tabla
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
                source:
                    _dataGridSource, // Asigna _dataGridSource como fuente de datos
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
                    columnName: 'Número Pedido',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Número Pedido'),
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
                    columnName: 'Fecha Venta',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Venta'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Valor Pedido',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Valor Pedido'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Medio Pago',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Medio Pago'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Vendedor',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Vendedor'),
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
                            builder: (context) => PdfFacturaUsuarioScreen(
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

class FacturaUsuarioDataGridSource extends DataGridSource {
  /// Obtiene el número de venta de una factura dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la factura y una lista de facturas.
  /// Recorre la lista de facturas buscando la factura que corresponda al
  /// número de pedido especificado. Si encuentra una factura que coincide con
  /// el número de pedido, obtiene el número de venta y lo devuelve como una
  /// cadena. Si no encuentra ninguna factura que coincida, devuelve una cadena
  /// vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la factura a buscar.
  /// - facturas: La lista de facturas en la que buscar la factura.
  ///
  /// Retorna:
  /// - Una cadena con el número de venta de la factura encontrada, si se encuentra
  ///   una factura que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna factura que coincida con el
  ///   número de pedido.
  String numeroVentaFactura(int numeroPedido, List<FacturaModel> facturas) {
    String numeroVenta = "";

    // Recorre la lista de facturas buscando la factura correspondiente.
    for (var factura in facturas) {
      // Verifica si el número de pedido de la factura coincide con el buscado.
      if (factura.pedido.numeroPedido == numeroPedido) {
        // Obtiene el número de venta de la factura.
        numeroVenta = factura.numero.toString();
      }
    }

    // Devuelve el número de venta encontrado o una cadena vacía.
    return numeroVenta;
  }

  /// Obtiene el nombre de un producto dado su identificador auxiliar.
  ///
  /// El método recibe el identificador auxiliar del producto y una lista de
  /// productos. Recorre la lista de productos buscando el producto que
  /// corresponda al identificador auxiliar especificado. Si encuentra un
  /// producto que coincide con el identificador auxiliar, obtiene su nombre y
  /// lo devuelve como una cadena. Si no encuentra ningún producto que
  /// coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - productoAxiliar: El identificador auxiliar del producto a buscar.
  /// - productos: La lista de productos en la que buscar el producto.
  ///
  /// Retorna:
  /// - Una cadena con el nombre del producto encontrado, si se encuentra un
  ///   producto que coincida con el identificador auxiliar.
  /// - Una cadena vacía si no se encuentra ningún producto que coincida con
  ///   el identificador auxiliar.
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    String productName =
        ""; // Inicializa una cadena vacía para almacenar el nombre del producto

    // Recorre la lista de productos buscando el producto correspondiente.
    for (var producto in productos) {
      // Verifica si el identificador auxiliar del producto coincide con el buscado.
      if (producto.id == productoAxiliar) {
        // Obtiene el nombre del producto.
        productName = producto.nombre;
        break; // Salta el bucle para evitar buscar más productos.
      }
    }

    // Devuelve el nombre del producto encontrado o una cadena vacía.
    return productName;
  }

  /// Obtiene la fecha de venta de una factura dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la factura y una lista de
  /// facturas. Recorre la lista de facturas buscando la factura que
  /// corresponda al número de pedido especificado. Si encuentra una factura que
  /// coincide con el número de pedido, obtiene la fecha de venta y la devuelve como
  /// una cadena. Si no encuentra ninguna factura que coincida, devuelve una
  /// cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la factura a buscar.
  /// - facturas: La lista de facturas en la que buscar la factura.
  ///
  /// Retorna:
  /// - Una cadena con la fecha de venta de la factura encontrada, si se encuentra
  ///   una factura que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna factura que coincida con el
  ///   número de pedido.
  String fechaVentaFactura(int numeroPedido, List<FacturaModel> facturas) {
    // Inicializa una cadena vacía para almacenar la fecha de venta.
    String fechaVenta = "";

    // Recorre la lista de facturas buscando la factura correspondiente.
    for (var factura in facturas) {
      // Verifica si el número de pedido de la factura coincide con el buscado.
      if (factura.pedido.numeroPedido == numeroPedido) {
        // Obtiene la fecha de venta de la factura.
        fechaVenta = factura.fecha;
        // Salta el bucle para evitar buscar más facturas.
        break;
      }
    }

    // Devuelve la fecha de venta de la factura encontrada o una cadena vacía.
    return fechaVenta;
  }

  /// Obtiene el medio de pago de una factura dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la factura y una lista de
  /// facturas. Recorre la lista de facturas buscando la factura que
  /// corresponda al número de pedido especificado. Si encuentra una factura que
  /// coincide con el número de pedido, obtiene el medio de pago y la devuelve como
  /// una cadena. Si no encuentra ninguna factura que coincida, devuelve una
  /// cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la factura a buscar.
  /// - facturas: La lista de facturas en la que buscar la factura.
  ///
  /// Retorna:
  /// - Una cadena con el medio de pago de la factura encontrada, si se encuentra
  ///   una factura que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna factura que coincida con el
  ///   número de pedido.
  String medioVentaFactura(int numeroPedido, List<FacturaModel> facturas) {
    // Inicializa una cadena vacía para almacenar el medio de pago.
    String medioVenta = "";

    // Recorre la lista de facturas buscando la factura correspondiente.
    for (var factura in facturas) {
      // Verifica si el número de pedido de la factura coincide con el buscado.
      if (factura.pedido.numeroPedido == numeroPedido) {
        // Obtiene el medio de pago de la factura.
        medioVenta = factura.medioPago.nombre;
        // Salta el bucle para evitar buscar más facturas.
        break;
      }
    }

    // Devuelve el medio de pago de la factura encontrada o una cadena vacía.
    return medioVenta;
  }

  /// Obtiene el nombre del vendedor de una factura dada su número de pedido.
  ///
  /// El método recibe el número de pedido de la factura y una lista de facturas y
  /// de usuarios. Recorre la lista de facturas buscando la factura que
  /// corresponda al número de pedido especificado. Si encuentra una factura que
  /// coincide con el número de pedido, obtiene el usuario vendedor de la factura
  /// y devuelve su nombre como una cadena. Si no encuentra ninguna factura que
  /// coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - numeroPedido: El número de pedido de la factura a buscar.
  /// - usuarios: La lista de usuarios en la que buscar el usuario vendedor.
  /// - facturas: La lista de facturas en la que buscar la factura.
  ///
  /// Retorna:
  /// - Una cadena con el nombre del vendedor de la factura encontrada, si se
  ///   encuentra una factura que coincida con el número de pedido.
  /// - Una cadena vacía si no se encuentra ninguna factura que coincida con el
  ///   número de pedido.
  String nombreVendedor(int numeroPedido, List<UsuarioModel> usuarios,
      List<FacturaModel> facturas) {
    // Inicializa una cadena vacía para almacenar el nombre del vendedor.
    String vendedor = "";

    // Recorre la lista de facturas buscando la factura correspondiente.
    for (var factura in facturas) {
      // Verifica si el número de pedido de la factura coincide con el buscado.
      if (factura.pedido.numeroPedido == numeroPedido) {
        // Busca el usuario vendedor en la lista de usuarios.
        var usuario = usuarios
            .firstWhere((usuario) => usuario.id == factura.usuarioVendedor);
        // Obtiene el nombre del usuario vendedor.
        vendedor = "${usuario.nombres} ${usuario.apellidos}";
        // Salta el bucle para evitar buscar más facturas.
        break;
      }
    }

    // Devuelve el nombre del vendedor de la factura encontrada o una cadena vacía.
    return vendedor;
  }

  /// Crea un objeto [FacturaUsuarioDataGridSource] a partir de una lista de
  /// facturas y una lista de productos.
  ///
  FacturaUsuarioDataGridSource({
    required List<AuxPedidoModel> facturas,
    required List<ProductoModel> listaProductos,
    required List<FacturaModel> listaFacturas,
    required List<UsuarioModel> listaUsuarios,
  }) {
    _facturaData = facturas.map<DataGridRow>((factura) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Número',
            value:
                numeroVentaFactura(factura.pedido.numeroPedido, listaFacturas)),
        DataGridCell<String>(
            columnName: 'Usuario',
            value:
                "${factura.pedido.usuario.nombres} ${factura.pedido.usuario.apellidos}"),
        DataGridCell<int>(
            columnName: 'Número Pedido', value: factura.pedido.numeroPedido),
        DataGridCell<String>(
            columnName: 'Producto',
            value: productoNombre(factura.producto, listaProductos)),
        DataGridCell<String>(
            columnName: 'Fecha Venta',
            value:
                fechaVentaFactura(factura.pedido.numeroPedido, listaFacturas)),
        DataGridCell<int>(columnName: 'Valor Pedido', value: factura.precio),
        DataGridCell<String>(
            columnName: 'Medio Pago',
            value:
                medioVentaFactura(factura.pedido.numeroPedido, listaFacturas)),
        DataGridCell<String>(
            columnName: 'Vendedor',
            value: nombreVendedor(
                factura.pedido.numeroPedido, listaUsuarios, listaFacturas)),
      ]);
    }).toList();
  }

  /// Lista que almacena las filas de datos para la grilla.
  List<DataGridRow> _facturaData = [];

  /// Obtiene las filas de datos de la grilla.
  @override
  List<DataGridRow> get rows => _facturaData;

  // Retorna la lista de datos
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
                "assets/icons/pagos.svg",
                height: 30,
                width: 30,
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
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
              : Text(i == 5
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formateo de valores de moneda
                  : i == 4
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Formateo de fechas
                      : row.getCells()[i].value.toString()), // Celdas restantes
        ),
    ]);
  }
}
