// ignore_for_file: use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Dashboard/controllers/MenuAppController.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/modalsDashboard.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/main/main_screen_usuario.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/Punto/pdfFacturaPunto.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';
import 'package:tienda_app/responsive.dart';
import 'package:tienda_app/source.dart';
import 'package:http/http.dart' as http;

/// Esta clase representa un widget de estado que muestra una tabla de facturas de un punto de venta.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_FacturaPuntoState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [auxPedido] es una lista de objetos [AuxPedidoModel] que representan las facturas del punto de venta.
class FacturaPunto extends StatefulWidget {
  /// Lista de objetos [AuxPedidoModel] que representan las facturas del punto de venta.
  final List<AuxPedidoModel> auxPedido;

  final UsuarioModel usuario;

  /// Constructor de la clase [FacturaPunto].
  ///
  /// [auxPedido] es la lista de objetos [AuxPedidoModel] que representan las facturas del punto de venta.
  const FacturaPunto(
      {super.key, required this.auxPedido, required this.usuario});

  /// Sobrecarga del método [createState] que crea un estado [_FacturaPuntoState] para manejar los datos de la pantalla.
  @override
  State<FacturaPunto> createState() => _FacturaPuntoState();
}

class _FacturaPuntoState extends State<FacturaPunto> {
  /// Lista de objetos [AuxPedidoModel] que representan las facturas del punto de venta.
  List<AuxPedidoModel> _facturas = [];

  /// Lista de objetos [ProductoModel] que representan los productos disponibles.
  List<ProductoModel> listaProductos = [];

  /// Lista de objetos [FacturaModel] que representan las facturas.
  List<FacturaModel> listaFacturas = [];

  /// Lista de objetos [UsuarioModel] que representan los vendedores.
  List<UsuarioModel> listaUsuarios = [];

  /// Fuente de datos para la grilla de facturas.
  late FacturaPuntoDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Se llama cuando se inicia el estado.
  ///
  /// Carga los datos iniciales y establece la fuente de datos para la grilla de facturas.
  @override
  void initState() {
    super.initState();

    // Establece la fuente de datos con los datos iniciales
    _dataGridSource = FacturaPuntoDataGridSource(
        facturas: _facturas,
        listaProductos: listaProductos,
        listaFacturas: listaFacturas,
        listaUsuarios: listaUsuarios);

    // Establece las facturas con los datos recibidos
    _facturas = widget.auxPedido;

    // Carga los datos iniciales
    _loadData();
  }

  /// Carga los datos iniciales necesarios para la pantalla.
  ///
  /// Obtiene los productos y las facturas de la API y los asigna a las variables
  /// correspondientes. Luego, actualiza [_dataGridSource] en el siguiente frame
  /// de la interfaz de usuario.
  ///
  /// Primero, obtiene los productos de la API y los asigna a la variable
  /// [listaProductos].
  ///
  /// Luego, obtiene las facturas de la API y las asigna a la variable
  /// [listaFacturas].
  ///
  /// Finalmente, obtiene los vendedores de la API y los asigna a la variable
  /// [listaUsuarios].
  ///
  /// Despues, actualiza [_dataGridSource] en el siguiente frame de la interfaz
  /// de usuario.
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
      // Actualiza _dataGridSource en el siguiente frame de la interfaz de usuario
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _dataGridSource = FacturaPuntoDataGridSource(
              facturas: _facturas,
              listaProductos: listaProductos,
              listaFacturas: listaFacturas,
              listaUsuarios: listaUsuarios);
        });
      });
    }
  }

  /// Función asíncrona para crear devoluciones basadas en facturas seleccionadas.
  ///
  /// Esta función toma una lista de filas de [DataGrid] y crea devoluciones
  /// para cada factura seleccionada.
  ///
  /// El proceso de creación de devoluciones implica verificar si una factura ya
  /// tiene una devolución asociada, y en ese caso mostrar un mensaje de error.
  /// Si la factura no tiene una devolución asociada, se agrega la factura a
  /// la lista de devoluciones a crear.
  ///
  /// Una vez que se completa la lista de devoluciones a crear, se envían
  /// solicitudes PUT a la API para crear cada devolución.
  ///
  /// Si todas las solicitudes exitosas, se muestra un mensaje de éxito y se navega
  /// a la pantalla principal de usuario. Si alguna solicitud falla, se muestra un
  /// mensaje de error.
  Future crearDevolucion(List<DataGridRow> facturas) async {
    // Lista para almacenar las devoluciones a editar
    List<FacturaModel> devolucionCrear = [];
    String url;

    // Obtiene las devoluciones cargadas desde la API
    List<DevolucionesModel> devolucionesCargadas = await getDevoluciones();

    List<FacturaModel> facturasCargadas = await getFacturas();

    // Utilizamos un Set para almacenar los números de factura ya procesados
    Set<String> facturasProcesadas = {};

    // Variable para controlar si el mensaje ya ha sido mostrado
    bool mensajeMostrado = false;

    // Recorre cada fila seleccionada
    for (var fac in facturas) {
      // Obtiene el número de factura de la fila actual
      String numeroFactura = fac.getCells()[0].value;

      // Verificamos si la factura ya tiene una devolución
      bool tieneDevolucion = devolucionesCargadas.any((devolucion) =>
          devolucion.factura.numero.toString() == numeroFactura);

      if (tieneDevolucion) {
        if (!mensajeMostrado) {
          // Muestra un mensaje de error si la devolución ya ha sido procesada
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'No se puede crear una devolución que ya ha sido procesada.'),
            ),
          );
          // Marcamos que el mensaje ya ha sido mostrado
          mensajeMostrado = true;
        }
        return; // Sale de la función para evitar continuar con la operación
      } else {
        // Verificamos si el número de factura ya ha sido procesado
        for (var factura in facturasCargadas) {
          if (!facturasProcesadas.contains(numeroFactura) &&
              factura.numero.toString() == numeroFactura) {
            // Agrega la devolución a la lista de devoluciones a editar
            devolucionCrear.add(factura);
            // Agregamos el número de factura al Set
            facturasProcesadas.add(numeroFactura);
          }
        }
      }
    }

    // Variable para controlar el estado de las solicitudes
    bool allSuccessful = true;

    // Recorre la lista de devoluciones a editar
    for (var crear in devolucionCrear) {
      // Genera la URL de la solicitud PUT
      url = "$sourceApi/api/devoluciones/";

      // Define los encabezados de la solicitud
      final headers = {
        'Content-Type': 'application/json',
      };

      // Define el cuerpo de la solicitud
      final body = {
        "fecha": DateTime.now().toString(),
        "estado": false,
        "factura": crear.id
      };

      // Realiza la solicitud PUT
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode != 201) {
        allSuccessful = false;

        // Muestra un mensaje de error si la respuesta indica un error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear registros: ${response.statusCode}.'),
          ),
        );
      }
    }

    if (allSuccessful) {
      // Muestra un mensaje de éxito si la respuesta del servidor es exitosa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Devoluciones creadas correctamente.'),
        ),
      );

      // Navega a la pantalla principal de usuario
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => MenuAppController()),
            ],
            child: const MainScreenUsuario(),
          ),
        ),
      );
    }
  }

  /// Libera los recursos utilizados por el widget.
  ///
  /// Llamar a este método es obligatorio para liberar los recursos utilizados
  /// por el widget y evitar fugas de memoria.
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
            "Ventas",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Grilla de facturas
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
                // Columnas
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
          // Botón de imprimir y devolver venta
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
                            builder: (context) => PdfFacturaPuntoScreen(
                                usuario: widget.usuario, registro: registros)));
                  }
                }),
                const SizedBox(
                  width: defaultPadding,
                ),
                _buildButton('Devolver Venta', () {
                  if (registros.isEmpty) {
                    operacionFallidaModal(context);
                  } else {
                    crearDevolucion(registros);
                  }
                }),
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
                              builder: (context) => PdfFacturaPuntoScreen(
                                  usuario: widget.usuario,
                                  registro: registros)));
                    }
                  }),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  _buildButton('Devolver Venta', () {
                    if (registros.isEmpty) {
                      operacionFallidaModal(context);
                    } else {
                      crearDevolucion(registros);
                    }
                  }),
                ],
              ),
            ),
        ],
      ),
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
      width: 200,
      // Decoración del botón con bordes redondeados y gradiente de colores
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            botonClaro, // Color claro del gradiente.
            botonOscuro, // Color oscuro del gradiente.
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: botonSombra, // Color de la sombra.
            blurRadius: 5, // Radio de desfoque de la sombra.
            offset: Offset(0, 3), // Desplazamiento de la sombra.
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Color de fondo transparente
        child: InkWell(
          onTap: onPressed, // Función a ejecutar al presionar el botón
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10), // Padding vertical
            child: Center(
              child: Text(
                text, // Texto del botón
                style: const TextStyle(
                  color: background1, // Color del texto
                  fontSize: 13, // Tamaño de fuente
                  fontWeight: FontWeight.bold, // Fuente en negrita
                  fontFamily: 'Calibri-Bold', // Fuente Calibri
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Clase que define la fuente de datos de la tabla
class FacturaPuntoDataGridSource extends DataGridSource {
  /// Obtiene el número de venta de una factura dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la factura y una lista de
  /// facturas. Recorre la lista de facturas buscando la factura que
  /// corresponda al número de pedido especificado. Si encuentra una factura que
  /// coincide con el número de pedido, obtiene el número de venta de la factura
  /// y lo devuelve como una cadena. Si no encuentra ninguna factura que
  /// coincida, devuelve una cadena vacía.
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
    // Inicializa una cadena vacía para almacenar el número de venta.
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

  /// Obtiene el nombre de un producto dado su identificador.
  ///
  /// El método recibe el identificador del producto y una lista de productos.
  /// Recorre la lista de productos buscando el producto que coincide con el
  /// identificador especificado. Si encuentra un producto que coincide, obtiene
  /// el nombre del producto y lo devuelve como una cadena. Si no encuentra
  /// ningún producto que coincida, devuelve una cadena vacía.
  ///
  /// Parámetros:
  /// - productoAxiliar: El identificador del producto a buscar.
  /// - productos: La lista de productos en la que buscar el producto.
  ///
  /// Retorna:
  /// - Una cadena con el nombre del producto encontrado, si se encuentra un
  ///   producto que coincida con el identificador.
  /// - Una cadena vacía si no se encuentra ningún producto que coincida con el
  ///   identificador.
  String productoNombre(int productoAxiliar, List<ProductoModel> productos) {
    // Inicializa una cadena vacía para almacenar el nombre del producto.
    String productName = "";

    // Recorre la lista de productos buscando el producto correspondiente.
    for (var producto in productos) {
      // Verifica si el identificador del producto coincide con el buscado.
      if (producto.id == productoAxiliar) {
        // Obtiene el nombre del producto.
        productName = producto.nombre;
        // Detiene el bucle for y devuelve el nombre del producto.
        break;
      }
    }

    // Devuelve el nombre del producto encontrado o una cadena vacía.
    return productName;
  }

  /// Obtiene la fecha de venta de una factura dado su número de pedido.
  ///
  /// El método recibe el número de pedido de la factura y una lista de facturas.
  /// Recorre la lista de facturas buscando la factura que corresponda al
  /// número de pedido especificado. Si encuentra una factura que coincide con
  /// el número de pedido, obtiene la fecha de venta y la devuelve como una cadena.
  /// Si no encuentra ninguna factura que coincida, devuelve una cadena vacía.
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
  /// El método recibe el número de pedido de la factura y una lista de facturas.
  /// Recorre la lista de facturas buscando la factura que corresponda al
  /// número de pedido especificado. Si encuentra una factura que coincide con
  /// el número de pedido, obtiene el medio de pago y lo devuelve como una cadena.
  /// Si no encuentra ninguna factura que coincida, devuelve una cadena vacía.
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
        UsuarioModel? usuario = usuarios
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

  /// Crea una fuente de datos para la grilla de facturas.
  FacturaPuntoDataGridSource({
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

  // Lista de datos de la grilla.
  List<DataGridRow> _facturaData = [];

  // Celdas de la grilla.
  @override
  List<DataGridRow> get rows => _facturaData;

  // retorna los valores de las celdas
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
                  ? "\$${formatter.format(row.getCells()[i].value)}" // Formato de moneda
                  : i == 4
                      ? formatFechaHora(row
                          .getCells()[i]
                          .value
                          .toString()) // Formatea la fecha
                      : row.getCells()[i].value.toString()), // Celda normal
        ),
    ]);
  }
}
