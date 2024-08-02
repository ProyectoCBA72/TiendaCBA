// ignore_for_file: must_be_immutable
// Ignora la advertencia sobre clases que deben ser inmutables

import 'package:provider/provider.dart'; // Paquete para manejar el estado de la aplicación
import 'package:tienda_app/Splash/page/SplashScreen.dart'; // Pantalla de carga inicial de la aplicación
import 'constantsDesign.dart'; // Archivo con constantes de diseño
import 'package:flutter/material.dart'; // Paquete principal de Flutter
import 'provider.dart'; // Archivo que proporciona el proveedor de estado de la aplicación

// Punto de entrada principal de la aplicación
void main() async {
  // Ejecuta la aplicación con el proveedor de estado `AppProvider`
  runApp(const AppProvider(
    child: MyApp(),
  ));
}

// Clase principal de la aplicación que extiende StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor que acepta una clave opcional

  @override
  Widget build(BuildContext context) {
    final appState =
        AppState(); // Crea una instancia de AppState, que maneja el estado de la aplicación

    // Proporciona `AppState` como ChangeNotifierProvider a los widgets hijos
    return ChangeNotifierProvider<AppState>(
      create: (context) => appState,
      // envolvemos el material en  un gesture detectos para gestionar la inactividad
      child: GestureDetector(
        behavior: HitTestBehavior.translucent, //sirve para que el gesture sirva en cada uno de los widgets que se crean despues 
        // se llaman las funciones al momento de hacer los On...
        onTap: () => appState.startInactivityTimer(),
        // onPanDown es cada vez que el usuario desliza por la pantalla.
        onPanDown: (_) => appState.startInactivityTimer(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: lightTheme, // Establece el tema de la aplicación
          debugShowCheckedModeBanner: false, // Oculta el banner de modo debug
          home: const SplashScreen(),
          // Establece la pantalla de inicio como `SplashScreen`, que muestra una imagen de carga
        ),
      ),
    );
  }
}
