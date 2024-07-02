import 'package:flutter/material.dart';
import '../../Auth/authScreen.dart';
import '../../Models/comentarioModel.dart';
import '../../Models/imagenUsuarioModel.dart';
import '../../Models/usuarioModel.dart';
import '../../constantsDesign.dart';
import '../../responsive.dart';
import '../comentarioForm.dart';

void modalComentarios(BuildContext context, List<ComentarioModel> anuncios,
    List<UsuarioModel> usuarios, List<ImagenUsuarioModel> usersImages) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(
                height: defaultPadding,
              ),
              // Título del modal
              Text(
                "Comentarios",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              // Cuerpo del modal con texto desplazable
              Expanded(
                child: SizedBox(
                  height: 495,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //Columnas dependiendo el ancho de la pantalla
                          crossAxisCount: Responsive.isMobile(context) ? 1 : 2),
                      itemCount: comentarios.length,
                      itemBuilder: (context, index) {
                        ComentarioModel comentario = comentarios[index];

                        UsuarioModel usuario = usuarios
                            .where(
                                (usuario) => usuario.id == comentario.usuario)
                            .first;
                        final ImagenUsuarioModel? imageUrl = usersImages
                            .where((user) => user.usuario == usuario.id)
                            .firstOrNull;
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          // Card para presentar los comentarios
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: InteractiveViewer(
                                        constrained: false,
                                        scaleEnabled: false,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                child: imageUrl != null
                                                    ? Image.network(
                                                        imageUrl.foto,
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor:
                                                            primaryColor,
                                                        radius: 20,
                                                        child: Text(
                                                          usuario.nombres[0]
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              const SizedBox(
                                                width: defaultPadding,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    usuario.nombres,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Text(
                                                    "Fecha de registro: ${formatFechaHora(usuario.fechaRegistro)}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    SizedBox(
                                      height: 20,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Text(
                                              formatFechaHora(comentario.fecha),
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Text(
                                      comentario.descripcion,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: primaryColor,
                                                offset: Offset(
                                                  2.0,
                                                  2.0,
                                                ),
                                                blurRadius: 3.0,
                                                spreadRadius: 1.0,
                                              ), //BoxShadow
                                              BoxShadow(
                                                color: primaryColor,
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 0.0,
                                                spreadRadius: 0.0,
                                              ), //BoxShadow
                                            ],
                                            color: Colors.white,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.edit,
                                                size: 25, color: primaryColor),
                                            onPressed: () {
                                              // Acción al presionar el botón de editar
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: defaultPadding,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: primaryColor,
                                                offset: Offset(
                                                  2.0,
                                                  2.0,
                                                ),
                                                blurRadius: 3.0,
                                                spreadRadius: 1.0,
                                              ), //BoxShadow
                                              BoxShadow(
                                                color: primaryColor,
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 0.0,
                                                spreadRadius: 0.0,
                                              ), //BoxShadow
                                            ],
                                            color: Colors.white,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.delete,
                                                size: 25, color: primaryColor),
                                            onPressed: () {
                                              // Acción al presionar el botón de editar
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
        // Acciones del modal
        actions: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cerrar"),
              ),
            ],
          )
        ],
      );
    },
  );
}

fomularioComentario(context, int userId, int anuncioID) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            padding: const EdgeInsets.all(15),
            height: 420,
            width: 400,
            child: SingleChildScrollView(
              // Llamar el formulario para hacer un comentario
              child: Comentario(
                userID: userId,
                anuncioID: anuncioID,
              ),
            ),
          ),
        ),
      );
    },
  );
}

void inicioSesionComents(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("¿Quiere agregar un Comentario?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("¡Para agregar un Comentario, debe iniciar sesión!"),
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
                child: _buildButton("Cancelar", () {
                  Navigator.pop(context);
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Iniciar Sesión", () {
                  // ignore: prefer_const_constructors
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
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
