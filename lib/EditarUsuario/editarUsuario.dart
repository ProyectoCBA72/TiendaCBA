// ignore_for_file: file_names, avoid_print, use_build_context_synchronously
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tienda_app/EditarUsuario/desplegablesEditar.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:image/image.dart' as im;

class FormActualizarUsuario extends StatefulWidget {
  const FormActualizarUsuario({super.key});

  @override
  State<FormActualizarUsuario> createState() => _FormActualizarUsuarioState();
}

class _FormActualizarUsuarioState extends State<FormActualizarUsuario> {
  String? documento;

  String? rol1;

  String? rol2;

  String? unidad;

  String? punto;

  String? sede;

  bool isChecked1 = false; // Variable para almacenar el estado del checkbox

  bool isChecked2 = false; // Variable para almacenar el estado del checkbox

  // Mascara para el número de telefono
  var inputtelefono = MaskTextInputFormatter(
      mask: "### ### ####", filter: {"#": RegExp(r'[0-9]')});

  String selectFile = '';
  Uint8List? selectedImagenInBytes;

  // Método para seleccionar una imagen
  _selectFile(bool imagenFrom) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
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
                      // Campo del titulo
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
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
                      const SizedBox(height: 15),
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
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: TextFormField(
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
                                value: isChecked1, // Estado actual del checkbox
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
                      const SizedBox(
                        height: 20,
                      ),
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
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
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
                                labelText: "Cargo"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                      const SizedBox(height: 15),
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
                      const SizedBox(
                        height: 20,
                      ),
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
                      const SizedBox(
                        height: 20,
                      ),
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
                                        'Seleccione unidad de producción',
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
                                items: unidadL
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
                                        'Seleccione punto de venta',
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
                                items: puntoL
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
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                            items: sedeL
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
                            value: sede,
                            onChanged: (String? value) {
                              // Actualización del valor seleccionado
                              setState(() {
                                sede = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
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
                                thickness: WidgetStateProperty.all<double>(6),
                                thumbVisibility:
                                    WidgetStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                            ),
                          ),
                        ),
                      ),
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
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              // Campo del titulo
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
                              const SizedBox(height: 15),
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
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                              const SizedBox(height: 15),
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
                                        labelText: "Cargo"),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                                                  'Seleccione rol secundario',
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                    fontWeight: FontWeight.bold,
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                              const SizedBox(
                                height: 20,
                              ),
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
                                          items: unidadL
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
                                          items: puntoL
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
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
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
                                    items: sedeL
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Container(
                    width: 2,
                    height: MediaQuery.of(context).size.height - 150,
                    color: Colors.white,
                  ),
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
