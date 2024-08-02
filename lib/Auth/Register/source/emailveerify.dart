// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Auth/Verify/randomCode.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:http/http.dart' as http;
import '../../../Home/homePage.dart';
import '../../../Models/usuarioModel.dart';
import '../../../source.dart';
import '../../source/verification.dart';
// import 'package:smtp/smtp.dart';

/// Esta clase representa la pantalla de verificación del correo electrónico para el registro de usuarios.
///
/// Esta clase extiende [StatefulWidget] y proporciona un estado asociado
/// [_VerificationScreenRegisterState].
///
/// Los siguientes atributos deben ser proporcionados:
/// - [usuarioNombres]: El nombre del usuario.
/// - [usuarioApellidos]: El apellido del usuario.
/// - [usuarioTelefono]: El número de teléfono del usuario.
/// - [usuarioTdocumento]: El tipo de documento del usuario.
/// - [usuarionoDocumento]: El número de documento del usuario.
/// - [usuarioemail]: El correo electrónico del usuario.
/// - [code]: El código de verificación enviado al correo electrónico del usuario.
class VerificationScreenRegister extends StatefulWidget {
  /// El nombre del usuario.
  final String usuarioNombres;

  /// El apellido del usuario.
  final String usuarioApellidos;

  /// El número de teléfono del usuario.
  final String usuarioTelefono;

  /// El tipo de documento del usuario.
  final String usuarioTdocumento;

  /// El número de documento del usuario.
  final String usuarionoDocumento;

  /// El correo electrónico del usuario.
  final String usuarioemail;

  /// El código de verificación enviado al correo electrónico del usuario.
  final String code;

  /// Construye un objeto [VerificationScreenRegister].
  ///
  /// Los siguientes parámetros deben ser proporcionados:
  /// - [usuarioNombres]: El nombre del usuario.
  /// - [usuarioApellidos]: El apellido del usuario.
  /// - [usuarioTelefono]: El número de teléfono del usuario.
  /// - [usuarioTdocumento]: El tipo de documento del usuario.
  /// - [usuarionoDocumento]: El número de documento del usuario.
  /// - [usuarioemail]: El correo electrónico del usuario.
  /// - [code]: El código de verificación enviado al correo electrónico del usuario.
  const VerificationScreenRegister({
    super.key,
    required this.usuarioNombres,
    required this.code,
    required this.usuarioApellidos,
    required this.usuarioTelefono,
    required this.usuarioTdocumento,
    required this.usuarionoDocumento,
    required this.usuarioemail,
  });

  @override
  State<VerificationScreenRegister> createState() =>
      _VerificationScreenRegisterState();
}

class _VerificationScreenRegisterState
    extends State<VerificationScreenRegister> {
  /// Los controles de texto de los campos de entrada.
  ///
  /// Cada elemento de la lista es un [TextEditingController] que se utiliza para
  /// validar el valor ingresado en el campo de entrada correspondiente.
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  /// Las nodos de enfoque de los campos de entrada.
  ///
  /// Cada elemento de la lista es un [FocusNode] que se utiliza para
  /// controlar el enfoque de los campos de entrada correspondientes.
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  /// La clase de servicio para la verificación de correos electrónicos.
  final emailService = VerificationService();

  /// Indica si se está realizando una carga de información.
  bool isLoading = false;

  /// El código de verificación actual.
  late String _currentCode;

  /// El temporizador que se utiliza para enviar nuevos códigos de verificación.
  late Timer _timer;

  /// El número de veces que se ha enviado un código de verificación.
  late int numeroEnvios = 0;

  @override

  /// Inicializa el estado de la pantalla de verificación del código.
  ///
  /// Establece el código de verificación actual y establece un temporizador que envía
  /// nuevos códigos de verificación cada 300 segundos. Si se han enviado 3 códigos,
  /// se cancela el temporizador y se muestra un diálogo de alerta.
  void initState() {
    super.initState();

    // Establecer el código de verificación actual
    _currentCode = widget.code;

    // Establecer un temporizador para enviar nuevos códigos de verificación
    _timer = Timer.periodic(
      const Duration(seconds: 300),
      (timer) {
        setState(() {
          // Generar un nuevo código de verificación
          _currentCode = generateRandomCode();

          // Incrementar el número de envios
          numeroEnvios++;

          // Si se han enviado 3 códigos, cancelar el temporizador y mostrar un diálogo
          if (numeroEnvios == 3) {
            _timer.cancel();
            showAlertAndNavigate(context);
          } else {
            // Enviar un nuevo código de verificación por correo electrónico
            emailService.djangoSendEmail(widget.usuarioemail, _currentCode);

            // Actualizar la interfaz de usuario con el nuevo código de verificación
            nuevoCodigo(context);
          }
        });
      },
    );
  }

  @override

  /// Libera los recursos utilizados por el temporizador y los controles de texto.
  ///
  /// Se llama automáticamente cuando se elimina el widget.
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por el temporizador y los controles de texto.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos adicionales.
  @override
  void dispose() {
    // Cancela el temporizador si está activo
    _timer.cancel();

    // Llama al método [clearControllers] para liberar los controles de texto
    clearControllers();

    // Llama al método [dispose] del widget base
    super.dispose();
  }

  /// Función asincrónica para confirmar el código de verificación ingresado por el usuario.
  ///
  /// Verifica si el código ingresado coincide con el código de verificación enviado por correo electrónico.
  /// Si los códigos coinciden, envía una solicitud POST a la API para registrar al usuario y muestra la página de inicio.
  /// Si los códigos no coinciden, muestra un diálogo indicando un error de verificación.
  ///
  /// No recibe ningún parámetro.
  /// Devuelve una [Future] que se completa cuando la función finaliza.
  Future<void> confirmCode() async {
    // Obtener el código de verificación ingresado por el usuario
    String code = getVerificationCode();

    // URL de la API para registrar al usuario
    String url = "$sourceApi/api/usuarios/";

    // Verificar si el código ingresado coincide con el código de verificación enviado por correo electrónico
    if (code == _currentCode) {
      // Cancelamos el temporizador y mostramos la siguiente página
      final headers = {'Content-Type': 'application/json'};
      var defaultRol = "EXTERNO";
      var defaultStatus = true;
      final body = jsonEncode({
        'ciudad': '',
        'nombres': widget.usuarioNombres,
        'apellidos': widget.usuarioApellidos,
        'correoElectronico': widget.usuarioemail,
        'tipoDocumento': widget.usuarioTdocumento,
        'numeroDocumento': widget.usuarionoDocumento,
        'telefono': '',
        'rol1': defaultRol,
        'rol2': '',
        'rol3': '',
        'estado': defaultStatus,
        'telefonoCelular': widget.usuarioTelefono,
      });
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        print('El usuario fue registrado exitosamente');
        // Obtener la lista de usuarios
        List<UsuarioModel> usuarios = await getUsuarios();
        // Buscar al usuario con el número de documento proporcionado
        final usuarioEncontrado = usuarios
            .where((usuario) =>
                usuario.numeroDocumento == widget.usuarionoDocumento)
            .firstOrNull;
        if (usuarioEncontrado != null) {
          setState(() {
            // Setear el usuario autenticado en el estado global
            Provider.of<AppState>(context, listen: false)
                .setUsuarioAutenticado(usuarioEncontrado, context);
            _timer.cancel();
          });
        }

        // Navegar a la página de inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        print('Error al registrar el usuario: $e');
      }
      // Comprobar si los datos ya están en la base de datos
    } else {
      // Mostrar un diálogo indicando un error de verificación
      verificacionError(context);
    }
  }

  /// Llama al método [clear] de cada controlador en la lista `_controllers`
  /// para limpiar los campos de texto.
  void clearControllers() {
    // Recorrer la lista de controles de texto y llamar al método [clear]
    // para limpiar cada uno de ellos.
    for (var controller in _controllers) {
      controller.clear();
    }
  }

  /// Obtiene el código de verificación concatenando el texto de cada controlador de texto en la lista [_controllers].
  ///
  /// Devuelve la cadena resultante.
  String getVerificationCode() {
    // Recorrer la lista de controladores de texto y obtener el texto de cada uno,
    // luego concatenarlos en una sola cadena.
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, responsive) {
        // Verificar si la pantalla es del tamaño móvil.
        if (responsive.maxWidth <= 970) {
          // Retornar el Scaffold para pantallas móviles.
          return Scaffold(
            body: Container(
              // Configuración del fondo de pantalla.
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/img/login.jpg'), // Ruta de la imagen de fondo
                  fit: BoxFit.fill, // Ajuste de la imagen al contenedor
                ),
              ),
              width: MediaQuery.of(context).size.width, // Ancho de la pantalla
              height: MediaQuery.of(context).size.height, // Alto de la pantalla
              child: Container(
                // Contenedor principal
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 150,
                  bottom: 50,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  // Decoración del contenedor
                  color: const Color.fromARGB(
                      122, 0, 0, 0), // Color de fondo con opacidad
                  borderRadius: BorderRadius.circular(15), // Bordes redondeados
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 2),
                            child: Text(
                              'Verificación',
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Calibri-Bold',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Text.rich(
                              // Texto de verificación con correo electrónico
                              TextSpan(
                                text: 'Se envió un correo de verificación a ',
                                children: [
                                  WidgetSpan(
                                    child: SizedBox(
                                      width:
                                          150, // Ancho máximo del texto del correo
                                      child: Text(
                                        widget
                                            .usuarioemail, // Correo electrónico dinámico
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const TextSpan(
                                    text:
                                        ', este código tiene una duración de 5 min, pasados estos se te enviará otro.',
                                  ),
                                ],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: List.generate(
                                    6,
                                    (index) {
                                      return Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.all(2),
                                          child: TextFormField(
                                            controller: _controllers[index],
                                            focusNode: _focusNodes[index],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: '*',
                                              hintStyle: const TextStyle(
                                                fontSize: 35,
                                                color: Colors.black,
                                              ),
                                            ),
                                            maxLength: 1,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            onChanged: (value) {
                                              if (value.length == 1) {
                                                // Avanzar al siguiente campo cuando se ingresa un valor
                                                _focusNodes[index].unfocus();
                                                if (index < 5) {
                                                  _focusNodes[index + 1]
                                                      .requestFocus();
                                                }
                                              } else if (value.isEmpty &&
                                                  index > 0) {
                                                // Retroceder al campo anterior cuando se borra un valor
                                                _focusNodes[index].unfocus();
                                                _focusNodes[index - 1]
                                                    .requestFocus();
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: InkWell(
                              onTap: () {
                                // Función de verificación
                                confirmCode();
                              },
                              child: Container(
                                width: 150,
                                height: 50,
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Verificar',
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
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          // Retornar el Scaffold para pantallas más grandes
          return Scaffold(
            body: Container(
              // Configuración del fondo de pantalla.
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/img/login.jpg'), // Ruta de la imagen de fondo
                  fit: BoxFit.fill, // Ajuste de la imagen al contenedor
                ),
              ),
              width: MediaQuery.of(context).size.width, // Ancho de la pantalla
              height: MediaQuery.of(context).size.height, // Alto de la pantalla
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 23.0, vertical: 30.0),
                child: Row(
                  children: [
                    // Columna izquierda, información principal
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'CBA Mosquera', // Título principal
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 100,
                                fontFamily: 'Calibri-Bold',
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(2, 2),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: Text(
                                'El camino hacia el éxito empieza aquí.', // Subtítulo
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontFamily: 'Calibri',
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(2, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Columna derecha con el formulario de verificación
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 50,
                          bottom: 50,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          // Decoración del contenedor
                          color: const Color.fromARGB(
                              122, 0, 0, 0), // Color de fondo con opacidad
                          borderRadius:
                              BorderRadius.circular(15), // Bordes redondeados
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      'Verificación',
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontFamily: 'Calibri-Bold',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Text.rich(
                                      // Texto de verificación con correo electrónico
                                      TextSpan(
                                        text:
                                            'Se envió un correo de verificación a ',
                                        children: [
                                          WidgetSpan(
                                            child: SizedBox(
                                              width:
                                                  150, // Ancho máximo del texto del correo
                                              child: Text(
                                                widget
                                                    .usuarioemail, // Correo electrónico dinámico
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const TextSpan(
                                            text:
                                                ', este código tiene una duración de 5 min, pasados estos se te enviará otro.',
                                          ),
                                        ],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: List.generate(
                                            6,
                                            (index) {
                                              return Expanded(
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  child: TextFormField(
                                                    controller:
                                                        _controllers[index],
                                                    focusNode:
                                                        _focusNodes[index],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 10),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText: '*',
                                                      hintStyle:
                                                          const TextStyle(
                                                        fontSize: 35,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    maxLength: 1,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    onChanged: (value) {
                                                      if (value.length == 1) {
                                                        // Avanzar al siguiente campo cuando se ingresa un valor
                                                        _focusNodes[index]
                                                            .unfocus();
                                                        if (index < 5) {
                                                          _focusNodes[index + 1]
                                                              .requestFocus();
                                                        }
                                                      } else if (value
                                                              .isEmpty &&
                                                          index > 0) {
                                                        // Retroceder al campo anterior cuando se borra un valor
                                                        _focusNodes[index]
                                                            .unfocus();
                                                        _focusNodes[index - 1]
                                                            .requestFocus();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: InkWell(
                                      onTap: () {
                                        // Función de verificación
                                        confirmCode();
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Verificar',
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  /// Método que muestra un diálogo con un mensaje de error cuando el código de verificación no coincide.
  ///
  /// Este método muestra un diálogo con el título "Error de verificación" y el mensaje "¡El código no coincide!"
  /// en el centro. También muestra una imagen del logo de la aplicación, recortada en forma circular.
  ///
  /// [context] es el contexto de la aplicación donde se mostrará el diálogo.
  void verificacionError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error de verificación"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "¡El código no coincide!",
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
                  child: _buildButton("Cancelar", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Intentar de nuevo", () {
                    Navigator.pop(context);
                    setState(() {
                      clearControllers();
                    });
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

// metodo que indica que pasaron 5 min y se enviara un nuevo codigo
  /// Muestra un diálogo indicando que se ha agotado el tiempo para la verificación
  /// y se enviará un nuevo código.
  ///
  /// [context] es el contexto de la aplicación donde se mostrará el diálogo.
  void nuevoCodigo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tiempo Agotado"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Texto informativo para el usuario
              const Text(
                "¡Te enviaremos un código nuevo!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              // Contenedor circular con la imagen del logo de la aplicación
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
                    // Al aceptar, se reinician los controles del formulario
                    Navigator.pop(context);
                    setState(() {
                      clearControllers();
                    });
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Muestra un diálogo indicando que se han enviado 3 correos y que se
  /// redirigirá a la página de inicio después de 5 segundos.
  ///
  /// [context] es el contexto de la aplicación donde se mostrará el diálogo.
  void showAlertAndNavigate(BuildContext context) {
    // Muestra un diálogo con el contenido personalizado.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Título del diálogo
          title: const Text("Emails Enviados"),
          // Contenido del diálogo
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Texto informativo para el usuario
              const Text(
                "¡Se han enviado 3 correos! Redirigiendo...",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              // Contenedor circular con la imagen del logo de la aplicación
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
        );
      },
    );

    // Cierra el diálogo después de 5 segundos y redirige a la página de inicio
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pop(context); // Cierra el diálogo
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

  /// Construye un botón con los estilos de diseño especificados.
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
  ///
  /// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
  Widget _buildButton(String text, VoidCallback onPressed) {
    // Contenedor con un ancho fijo de 200 píxeles y una apariencia personalizada
    // con un borde redondeado, un gradiente de colores y una sombra.
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Borde redondeado.
        gradient: const LinearGradient(
          colors: [
            botonClaro, // Color claro del gradiente.
            botonOscuro, // Color oscuro del gradiente.
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: botonSombra, // Color de la sombra.
            blurRadius: 5, // Radio de desfoque de la sombra.
            offset: Offset(0, 3), // Desplazamiento de la sombra.
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Color transparente para el Material.
        child: InkWell(
          onTap: onPressed, // Función de presionar.
          borderRadius:
              BorderRadius.circular(10), // Radio del borde redondeado.
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10), // Padding vertical.
            child: Center(
              child: Text(
                text, // Texto del botón.
                style: const TextStyle(
                  color: background1, // Color del texto.
                  fontSize: 13, // Tamaño de fuente.
                  fontWeight: FontWeight.bold, // Peso de fuente.
                  fontFamily: 'Calibri-Bold', // Fuente.
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
