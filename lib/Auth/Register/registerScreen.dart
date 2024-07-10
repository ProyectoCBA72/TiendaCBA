// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tienda_app/Auth/Register/source/emailveerify.dart';
import 'package:tienda_app/Auth/Verify/randomCode.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'source/desplegables.dart';
import '../source/verification.dart';

/// Esta clase representa la pantalla de registro de usuarios.
///
/// Esta clase extiende [StatefulWidget] y tiene un único método obligatorio:
/// [createState] que crea un estado [_RegisterState] para manejar los datos de la pantalla.
class Register extends StatefulWidget {
  /// Constructor de la clase [Register].
  ///
  /// No recibe ningún parámetro.
  const Register({
    super.key,
  });

  /// Retorna el estado de la pantalla de registro de usuarios.
  ///
  /// Devuelve un estado [_RegisterState].
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  /// Controlador de entrada de texto para el nombre.
  ///
  /// Es utilizado para capturar el nombre del usuario.
  final _nombresController = TextEditingController();

  /// Controlador de entrada de texto para los apellidos.
  ///
  /// Es utilizado para capturar los apellidos del usuario.
  final _apellidosController = TextEditingController();

  /// Controlador de entrada de texto para el número de teléfono.
  ///
  /// Es utilizado para capturar el número de teléfono del usuario.
  final _telefonoController = TextEditingController();

  /// Controlador de entrada de texto para el tipo de documento.
  ///
  /// Es utilizado para capturar el tipo de documento del usuario.
  final _tipoDocumenntoController = TextEditingController();

  /// Controlador de entrada de texto para el número de documento.
  ///
  /// Es utilizado para capturar el número de documento del usuario.
  final _noDocumentoController = TextEditingController();

  /// Controlador de entrada de texto para el correo electrónico.
  ///
  /// Es utilizado para capturar el correo electrónico del usuario.
  final _emailController = TextEditingController();

  /// Controlador de página para el desplazamiento entre las páginas.
  ///
  /// Es utilizado para controlar el desplazamiento entre las páginas del formulario.
  final PageController _pageController = PageController();

  /// Servicio para la verificación del correo electrónico.
  ///
  /// Es utilizado para enviar los correos de verificación.
  final emailService = VerificationService();

  /// Mascara para el número de teléfono.
  ///
  /// Es utilizado para formatear el número de teléfono ingresado por el usuario.
  var inputtelefono = MaskTextInputFormatter(
      mask: "### ### ####", filter: {"#": RegExp(r'[0-9]')});

  String? documento;

  /// Clave de formulario para la primera página.
  ///
  /// Es utilizado para validar los campos de entrada de texto en la primera página del formulario.
  final _page1FormKey = GlobalKey<FormState>();

  /// Clave de formulario para la segunda página.
  ///
  /// Es utilizado para validar los campos de entrada de texto en la segunda página del formulario.
  final _page2FormKey = GlobalKey<FormState>();

  /// Indica la página actual del formulario.
  ///
  /// Es utilizado para controlar la página actual del formulario.
  int _currentPage = 0;

  @override

  /// Método que se llama automáticamente cuando se elimina el widget.
  ///
  /// Se utiliza para liberar los recursos utilizados por el widget.
  /// En este caso, se libera la memoria utilizada por los controladores de entrada de texto.
  /// También se llama al método [super.dispose()] para liberar los recursos del widget padre.
  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _tipoDocumenntoController.dispose();
    _noDocumentoController.dispose();
    super.dispose();
  }

  /// Método que se encarga de avanzar a la página siguiente del formulario.
  ///
  /// Verifica si la página actual es la primera página y si los campos de entrada de texto en la primera página son válidos.
  /// Si los campos son válidos, avanza a la página siguiente y actualiza el estado de la página actual.
  ///
  /// No devuelve nada.
  void _nextPage() {
    // Verifica si la página actual es la primera página
    if (_currentPage == 0) {
      // Verifica si los campos de entrada de texto en la primera página son válidos
      if (_page1FormKey.currentState?.validate() == true) {
        // Avanza a la siguiente página
        setState(() {
          _currentPage++;
        });
        // Anima la transición a la siguiente página
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  /// Método que se encarga de retroceder a la página anterior del formulario.
  ///
  /// Verifica si la página actual es mayor que 0, es decir, si no es la primera página.
  /// Si es así, retrocede a la página anterior y actualiza el estado de la página actual.
  ///
  /// No devuelve nada.
  void _prevPage() {
    // Verifica si la página actual es mayor que 0
    if (_currentPage > 0) {
      // Retrocede a la página anterior
      setState(() {
        _currentPage--;
      });
      // Anima la transición a la página anterior
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500), // Duración de la animación
        curve:
            Curves.easeInOut, // Curva de la animación para suavizar los cambios
      );
    }
  }

  /// Método asincrónico para registrar un usuario en la base de datos.
  ///
  /// Verifica si los campos de entrada en la segunda página son válidos.
  /// Si los campos son válidos, genera un código aleatorio y envía un correo electrónico de verificación.
  /// Luego, navega a la pantalla de verificación de correo electrónico pasando los datos del usuario y el código aleatorio generado.
  ///
  /// No devuelve nada.
  Future<void> singUp() async {
    // Obtener la lista de usuarios de la base de datos
    final usuarios = await getUsuarios();

    // Generar un código aleatorio para la verificación del correo electrónico
    final currentCode = generateRandomCode();

    // Verificar si el número de documento del usuario ya está registrado
    final isRegister = usuarios.any(
      (usuario) => usuario.numeroDocumento == _noDocumentoController.text,
    );

    // Si el usuario ya está registrado, mostramos un modal de error
    if (isRegister) {
      mostrarDialogoError(context);
    } else {
      // Si el usuario no está registrado, verificamos que los datos sean válidos
      if (_page2FormKey.currentState?.validate() == true) {
        // Enviar un correo electrónico de verificación al usuario
        emailService.djangoSendEmail(_emailController.text.trim(), currentCode);

        // Navegar a la pantalla de verificación de correo electrónico
        Navigator.push(
          context,
          MaterialPageRoute(
            // Construir la siguiente página, pasando los datos del usuario y el código aleatorio generado
            builder: (context) => VerificationScreenRegister(
              usuarioNombres: _nombresController.text.trim(),
              usuarioApellidos: _apellidosController.text.trim(),
              usuarioTelefono: _telefonoController.text.trim(),
              usuarioTdocumento: _tipoDocumenntoController.text.trim(),
              usuarionoDocumento: _noDocumentoController.text.trim(),
              usuarioemail: _emailController.text.trim(),
              code: currentCode,
            ),
          ),
        );
      }
    }
  }

  void mostrarDialogoError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error de Registro"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "¡El numero de documento ya existe en la base de datos. Ingrese con su numero de documento!",
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
                  child: _buildButton("Aceptar", () {
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

  /// Método que se encarga de construir la interfaz de la página actual.
  ///
  /// Este método retorna un widget [PageView] que contiene las dos páginas de
  /// registro, [ _buildPage1() ] e [ _buildPage2() ].
  @override
  Widget build(Object context) {
    // Construye la página actual con una lista de widgets [PageView] que
    // contiene las dos páginas de registro. El controlador de la página se
    // inicializa con el widget [ _pageController ]. Además, se establece la
    // física de desplazamiento a [ NeverScrollableScrollPhysics ], lo que
    // impide desplazarse por la página.
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildPage1(), // Construye la primera página de registro
        _buildPage2(), // Construye la segunda página de registro
      ],
    );
  }

  /// Construye la primera página del formulario de registro.
  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Encabezado de registro
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 33,
                        fontFamily: 'Calibri-Bold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 30),
                    child: Text(
                      'Únete hoy y descubre tu potencial con nosotros',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        //fontFamily: 'DelaGothicOne'
                      ),
                    ),
                  ),
                ],
              ),
              // Formulario de registro
              Form(
                key: _page1FormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 35),
                    // Campo de nombres completos
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.black),
                            controller: _nombresController,
                            obscureText: false,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: primaryColor),
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
                              hintText: 'Nombres Completos',
                              hintStyle: const TextStyle(color: Colors.black),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    // Campo de apellidos completos
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.black),
                            controller: _apellidosController,
                            obscureText: false,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: primaryColor),
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
                              hintText: 'Apellidos Completos',
                              hintStyle: const TextStyle(color: Colors.black),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    // Campo de teléfono celular
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            inputFormatters: [inputtelefono],
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.black),
                            controller: _telefonoController,
                            obscureText: false,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: primaryColor),
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
                              hintText: 'Teléfono Celular',
                              hintStyle: const TextStyle(color: Colors.black),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Botón siguiente
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 15, top: 25, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              _nextPage();
                            },
                            child: Container(
                              width: 200,
                              height: 50,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'Siguiente',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye la segunda página del formulario de registro.
  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Encabezado de registro
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 33,
                        fontFamily: 'Calibri-Bold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 30),
                    child: Text(
                      'Únete hoy y descubre tu potencial con nosotros',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        //fontFamily: 'DelaGothicOne'
                      ),
                    ),
                  ),
                ],
              ),
              // Formulario de registro
              Form(
                key: _page2FormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 35),
                    // Selector de tipo de documento
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
                          items: options
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
                              _tipoDocumenntoController.text = documento!;
                            });
                            if (documento == null || documento!.isEmpty) {
                              return;
                            }
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            padding: const EdgeInsets.only(left: 14, right: 14),
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
                    const SizedBox(
                      height: 35,
                    ),
                    // Campo de número de documento
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.black),
                            controller: _noDocumentoController,
                            obscureText: false,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: primaryColor),
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
                              hintText: 'N° Documento',
                              hintStyle: const TextStyle(color: Colors.black),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    // Campo de correo electrónico
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.black),
                            controller: _emailController,
                            obscureText: false,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(color: primaryColor),
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
                              hintText: 'Correo Electrónico',
                              hintStyle: const TextStyle(color: Colors.black),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Botones de navegación
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 15, top: 25, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Botón 'Anterior' y 'Registrarse' adaptativos según el ancho de pantalla
                          if (MediaQuery.of(context).size.width <= 1250)
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _prevPage();
                                  },
                                  child: Container(
                                    width: 200,
                                    height: 50,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Anterior',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    singUp();
                                  },
                                  child: Container(
                                    width: 200,
                                    height: 50,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Registrarse',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(),
                                  child: InkWell(
                                    onTap: () {
                                      _prevPage();
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 50,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Anterior',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      singUp();
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 50,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Registrarse',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
