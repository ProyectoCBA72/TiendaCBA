// ignore_for_file: use_full_hex_values_for_flutter_colors, file_names

import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/controllers/MenuAppController.dart';
import 'package:tienda_app/Models/imagenUsuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';

import '../Auth/authScreen.dart';
import '../Dashboard/dashboard/screens/main/main_screen_usuario.dart';

/// Widget que representa una tarjeta de perfil de usuario.
///
/// Esta clase extiende [StatefulWidget] y se encarga de mostrar la foto
/// del usuario, nombre y apellido, y permite acceder a la pantalla principal del
/// usuario.
class ProfileCard extends StatefulWidget {
  /// Constructor por defecto.
  ///
  /// No requiere parámetros.
  const ProfileCard({super.key});

  /// Crea el estado para este widget.
  ///
  /// El estado se encarga de manejar los datos de la pantalla.
  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  // Futuro para traer todas la imagenes de lso usuario y verificar cuan es la del actual se usa where para mas eficiencia...
  /// Método que obtiene la imagen de un usuario.
  ///
  /// Este método utiliza la función [getImagenesUsuarios] para obtener todas las
  /// imágenes de usuario y luego busca la imagen del usuario con el [idUsuario]
  /// especificado. Si encuentra la imagen, se devuelve la ruta de la imagen.
  ///
  /// El parámetro [idUsuario] es el identificador único del usuario cuya imagen se
  /// desea obtener.
  ///
  /// Retorna la ruta de la imagen del usuario si se encuentra, o null en caso
  /// contrario.
  Future<String?> imagen(int idUsuario) async {
    // Obtiene todas las imágenes de usuario
    List<ImagenUsuarioModel> images = await getImagenesUsuarios();

    // Busca la imagen del usuario con el idUsuario especificado
    final imagenUsuario = images
        .where(
          (imagen) => imagen.usuario == idUsuario,
        )
        .firstOrNull;

    // Retorna la ruta de la imagen del usuario si se encuentra, o null en caso contrario
    return imagenUsuario?.foto;
  }

  @override
  Widget build(BuildContext context) {
    // Uso de Consumer para acceder al estado de la aplicación.
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final usuarioAutenticado = appState.usuarioAutenticado;
        return InkWell(
          onTap: () {
            if (usuarioAutenticado != null) {
              // Navegar a la pantalla principal del usuario autenticado.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                          create: (context) => MenuAppController()),
                    ],
                    child: const MainScreenUsuario(),
                  ),
                ),
              );
            } else {
              // Navegar a la pantalla de inicio de sesión si no hay usuario autenticado.
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
            child: Row(
              children: [
                if (usuarioAutenticado != null)
                  // Mostrar la imagen del usuario si está autenticado.
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
                  // Mostrar opción de iniciar sesión si no está autenticado.
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
          ),
        );
      },
    );
  }
}
