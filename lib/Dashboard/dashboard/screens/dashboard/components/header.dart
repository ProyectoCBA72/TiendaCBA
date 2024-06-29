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

class Header extends StatefulWidget {
  const Header({
    super.key,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            "CBA Mosquera",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'Calibri-Bold',
                ),
          ),
        Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: Container(
                // Contenedor que envuelve un botón de búsqueda.
                color: primaryColor,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FormActualizarUsuario()));
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    )))),
        const ProfileCard()
      ],
    );
  }
}

// Card donde estara el avatar y el nombre del usuario que este haciendo la sesión

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
  });

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
    return Consumer<AppState>(builder: (context, appState, _) {
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
      );
    });
  }
}
