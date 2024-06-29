// ignore_for_file: file_names, prefer_final_fields, use_build_context_synchronously, avoid_print, no_logic_in_create_state, avoid_unnecessary_containers

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Auth/Verify/metodoVerificacion.dart';
import 'package:tienda_app/Auth/Verify/randomCode.dart';
import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:universal_platform/universal_platform.dart';

import '../Register/registerScreen.dart';
import '../source/verification.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  late TabController tabController;
  Login({
    super.key,
    required this.tabController,
  });

  @override
  State<Login> createState() => _LoginState(tabController: tabController);
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late TabController tabController;
  // Constructor para inicializar el estado
  _LoginState({required this.tabController});

  // Controladores para los campos de correo electrónico y contraseña
  final _documentoController = TextEditingController();
  // Pasword controller sin uso..

  final LocalAuthentication auth = LocalAuthentication();

  final emailService = VerificationService();

  // Función asincrónica para realizar el inicio de sesión
  Future login() async {
    List<UsuarioModel> usuarios = await getUsuarios();

    // Algoritmo de encriptamiento sha256
    // final algorithm = Argon2id(
    //   memory: 10 * 1000, // 10 MBi
    //   parallelism: 2, // Use maximum two CPU cores.
    //   iterations: 1,
    //   hashLength: 256, // Number of bytes in the returned hash
    // );

    // final secretKey = await algorithm.deriveKeyFromPassword(
    //   password: _passwordController.text.trim(),
    //   nonce: [1, 2, 3],
    // );
    // final secretKeyBytes = await secretKey.extractBytes();

    // final secretPasswordKey = base64Encode(secretKeyBytes);

    final code = generateRandomCode();

    final usuarioEncontrado = usuarios
        .where((usuario) =>
            usuario.numeroDocumento == _documentoController.text.trim())
        .firstOrNull;

        if (usuarioEncontrado != null) {
      if (usuarioEncontrado.estado) {
        if (!UniversalPlatform.isWeb && (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)) {
          bool isAvailable;

          bool isDeviceSupported;

          isAvailable = await auth.canCheckBiometrics;
          isDeviceSupported = await auth.isDeviceSupported();

          if (isAvailable && isDeviceSupported) {
            bool result = await auth.authenticate(
                options: const AuthenticationOptions(biometricOnly: false),
                localizedReason: 'Toca el sensor de huellas digitales');
            if (result) {
              setState(() {
                Provider.of<AppState>(context, listen: false)
                    .setUsuarioAutenticado(usuarioEncontrado);
              });
              // emailService.djangoLoginNow(usuarioEncontrado.correoElectronico);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            } else {
              print('Permiso Denegado');
            }
          } else {
            // Si el dispositivo movil no tiene biometria.
            emailService.djangoSendEmail(
                usuarioEncontrado.correoElectronico, code);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(
                  usuario: usuarioEncontrado,
                  code: code,
                ),
              ),
            );
          }
        } else {
          // Si no es android o ios, se hace el envio por el correo,
          emailService.djangoSendEmail(
              usuarioEncontrado.correoElectronico, code);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationScreen(
                usuario: usuarioEncontrado,
                code: code,
              ),
            ),
          );
        }
      } else {
        // usuario inactivo.
        mostrarUserInactivo(context);
      }
    } else {
      // Error de autenticacion, registrarse
      mostrarDialogoError(context);
    }
  }

  @override
  void dispose() {
    // Liberar recursos cuando el widget sea eliminado
    _documentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, responsive) {
        // Verificación de la anchura de la pantalla para realizar ajustes responsivos
        if (responsive.maxWidth <= 970) {
          // Diseño para pantallas con anchura máxima de 300
          return isMobile(context);
        } else {
          return isDesktop(context);
        }
      },
    );
  }

  Padding isMobile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 23, right: 23, top: 100, bottom: 50),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(122, 0, 0, 0),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            PreferredSize(
                preferredSize: const Size.fromHeight(30),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            TabBar(
                              controller: tabController,
                              isScrollable: true,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.white,
                              indicatorColor: Colors.white,
                              labelStyle: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              tabs: const [
                                Tab(text: 'Iniciar Sesión'),
                                Tab(
                                  text: 'Registrarse',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 5,
              child: TabBarView(
                controller: tabController,
                children: [
                  // Vista para iniciar sesión
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text(
                                  'Iniciar Sesion',
                                  style: TextStyle(
                                      fontSize: 33,
                                      fontFamily: 'Calibri-Bold',
                                      color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 25, right: 30),
                                child: Text(
                                  'Bienvenido de nuevo, tu aprendizaje continúa aquí',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white
                                      //fontFamily: 'DelaGothicOne'
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2.0, right: 2.0),
                                child: TextField(
                                  style: const TextStyle(color: Colors.black),
                                  controller: _documentoController,
                                  obscureText: false,
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
                                    hintText: 'N° Identificación',
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Función de login
                                  login();
                                },
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Iniciar Sesión',
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
                          const SizedBox(height: 40)
                        ],
                      ),
                    ),
                  ),
                  // Vista para el registro
                  const Register()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding isDesktop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 30.0),
      child: Row(
        children: [
          // Columna izquierda con información
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
                          blurRadius: 3, // Radio de desenfoque de la sombra
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
                            blurRadius: 3, // Radio de desenfoque de la sombra
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
          // Columna derecha con pestañas de inicio de sesión y registro
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(122, 0, 0, 0),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Barra de pestañas
                  PreferredSize(
                      preferredSize: const Size.fromHeight(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                TabBar(
                                  controller: tabController,
                                  isScrollable: true,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.white,
                                  indicatorColor: Colors.white,
                                  labelStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  tabs: const [
                                    Tab(text: 'Iniciar Sesión'),
                                    Tab(
                                      text: 'Registrarse',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 6,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        // Vista para iniciar sesión
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 50),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 25),
                                      child: Text(
                                        'Iniciar Sesión',
                                        style: TextStyle(
                                            fontSize: 35,
                                            fontFamily: 'Calibri-Bold',
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 25,
                                        right: 30,
                                        bottom: 25,
                                      ),
                                      child: Text(
                                        'Bienvenido de nuevo, tu aprendizaje continúa aquí',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white
                                            //fontFamily: 'DelaGothicOne'
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2.0, right: 2.0),
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: _documentoController,
                                        obscureText: false,
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
                                          hintText: 'N° Identificación',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: InkWell(
                                      onTap: () {
                                        login();
                                        // Función de login
                                      },
                                      child: Container(
                                        width: 180,
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Iniciar Sesión',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const SizedBox(height: 20)
                              ],
                            ),
                          ),
                        ),
                        // Vista para el registro
                        const Register()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void mostrarDialogoError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error de autenticación"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  "¡El numero de documento no existe por favor registrese!", textAlign: TextAlign.center,),
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

  void mostrarUserInactivo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error de autenticación"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  "¡Tu usuario esta inactivo, solicita la activación aquí!", textAlign: TextAlign.center,),
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
