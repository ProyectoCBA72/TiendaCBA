// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/inventarioModel.dart';
import 'package:tienda_app/Models/produccionModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class BodegaLider extends StatefulWidget {
  final List<InventarioModel> inventarioLista;
  const BodegaLider({super.key, required this.inventarioLista});

  @override
  State<BodegaLider> createState() => _BodegaLiderState();
}

class _BodegaLiderState extends State<BodegaLider> {
  List<InventarioModel> _bodegas = [];
  List<ProduccionModel> listaProducciones = [];

  late BodegaLiderDataGridSource _dataGridSource;

  @override
  void initState() {
    super.initState();
    _dataGridSource = BodegaLiderDataGridSource(
        bodegas: _bodegas, listaProducciones: listaProducciones);
    _bodegas = widget.inventarioLista;
    _loadData();
  }

  Future<void> _loadData() async {
    List<ProduccionModel> produccionesCargadas = await getProducciones();

    listaProducciones = produccionesCargadas;

    // Ahora inicializa _dataGridSource después de cargar los datos
    _dataGridSource = BodegaLiderDataGridSource(
        bodegas: _bodegas, listaProducciones: listaProducciones);
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
            "Inventario",
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
          Center(
            child: Column(
              children: [
                _buildButton('Imprimir Reporte', () {}),
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

class BodegaLiderDataGridSource extends DataGridSource {
  String numeroProduccionInventario(
      int produccionId, List<ProduccionModel> producciones) {
    String produccionNumero = "";

    for (var produccion in producciones) {
      if (produccion.id == produccionId) {
        produccionNumero = produccion.numero.toString();
        break;
      }
    }

    return produccionNumero;
  }

  String unidadProduccionInventario(
      int produccionId, List<ProduccionModel> producciones) {
    String produccionUnidad = "";

    for (var produccion in producciones) {
      if (produccion.id == produccionId) {
        produccionUnidad = produccion.unidadProduccion.nombre;
        break;
      }
    }

    return produccionUnidad;
  }

  String cantidadProduccionInventario(
      int produccionId, List<ProduccionModel> producciones) {
    String produccionCantidad = "";

    for (var produccion in producciones) {
      if (produccion.id == produccionId) {
        produccionCantidad = produccion.cantidad.toString();
        break;
      }
    }

    return produccionCantidad;
  }

  BodegaLiderDataGridSource(
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

  List<DataGridRow> _bodegaData = [];

  @override
  List<DataGridRow> get rows => _bodegaData;

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
                  ? "${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).day)}-${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).month)}-${DateTime.parse(row.getCells()[i].value.toString()).year.toString()} ${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).hour)}:${twoDigits(DateTime.parse(row.getCells()[i].value.toString()).minute)}"
                  : row.getCells()[i].value.toString()),
        ),
    ]);
  }
}
