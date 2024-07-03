// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class ProduccionLider extends StatefulWidget {
  final List<ProduccionModel> producciones;
  const ProduccionLider({super.key, required this.producciones});

  @override
  State<ProduccionLider> createState() => _ProduccionLiderState();
}

class _ProduccionLiderState extends State<ProduccionLider> {
  List<ProduccionModel> _producciones = [];
  List<ProductoModel> listaProductos = [];

  late ProduccionLiderDataGridSource _dataGridSource;

  @override
  void initState() {
    super.initState();
    _dataGridSource = ProduccionLiderDataGridSource(
        producciones: _producciones, listaProductos: listaProductos);
    _producciones = widget.producciones;
    _loadData();
  }

  Future<void> _loadData() async {
    List<ProductoModel> productosCargados = await getProductos();

    listaProductos = productosCargados;

    // Ahora inicializa _dataGridSource después de cargar los datos
    _dataGridSource = ProduccionLiderDataGridSource(
        producciones: _producciones, listaProductos: listaProductos);
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
            "Producciones",
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

class ProduccionLiderDataGridSource extends DataGridSource {
  String productoNombre(int productoId, List<ProductoModel> productos) {
    String productName = "";

    for (var producto in productos) {
      if (producto.id == productoId) {
        productName = producto.nombre;
        break;
      }
    }

    return productName;
  }

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

  List<DataGridRow> _produccionData = [];

  @override
  List<DataGridRow> get rows => _produccionData;

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
                  ? "\$${formatter.format(row.getCells()[i].value)}"
                  : i == 4 || i == 5 || i == 7
                      ? "${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).day)}-${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).month)}-${DateTime.parse(row.getCells()[i].value.toString()).year.toString()} ${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).hour)}:${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).minute)}"
                      : row.getCells()[i].value.toString()),
        ),
    ]);
  }
}
