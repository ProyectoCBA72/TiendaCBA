// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Models/boletaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Widget de estado que representa la vista de eventos de un punto de venta.
///
/// Esta clase extiende [StatefulWidget] y proporciona un estado asociado
/// [_EventosPuntoState]. Tiene una lista de [BoletaModel] que representa
/// los eventos del punto de venta.
class EventosPunto extends StatefulWidget {
  /// Lista de boletas del punto de venta.
  ///
  /// Cada boleta representa un evento del punto de venta, como una venta o una
  /// devolución.
  final List<BoletaModel> boletas;

  /// Crea un nuevo widget de estado para mostrar la vista de eventos de un punto
  /// de venta.
  ///
  /// El parámetro [boletas] es la lista de boletas del punto de venta.
  const EventosPunto({
    super.key,
    required this.boletas,
  });

  @override
  State<EventosPunto> createState() => _EventosPuntoState();
}

class _EventosPuntoState extends State<EventosPunto> {
  /// Lista de eventos del punto de venta.
  ///
  /// Cada elemento de la lista representa un evento del punto de venta, como una
  /// venta o una devolución.
  List<BoletaModel> _eventos = [];

  /// Lista de usuarios del punto de venta.
  ///
  /// Cada elemento de la lista representa un usuario del punto de venta.
  List<UsuarioModel> listaUsuarios = [];

  /// Origen de datos de la grilla de eventos del punto de venta.
  ///
  /// Este objeto se utiliza para proporcionar los datos y la configuración de la
  /// grilla de eventos mostrada en la interfaz de usuario.
  late EventosPuntoDataGridSource _dataGridSource;

  @override

  /// Se llama cuando se inicia el estado del widget.
  ///
  /// Aquí se inicializa [_dataGridSource] con los datos de los eventos y usuarios
  /// del punto de venta y se cargan los datos necesarios para la pantalla.
  @override
  void initState() {
    super.initState();

    // Inicializa _dataGridSource con los datos de los eventos y usuarios
    _dataGridSource = EventosPuntoDataGridSource(
        eventos: _eventos, listaUsuarios: listaUsuarios);

    // Actualiza la lista de eventos con los eventos del punto de venta
    _eventos = widget.boletas;

    // Carga los datos necesarios para la pantalla
    _loadData();
  }

  /// Carga los datos necesarios para la pantalla, como los usuarios.
  ///
  /// Este método realiza una solicitud asíncrona a la API para obtener los usuarios
  /// y luego actualiza [_dataGridSource] con los datos cargados.
  Future<void> _loadData() async {
    // Realiza una solicitud asíncragona a la API para obtener los usuarios
    List<UsuarioModel> usuariosCargados = await getUsuarios();

    // Actualiza la lista de usuarios con los datos cargados
    listaUsuarios = usuariosCargados;

    // Ahora inicializa _dataGridSource después de cargar los datos
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Actualiza _dataGridSource con los datos cargados de eventos y usuarios
        _dataGridSource = EventosPuntoDataGridSource(
            eventos: _eventos, listaUsuarios: listaUsuarios);
      });
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
          // Título del reporte
          Text(
            "Asistencia Eventos",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Calibri-Bold'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Grilla de eventos
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
                // Establece las columnas de la grilla
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'Evento',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Evento'),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Fecha',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Fecha'),
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
                    width: 150,
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
                    allowSorting: false,
                    allowFiltering: false,
                    columnName: 'Eliminar',
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
          // Botón para imprimir el reporte
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

  /// Construye un botón con el texto dado y la función de presionar dada.
  ///
  /// El botón tiene un diseño con bordes redondeados y un gradiente de colores.
  /// Al presionar el botón se llama a la función [onPressed].
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará al presionar el botón.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200, // Ancho fijo del botón.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Border redondeado.
        gradient: const LinearGradient(
          // Gradiente de colores.
          colors: [
            botonClaro, // Color claro del gradiente.
            botonOscuro, // Color oscuro del gradiente.
          ],
        ),
        boxShadow: const [
          // Sombra del botón.
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

// Clase para la fuente de datos
class EventosPuntoDataGridSource extends DataGridSource {
  /// Devuelve el nombre completo de un usuario dado su [usuarioId] y la lista de [usuarios].
  ///
  /// El nombre completo se obtiene concatenando los nombres y apellidos del usuario.
  /// Si no se encuentra un usuario con el [usuarioId] dado, se devuelve una cadena vacía.
  ///
  /// El parámetro [usuarioId] es el identificador del usuario.
  /// El parámetro [usuarios] es la lista de usuarios.
  ///
  /// Devuelve un [String] con el nombre completo del usuario o una cadena vacía si no se encuentra.
  String nombreUsuarioEvento(int usuarioId, List<UsuarioModel> usuarios) {
    // Inicializamos la variable nombre con una cadena vacía
    String nombre = "";

    // Iteramos sobre cada usuario en la lista de usuarios
    for (var usuario in usuarios) {
      // Verificamos si el id del usuario coincide con el usuarioId dado
      if (usuario.id == usuarioId) {
        // Concatenamos los nombres y apellidos del usuario para obtener el nombre completo
        nombre = "${usuario.nombres} ${usuario.apellidos}";
      }
    }

    // Devolvemos el nombre completo del usuario o una cadena vacía si no se encuentra
    return nombre;
  }

  /// Devuelve el tipo de documento de un usuario dado su [usuarioId] y la lista de [usuarios].
  ///
  /// El tipo de documento se obtiene del usuario correspondiente al [usuarioId] dado.
  /// Si no se encuentra un usuario con el [usuarioId] dado, se devuelve una cadena vacía.
  ///
  /// El parámetro [usuarioId] es el identificador del usuario.
  /// El parámetro [usuarios] es la lista de usuarios.
  ///
  /// Devuelve un [String] con el tipo de documento del usuario o una cadena vacía si no se encuentra.
  String tipoDocumentoEvento(int usuarioId, List<UsuarioModel> usuarios) {
    // Inicializamos la variable tipoDocumento con una cadena vacía
    String tipoDocumento = "";

    // Iteramos sobre cada usuario en la lista de usuarios
    for (var usuario in usuarios) {
      // Verificamos si el id del usuario coincide con el usuarioId dado
      if (usuario.id == usuarioId) {
        // Asignamos el tipo de documento del usuario a la variable tipoDocumento
        tipoDocumento = usuario.tipoDocumento;
      }
    }

    // Devolvemos el tipo de documento del usuario o una cadena vacía si no se encuentra
    return tipoDocumento;
  }

  /// Devuelve el número de documento de un usuario dado su [usuarioId] y la lista de [usuarios].
  ///
  /// El número de documento se obtiene del usuario correspondiente al [usuarioId] dado.
  /// Si no se encuentra un usuario con el [usuarioId] dado, se devuelve una cadena vacía.
  ///
  /// El parámetro [usuarioId] es el identificador del usuario.
  /// El parámetro [usuarios] es la lista de usuarios.
  ///
  /// Devuelve un [String] con el número de documento del usuario o una cadena vacía si no se encuentra.
  String numeroDocumentoEvento(int usuarioId, List<UsuarioModel> usuarios) {
    // Inicializamos la variable numeroDocumento con una cadena vacía
    String numeroDocumento = "";

    // Iteramos sobre cada usuario en la lista de usuarios
    for (var usuario in usuarios) {
      // Verificamos si el id del usuario coincide con el usuarioId dado
      if (usuario.id == usuarioId) {
        // Asignamos el número de documento del usuario a la variable numeroDocumento
        numeroDocumento = usuario.numeroDocumento;
      }
    }

    // Devolvemos el número de documento del usuario o una cadena vacía si no se encuentra
    return numeroDocumento;
  }

  /// Devuelve el correo electrónico de un usuario dado su [usuarioId] y la lista de [usuarios].
  ///
  /// El correo electrónico se obtiene del usuario correspondiente al [usuarioId] dado.
  /// Si no se encuentra un usuario con el [usuarioId] dado, se devuelve una cadena vacía.
  ///
  /// El parámetro [usuarioId] es el identificador del usuario.
  /// El parámetro [usuarios] es la lista de usuarios.
  ///
  /// Devuelve un [String] con el correo electrónico del usuario o una cadena vacía si no se encuentra.
  String correoEvento(int usuarioId, List<UsuarioModel> usuarios) {
    // Inicializamos la variable correo con una cadena vacía
    String correo = "";

    // Iteramos sobre cada usuario en la lista de usuarios
    for (var usuario in usuarios) {
      // Verificamos si el id del usuario coincide con el usuarioId dado
      if (usuario.id == usuarioId) {
        // Asignamos el correo electrónico del usuario a la variable correo
        correo = usuario.correoElectronico;
      }
    }

    // Devolvemos el correo electrónico del usuario o una cadena vacía si no se encuentra
    return correo;
  }

  /// Devuelve el número de teléfono fijo de un usuario dado su [usuarioId] y la lista de [usuarios].
  ///
  /// El número de teléfono fijo se obtiene del usuario correspondiente al [usuarioId] dado.
  /// Si no se encuentra un usuario con el [usuarioId] dado, se devuelve una cadena vacía.
  ///
  /// El parámetro [usuarioId] es el identificador del usuario.
  /// El parámetro [usuarios] es la lista de usuarios.
  ///
  /// Devuelve un [String] con el número de teléfono fijo del usuario o una cadena vacía si no se encuentra.
  String telefonoFijoEvento(int usuarioId, List<UsuarioModel> usuarios) {
    // Inicializamos la variable telefonoFijo con una cadena vacía
    String telefonoFijo = "";

    // Iteramos sobre cada usuario en la lista de usuarios
    for (var usuario in usuarios) {
      // Verificamos si el id del usuario coincide con el usuarioId dado
      if (usuario.id == usuarioId) {
        // Asignamos el número de teléfono fijo del usuario a la variable telefonoFijo
        telefonoFijo = usuario.telefono;
      }
    }

    // Devolvemos el número de teléfono fijo del usuario o una cadena vacía si no se encuentra
    return telefonoFijo;
  }

  /// Devuelve el número de teléfono celular de un usuario dado su [usuarioId] y la lista de [usuarios].
  ///
  /// El número de teléfono celular se obtiene del usuario correspondiente al [usuarioId] dado.
  /// Si no se encuentra un usuario con el [usuarioId] dado, se devuelve una cadena vacía.
  ///
  /// El parámetro [usuarioId] es el identificador del usuario.
  /// El parámetro [usuarios] es la lista de usuarios.
  ///
  /// Devuelve un [String] con el número de teléfono celular del usuario o una cadena vacía si no se encuentra.
  String telefonoCelularEvento(int usuarioId, List<UsuarioModel> usuarios) {
    // Inicializamos la variable telefonoCelular con una cadena vacía
    String telefonoCelular = "";

    // Iteramos sobre cada usuario en la lista de usuarios
    for (var usuario in usuarios) {
      // Verificamos si el id del usuario coincide con el usuarioId dado
      if (usuario.id == usuarioId) {
        // Asignamos el número de teléfono celular del usuario a la variable telefonoCelular
        telefonoCelular = usuario.telefonoCelular;
      }
    }

    // Devolvemos el número de teléfono celular del usuario o una cadena vacía si no se encuentra
    return telefonoCelular;
  }

  // Crea una fuente de datos de la tabla
  EventosPuntoDataGridSource(
      {required List<BoletaModel> eventos,
      required final List<UsuarioModel> listaUsuarios}) {
    _eventoData = eventos.map<DataGridRow>((evento) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Evento', value: evento.anuncio.titulo),
        DataGridCell<String>(
            columnName: 'Fecha', value: evento.anuncio.fechaEvento),
        DataGridCell<String>(
            columnName: 'Usuario',
            value: nombreUsuarioEvento(evento.usuario, listaUsuarios)),
        DataGridCell<String>(
            columnName: 'Tipo Documento',
            value: tipoDocumentoEvento(evento.usuario, listaUsuarios)),
        DataGridCell<String>(
            columnName: 'Número Documento',
            value: numeroDocumentoEvento(evento.usuario, listaUsuarios)),
        DataGridCell<String>(
            columnName: 'Correo',
            value: correoEvento(evento.usuario, listaUsuarios)),
        DataGridCell<String>(
            columnName: 'Teléfono Fijo',
            value: telefonoFijoEvento(evento.usuario, listaUsuarios)),
        DataGridCell<String>(
            columnName: 'Teléfono Celular',
            value: telefonoCelularEvento(evento.usuario, listaUsuarios)),
        DataGridCell<Widget>(
            columnName: 'Eliminar',
            value: ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primaryColor)),
              child: const Text("Eliminar"),
            )),
      ]);
    }).toList();
  }

  // Lista de datos de la tabla
  List<DataGridRow> _eventoData = [];

  // Obtiene la lista de datos de la tabla
  @override
  List<DataGridRow> get rows => _eventoData;

  // Retorna una celda para cada columna
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
                "assets/icons/eventos.svg",
                height: 30,
                width: 30,
                colorFilter:
                    const ColorFilter.mode(Colors.orange, BlendMode.srcIn),
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
              : Text(i == 1
                  ? formatFechaHora(
                      row.getCells()[i].value.toString()) // Formatea la fecha
                  : row.getCells()[i].value.toString()), // Muestra el valor
        ),
    ]);
  }
}
