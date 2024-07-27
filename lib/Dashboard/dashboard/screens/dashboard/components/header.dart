// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/controllers/MenuAppController.dart';
import 'package:tienda_app/EditarUsuario/editarUsuario.dart';
import 'package:tienda_app/Models/imagenUsuarioModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';

// Header el cual tendra el buscador y una card identificativa del usuario que este usando el aplicativo

/// Widget que representa la barra de encabezado de la aplicación, que contiene
/// un buscador y una tarjeta de identificación del usuario autenticado.
///
/// Este widget es un [StatefulWidget] y delega la creación del estado en su
/// [_HeaderState].
class Header extends StatefulWidget {
  /// Crea una nueva instancia de [Header].
  ///
  /// No tiene parámetros.
  const Header({
    super.key, // Clave única para identificar este widget.
  });

  @override
  // Miembro que crea y devuelve una nueva instancia de [_HeaderState].
  //
  // No tiene parámetros.
  // Devuelve una nueva instancia de [_HeaderState].
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    // Retorna un widget que muestra el encabezado de la aplicación.
    //
    // El widget retornado es un Row que contiene un botón de menú, un
    // texto que indica el nombre de la tienda y un botón para
    // actualizar la información del usuario autenticado. Además, muestra
    // una tarjeta de identificación del usuario autenticado.
    return Consumer<AppState>(builder: (context, appState, _) {
      // Obtiene el usuario autenticado del estado de la aplicación.
      final usuarioAutenticado = appState.usuarioAutenticado;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Si no estamos en una pantalla de escritorio, muestra un
          // botón de menú.
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.menu),
              // Abre el menú de la aplicación.
              onPressed: context.read<MenuAppController>().controlMenu,
            ),

          // Si no estamos en una pantalla móvil, muestra el texto que
          // indica el nombre de la tienda.
          if (!Responsive.isMobile(context))
            Text(
              "CBA Mosquera",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Calibri-Bold',
                  ),
            ),

          // Si estamos en una pantalla de escritorio, agrega espacio
          // adicional al lado derecho del encabezado.
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),

          // Muestra un botón redondeado con un icono de edición.
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: Container(
              color: primaryColor,
              child: IconButton(
                // Al presionar el botón, abre un formulario para
                // actualizar la información del usuario autenticado.
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FormActualizarUsuario(
                                usuario: usuarioAutenticado!,
                                usuarioAutenticado: usuarioAutenticado,
                              )));
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Muestra una tarjeta de identificación del usuario
          // autenticado.
          const ProfileCard()
        ],
      );
    });
  }
}

// Card donde estara el avatar y el nombre del usuario que este haciendo la sesión

/// Un widget que muestra la información del usuario autenticado.
///
/// Este widget muestra una tarjeta con la imagen del usuario y su nombre.
/// Además, contiene un botón para editar la información del usuario.
class ProfileCard extends StatefulWidget {
  /// Construye un widget [ProfileCard].
  ///
  /// No toma ningún parámetro.
  const ProfileCard({
    super.key,
  });

  @override

  /// Crea un estado [_ProfileCardState] para manejar los datos del widget.
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  /// Un método asincrónico que obtiene la imagen de un usuario por su ID.
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

  /// Método que construye el widget.

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, _) {
      // Obtenemos el usuario autenticado del estado de la aplicación
      final usuarioAutenticado = appState.usuarioAutenticado;

      return Container(
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
              // Futuro para mostrar si hay imagen del usuario autenticado
              FutureBuilder(
                future: imagen(usuarioAutenticado.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Mostrar un indicador de carga mientras se obtiene la imagen
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Mostrar un icono de error si hubo un problema al obtener la imagen
                    return const Icon(Icons.error);
                  } else {
                    // Obtener la URL de la imagen
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
                                    usuarioAutenticado.nombres[0].toUpperCase(),
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
              // Mostrar el botón de iniciar sesión si no hay un usuario autenticado
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
                      padding:
                          EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                      child: Text(
                        "Iniciar Sesión",
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                ],
              ),
          ],
        ),
      );
    });
  }
}
