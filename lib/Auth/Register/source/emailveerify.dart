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

class VerificationScreenRegister extends StatefulWidget {
  final String usuarioNombres;
  final String usuarioApellidos;
  final String usuarioTelefono;
  final String usuarioTdocumento;
  final String usuarionoDocumento;
  final String usuarioemail;

  final String code;
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
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  final emailService = VerificationService();
  bool isLoading = false;
  late String _currentCode;
  late Timer _timer;
  late int numeroEnvios = 0;

  @override
  void initState() {
    super.initState();
    _currentCode = widget.code;
    _timer = Timer.periodic(
      const Duration(seconds: 300),
      (timer) {
        setState(
          () {
            _currentCode = generateRandomCode();
            numeroEnvios++;
            if (numeroEnvios == 3) {
              _timer.cancel();
              showAlertAndNavigate(context);
            } else {
              emailService.djangoSendEmail(widget.usuarioemail, _currentCode);
              nuevoCodigo(context);
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispos
    super.dispose();
    _timer.cancel();
    clearControllers();
  }

  Future<void> confirmCode() async {
    String code = getVerificationCode();

    String url = "";

    url = "$sourceApi/api/usuarios/";
    if (code == _currentCode) {
      // Cancelamos el timer y mostramos la siguiente pagina
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
        List<UsuarioModel> usuarios = await getUsuarios();
        final usuarioEncontrado = usuarios
            .where((usuario) =>
                usuario.numeroDocumento == widget.usuarionoDocumento)
            .firstOrNull;
        if (usuarioEncontrado != null) {
          setState(() {
            Provider.of<AppState>(context, listen: false)
                .setUsuarioAutenticado(usuarioEncontrado);
            _timer.cancel();
          });
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        print('Error al registrar el usuario: $e');
      }
      // comprobamos que los datos si esten en la base de datos
    } else {
      verificacionError(context);
    }
  }

  // limpiar los controladores
  void clearControllers() {
    for (var controller in _controllers) {
      controller.clear();
    }
  }

  String getVerificationCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, responsive) {
        // verificar si la oantalla es del tamaño movil.
        if (responsive.maxWidth <= 970) {
          return Scaffold(
            body: Container(
              decoration:
                  const BoxDecoration(image: DecorationImage(image: AssetImage(
                      //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                      'assets/img/login.jpg'), fit: BoxFit.fill)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
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
                    color: const Color.fromARGB(122, 0, 0, 0),
                    borderRadius: BorderRadius.circular(15)),
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
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Text.rich(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              TextSpan(
                                text: 'Se envio un correo de verificación a ',
                                children: [
                                  WidgetSpan(
                                    child: SizedBox(
                                      width: 150, // ancho máximo del texto
                                      child: Text(
                                        widget.usuarioemail,
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
                                        ', este codigo tiene una duracion de 5 min, pasados estos se te enviara otro.',
                                  ),
                                ],
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
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
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
                                                  fontSize: 24,
                                                  color: Colors.black),
                                            ),
                                            maxLength: 1,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            onChanged: (value) {
                                              if (value.length == 1) {
                                                // Si se ingresa un valor, pasar al siguiente campo
                                                _focusNodes[index].unfocus();
                                                if (index < 5) {
                                                  _focusNodes[index + 1]
                                                      .requestFocus();
                                                }
                                              } else if (value.isEmpty &&
                                                  index > 0) {
                                                // Si se borra un valor, regresar al campo anterior
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
                                // Función de Verificación
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
          return Scaffold(
            body: Container(
              decoration:
                  const BoxDecoration(image: DecorationImage(image: AssetImage(
                      //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                      'assets/img/login.jpg'), fit: BoxFit.fill)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 23.0, vertical: 30.0),
                child: Row(
                  children: [
                    // Columna izquierda, información
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'CBA Mosquera',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 100,
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
                            Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: Text(
                                'El camino hacia el éxito empieza aquí.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontFamily: 'Calibri',
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
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Columna derecha con formulario.
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
                            color: const Color.fromARGB(122, 0, 0, 0),
                            borderRadius: BorderRadius.circular(15)),
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
                                          color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Text.rich(
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      TextSpan(
                                        text:
                                            'Se envio un correo de verificación a ',
                                        children: [
                                          WidgetSpan(
                                            child: SizedBox(
                                              width:
                                                  150, // ancho máximo del texto
                                              child: Text(
                                                widget.usuarioemail,
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
                                                ', este codigo tiene una duracion de 5 min, pasados estos se te enviara otro.',
                                          ),
                                        ],
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
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
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
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.black),
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
                                                        // Si se ingresa un valor, pasar al siguiente campo
                                                        _focusNodes[index]
                                                            .unfocus();
                                                        if (index < 5) {
                                                          _focusNodes[index + 1]
                                                              .requestFocus();
                                                        }
                                                      } else if (value
                                                              .isEmpty &&
                                                          index > 0) {
                                                        // Si se borra un valor, regresar al campo anterior
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
                                        // Función de Verificación
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

// metodo que indica que el codigo no coincide
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
  void nuevoCodigo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tiempo Agotado"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "¡Te enviaremos un código nuevo!",
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

  void showAlertAndNavigate(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Emails Enviados"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("¡Se han enviado 3 correos! Redirigiendo..."),
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
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pop(context); // Cerrar el diálogo
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
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
