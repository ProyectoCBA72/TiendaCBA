// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/components/lider/csvScreen.dart';
import 'package:tienda_app/EditarUsuario/editarUsuario.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';

/// Esta clase representa un widget de estado que muestra una tabla de usuarios.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_UsuarioLiderState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [usuarioLista] es una lista de objetos [UsuarioModel] que representan los usuarios a mostrar.
class UsuarioLider extends StatefulWidget {
  /// Lista de usuarios a mostrar en la tabla.
  ///
  /// Esta lista debe contener objetos [UsuarioModel] que representan los
  /// usuarios a mostrar en la tabla.
  final List<UsuarioModel> usuarioLista;

  /// Constructor de la clase [UsuarioLider].
  ///
  /// El parámetro [usuarioLista] es requerido y debe contener una lista de
  /// objetos [UsuarioModel] que representan los usuarios a mostrar en la tabla.
  const UsuarioLider({super.key, required this.usuarioLista});

  /// Crea el estado de la clase [UsuarioLider].
  ///
  /// Este método es obligatorio y debe crear un estado de la clase
  /// [_UsuarioLiderState] para manejar los datos de la pantalla.
  @override
  State<UsuarioLider> createState() => _UsuarioLiderState();
}

class _UsuarioLiderState extends State<UsuarioLider> {
  /// Lista de objetos [UsuarioModel] que representan los usuarios a mostrar en la tabla.
  ///
  /// Esta lista se utiliza para almacenar los usuarios a mostrar en la tabla.
  List<UsuarioModel> _usuarios = [];

  /// Instancia de [UsuarioDataGridSource] que representa la fuente de datos para la tabla.
  ///
  /// Esta instancia se utiliza para manejar los datos de la tabla y proporcionar
  /// los datos necesarios para mostrar la tabla en la pantalla.
  late UsuarioDataGridSource _dataGridSource;

  /// Lista de objetos [UsuarioModel] que representan los usuarios a mostrar en la tabla.
  ///
  /// Esta lista es privada y solo se puede acceder a través de la propiedad [usuarios].
  /// La lista se inicializa vacía y se rellena en el método [initState].

  @override

  /// Inicializa el estado de la clase [_UsuarioLiderState].
  ///
  /// Este método se llama cuando se crea una instancia de [_UsuarioLiderState] y se
  /// utiliza para inicializar los datos necesarios para mostrar la tabla de usuarios.
  /// En este caso, se inicializa la lista [_usuarios] con los usuarios proporcionados
  /// por el widget y se crea una instancia de [_UsuarioDataGridSource] para manejar
  /// los datos de la tabla.
  @override
  void initState() {
    // Llama al super constructor para inicializar el estado del widget.
    super.initState();

    // Inicializa la lista de usuarios con los usuarios proporcionados por el widget.
    _usuarios = widget.usuarioLista;

    // Crea una instancia de [_UsuarioDataGridSource] para manejar los datos de la tabla.
    // El parámetro [usuarios] se utiliza para pasar la lista de usuarios a mostrar en la tabla.
    // El parámetro [context] se utiliza para obtener el contexto actual de la aplicación.
    _dataGridSource = UsuarioDataGridSource(
      usuarios: _usuarios,
      context: context,
    );
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
            "Usuarios",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Tabla
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
                source: _dataGridSource, // Fuente de datos de la tabla.
                selectionMode: SelectionMode.multiple,
                showCheckboxColumn: true,
                allowSorting: true,
                allowFiltering: true,
                // Columnas de la tabla
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'Usuario',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Usuario'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Tipo Documento',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Tipo Documento'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Número Documento',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Número Documento'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Correo',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Correo'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Teléfono Fijo',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Teléfono Fijo'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Teléfono Celular',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Teléfono Celular'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Rol 1',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Rol 1'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Rol 2',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Rol 2'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Rol 3',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Rol 3'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Estado',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Estado'),
                    ),
                  ),
                  GridColumn(
                    allowSorting: false,
                    allowFiltering: false,
                    columnName: 'Editar',
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
          // Botones de acción los cuales imprimen el reporte y añaden el usuario
          if (!Responsive.isMobile(context))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('Imprimir Reporte', () {}),
                const SizedBox(
                  width: defaultPadding,
                ),
                _buildButton('Añadir Usuarios', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadUsersCSV()));
                }),
              ],
            ),
          if (Responsive.isMobile(context))
            Center(
              child: Column(
                children: [
                  _buildButton('Imprimir Reporte', () {}),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  _buildButton('Añadir Usuarios', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadUsersCSV()));
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
  /// Parámetros:
  ///   - [text]: El texto que se mostrará en el botón.
  ///   - [onPressed]: La acción que se ejecutará cuando se presione el botón.
  ///
  /// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Borde redondeado
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

/// Crea un widget [DataGridSource] para la tabla de usuarios.
class UsuarioDataGridSource extends DataGridSource {
  // Crea un objeto de tipo DataGridRow para cada usuario
  UsuarioDataGridSource(
      {required List<UsuarioModel> usuarios, required BuildContext context}) {
    _usuarioData = usuarios.map<DataGridRow>((usuario) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Usuario',
            value: "${usuario.nombres} ${usuario.apellidos}"),
        DataGridCell<String>(
            columnName: 'Tipo Documento', value: usuario.tipoDocumento),
        DataGridCell<String>(
            columnName: 'Número Documento', value: usuario.numeroDocumento),
        DataGridCell<String>(
            columnName: 'Correo', value: usuario.correoElectronico),
        DataGridCell<String>(
            columnName: 'Teléfono Fijo', value: usuario.telefono),
        DataGridCell<String>(
            columnName: 'Teléfono Celular', value: usuario.telefonoCelular),
        DataGridCell<String>(columnName: 'Rol 1', value: usuario.rol1),
        DataGridCell<String>(columnName: 'Rol 2', value: usuario.rol2),
        DataGridCell<String>(columnName: 'Rol 3', value: usuario.rol3),
        DataGridCell<String>(
            columnName: 'Estado',
            value: usuario.estado ? "Activo" : "Inactivo"),
        DataGridCell<Widget>(
            columnName: 'Editar',
            value: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormActualizarUsuario(
                              usuario: usuario,
                            )));
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primaryColor)),
              child: const Text("Editar"),
            )),
      ]);
    }).toList();
  }

  // Lista de datos de la grilla
  List<DataGridRow> _usuarioData = [];

  // Metodo para obtener los datos de la grilla
  @override
  List<DataGridRow> get rows => _usuarioData;

  // Retorna un objeto de tipo DataGridRow para cada usuario
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
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 18,
                  child: Text(
                    row.getCells()[0].value[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
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
              ? row.getCells()[i].value // Texto normal
              : Text(row
                  .getCells()[i]
                  .value
                  .toString()), // Texto modificado para valores enteros
        ),
    ]);
  }
}
