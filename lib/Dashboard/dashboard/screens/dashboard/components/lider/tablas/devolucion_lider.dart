// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/devolucionesModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class DevolucionLider extends StatefulWidget {
  final List<AuxPedidoModel> auxPedido;
  const DevolucionLider({super.key, required this.auxPedido});

  @override
  State<DevolucionLider> createState() => _DevolucionLiderState();
}

class _DevolucionLiderState extends State<DevolucionLider> {
  List<AuxPedidoModel> _devoluciones = [];
  List<ProductoModel> listaProductos = [];
  List<DevolucionesModel> listaDevoluciones = [];

  late DevolucionLiderDataGridSource _dataGridSource;

  @override
  void initState() {
    super.initState();
    _dataGridSource = DevolucionLiderDataGridSource(
        devoluciones: _devoluciones,
        listaProductos: listaProductos,
        listaDevoluciones: listaDevoluciones);
    _devoluciones = widget.auxPedido;
    _loadData();
  }

  Future<void> _loadData() async {
    List<ProductoModel> productosCargados = await getProductos();
    List<DevolucionesModel> devolucionesCargadas = await getDevoluciones();

    listaProductos = productosCargados;
    listaDevoluciones = devolucionesCargadas;

    // Ahora inicializa _dataGridSource después de cargar los datos
    _dataGridSource = DevolucionLiderDataGridSource(
        devoluciones: _devoluciones,
        listaProductos: listaProductos,
        listaDevoluciones: listaDevoluciones);
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
          Text(
            "Devoluciones",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
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
                source: _dataGridSource,
                selectionMode: SelectionMode.multiple,
                showCheckboxColumn: true,
                allowSorting: true,
                allowFiltering: true,
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'Número Venta',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Número Venta'),
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
                    columnName: 'Fecha Devolución',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha Devolución'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Estado Devolución',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Estado Devolución'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
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

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            botonClaro,
            botonOscuro,
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: botonSombra,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: background1,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Calibri-Bold',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DevolucionLiderDataGridSource extends DataGridSource {
  String numeroVentaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    String numeroVenta = "";

    for (var devolucion in devoluciones) {
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        numeroVenta = devolucion.factura.numero.toString();
      }
    }

    return numeroVenta;
  }

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

  String fechaVentaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    String fechaVenta = "";

    for (var devolucion in devoluciones) {
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        fechaVenta = devolucion.factura.fecha;
      }
    }

    return fechaVenta;
  }

  String medioVentaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    String medioVenta = "";

    for (var devolucion in devoluciones) {
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        medioVenta = devolucion.factura.medioPago.nombre;
      }
    }

    return medioVenta;
  }

  String fechaDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    String fechaDevolucion = "";

    for (var devolucion in devoluciones) {
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        fechaDevolucion = devolucion.fecha;
      }
    }

    return fechaDevolucion;
  }

  bool estadoDevolucion(
      int numeroPedido, List<DevolucionesModel> devoluciones) {
    bool estadoDevolucion = false;

    for (var devolucion in devoluciones) {
      if (devolucion.factura.pedido.numeroPedido == numeroPedido) {
        estadoDevolucion = devolucion.estado;
      }
    }

    return estadoDevolucion;
  }

  DevolucionLiderDataGridSource({
    required List<AuxPedidoModel> devoluciones,
    required List<ProductoModel> listaProductos,
    required List<DevolucionesModel> listaDevoluciones,
  }) {
    _devolucionData = devoluciones.map<DataGridRow>((devolucion) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Número Venta',
            value: numeroVentaDevolucion(
                devolucion.pedido.numeroPedido, listaDevoluciones)),
        DataGridCell<String>(
            columnName: 'Usuario',
            value:
                "${devolucion.pedido.usuario.nombres} ${devolucion.pedido.usuario.apellidos}"),
        DataGridCell<int>(
            columnName: 'Número Pedido', value: devolucion.pedido.numeroPedido),
        DataGridCell<String>(
            columnName: 'Producto',
            value: productoNombre(devolucion.producto, listaProductos)),
        DataGridCell<String>(
            columnName: 'Fecha Venta',
            value: fechaVentaDevolucion(
                devolucion.pedido.numeroPedido, listaDevoluciones)),
        DataGridCell<int>(columnName: 'Valor Pedido', value: devolucion.precio),
        DataGridCell<String>(
            columnName: 'Medio Pago',
            value: medioVentaDevolucion(
                devolucion.pedido.numeroPedido, listaDevoluciones)),
        DataGridCell<String>(
            columnName: 'Fecha Devolución',
            value: fechaDevolucion(
                devolucion.pedido.numeroPedido, listaDevoluciones)),
        DataGridCell<String>(
            columnName: 'Estado Devolución',
            value: estadoDevolucion(
                    devolucion.pedido.numeroPedido, listaDevoluciones)
                ? "Cancelado"
                : "Pendiente"),
      ]);
    }).toList();
  }

  List<DataGridRow> _devolucionData = [];

  @override
  List<DataGridRow> get rows => _devolucionData;

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
                "assets/icons/pagos.svg",
                height: 30,
                width: 30,
                colorFilter:
                    const ColorFilter.mode(Colors.deepPurple, BlendMode.srcIn),
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
                  ? "\$${formatter.format(row.getCells()[i].value)}"
                  : i == 4 || i == 7
                      ? "${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).day)}-${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).month)}-${DateTime.parse(row.getCells()[i].value.toString()).year.toString()} ${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).hour)}:${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).minute)}"
                      : row.getCells()[i].value.toString()),
        ),
    ]);
  }
}
