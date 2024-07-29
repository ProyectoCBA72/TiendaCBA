// ignore_for_file: use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tienda_app/Dashboard/controllers/MenuAppController.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/main/main_screen_usuario.dart';
import 'package:tienda_app/Models/boletaModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/pdf/Usuario/pdfEventosUsuario.dart';
import 'package:tienda_app/pdf/modalsPdf.dart';
import 'package:http/http.dart' as http;
import 'package:tienda_app/source.dart';

/// Esta clase representa un widget de estado que muestra una tabla de eventos de un usuario.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_EventosUsuarioState] para manejar los datos de la pantalla.
///
/// Los atributos de esta clase son:
///
/// - [boletas] es una lista de objetos [BoletaModel] que representan los eventos del usuario.
class EventosUsuario extends StatefulWidget {
  /// Lista de boletas del usuario.
  ///
  /// Esta lista debe contener objetos de tipo [BoletaModel].
  final List<BoletaModel> boletas;

  final UsuarioModel usuario;

  /// Construye un nuevo widget [EventosUsuario].
  ///
  /// El parámetro [boletas] es requerido y debe contener objetos de tipo [BoletaModel].
  const EventosUsuario(
      {super.key, required this.boletas, required this.usuario});

  /// Crea un nuevo estado [_EventosUsuarioState] para manejar los datos de la pantalla.
  @override
  State<EventosUsuario> createState() => _EventosUsuarioState();
}

class _EventosUsuarioState extends State<EventosUsuario> {
  /// Lista de eventos del usuario.
  ///
  /// Esta lista almacena objetos de tipo [BoletaModel].
  List<BoletaModel> _eventos = [];

  /// Lista de usuarios registrados en la aplicación.
  ///
  /// Esta lista almacena objetos de tipo [UsuarioModel].
  List<UsuarioModel> listaUsuarios = [];

  /// Fuente de datos para la tabla de eventos del usuario.
  ///
  /// Este atributo almacena un objeto de tipo [EventosUsuarioDataGridSource].
  late EventosUsuarioDataGridSource _dataGridSource;

  List<DataGridRow> registros = [];

  @override

  /// Se llama una vez cuando el estado del widget se inserta en el árbol de widgets.
  ///
  /// Aquí se inicializa [_dataGridSource] con los datos de los eventos del usuario.
  /// También se asigna [_eventos] con los datos proporcionados en el constructor del widget.
  /// Por último, se llama a [_loadData] para cargar los datos necesarios.
  @override
  void initState() {
    super.initState();

    // Inicializa _dataGridSource con los datos de los eventos del usuario
    _dataGridSource = EventosUsuarioDataGridSource(
        eventos: _eventos, listaUsuarios: listaUsuarios)
      ..eliminarBoletaCallback =
          (int boletaID) => eliminarBoletaModal(context, boletaID);

    // Asigna los datos proporcionados en el constructor del widget a _eventos
    _eventos = widget.boletas;

    // Carga los datos necesarios, como los usuarios
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

    if (mounted) {
      // Ahora inicializa _dataGridSource después de cargar los datos
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Actualiza _dataGridSource con los datos cargados de usuarios y eventos
          _dataGridSource = EventosUsuarioDataGridSource(
              eventos: _eventos, listaUsuarios: listaUsuarios)
            ..eliminarBoletaCallback =
                (int boletaID) => eliminarBoletaModal(context, boletaID);
        });
      });
    }
  }

  /// Elimina una boleta específica de la API.
  ///
  /// Se envía una solicitud DELETE a la API con el ID de la boleta especificada.
  /// Si la solicitud es exitosa (código de estado 204), se navega hacia la pantalla
  /// principal de usuario. En caso de error, se muestra un mensaje de error.
  Future deleteBoleta(int boletaID) async {
    // Construye la URL de la API
    String url;
    url = "$sourceApi/api/boletas/$boletaID/";

    // Define los encabezados de la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Envía una solicitud DELETE a la API con el ID del comentario específico
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    // Verifica el estado de la respuesta HTTP
    if (response.statusCode == 204) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asistencia eliminada correctamente.'),
        ),
      );
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
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error al eliminar la asistencia: ${response.statusCode}'),
        ),
      );
    }
  }

  /// Se llama automáticamente cuando se elimina el widget.
  ///
  /// Este método se llama automáticamente cuando el widget se elimina del árbol de widgets.
  /// Se debe llamar al método [dispose] para liberar los recursos utilizados por el widget.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos adicionales.
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
            "Asistencia Eventos",
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
          // Botón para imprimir reporte
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
                            builder: (context) => PdfEventosUsuarioScreen(
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

  /// Muestra un diálogo modal para confirmar la eliminación de una asistencia.
  ///
  /// El diálogo solicita al usuario que confirme la eliminación de la asistencia.
  /// Si el usuario hace clic en "Cancelar", se cierra el diálogo.
  /// Si el usuario hace clic en "Eliminar", se elimina la asistencia.
  ///
  /// Parámetros:
  ///
  ///   - `context` (BuildContext): El contexto de la aplicación.
  ///   - `boletaID` (int): El ID de la asistencia a eliminar.
  void eliminarBoletaModal(BuildContext context, int boletaID) {
    // Muestra el diálogo modal para confirmar la eliminación de la asistencia
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Título del diálogo
          title: const Text(
            "¿Desea eliminar esta asistencia?",
            textAlign: TextAlign.center,
          ),
          // Contenido del diálogo
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Mensaje informativo para el usuario
              const Text(
                "Si elimina la asistencia, no podrá participar en este evento.",
                textAlign: TextAlign.center,
              ),
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
          // Botones de acción dentro del diálogo
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  // Construye un botón con los estilos de diseño especificados
                  child: _buildButton("Cancelar", () {
                    // Cierra el diálogo cuando se hace clic en el botón de aceptar
                    Navigator.pop(context);
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  // Construye un botón con los estilos de diseño especificados
                  child: _buildButton("Eliminar", () {
                    // Elimina la asistencia cuando se hace clic en el botón de aceptar
                    deleteBoleta(boletaID);
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Construye un botón con los estilos de diseño especificados.
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
  ///
  /// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200, // Ancho del contenedor
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(10), // Borde redondeado con un radio de 10
        gradient: const LinearGradient(
          // Gradiente de color
          colors: [
            botonClaro, // Color de fondo claro
            botonOscuro, // Color de fondo oscuro
          ],
        ),
        boxShadow: const [
          // Sombra
          BoxShadow(
            color: botonSombra, // Color de sombra
            blurRadius: 5, // Radio de la sombra
            offset: Offset(0, 3), // Desplazamiento en x e y de la sombra
          ),
        ],
      ),
      child: Material(
        // Widget Material
        color: Colors.transparent, // Color de fondo transparente
        child: InkWell(
          // Widget InkWell
          onTap: onPressed, // Controlador de eventos al presionar el botón
          borderRadius:
              BorderRadius.circular(10), // Borde redondeado con un radio de 10
          child: Padding(
            // Widget Padding
            padding: const EdgeInsets.symmetric(
                vertical: 10), // Padding vertical de 10
            child: Center(
              // Widget Center
              child: Text(
                // Widget Text
                text, // Texto del botón
                style: const TextStyle(
                  // Estilo del texto
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

// Clase que define la fuente de datos de la tabla
class EventosUsuarioDataGridSource extends DataGridSource {
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

  /// Crea una fuente de datos para la tabla de eventos de un usuario.
  EventosUsuarioDataGridSource(
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
              onPressed: () {
                // Notificar al estado que se ha seleccionado una fila para eliminar
                eliminarBoletaCallback?.call(evento.id);
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primaryColor)),
              child: const Text("Eliminar"),
            )),
      ]);
    }).toList();
  }

  // Lista de eventos
  List<DataGridRow> _eventoData = [];

  // Callback para eliminar boleta
  void Function(int)? eliminarBoletaCallback;

  // Celdas
  @override
  List<DataGridRow> get rows => _eventoData;

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
                      row.getCells()[i].value.toString()) // Formateo de fechas
                  : row.getCells()[i].value.toString()), // Celdas restantes
        ),
    ]);
  }
}
