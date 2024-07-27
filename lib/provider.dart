import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';

/// La clase `AppState` maneja el estado global de la aplicación extendiendo `ChangeNotifier`.
/// Almacena el usuario autenticado y proporciona métodos para cargar y guardar su estado en `SharedPreferences`.
class AppState extends ChangeNotifier {
  /// Variable privada para almacenar el usuario autenticado.
  UsuarioModel? _usuarioAutenticado;

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
      await prefs.setInt('usuarioId', usuario.id);
    } else {
      await prefs.remove('usuarioId');
    }
    notifyListeners();
  }

  /// Método para cerrar sesión y eliminar el estado del usuario de `SharedPreferences`.
  /// Notifica a los oyentes del cambio de estado.
  void logout() async {
    _usuarioAutenticado = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuarioId');
    notifyListeners();
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
          notifyListeners();
          return;
        }
      }
    }
  }
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
