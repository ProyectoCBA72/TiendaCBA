// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/auxPedidoModel.dart';
import 'package:tienda_app/Models/facturaModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class FacturaUsuario extends StatefulWidget {
  final List<AuxPedidoModel> auxPedido;
  const FacturaUsuario({super.key, required this.auxPedido});

  @override
  State<FacturaUsuario> createState() => _FacturaUsuarioState();
}

class _FacturaUsuarioState extends State<FacturaUsuario> {
  List<AuxPedidoModel> _facturas = [];
  List<ProductoModel> listaProductos = [];
  List<FacturaModel> listaFacturas = [];

  late FacturaUsuarioDataGridSource _dataGridSource;

  @override
  void initState() {
    super.initState();
    _dataGridSource = FacturaUsuarioDataGridSource(
        facturas: _facturas,
        listaProductos: listaProductos,
        listaFacturas: listaFacturas);
    _facturas = widget.auxPedido;
    _loadData();
  }

  Future<void> _loadData() async {
    List<ProductoModel> productosCargados = await getProductos();
    List<FacturaModel> facturasCargadas = await getFacturas();

    setState(() {
      listaProductos = productosCargados;
      listaFacturas = facturasCargadas;

      // Ahora inicializa _dataGridSource después de cargar los datos
      _dataGridSource = FacturaUsuarioDataGridSource(
          facturas: _facturas,
          listaProductos: listaProductos,
          listaFacturas: listaFacturas);
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

class FacturaUsuarioDataGridSource extends DataGridSource {
  String numeroVentaFactura(int numeroPedido, List<FacturaModel> facturas) {
    String numeroVenta = "";

    for (var factura in facturas) {
      if (factura.pedido.numeroPedido == numeroPedido) {
        numeroVenta = factura.numero.toString();
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

  String fechaVentaFactura(int numeroPedido, List<FacturaModel> facturas) {
    String fechaVenta = "";

    for (var factura in facturas) {
      if (factura.pedido.numeroPedido == numeroPedido) {
        fechaVenta = factura.fecha;
      }
    }

    return fechaVenta;
  }

  String medioVentaFactura(int numeroPedido, List<FacturaModel> facturas) {
    String medioVenta = "";

    for (var factura in facturas) {
      if (factura.pedido.numeroPedido == numeroPedido) {
        medioVenta = factura.medioPago.nombre;
      }
    }

    return medioVenta;
  }

  FacturaUsuarioDataGridSource({
    required List<AuxPedidoModel> facturas,
    required List<ProductoModel> listaProductos,
    required List<FacturaModel> listaFacturas,
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
      ]);
    }).toList();
  }

  List<DataGridRow> _facturaData = [];

  @override
  List<DataGridRow> get rows => _facturaData;

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
                  ? "\$${formatter.format(row.getCells()[i].value)}"
                  : i == 4
                      ? "${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).day)}-${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).month)}-${DateTime.parse(row.getCells()[i].value.toString()).year.toString()} ${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).hour)}:${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).minute)}"
                      : row.getCells()[i].value.toString()),
        ),
    ]);
  }
}
