import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';

class AppState extends ChangeNotifier {
  UsuarioModel? _usuarioAutenticado;

  AppState() {
    // Recuperar el estado del usuario al iniciar la aplicación
    _loadUsuarioFromPrefs();
  }

  UsuarioModel? get usuarioAutenticado => _usuarioAutenticado;

  void setUsuarioAutenticado(UsuarioModel? usuario) async {
    _usuarioAutenticado = usuario;
    // Guardar el estado del usuario en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (usuario != null) {
      await prefs.setInt('usuarioId', usuario.id);
    } else {
      await prefs.remove('usuarioId');
    }
    notifyListeners();
  }

  void logout() async {
    _usuarioAutenticado = null;
    // Borrar el estado del usuario en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuarioId');
    notifyListeners();
  }

  void _loadUsuarioFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuarioId');

    final usuarios = await getUsuarios();

    // Validar si el usuario almacenado está en la lista de usuarios
    if (usuarioId != null) {
      for (var usuario in usuarios) {
        if (usuario.id == usuarioId) {
          _usuarioAutenticado = usuario;
          notifyListeners();
          return; // Terminar el bucle ya que encontramos al usuario
        }
      }
    }
  }
}

class AppProvider extends StatelessWidget {
  final Widget child;

  const AppProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => Tiendacontroller()),
      ],
      child: child,
    );
  }
}
