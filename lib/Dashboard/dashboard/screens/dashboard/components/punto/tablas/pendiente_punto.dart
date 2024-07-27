// ignore_for_file: use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Dashboard/controllers/MenuAppController.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/modalsDashboard.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/punto/metodoForm.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/main/main_screen_usuario.dart';
import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/pedidoModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/Punto/pdfPendientePunto.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';
import 'package:tienda_app/pdf/pdf_constancia_factura_screen.dart';
import 'package:tienda_app/responsive.dart';
import 'package:tienda_app/source.dart';
import 'package:http/http.dart' as http;

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

  final UsuarioModel usuario;

  /// Crea un nuevo objeto [PendientePunto].
  ///
  /// El parámetro [auxPedido] es obligatorio y representa los pedidos pendientes del punto de venta.
  const PendientePunto(
      {super.key, required this.auxPedido, required this.usuario});

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

  List<DataGridRow> registros = [];

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
    )..eliminarProductoCallback =
        (AuxPedidoModel producto) => _removeProducto(producto);

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

    if (mounted) {
      // Actualiza _dataGridSource en el siguiente frame de la interfaz de usuario
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Inicializa _dataGridSource con los datos de los pedidos, productos y puntos de venta
          _dataGridSource = PendientePuntoDataGridSource(
            pedidos: _pedidos,
            listaProductos: listaProductos,
            listaPuntosVenta: listaPuntosVenta,
          )..eliminarProductoCallback =
              (AuxPedidoModel producto) => _removeProducto(producto);
        });
      });
    }
  }

  /// Cancela los pedidos seleccionados.
  ///
  /// Esta función toma una lista de filas de [DataGrid] y cancela cada pedido
  /// correspondiente. Primero, verifica si alguna devolución ya ha sido
  /// procesada y si no es así, continua con la operación. Luego, recorre la lista
  /// de devoluciones a editar y realiza una solicitud PUT para cada una de ellas.
  /// Si todas las solicitudes son exitosas, muestra un mensaje de éxito y navega
  /// a la pantalla principal de usuario. Si alguna solicitud falla, muestra un
  /// mensaje de error.
  Future cancelarPedido(List<DataGridRow> pedidos) async {
    // Lista para almacenar las devoluciones a editar
    List<PedidoModel> pedidoCancelado = [];
    String url;

    // Obtiene las devoluciones cargadas desde la API
    List<PedidoModel> pedidosCargados = await getPedidos();

    // Utilizamos un Set para almacenar los números de factura ya procesados
    Set<String> pedidosProcesados = {};

    // Verificación inicial para determinar si alguna devolución ya ha sido procesada
    for (var ped in pedidos) {
      // Obtiene el número de factura de la fila actual
      String numeroPedido = ped.getCells()[0].value;

      // Si ninguna devolución ya ha sido procesada, continuar con la operación
      for (var pedido in pedidosCargados) {
        if (!pedidosProcesados.contains(numeroPedido) &&
            numeroPedido == pedido.numeroPedido.toString()) {
          // Agrega la devolución a la lista de devoluciones a editar
          pedidoCancelado.add(pedido);
          // Agregamos el número de factura al Set
          pedidosProcesados.add(numeroPedido);
        }
      }
    }

    // Variable para controlar el estado de las solicitudes
    bool allSuccessful = true;

    // Recorre la lista de devoluciones a editar
    for (var cancelado in pedidoCancelado) {
      // Genera la URL de la solicitud PUT
      url = "$sourceApi/api/pedidos/${cancelado.id}/";

      // Define los encabezados de la solicitud
      final headers = {
        'Content-Type': 'application/json',
      };

      // Define el cuerpo de la solicitud
      final body = {
        "numeroPedido": cancelado.numeroPedido,
        "fechaEncargo": cancelado.fechaEncargo,
        "fechaEntrega": cancelado.fechaEntrega,
        "grupal": cancelado.grupal,
        "estado": "CANCELADO",
        "entregado": cancelado.entregado,
        "puntoVenta": cancelado.puntoVenta,
        "pedidoConfirmado": cancelado.pedidoConfirmado,
        "usuario": cancelado.usuario.id
      };

      // Realiza la solicitud PUT
      final response = await http.put(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      // Si la solicitud falla, marcamos allSuccessful como false
      if (response.statusCode != 200) {
        allSuccessful = false;

        // Muestra un mensaje de error si la respuesta indica un error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al editar registros: ${response.statusCode}.'),
          ),
        );
      }
    }

    // Si todas las solicitudes fueron exitosas
    if (allSuccessful) {
      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedidos actualizados correctamente.'),
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

  Future<void> entregarPedido(List<DataGridRow> pedidos) async {
    // Lista para almacenar las devoluciones a editar
    List<PedidoModel> pedidoEntregado = [];
    String url;

    // Obtiene las devoluciones cargadas desde la API
    List<PedidoModel> pedidosCargados = await getPedidos();
    List<FacturaModel> facturasCargadas = await getFacturas();

    // Utilizamos un Set para almacenar los números de pedido ya procesados
    Set<String> pedidosProcesados = {};

    // Contadores para verificar el estado de facturación
    int facturados = 0;
    int sinFacturar = 0;

    // Iterar sobre los pedidos para verificar el estado de facturación
    for (var ped in pedidos) {
      String numeroPedido = ped.getCells()[0].value.toString();

      bool facturado = facturasCargadas.any(
          (factura) => numeroPedido == factura.pedido.numeroPedido.toString());

      if (facturado) {
        facturados++;
      } else {
        sinFacturar++;
      }
    }

    // Evaluar los tres casos posibles
    if (facturados == pedidos.length) {
      for (var ped in pedidos) {
        // Obtiene el número de factura de la fila actual
        String numeroPedido = ped.getCells()[0].value;

        // Si ninguna devolución ya ha sido procesada, continuar con la operación
        for (var pedido in pedidosCargados) {
          if (!pedidosProcesados.contains(numeroPedido) &&
              numeroPedido == pedido.numeroPedido.toString()) {
            // Agrega la devolución a la lista de devoluciones a editar
            pedidoEntregado.add(pedido);
            // Agregamos el número de factura al Set
            pedidosProcesados.add(numeroPedido);
          }
        }

        // Variable para controlar el estado de las solicitudes
        bool allSuccessful = true;

        // Recorre la lista de devoluciones a editar
        for (var entregado in pedidoEntregado) {
          // Genera la URL de la solicitud PUT
          url = "$sourceApi/api/pedidos/${entregado.id}/";

          // Define los encabezados de la solicitud
          final headers = {
            'Content-Type': 'application/json',
          };

          // Define el cuerpo de la solicitud
          final body = {
            "numeroPedido": entregado.numeroPedido,
            "fechaEncargo": entregado.fechaEncargo,
            "fechaEntrega": entregado.fechaEntrega,
            "grupal": entregado.grupal,
            "estado": "COMPLETADO",
            "entregado": true,
            "puntoVenta": entregado.puntoVenta,
            "pedidoConfirmado": entregado.pedidoConfirmado,
            "usuario": entregado.usuario.id
          };

          // Realiza la solicitud PUT
          final response = await http.put(Uri.parse(url),
              headers: headers, body: jsonEncode(body));

          // Si la solicitud falla, marcamos allSuccessful como false
          if (response.statusCode != 200) {
            allSuccessful = false;

            // Muestra un mensaje de error si la respuesta indica un error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Error al editar registros: ${response.statusCode}.'),
              ),
            );
          }
        }

        // Si todas las solicitudes fueron exitosas
        if (allSuccessful) {
          // Muestra un mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pedidos actualizados correctamente.'),
            ),
          );

          // Navega a la pantalla principal de usuario
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (context) => MenuAppController()),
                ],
                child: const MainScreenUsuario(),
              ),
            ),
          );
        }
      }
      // Aquí puedes agregar la lógica para cuando todos los pedidos están facturados
    } else if (sinFacturar == pedidos.length) {
      metodoModal(context, pedidos);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'No se puede realizar la entrega porque hay pedidos pendientes de facturación.'),
        ),
      );
    }
  }

  Future<void> _removeProducto(AuxPedidoModel producto) async {
    // Obtén los pedidos auxiliares cargados desde la API
    List<AuxPedidoModel> auxPedidosCargados = await getAuxPedidos();

    // Contar cuántos productos hay en el pedido especificado
    int contadorProductos = auxPedidosCargados
        .where((aux) => aux.pedido.numeroPedido == producto.pedido.numeroPedido)
        .length;

    if (contadorProductos > 1) {
      // Construir la URL para eliminar el aux pedido especificado
      final url = Uri.parse('$sourceApi/api/aux-pedidos/${producto.id}/');

      // Realizar la solicitud DELETE al API
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Verificar el estado de la respuesta de la solicitud
      if (response.statusCode == 204) {
        // Si la respuesta es exitosa (código 204), mostrar un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto eliminado con éxito.'),
          ),
        );

        // Navegar a la pantalla principal de usuario
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                    create: (context) => MenuAppController()),
              ],
              child: const MainScreenUsuario(),
            ),
          ),
        );
      } else {
        // Si la respuesta no es exitosa, mostrar un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar el producto: ${response.body}.'),
          ),
        );
      }
    } else {
      // Si el contador de productos es 1 o menos, llamar a la función de modal para manejo de error
      eliminacionFallidaModal(context);
    }
  }

  Future<void> crearFactura(int medioPago, List<DataGridRow> pedidos) async {
    // Lista para almacenar las devoluciones a editar
    List<PedidoModel> pedidoEntregado = [];
    String url;
    String url2;

    // Obtiene las devoluciones cargadas desde la API
    List<PedidoModel> pedidosCargados = await getPedidos();
    List<FacturaModel> facturasCargadas = await getFacturas();

    // Utilizamos un Set para almacenar los números de pedido ya procesados
    Set<String> pedidosProcesados = {};

    dynamic facturaId;

    // Itera sobre cada pedido en la lista proporcionada
    for (var ped in pedidos) {
      // Obtiene el número de pedido de la fila actual
      String numeroPedido = ped.getCells()[0].value;

      // Verifica si el pedido ya ha sido procesado
      for (var pedido in pedidosCargados) {
        if (!pedidosProcesados.contains(numeroPedido) &&
            numeroPedido == pedido.numeroPedido.toString()) {
          // Agrega el pedido a la lista de devoluciones a editar
          pedidoEntregado.add(pedido);
          // Marca el número de pedido como procesado
          pedidosProcesados.add(numeroPedido);
        }
      }

      // Obtener el último número de factura generado
      String ultimoNumeroFactura = facturasCargadas.isEmpty
          ? '01000'
          : facturasCargadas
              .map((factura) => int.parse(factura.numero.toString()))
              .reduce((a, b) => a > b ? a : b)
              .toString();

      // Genera el nuevo número de factura incrementando el último número en uno
      String nuevoNumeroFactura =
          (int.parse(ultimoNumeroFactura) + 1).toString().padLeft(5, '0');

      // Variable para controlar el estado de las solicitudes
      bool allSuccessful = true;

      // Recorre la lista de devoluciones a editar
      for (var entregado in pedidoEntregado) {
        // Genera la URL para actualizar el pedido
        url = "$sourceApi/api/pedidos/${entregado.id}/";

        // Genera la URL para crear la factura
        url2 = "$sourceApi/api/facturas/";

        // Define los encabezados de la solicitud
        final headers = {
          'Content-Type': 'application/json',
        };

        // Define el cuerpo de la solicitud PUT para actualizar el pedido
        final body = {
          "numeroPedido": entregado.numeroPedido,
          "fechaEncargo": entregado.fechaEncargo,
          "fechaEntrega": entregado.fechaEntrega,
          "grupal": entregado.grupal,
          "estado": "COMPLETADO",
          "entregado": true,
          "puntoVenta": entregado.puntoVenta,
          "pedidoConfirmado": entregado.pedidoConfirmado,
          "usuario": entregado.usuario.id
        };

        // Define el cuerpo de la solicitud POST para crear la factura
        final body2 = {
          "numero": nuevoNumeroFactura,
          "fecha": DateTime.now().toString(),
          "usuarioVendedor": widget.usuario.id,
          "medioPago": medioPago,
          "pedido": entregado.id
        };

        // Realiza la solicitud PUT para actualizar el pedido
        final response = await http.put(Uri.parse(url),
            headers: headers, body: jsonEncode(body));

        // Realiza la solicitud POST para crear la factura
        final response2 = await http.post(Uri.parse(url2),
            headers: headers, body: jsonEncode(body2));

        // Si alguna de las solicitudes falla, marca la operación como fallida
        if (response.statusCode != 200 && response2.statusCode != 201) {
          allSuccessful = false;

          // Muestra un mensaje de error si la respuesta indica un error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Error al editar registros: ${response.statusCode}.'),
            ),
          );
        }

        // Extrae el ID de la factura creada desde la respuesta
        final responseBody = jsonDecode(response2.body);
        facturaId =
            responseBody['id']; // Asegúrate de que 'id' es el campo correcto
      }

      // Si todas las solicitudes fueron exitosas, muestra el modal de confirmación de pago
      if (allSuccessful) {
        pagoConfirmadoModal(context, facturaId);
      }
    }
  }

  Future<void> crearRecibo(int facturaId) async {
    // Cargar datos necesarios desde la API
    List<FacturaModel> facturasCargadas =
        await getFacturas(); // Obtiene todas las facturas
    List<UsuarioModel> usuariosCargados =
        await getUsuarios(); // Obtiene todos los usuarios
    List<AuxPedidoModel> pedidosCargados =
        await getAuxPedidos(); // Obtiene todos los pedidos auxiliares
    List<ProductoModel> productosCargados =
        await getProductos(); // Obtiene todos los productos

    // Lista para almacenar las filas del DataGrid
    List<DataGridRow> filasRecibo = [];

    // Buscar la factura específica usando el ID proporcionado
    FacturaModel facturaSeleccionada =
        facturasCargadas.firstWhere((f) => f.id == facturaId);

    // Buscar el usuario que hizo el pedido en la factura
    UsuarioModel usuarioFactura = usuariosCargados
        .firstWhere((u) => u.id == facturaSeleccionada.pedido.usuario.id);

    // Buscar el vendedor asociado a la factura
    UsuarioModel vendedor = usuariosCargados
        .firstWhere((u) => u.id == facturaSeleccionada.usuarioVendedor);

    // Buscar los pedidos asociados a la factura seleccionada
    List<AuxPedidoModel> pedidosFactura = pedidosCargados
        .where((p) => p.pedido.id == facturaSeleccionada.pedido.id)
        .toList();

    // Iterar sobre los pedidos asociados para crear las filas del recibo
    for (var pedido in pedidosFactura) {
      // Buscar el producto asociado al pedido
      ProductoModel producto =
          productosCargados.firstWhere((p) => p.id == pedido.producto);

      // Crear una fila de DataGridRow con los detalles del recibo
      filasRecibo.add(DataGridRow(cells: [
        DataGridCell(
            columnName: 'Número',
            value: facturaSeleccionada.numero), // Número de la factura
        DataGridCell(
            columnName: 'Usuario',
            value:
                "${usuarioFactura.nombres} ${usuarioFactura.apellidos}"), // Nombre del usuario
        DataGridCell(
            columnName: 'Número Pedido',
            value: pedido.pedido.numeroPedido), // Número del pedido
        DataGridCell(
            columnName: 'Producto',
            value: producto.nombre), // Nombre del producto
        DataGridCell(
            columnName: 'Fecha Venta',
            value: facturaSeleccionada.fecha
                .toString()), // Fecha de venta de la factura
        DataGridCell(
            columnName: 'Valor Pedido',
            value: pedido.precio), // Precio del pedido
        DataGridCell(
            columnName: 'Medio Pago',
            value: facturaSeleccionada
                .medioPago.nombre), // Medio de pago utilizado
        DataGridCell(
            columnName: 'Vendedor',
            value:
                "${vendedor.nombres} ${vendedor.apellidos}"), // Nombre del vendedor
      ]));

      // Debug: Verificar fila añadida
    }

    // Debug: Verificar todas las filas añadidas

    // Navega a la pantalla de PDF con la lista de filasRecibo
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => PdfConstanciaFacturaScreen(
          usuario: usuarioFactura, // Usuario relacionado con la factura
          registro: filasRecibo, // Lista de filas del recibo
        ),
      ),
    );
  }

  /// Se llama automáticamente cuando se elimina el widget.
  ///
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por el
  /// widget.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos
  /// adicionales.
  @override
  void dispose() {
    // Llama al método [dispose] del widget base para liberar recursos
    // adicionales.
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
                _buildButton('Imprimir Reporte', () {
                  if (registros.isEmpty) {
                    noHayPDFModal(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfPendientePuntoScreen(
                                usuario: widget.usuario, registro: registros)));
                  }
                }),
                const SizedBox(
                  width: defaultPadding,
                ),
                _buildButton('Entregar Pedido', () {
                  if (registros.isEmpty) {
                    operacionFallidaModal(context);
                  } else {
                    entregarPedido(registros);
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
                              builder: (context) => PdfPendientePuntoScreen(
                                  usuario: widget.usuario,
                                  registro: registros)));
                    }
                  }),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  _buildButton('Entregar Pedido', () {
                    if (registros.isEmpty) {
                      operacionFallidaModal(context);
                    } else {
                      entregarPedido(registros);
                    }
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
                _buildButton('Cancelar Pedido', () {
                  if (registros.isEmpty) {
                    operacionFallidaModal(context);
                  } else {
                    cancelarPedido(registros);
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra un diálogo para seleccionar el método de pago.
  ///
  /// Este método muestra un diálogo con un formulario para seleccionar el método de pago.
  /// Luego, cuando el usuario acepta la opción "Finalizar Entrega", se cierra el diálogo
  /// y se muestra otro diálogo para confirmar el pago.
  ///
  /// [context] es el contexto de la aplicación donde se mostrará el diálogo.
  void metodoModal(BuildContext context, List<DataGridRow> pedidos) {
    int? seleccionarMetodoPago;

    void handleSelectedItemChanged(int? value) {
      setState(() {
        seleccionarMetodoPago = value;
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Método de pago"), // Título del diálogo
          content: MetodoForm(
            onSelectedItemChanged: handleSelectedItemChanged,
          ), // Contenido del diálogo (formulario para seleccionar el método de pago)
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

                    if (seleccionarMetodoPago == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Por favor, seleccione un mecanismo de pago.'),
                        ),
                      );
                    } else {
                      crearFactura(seleccionarMetodoPago!, pedidos);
                    }
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
  void pagoConfirmadoModal(BuildContext context, int facturaID) {
    showDialog(
      barrierDismissible: false,
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
                    // Al hacer clic en "Imprimir Recibo"
                    crearRecibo(facturaID);
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Ir al inicio", () {
                    // Al hacer clic en "Ir al inicio", se navega al inicio de la aplicación
                    Navigator.pushReplacement(
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
}

void eliminacionFallidaModal(BuildContext context) {
  // Muestra el diálogo modal para confirmar la eliminación de la asistencia
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // Título del diálogo
        title: const Text(
          "¡La eliminación del producto falló!",
          textAlign: TextAlign.center,
        ),
        // Contenido del diálogo
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Mensaje informativo para el usuario
            const Text(
              "No se puede eliminar este producto ya que es el único en este pedido. Se recomienda cancelar el pedido.",
              textAlign: TextAlign.center,
            ),
            // Espaciado entre el texto y la imagen
            const SizedBox(
              height: 10,
            ),
            // Muestra una imagen circular del logo de la aplicación
            ClipOval(
              child: Container(
                width: 100, // Ajusta el tamaño según sea necesario
                height: 100, // Ajusta el tamaño según sea necesario
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor, // Color de fondo del contenedor
                ),
                child: Image.asset(
                  "assets/img/logo.png",
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
            ),
          ],
        ),
        // Botones de acción dentro del diálogo
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                // Construye un botón con los estilos de diseño especificados
                child: _buildButton("Aceptar", () {
                  // Cierra el diálogo cuando se hace clic en el botón de aceptar
                  Navigator.pop(context);
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
              onPressed: () {
                eliminarProductoCallback?.call(pedido);
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primaryColor)),
              child: const Text("Eliminar Producto"),
            )),
      ]);
    }).toList();
  }

  // Lista de pedidos
  List<DataGridRow> _pedidoData = [];

  // Callback para eliminar boleta
  void Function(AuxPedidoModel)? eliminarProductoCallback;

  // Obtiene la lista de pedidos
  @override
  List<DataGridRow> get rows => _pedidoData;

  // Retorna los valores de las celdas
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
