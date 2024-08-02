import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda_app/Auth/source/verification.dart';
import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';
import 'package:tienda_app/constantsDesign.dart';

// Constante para No tener necesidad de usar el Material a cada momento ( opcional )

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// La clase `AppState` maneja el estado global de la aplicación extendiendo `ChangeNotifier`.
/// Almacena el usuario autenticado y proporciona métodos para cargar y guardar su estado en `SharedPreferences`.
class AppState extends ChangeNotifier {
  /// Variable privada para almacenar el usuario autenticado.
  UsuarioModel? _usuarioAutenticado;

  Future<void>? _logoutFuture;

  Timer? _inactivityTimer;

  VerificationService emailService = VerificationService();

  /// Constructor de `AppState` que carga el usuario desde `SharedPreferences` al iniciar la aplicación.
  AppState() {
    _loadUsuarioFromPrefs();
  }

  /// Getter para obtener el usuario autenticado.
  UsuarioModel? get usuarioAutenticado => _usuarioAutenticado;

  /// Método para establecer el usuario autenticado y guardar su estado en `SharedPreferences`.
  /// Si el usuario es nulo, elimina su estado de `SharedPreferences`.
  /// Notifica a los oyentes del cambio de estado.
  void setUsuarioAutenticado(UsuarioModel? usuario) async {
    _usuarioAutenticado = usuario;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (usuario != null) {
      emailService.sendEmailLogin(usuario.correoElectronico);
      // llamamos la funcion al momento de iniciar sesion.
      startInactivityTimer();
      await prefs.setInt('usuarioId', usuario.id);
    } else {
      await prefs.remove('usuarioId');
    }
    notifyListeners();
  }

  // al llamar al la funcion se reiniica el temporizador y se crea de nuevo.
  void startInactivityTimer() {
    _cancelInactivityTimer();
    _inactivityTimer = Timer(const Duration(minutes: 5), () {
      if (_usuarioAutenticado != null) {
        logout();
        modalDesconectado(navigatorKey.currentState!.context);
      }
    });
  }

  // funcion para cancelar el temporizaodr
  void _cancelInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }

  // función que cancela en temporizador.

  /// Método para cerrar sesión y eliminar el estado del usuario de `SharedPreferences`.
  /// Notifica a los oyentes del cambio de estado.
  void logout() async {
    _usuarioAutenticado = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuarioId');
    notifyListeners();
  }

  Future<void> modalDesconectado(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sesión expirada"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Tu sesión ha expirado. Serás desconectado.'),
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
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Aceptar", () {
                  Navigator.pop(context);
                  navigatorKey.currentState!.pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                  // Cierra el diálogo cuando se hace clic en el botón de aceptar
                }),
              ),
            ],
          ),
        ],
      ),
    );
    return Future.value();
  }

  /// Método privado para cargar el usuario desde `SharedPreferences`.
  /// Busca el usuario en la lista de usuarios y lo asigna a `_usuarioAutenticado` si se encuentra.
  /// Notifica a los oyentes del cambio de estado.
  void _loadUsuarioFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuarioId');
    final usuarios = await getUsuarios();
    if (usuarioId != null) {
      for (var usuario in usuarios) {
        if (usuario.id == usuarioId) {
          _usuarioAutenticado = usuario;
          // se reinicia el temporizador al momento de recargar la pagina.
          startInactivityTimer();
          notifyListeners();
          return;
        }
      }
    }
  }
}

Widget _buildButton(String text, VoidCallback onPressed) {
  // Construye el widget del botón con el texto y la función de presionar.
  return Container(
    width: 200, // Ancho fijo del botón.
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
        borderRadius: BorderRadius.circular(10), // Radio del borde redondeado.
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

/// La clase `AppProvider` configura los proveedores para la aplicación.
/// Proporciona el estado global (`AppState`) y el controlador de la tienda (`TiendaController`).
class AppProvider extends StatelessWidget {
  /// Widget hijo que se renderiza dentro del proveedor.
  final Widget child;

  /// Constructor de `AppProvider`.
  const AppProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Proveedor para el estado global de la aplicación (`AppState`)
        ChangeNotifierProvider(create: (context) => AppState()),

        /// Proveedor para el controlador de la tienda (`TiendaController`)
        ChangeNotifierProvider(create: (context) => Tiendacontroller()),

        // Provider para el controlador del punto de venta en la tienda
        ChangeNotifierProvider(create: (context) => PuntoVentaProvider()),
      ],
      child: child,
    );
  }
}
