// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/controllers/MenuAppController.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/main/main_screen_lider.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/main/main_screen_punto.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/main/main_screen_unidad.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/main/main_screen_usuario.dart';
import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
        builder: (BuildContext context, AppState appState, _) {
      if (appState == null || appState.usuarioAutenticado == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final usuarioAutenticado = appState.usuarioAutenticado;

      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: ClipOval(
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
              ),
            ),
            DrawerListTile(
              title: "Inicio",
              svgSrc: "assets/icons/home.svg",
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            if (usuarioAutenticado!.rol1 == "EXTERNO")
              DrawerListTile(
                title: "Panel Usuario",
                svgSrc: "assets/icons/persona.svg",
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(
                                    create: (context) => MenuAppController(),
                                  ),
                                  ChangeNotifierProvider(
                                    create: (context) => Tiendacontroller(),
                                  ),
                                ],
                                child: const MainScreenUsuario(),
                              )));
                },
              ),
            if (usuarioAutenticado.rol3 == "TUTOR" &&
                usuarioAutenticado.unidadProduccion != null)
              DrawerListTile(
                title: "Panel unidad de producción",
                svgSrc: "assets/icons/produccion.svg",
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(
                                    create: (context) => MenuAppController(),
                                  ),
                                  ChangeNotifierProvider(
                                    create: (context) => Tiendacontroller(),
                                  ),
                                ],
                                child: const MainScreenUnidad(),
                              )));
                },
              ),
            if (usuarioAutenticado.rol3 == "PUNTO" &&
                usuarioAutenticado.puntoVenta != null)
              DrawerListTile(
                title: "Panel punto de venta",
                svgSrc: "assets/icons/store.svg",
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(
                                    create: (context) => MenuAppController(),
                                  ),
                                  ChangeNotifierProvider(
                                    create: (context) => Tiendacontroller(),
                                  ),
                                ],
                                child: const MainScreenPunto(),
                              )));
                },
              ),
            if (usuarioAutenticado.rol3 == "LIDER")
              DrawerListTile(
                title: "Panel líder SENA",
                svgSrc: "assets/icons/lider.svg",
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(
                                    create: (context) => MenuAppController(),
                                  ),
                                  ChangeNotifierProvider(
                                    create: (context) => Tiendacontroller(),
                                  ),
                                ],
                                child: const MainScreenLider(),
                              )));
                },
              ),
            DrawerListTile(
              title: "Cerrar Sesión",
              svgSrc: "assets/icons/logout.svg",
              press: () {
                logout(context);
              },
            ),
          ],
        ),
      );
    });
  }
}

void logout(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("¿Seguro que quiere cerrar sesión?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                  Navigator.pop(context);
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Salir", () {
                  Navigator.pop(context);
                  Provider.of<AppState>(context, listen: false).logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                }),
              )
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

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 10.0, // Ajusta esto según el espaciado que prefieras
      leading: SizedBox(
        height: 24, // Ajusta el tamaño del contenedor
        width: 24, // Asegura que el icono sea cuadrado
        child: SvgPicture.asset(
          svgSrc,
          colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: primaryColor, fontFamily: 'Calibri-Bold'),
      ),
    );
  }
}
