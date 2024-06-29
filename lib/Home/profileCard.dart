// ignore_for_file: use_full_hex_values_for_flutter_colors, file_names

import 'package:provider/provider.dart';
import 'package:tienda_app/Models/imagenUsuarioModel.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';

import '../Auth/authScreen.dart';
import '../Dashboard/controllers/MenuAppController.dart';
import '../Dashboard/dashboard/screens/main/main_screen_usuario.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  // Futuro para traer todas la imagenes de lso usuario y verificar cuan es la del actual se usa where para mas eficiencia...
  Future imagen(int idUsuario) async {
    List<ImagenUsuarioModel> images = await getImagenesUsuarios();

    final imagenUsuario =
        images.where((imagen) => imagen.usuario == idUsuario).firstOrNull;

    return imagenUsuario?.foto;
  }

  @override
  Widget build(BuildContext context) {
    // Uso de consumer para usar el app state...

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final usuarioAutenticado = appState.usuarioAutenticado;
        return InkWell(
          onTap: () {
            if (usuarioAutenticado != null) {
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
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            }
          },
          child: Container(
            // Contenedor que envuelve la tarjeta de perfil.
            margin: const EdgeInsets.only(left: defaultPadding),
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFF2F0F2),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white10),
            ),

            // Fila que contiene elementos si el usuario no ha iniciado sesión.

            child: Row(
              children: [
                if (usuarioAutenticado != null)
                  // Futuro para mostrar si hay imagen
                  FutureBuilder(
                    future: imagen(usuarioAutenticado.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.error);
                      } else {
                        final imageUrl = snapshot.data;
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: imageUrl != null
                                  ? Image.network(
                                      imageUrl,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: primaryColor,
                                      radius: 20,
                                      child: Text(
                                        usuarioAutenticado.nombres[0]
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                            if (!Responsive.isMobile(context))
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding / 2),
                                child: Text(
                                  usuarioAutenticado.nombres,
                                  style: const TextStyle(color: primaryColor),
                                ),
                              ),
                          ],
                        );
                      }
                    },
                  )
                else
                  Row(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 38,
                              height: 38,
                              color: primaryColor,
                              child: const Icon(
                                Icons.login,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (!Responsive.isMobile(context))
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2),
                              child: Text(
                                "Iniciar Sesión",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
