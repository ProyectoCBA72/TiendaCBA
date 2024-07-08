// ignore_for_file: file_names, avoid_print, use_build_context_synchronously
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tienda_app/EditarUsuario/desplegablesEditar.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/sedeModel.dart';
import 'package:tienda_app/Models/unidadProduccionModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:image/image.dart' as im;

/// Un widget de estado que muestra un formulario para actualizar la información
/// de un usuario.
///
/// El widget [FormActualizarUsuario] toma un parámetro obligatorio [usuario],
/// que es un objeto [UsuarioModel] que representa el usuario a actualizar.
///
/// El widget devuelve un [StatefulWidget] con un estado asociado
/// [_FormActualizarUsuarioState].
class FormActualizarUsuario extends StatefulWidget {
  /// El objeto [UsuarioModel] que representa el usuario a actualizar.
  final UsuarioModel usuario;

  /// Construye un widget [FormActualizarUsuario].
  ///
  /// El parámetro [usuario] es obligatorio y debe ser un objeto
  /// [UsuarioModel].
  const FormActualizarUsuario({
    super.key,
    required this.usuario,
  });

  @override
  State<FormActualizarUsuario> createState() => _FormActualizarUsuarioState();
}

class _FormActualizarUsuarioState extends State<FormActualizarUsuario> {
  /// Cadena que almacena el número de documento del usuario.
  String? documento;

  /// Cadena que almacena el primer rol del usuario.
  String? rol1;

  /// Cadena que almacena el segundo rol del usuario.
  String? rol2;

  /// Cadena que almacena la unidad de producción del usuario.
  String? unidad;

  /// Cadena que almacena el punto de venta del usuario.
  String? punto;

  /// Cadena que almacena la sede del usuario.
  String? sede;

  /// Variable booleana que guarda el estado del primer checkbox.
  bool isChecked1 = false;

  /// Variable booleana que guarda el estado del segundo checkbox.
  bool isChecked2 = false;

  /// Controlador de texto para el nombre del usuario.
  final TextEditingController _nombresController = TextEditingController();

  /// Controlador de texto para los apellidos del usuario.
  final TextEditingController _apellidosController = TextEditingController();

  /// Controlador de texto para el correo electrónico del usuario.
  final TextEditingController _emailController = TextEditingController();

  /// Controlador de texto para el número de teléfono del usuario.
  final TextEditingController _telefonoController = TextEditingController();

  /// Controlador de texto para el número de documento del usuario.
  final TextEditingController _documentoController = TextEditingController();

  /// Controlador de texto para la dirección del usuario.
  final TextEditingController _direccionController = TextEditingController();

  /// Controlador de texto para la ciudad del usuario.
  final TextEditingController _ciudadController = TextEditingController();

  /// Controlador de texto para el número de teléfono celular del usuario.
  final TextEditingController _telefonoCelularController =
      TextEditingController();

  /// Controlador de texto para la ficha del usuario.
  final TextEditingController _fichaController = TextEditingController();

  /// Controlador de texto para el cargo del usuario.
  final TextEditingController _cargoController = TextEditingController();

  /// Controlador de texto para la imagen del usuario.
  final TextEditingController _imagenController = TextEditingController();

  // Máscara para el número de teléfono.
  var inputtelefono = MaskTextInputFormatter(
      mask: "### ### ####", filter: {"#": RegExp(r'[0-9]')});

  /// Cadena que almacena el nombre del archivo seleccionado.
  String selectFile = '';

  /// Byte array que almacena la imagen seleccionada.
  Uint8List? selectedImagenInBytes;

  // Método para seleccionar una imagen
  /// Selecciona un archivo de imagen y lo carga en un Uint8List.
  ///
  /// Si la imagen seleccionada no tiene tamaño 400x400, se redimensiona
  /// a ese tamaño y se reduce la calidad de la imagen a 50.
  ///
  /// El parámetro [imagenFrom] indica si se seleccionó la imagen desde el
  /// botón de "Foto desde dispositivo" o desde la galería del dispositivo.
  ///
  /// Si [imagenFrom] es verdadero, se abre la galería del dispositivo para
  /// que el usuario seleccione la imagen. Si es falso, se abre el selector
  /// de archivos para que el usuario seleccione la imagen desde el dispositivo.
  _selectFile(bool imagenFrom) async {
    // Abrir el selector de archivos o la galería del dispositivo
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        // Obtener el nombre del archivo y los bytes de la imagen seleccionada
        selectFile = fileResult.files.first.name;
        selectedImagenInBytes = fileResult.files.first.bytes;
      });
    }

    // Cargar la imagen desde los bytes
    final image = im.decodeImage(selectedImagenInBytes!);

    // Verificar los casos y modificar la imagen según sea necesario
    if (image!.width != 400 && image.height != 400) {
      // Caso 1: La imagen es diferente a los tamaños establecidos
      final resizedImage = im.copyResize(image, width: 400, height: 400);
      selectedImagenInBytes = Uint8List.fromList(
          im.encodeJpg(resizedImage, quality: 50)); // Reducir calidad a 50
    } else {
      // Caso por defecto
      selectedImagenInBytes = Uint8List.fromList(
          im.encodeJpg(image, quality: 50)); // Reducir calidad a 50
    }

    print(selectFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // Botón para regresar a la pantalla anterior
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          // Botón para guardar los cambios
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 110,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    "Guardar",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 17,
                        fontFamily: 'Calibri-Bold'),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, responsive) {
          // Valida si el ancho de la pantalla es menor a 900
          if (responsive.maxWidth <= 900) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          primaryColor.withOpacity(0.7), BlendMode.darken),
                      image: const AssetImage('assets/img/confirmacion.jpg'),
                      fit: BoxFit.cover)),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titulo
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 5),
                        child: Text(
                          "Editar Usuario",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Calibri-Bold',
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(
                                    0.5), // Color y opacidad de la sombra
                                offset: const Offset(2,
                                    2), // Desplazamiento de la sombra (horizontal, vertical)
                                blurRadius:
                                    3, // Radio de desenfoque de la sombra
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Campo de texto para el nombre
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            controller: _nombresController,
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                labelStyle: const TextStyle(color: Colors.grey),
                                labelText: "Nombres Completos"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Campo de texto para los apellidos
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            controller: _apellidosController,
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                labelStyle: const TextStyle(color: Colors.grey),
                                labelText: "Apellidos Completos"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Campo de texto para la identificación
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "Identificación",
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Calibri-Bold',
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(
                                    0.5), // Color y opacidad de la sombra
                                offset: const Offset(2,
                                    2), // Desplazamiento de la sombra (horizontal, vertical)
                                blurRadius:
                                    3, // Radio de desenfoque de la sombra
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // DropdownButton para el tipo de documento
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                // Configuración del DropdownButton
                                isExpanded: true,
                                hint: const Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Seleccione tipo de documento',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: options1
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.valor,
                                          child: Text(
                                            item.titulo,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: documento,
                                onChanged: (String? value) {
                                  // Actualización del valor seleccionado
                                  setState(() {
                                    documento = value;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.white,
                                  ),
                                  elevation: 2,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white,
                                  ),
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: TextFormField(
                                controller: _documentoController,
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    labelStyle:
                                        const TextStyle(color: Colors.grey),
                                    labelText: "N° Documento"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Campo de texto para el correo
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                labelStyle: const TextStyle(color: Colors.grey),
                                labelText: "Correo Electrónico"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Información de contacto
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "Información de contacto",
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Calibri-Bold',
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(
                                    0.5), // Color y opacidad de la sombra
                                offset: const Offset(2,
                                    2), // Desplazamiento de la sombra (horizontal, vertical)
                                blurRadius:
                                    3, // Radio de desenfoque de la sombra
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Campo de texto para la dirección y ciudad
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2.0, right: 2.0),
                                child: TextFormField(
                                  controller: _direccionController,
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      labelStyle:
                                          const TextStyle(color: Colors.grey),
                                      labelText: "Dirección"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2.0, right: 2.0),
                                child: TextFormField(
                                  controller: _ciudadController,
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      labelStyle:
                                          const TextStyle(color: Colors.grey),
                                      labelText: "Ciudad"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Campo de texto para el telefono y telefono celular
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2.0, right: 2.0),
                                child: TextFormField(
                                  controller: _telefonoController,
                                  inputFormatters: [inputtelefono],
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      labelStyle:
                                          const TextStyle(color: Colors.grey),
                                      labelText: "Teléfono"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2.0, right: 2.0),
                                child: TextFormField(
                                  controller: _telefonoCelularController,
                                  inputFormatters: [inputtelefono],
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      labelStyle:
                                          const TextStyle(color: Colors.grey),
                                      labelText: "Teléfono Celular"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Imagen de perfil
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "Imagen de perfil",
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Calibri-Bold',
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(
                                    0.5), // Color y opacidad de la sombra
                                offset: const Offset(2,
                                    2), // Desplazamiento de la sombra (horizontal, vertical)
                                blurRadius:
                                    3, // Radio de desenfoque de la sombra
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: selectFile.isEmpty
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.5),
                                    backgroundImage: const AssetImage(
                                      "assets/img/logo.png",
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        MemoryImage(selectedImagenInBytes!),
                                  )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Botón de editar imagen
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: primaryColor,
                                  offset: Offset(
                                    2.0,
                                    2.0,
                                  ),
                                  blurRadius: 3.0,
                                  spreadRadius: 1.0,
                                ), //BoxShadow
                                BoxShadow(
                                  color: primaryColor,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ), //BoxShadow
                              ],
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit,
                                  size: 25, color: primaryColor),
                              onPressed: () {
                                // Acción al presionar el botón de editar
                                _selectFile(true);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: primaryColor,
                                  offset: Offset(
                                    2.0,
                                    2.0,
                                  ),
                                  blurRadius: 3.0,
                                  spreadRadius: 1.0,
                                ), //BoxShadow
                                BoxShadow(
                                  color: primaryColor,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ), //BoxShadow
                              ],
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete,
                                  size: 25, color: primaryColor),
                              onPressed: () {
                                // Acción al presionar el botón de editar
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Información aprendiz
                      // ver si es aprendiz
                      if (widget.usuario.rol2 == "APRENDIZ")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Información Aprendiz",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Calibri-Bold',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Color y opacidad de la sombra
                                  offset: const Offset(2,
                                      2), // Desplazamiento de la sombra (horizontal, vertical)
                                  blurRadius:
                                      3, // Radio de desenfoque de la sombra
                                ),
                              ],
                            ),
                          ),
                        ),
                      // ver si es aprendiz
                      if (widget.usuario.rol2 == "APRENDIZ")
                        const SizedBox(height: 15),
                      // ver si es aprendiz
                      // captura el n° de ficha y si es vocero
                      if (widget.usuario.rol2 == "APRENDIZ")
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2.0, right: 2.0),
                                child: TextFormField(
                                  controller: _fichaController,
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      labelStyle:
                                          const TextStyle(color: Colors.grey),
                                      labelText: "N° Ficha"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "¿Usted es vocero?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(
                                            0.5), // Color y opacidad de la sombra
                                        offset: const Offset(2,
                                            2), // Desplazamiento de la sombra (horizontal, vertical)
                                        blurRadius:
                                            3, // Radio de desenfoque de la sombra
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Checkbox(
                                  side: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                  value:
                                      isChecked1, // Estado actual del checkbox
                                  onChanged: (bool? newValue) {
                                    // Función que se ejecuta cuando el usuario cambia el estado del checkbox
                                    setState(() {
                                      // Actualiza el estado del widget
                                      isChecked1 = newValue ??
                                          false; // Cambia el estado del checkbox al nuevo valor
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      // ver si es aprendiz
                      if (widget.usuario.rol2 == "APRENDIZ")
                        const SizedBox(
                          height: 20,
                        ),
                      // ver si es funcionario
                      if (widget.usuario.rol2 == "FUNCIONARIO")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Información Funcionario",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Calibri-Bold',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Color y opacidad de la sombra
                                  offset: const Offset(2,
                                      2), // Desplazamiento de la sombra (horizontal, vertical)
                                  blurRadius:
                                      3, // Radio de desenfoque de la sombra
                                ),
                              ],
                            ),
                          ),
                        ),
                      // ver si es funcionario
                      if (widget.usuario.rol2 == "FUNCIONARIO")
                        const SizedBox(height: 15),
                      // ver si es funcionario
                      // campo de texto cargo
                      if (widget.usuario.rol2 == "FUNCIONARIO")
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 2.0, right: 2.0),
                            child: TextFormField(
                              controller: _cargoController,
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  labelText: "Cargo"),
                            ),
                          ),
                        ),
                      // ver si es funcionario
                      if (widget.usuario.rol2 == "FUNCIONARIO")
                        const SizedBox(
                          height: 20,
                        ),
                      // ver si es lider
                      if (widget.usuario.rol3 == "LIDER")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Información Aplicativo",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Calibri-Bold',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Color y opacidad de la sombra
                                  offset: const Offset(2,
                                      2), // Desplazamiento de la sombra (horizontal, vertical)
                                  blurRadius:
                                      3, // Radio de desenfoque de la sombra
                                ),
                              ],
                            ),
                          ),
                        ),
                      // ver si es lider
                      if (widget.usuario.rol3 == "LIDER")
                        const SizedBox(height: 15),
                      // ver si es lider
                      // Desplegables para elegir los roles
                      if (widget.usuario.rol3 == "LIDER")
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  // Configuración del DropdownButton
                                  isExpanded: true,
                                  hint: const Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Seleccione rol secundario',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: rolN1
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.valor,
                                            child: Text(
                                              item.titulo,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: rol1,
                                  onChanged: (String? value) {
                                    // Actualización del valor seleccionado
                                    setState(() {
                                      rol1 = value;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                      color: Colors.white,
                                    ),
                                    elevation: 2,
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    ),
                                    iconSize: 14,
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.grey,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Colors.white,
                                    ),
                                    offset: const Offset(-20, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness:
                                          WidgetStateProperty.all<double>(6),
                                      thumbVisibility:
                                          WidgetStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25.0),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  // Configuración del DropdownButton
                                  isExpanded: true,
                                  hint: const Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Seleccione rol terciario',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: rolN2
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.valor,
                                            child: Text(
                                              item.titulo,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: rol2,
                                  onChanged: (String? value) {
                                    // Actualización del valor seleccionado
                                    setState(() {
                                      rol2 = value;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                      color: Colors.white,
                                    ),
                                    elevation: 2,
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    ),
                                    iconSize: 14,
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.grey,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Colors.white,
                                    ),
                                    offset: const Offset(-20, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness:
                                          WidgetStateProperty.all<double>(6),
                                      thumbVisibility:
                                          WidgetStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      // ver si es lider
                      if (widget.usuario.rol3 == "LIDER")
                        const SizedBox(
                          height: 20,
                        ),
                      // ver si es lider
                      // Checkbox para habilitar o deshabilitar el usuario
                      if (widget.usuario.rol3 == "LIDER")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿El usuario se encuentra activo?",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(
                                        0.5), // Color y opacidad de la sombra
                                    offset: const Offset(2,
                                        2), // Desplazamiento de la sombra (horizontal, vertical)
                                    blurRadius:
                                        3, // Radio de desenfoque de la sombra
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Checkbox(
                              side: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              value: isChecked2, // Estado actual del checkbox
                              onChanged: (bool? newValue) {
                                // Función que se ejecuta cuando el usuario cambia el estado del checkbox
                                setState(() {
                                  // Actualiza el estado del widget
                                  isChecked2 = newValue ??
                                      false; // Cambia el estado del checkbox al nuevo valor
                                });
                              },
                            ),
                          ],
                        ),
                      // ver si es lider
                      if (widget.usuario.rol3 == "LIDER")
                        const SizedBox(
                          height: 20,
                        ),
                      // ver si es lider
                      // Desplegables para seleccionar la unidad de producción y el punto de venta
                      if (widget.usuario.rol3 == "LIDER")
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FutureBuilder(
                                future:
                                    getUndadesProduccion(), // Llamada al método para obtener los datos
                                builder: (context,
                                    AsyncSnapshot<List<UnidadProduccionModel>>
                                        snapshot) {
                                  // Verificar el estado de la llamada
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                    // Verificar si hay un error
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Error al cargar unidades: ${snapshot.error}',
                                        style: TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                  0.5), // Color y opacidad de la sombra
                                              offset: const Offset(2,
                                                  2), // Desplazamiento de la sombra (horizontal, vertical)
                                              blurRadius:
                                                  3, // Radio de desenfoque de la sombra
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                    // Verificar si hay datos
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          // Configuración del DropdownButton
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Seleccione unidad de producción',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: snapshot.data!
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.id.toString(),
                                                    child: Text(
                                                      item.nombre,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: unidad,
                                          onChanged: (String? value) {
                                            // Actualización del valor seleccionado
                                            setState(() {
                                              unidad = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                              color: Colors.white,
                                            ),
                                            elevation: 2,
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.black,
                                            iconDisabledColor: Colors.grey,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                            offset: const Offset(-20, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: WidgetStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.0),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            FutureBuilder(
                                future:
                                    getPuntosVenta(), // Llamada al método para obtener los datos
                                builder: (context,
                                    AsyncSnapshot<List<PuntoVentaModel>>
                                        snapshot) {
                                  // Verificar el estado de la llamada
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                    // Verificar si hay un error
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Error al cargar puntos: ${snapshot.error}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                  0.5), // Color y opacidad de la sombra
                                              offset: const Offset(2,
                                                  2), // Desplazamiento de la sombra (horizontal, vertical)
                                              blurRadius:
                                                  3, // Radio de desenfoque de la sombra
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                    // Verificar si hay datos
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          // Configuración del DropdownButton
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Seleccione punto de venta',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: snapshot.data!
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.id.toString(),
                                                    child: Text(
                                                      item.nombre,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: punto,
                                          onChanged: (String? value) {
                                            // Actualización del valor seleccionado
                                            setState(() {
                                              punto = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                              color: Colors.white,
                                            ),
                                            elevation: 2,
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.black,
                                            iconDisabledColor: Colors.grey,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                            offset: const Offset(-20, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: WidgetStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.0),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                      // ver si es lider
                      if (widget.usuario.rol3 == "LIDER")
                        const SizedBox(
                          height: 20,
                        ),
                      // ver si es lider
                      // Desplegable de sedes
                      if (widget.usuario.rol3 == "LIDER")
                        FutureBuilder(
                            future:
                                getSedes(), // Llamada al método para obtener los datos
                            builder: (context,
                                AsyncSnapshot<List<SedeModel>> snapshot) {
                              // Verificar el estado de la llamada
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                                // Verificar si hay un error
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error al cargar sedes: ${snapshot.error}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Color y opacidad de la sombra
                                          offset: const Offset(2,
                                              2), // Desplazamiento de la sombra (horizontal, vertical)
                                          blurRadius:
                                              3, // Radio de desenfoque de la sombra
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                // Verificar si hay datos
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      // Configuración del DropdownButton
                                      isExpanded: true,
                                      hint: const Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Seleccione Sede',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: snapshot.data!
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item.id.toString(),
                                                child: Text(
                                                  item.nombre,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: sede,
                                      onChanged: (String? value) {
                                        // Actualización del valor seleccionado
                                        setState(() {
                                          sede = value;
                                        });
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          color: Colors.white,
                                        ),
                                        elevation: 2,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                        ),
                                        iconSize: 14,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.grey,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Colors.white,
                                        ),
                                        offset: const Offset(-20, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              WidgetStateProperty.all<double>(
                                                  6),
                                          thumbVisibility:
                                              WidgetStateProperty.all<bool>(
                                                  true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }),
                    ],
                  ),
                ),
              ),
            );
            // Vista por defecto
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          primaryColor.withOpacity(0.7), BlendMode.darken),
                      image: const AssetImage('assets/img/confirmacion.jpg'),
                      fit: BoxFit.cover)),
              child: Row(
                children: [
                  // Columna izquierda
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Titulo
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 5),
                                child: Text(
                                  "Editar Usuario",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Calibri-Bold',
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(
                                            0.5), // Color y opacidad de la sombra
                                        offset: const Offset(2,
                                            2), // Desplazamiento de la sombra (horizontal, vertical)
                                        blurRadius:
                                            3, // Radio de desenfoque de la sombra
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Campo de nombres
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2.0),
                                  child: TextFormField(
                                    controller: _nombresController,
                                    keyboardType: TextInputType.number,
                                    obscureText: false,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        labelText: "Nombres Completos"),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Campo de apellidos
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2.0),
                                  child: TextFormField(
                                    controller: _apellidosController,
                                    keyboardType: TextInputType.number,
                                    obscureText: false,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        labelText: "Apellidos Completos"),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Campos de identificación
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Identificación",
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Calibri-Bold',
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(
                                            0.5), // Color y opacidad de la sombra
                                        offset: const Offset(2,
                                            2), // Desplazamiento de la sombra (horizontal, vertical)
                                        blurRadius:
                                            3, // Radio de desenfoque de la sombra
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          // Configuración del DropdownButton
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Seleccione tipo de documento',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: options1
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.valor,
                                                    child: Text(
                                                      item.titulo,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: documento,
                                          onChanged: (String? value) {
                                            // Actualización del valor seleccionado
                                            setState(() {
                                              documento = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                              color: Colors.white,
                                            ),
                                            elevation: 2,
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.black,
                                            iconDisabledColor: Colors.grey,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                            offset: const Offset(-20, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: WidgetStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2.0, right: 2.0),
                                        child: TextFormField(
                                          controller: _documentoController,
                                          keyboardType: TextInputType.number,
                                          obscureText: false,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              fillColor: Colors.grey[200],
                                              filled: true,
                                              labelStyle: const TextStyle(
                                                  color: Colors.grey),
                                              labelText: "N° Documento"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Campo de correo electronico
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2.0),
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.number,
                                    obscureText: false,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        labelText: "Correo Electrónico"),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Información de contacto
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Información de contacto",
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Calibri-Bold',
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(
                                            0.5), // Color y opacidad de la sombra
                                        offset: const Offset(2,
                                            2), // Desplazamiento de la sombra (horizontal, vertical)
                                        blurRadius:
                                            3, // Radio de desenfoque de la sombra
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Campos de dirección y ciudad
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2.0, right: 2.0),
                                        child: TextFormField(
                                          controller: _direccionController,
                                          keyboardType: TextInputType.number,
                                          obscureText: false,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              fillColor: Colors.grey[200],
                                              filled: true,
                                              labelStyle: const TextStyle(
                                                  color: Colors.grey),
                                              labelText: "Dirección"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: defaultPadding,
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2.0, right: 2.0),
                                        child: TextFormField(
                                          controller: _ciudadController,
                                          keyboardType: TextInputType.number,
                                          obscureText: false,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              fillColor: Colors.grey[200],
                                              filled: true,
                                              labelStyle: const TextStyle(
                                                  color: Colors.grey),
                                              labelText: "Ciudad"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Campos de teléfono y celular
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2.0, right: 2.0),
                                        child: TextFormField(
                                          controller: _telefonoController,
                                          inputFormatters: [inputtelefono],
                                          keyboardType: TextInputType.number,
                                          obscureText: false,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              fillColor: Colors.grey[200],
                                              filled: true,
                                              labelStyle: const TextStyle(
                                                  color: Colors.grey),
                                              labelText: "Teléfono"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: defaultPadding,
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2.0, right: 2.0),
                                        child: TextFormField(
                                          controller:
                                              _telefonoCelularController,
                                          inputFormatters: [inputtelefono],
                                          keyboardType: TextInputType.number,
                                          obscureText: false,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              fillColor: Colors.grey[200],
                                              filled: true,
                                              labelStyle: const TextStyle(
                                                  color: Colors.grey),
                                              labelText: "Teléfono Celular"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Ver si es aprendiz
                              if (widget.usuario.rol2 == "APRENDIZ")
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    "Información Aprendiz",
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Calibri-Bold',
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Color y opacidad de la sombra
                                          offset: const Offset(2,
                                              2), // Desplazamiento de la sombra (horizontal, vertical)
                                          blurRadius:
                                              3, // Radio de desenfoque de la sombra
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // Ver si es aprendiz
                              if (widget.usuario.rol2 == "APRENDIZ")
                                const SizedBox(height: 15),
                              // Ver si es aprendiz
                              // Campos de ficha y si es vocero
                              if (widget.usuario.rol2 == "APRENDIZ")
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 2.0, right: 2.0),
                                          child: TextFormField(
                                            controller: _fichaController,
                                            keyboardType: TextInputType.number,
                                            obscureText: false,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                fillColor: Colors.grey[200],
                                                filled: true,
                                                labelStyle: const TextStyle(
                                                    color: Colors.grey),
                                                labelText: "N° Ficha"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: defaultPadding,
                                    ),
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "¿Usted es vocero?",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black.withOpacity(
                                                      0.5), // Color y opacidad de la sombra
                                                  offset: const Offset(2,
                                                      2), // Desplazamiento de la sombra (horizontal, vertical)
                                                  blurRadius:
                                                      3, // Radio de desenfoque de la sombra
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Checkbox(
                                            side: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                            value:
                                                isChecked1, // Estado actual del checkbox
                                            onChanged: (bool? newValue) {
                                              // Función que se ejecuta cuando el usuario cambia el estado del checkbox
                                              setState(() {
                                                // Actualiza el estado del widget
                                                isChecked1 = newValue ??
                                                    false; // Cambia el estado del checkbox al nuevo valor
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              // Ver si es aprendiz
                              if (widget.usuario.rol2 == "APRENDIZ")
                                const SizedBox(
                                  height: 20,
                                ),
                              // Ver si es funcionario
                              if (widget.usuario.rol2 == "FUNCIONARIO")
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    "Información Funcionario",
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Calibri-Bold',
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Color y opacidad de la sombra
                                          offset: const Offset(2,
                                              2), // Desplazamiento de la sombra (horizontal, vertical)
                                          blurRadius:
                                              3, // Radio de desenfoque de la sombra
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // Ver si es funcionario
                              if (widget.usuario.rol2 == "FUNCIONARIO")
                                const SizedBox(height: 15),
                              // Ver si es funcionario
                              // Campo para el cargo
                              if (widget.usuario.rol2 == "FUNCIONARIO")
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2.0, right: 2.0),
                                    child: TextFormField(
                                      controller: _cargoController,
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                          labelStyle: const TextStyle(
                                              color: Colors.grey),
                                          labelText: "Cargo"),
                                    ),
                                  ),
                                ),
                              // Ver si es funcionario
                              if (widget.usuario.rol2 == "FUNCIONARIO")
                                const SizedBox(
                                  height: 20,
                                ),
                              // Ver si es lider
                              if (widget.usuario.rol3 == "LIDER")
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    "Información Aplicativo",
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Calibri-Bold',
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Color y opacidad de la sombra
                                          offset: const Offset(2,
                                              2), // Desplazamiento de la sombra (horizontal, vertical)
                                          blurRadius:
                                              3, // Radio de desenfoque de la sombra
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // Ver si es lider
                              if (widget.usuario.rol3 == "LIDER")
                                const SizedBox(height: 15),
                              // Ver si es lider
                              // Desplegables para los roles
                              if (widget.usuario.rol3 == "LIDER")
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            // Configuración del DropdownButton
                                            isExpanded: true,
                                            hint: const Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Seleccione rol secundario',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            items: rolN1
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item.valor,
                                                      child: Text(
                                                        item.titulo,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ))
                                                .toList(),
                                            value: rol1,
                                            onChanged: (String? value) {
                                              // Actualización del valor seleccionado
                                              setState(() {
                                                rol1 = value;
                                              });
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                  left: 14, right: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: Colors.black26,
                                                ),
                                                color: Colors.white,
                                              ),
                                              elevation: 2,
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                              ),
                                              iconSize: 14,
                                              iconEnabledColor: Colors.black,
                                              iconDisabledColor: Colors.grey,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: Colors.white,
                                              ),
                                              offset: const Offset(-20, 0),
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                radius:
                                                    const Radius.circular(40),
                                                thickness: WidgetStateProperty
                                                    .all<double>(6),
                                                thumbVisibility:
                                                    WidgetStateProperty.all<
                                                        bool>(true),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 40,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            // Configuración del DropdownButton
                                            isExpanded: true,
                                            hint: const Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Seleccione rol terciario',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            items: rolN2
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item.valor,
                                                      child: Text(
                                                        item.titulo,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ))
                                                .toList(),
                                            value: rol2,
                                            onChanged: (String? value) {
                                              // Actualización del valor seleccionado
                                              setState(() {
                                                rol2 = value;
                                              });
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                  left: 14, right: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: Colors.black26,
                                                ),
                                                color: Colors.white,
                                              ),
                                              elevation: 2,
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                              ),
                                              iconSize: 14,
                                              iconEnabledColor: Colors.black,
                                              iconDisabledColor: Colors.grey,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: Colors.white,
                                              ),
                                              offset: const Offset(-20, 0),
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                radius:
                                                    const Radius.circular(40),
                                                thickness: WidgetStateProperty
                                                    .all<double>(6),
                                                thumbVisibility:
                                                    WidgetStateProperty.all<
                                                        bool>(true),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 40,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              // Ver si es lider
                              if (widget.usuario.rol3 == "LIDER")
                                const SizedBox(
                                  height: 20,
                                ),
                              // Ver si es lider
                              // Campo para activar o desactivar el usuario
                              if (widget.usuario.rol3 == "LIDER")
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "¿El usuario se encuentra activo?",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                                0.5), // Color y opacidad de la sombra
                                            offset: const Offset(2,
                                                2), // Desplazamiento de la sombra (horizontal, vertical)
                                            blurRadius:
                                                3, // Radio de desenfoque de la sombra
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Checkbox(
                                      side: const BorderSide(
                                          color: Colors.white, width: 2.0),
                                      value:
                                          isChecked2, // Estado actual del checkbox
                                      onChanged: (bool? newValue) {
                                        // Función que se ejecuta cuando el usuario cambia el estado del checkbox
                                        setState(() {
                                          // Actualiza el estado del widget
                                          isChecked2 = newValue ??
                                              false; // Cambia el estado del checkbox al nuevo valor
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              // Ver si es lider
                              if (widget.usuario.rol3 == "LIDER")
                                const SizedBox(
                                  height: 20,
                                ),
                              // Ver si es lider
                              // Desplegables para el punto de venta y la unidad de producción
                              if (widget.usuario.rol3 == "LIDER")
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: FutureBuilder(
                                          future:
                                              getUndadesProduccion(), // Carga las unidades de producción
                                          builder: (context,
                                              AsyncSnapshot<
                                                      List<
                                                          UnidadProduccionModel>>
                                                  snapshot) {
                                            // Verifica el estado de la carga
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                              // Verifica si hay un error
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                  'Error al cargar unidades: ${snapshot.error}',
                                                  style: TextStyle(
                                                    fontSize: 50,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.5), // Color y opacidad de la sombra
                                                        offset: const Offset(2,
                                                            2), // Desplazamiento de la sombra (horizontal, vertical)
                                                        blurRadius:
                                                            3, // Radio de desenfoque de la sombra
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                              // Verifica si hay datos
                                            } else {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25.0),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButton2<String>(
                                                    // Configuración del DropdownButton
                                                    isExpanded: true,
                                                    hint: const Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Seleccione unidad de producción',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    items: snapshot.data!
                                                        .map((item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item.id
                                                                  .toString(),
                                                              child: Text(
                                                                item.nombre,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: unidad,
                                                    onChanged: (String? value) {
                                                      // Actualización del valor seleccionado
                                                      setState(() {
                                                        unidad = value;
                                                      });
                                                    },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      height: 50,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: Colors.black26,
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                      elevation: 2,
                                                    ),
                                                    iconStyleData:
                                                        const IconStyleData(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                      ),
                                                      iconSize: 14,
                                                      iconEnabledColor:
                                                          Colors.black,
                                                      iconDisabledColor:
                                                          Colors.grey,
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      maxHeight: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        color: Colors.white,
                                                      ),
                                                      offset:
                                                          const Offset(-20, 0),
                                                      scrollbarTheme:
                                                          ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(40),
                                                        thickness:
                                                            WidgetStateProperty
                                                                .all<double>(6),
                                                        thumbVisibility:
                                                            WidgetStateProperty
                                                                .all<bool>(
                                                                    true),
                                                      ),
                                                    ),
                                                    menuItemStyleData:
                                                        const MenuItemStyleData(
                                                      height: 40,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 25.0),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                    ),
                                    Flexible(
                                      child: FutureBuilder(
                                          future:
                                              getPuntosVenta(), // Carga los puntos de venta
                                          builder: (context,
                                              AsyncSnapshot<
                                                      List<PuntoVentaModel>>
                                                  snapshot) {
                                            // Verifica el estado de la carga
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                              // Verifica si hay un error
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                  'Error al cargar puntos: ${snapshot.error}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.5), // Color y opacidad de la sombra
                                                        offset: const Offset(2,
                                                            2), // Desplazamiento de la sombra (horizontal, vertical)
                                                        blurRadius:
                                                            3, // Radio de desenfoque de la sombra
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                              // Verifica si hay datos
                                            } else {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25.0),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButton2<String>(
                                                    // Configuración del DropdownButton
                                                    isExpanded: true,
                                                    hint: const Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Seleccione punto de venta',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    items: snapshot.data!
                                                        .map((item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item.id
                                                                  .toString(),
                                                              child: Text(
                                                                item.nombre,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: punto,
                                                    onChanged: (String? value) {
                                                      // Actualización del valor seleccionado
                                                      setState(() {
                                                        punto = value;
                                                      });
                                                    },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      height: 50,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: Colors.black26,
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                      elevation: 2,
                                                    ),
                                                    iconStyleData:
                                                        const IconStyleData(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                      ),
                                                      iconSize: 14,
                                                      iconEnabledColor:
                                                          Colors.black,
                                                      iconDisabledColor:
                                                          Colors.grey,
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      maxHeight: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        color: Colors.white,
                                                      ),
                                                      offset:
                                                          const Offset(-20, 0),
                                                      scrollbarTheme:
                                                          ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(40),
                                                        thickness:
                                                            WidgetStateProperty
                                                                .all<double>(6),
                                                        thumbVisibility:
                                                            WidgetStateProperty
                                                                .all<bool>(
                                                                    true),
                                                      ),
                                                    ),
                                                    menuItemStyleData:
                                                        const MenuItemStyleData(
                                                      height: 40,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 25.0),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              // Ver si es lider
                              if (widget.usuario.rol3 == "LIDER")
                                const SizedBox(
                                  height: 20,
                                ),
                              // Ver si es lider
                              // Desplegable para la sede
                              if (widget.usuario.rol3 == "LIDER")
                                FutureBuilder(
                                    future: getSedes(), // Carga las sedes
                                    builder: (context,
                                        AsyncSnapshot<List<SedeModel>>
                                            snapshot) {
                                      // Verifica el estado de la carga
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                        // Verifica si hay un error
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            'Error al cargar sedes: ${snapshot.error}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black.withOpacity(
                                                      0.5), // Color y opacidad de la sombra
                                                  offset: const Offset(2,
                                                      2), // Desplazamiento de la sombra (horizontal, vertical)
                                                  blurRadius:
                                                      3, // Radio de desenfoque de la sombra
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                        // Verifica si hay datos
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              // Configuración del DropdownButton
                                              isExpanded: true,
                                              hint: const Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Seleccione Sede',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              items: snapshot.data!
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value:
                                                            item.id.toString(),
                                                        child: Text(
                                                          item.nombre,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: sede,
                                              onChanged: (String? value) {
                                                // Actualización del valor seleccionado
                                                setState(() {
                                                  sede = value;
                                                });
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                height: 50,
                                                padding: const EdgeInsets.only(
                                                    left: 14, right: 14),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                elevation: 2,
                                              ),
                                              iconStyleData:
                                                  const IconStyleData(
                                                icon: Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                ),
                                                iconSize: 14,
                                                iconEnabledColor: Colors.black,
                                                iconDisabledColor: Colors.grey,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                maxHeight: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: Colors.white,
                                                ),
                                                offset: const Offset(-20, 0),
                                                scrollbarTheme:
                                                    ScrollbarThemeData(
                                                  radius:
                                                      const Radius.circular(40),
                                                  thickness: WidgetStateProperty
                                                      .all<double>(6),
                                                  thumbVisibility:
                                                      WidgetStateProperty.all<
                                                          bool>(true),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                height: 40,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25.0),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                            ],
                          ),
                        ),
                      )),
                  // Separador
                  Container(
                    width: 2,
                    height: MediaQuery.of(context).size.height - 150,
                    color: Colors.white,
                  ),
                  // Columna derecha
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            // Imagen de perfil
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "Imagen de perfil",
                                style: TextStyle(
                                  fontSize:
                                      24, // Incremento de tamaño de fuente
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Calibri-Bold',
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(3, 3),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Imagen
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: selectFile.isEmpty
                                    ? CircleAvatar(
                                        radius: 200,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.5),
                                        backgroundImage: const AssetImage(
                                          "assets/img/logo.png",
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 200,
                                        backgroundImage:
                                            MemoryImage(selectedImagenInBytes!),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            // Botón de editar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      60, // Ajusta el ancho del contenedor del botón
                                  height:
                                      60, // Ajusta la altura del contenedor del botón
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: primaryColor,
                                        offset: Offset(3.0, 3.0),
                                        blurRadius: 4.0,
                                        spreadRadius: 1.5,
                                      ),
                                      BoxShadow(
                                        color: primaryColor,
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit,
                                        size: 35,
                                        color:
                                            primaryColor), // Incremento de tamaño del icono
                                    onPressed: () {
                                      // Llamado a la función
                                      _selectFile(true);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width:
                                      20, // Ajusta el espacio entre los botones
                                ),
                                Container(
                                  width:
                                      60, // Ajusta el ancho del contenedor del botón
                                  height:
                                      60, // Ajusta la altura del contenedor del botón
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: primaryColor,
                                        offset: Offset(3.0, 3.0),
                                        blurRadius: 4.0,
                                        spreadRadius: 1.5,
                                      ),
                                      BoxShadow(
                                        color: primaryColor,
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        size: 35,
                                        color:
                                            primaryColor), // Incremento de tamaño del icono
                                    onPressed: () {
                                      // Acción al presionar el botón de eliminar
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
