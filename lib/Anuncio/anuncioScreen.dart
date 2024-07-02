// ignore_for_file: file_names

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tienda_app/Models/anuncioModel.dart';
import 'package:tienda_app/Models/comentarioModel.dart';
import 'package:tienda_app/Models/imagenUsuarioModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/source.dart';
import 'package:universal_platform/universal_platform.dart';
import '../Details/sourceDetails/modalsCardAndDetails.dart';
import 'package:http/http.dart' as http;
import 'Modals/modals.dart';

class AnuncioScreen extends StatefulWidget {
  final AnuncioModel anuncio;
  final List<String> images;
  const AnuncioScreen({super.key, required this.anuncio, required this.images});

  @override
  State<AnuncioScreen> createState() => _AnuncioScreenState();
}

class _AnuncioScreenState extends State<AnuncioScreen> {
  // URL de la imagen principal
  String mainImageUrl = '';


  // Lista de URL de miniaturas de imágenes
  List<String> thumbnailUrls = [];

// Lista de comentarios nuevos para reinucializar.
  List<dynamic> _newData = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() {
    thumbnailUrls = widget.images;
    mainImageUrl = thumbnailUrls.first;
  }

  Future<List<dynamic>> fetchData() {
    return Future.wait([
      getComentarios(),
      getImagenesUsuarios(),
      getUsuarios(),
    ]);
  }

  Future deleteComent(int comentID) async {
    String url;
    url = "$sourceApi/api/comentarios/$comentID/";

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 204) {
      print('Datos eliminados correctamente');
      final List<dynamic>  newData = await fetchData();
      // Actualiza la lista de comentarios en el estado
      setState(() {
        _newData = newData;
      }); 
    } else {
      print('Error al eliminar datos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final anuncio = widget.anuncio;
    return Consumer<AppState>(
      builder: (BuildContext context, appState, _) {
        final usuarioAutenticado = appState.usuarioAutenticado;

        return Scaffold(
          body: LayoutBuilder(
            builder: (context, responsive) {
              if (responsive.maxWidth <= 900) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Ancho fijo para el diseño de escritorio
                    height: MediaQuery.of(context)
                        .size
                        .height, // Altura fija para el diseño de escritorio
                    child: Scaffold(
                      body: Column(
                        children: [
                          // Imagen principal con miniaturas
                          Expanded(
                            child: Stack(
                              children: [
                                // Imagen principal
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () {
                                      _modalAmpliacion(context, mainImageUrl);
                                    },
                                    child: Image.network(
                                      mainImageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                // Botón de retroceso
                                Positioned(
                                  top: 20,
                                  left: 20,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: background1,
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                            size: 24,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Fila de miniaturas
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width, // Ancho fijo para el diseño de escritorio
                                    height: 100,
                                    padding: const EdgeInsets.all(10),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: thumbnailUrls.map((url) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                mainImageUrl = url;
                                              });
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: mainImageUrl == url
                                                      ? primaryColor
                                                      : Colors
                                                          .transparent, // Color del borde resaltado
                                                  width: mainImageUrl == url
                                                      ? 3
                                                      : 0, // Ancho del borde resaltado
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(
                                                        0.5), // Color de la sombra
                                                    spreadRadius:
                                                        1, // Radio de expansión de la sombra
                                                    blurRadius:
                                                        2, // Radio de desenfoque de la sombra
                                                    offset: const Offset(0,
                                                        3), // Desplazamiento de la sombra
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  url,
                                                  width: mainImageUrl == url
                                                      ? 120
                                                      : 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Información del Producto
                          Expanded(
                            child: Container(
                              color: background1,
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        anuncio.titulo,
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                          fontFamily: 'Calibri-Bold',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      anuncio.descripcion,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                        fontFamily: 'Calibri-Bold',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Center(
                                      child: Container(
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                            colors: [
                                              botonClaro, // Verde más claro
                                              botonOscuro, // Verde más oscuro
                                            ],
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  botonSombra, // Verde más claro para sombra
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              // Acción al presionar el botón
                                            },
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: const Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.file_copy,
                                                    color: background1,
                                                    size: 40,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'Ver Más',
                                                    style: TextStyle(
                                                      color: background1,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const Text(
                                      'Comentarios',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontFamily: 'Calibri-Bold',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                      future: _newData.isNotEmpty ? Future.value(_newData) : fetchData(),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              'Ocurrio un error ${snapshot.error}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          );
                                        } else if (snapshot.data!.isEmpty) {
                                          return SizedBox(
                                            height: 300,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: const Center(
                                              child: Text(
                                                'No hay comentarios para este anuncio.',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          final List<UsuarioModel> usuarios =
                                              snapshot.data![2];
                                          final List<ComentarioModel>
                                              comentarios = snapshot.data![0]
                                                  .where((coment) =>
                                                      coment.anuncio.id ==
                                                      anuncio.id)
                                                  .toList();
                                          final List<ImagenUsuarioModel>
                                              allImagesUsuario =
                                              snapshot.data![1];
                                          if (comentarios.isEmpty) {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 300,
                                              child: const Center(
                                                child: Text(
                                                  'No hay comentarios para este anuncio.',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            int itemCount =
                                                comentarios.length > 4
                                                    ? 4
                                                    : comentarios.length;
                                            return Column(
                                              children: [
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: SizedBox(
                                                      height: 300,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: GridView.builder(
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                //Columnas dependiendo el ancho de la pantalla
                                                                crossAxisCount:
                                                                    Responsive.isMobile(
                                                                            context)
                                                                        ? 1
                                                                        : 2),
                                                        itemCount: itemCount,
                                                        itemBuilder:
                                                            (context, index) {
                                                          ComentarioModel
                                                              comentario =
                                                              comentarios[
                                                                  index];

                                                          UsuarioModel usuario =
                                                              usuarios
                                                                  .where((usuario) =>
                                                                      usuario
                                                                          .id ==
                                                                      comentario
                                                                          .usuario)
                                                                  .first;
                                                          final ImagenUsuarioModel?
                                                              imageUrl =
                                                              allImagesUsuario
                                                                  .where((user) =>
                                                                      user.usuario ==
                                                                      usuario
                                                                          .id)
                                                                  .firstOrNull;
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            // Card para presentar los comentarios
                                                            child: Card(
                                                              elevation: 4.0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            InteractiveViewer(
                                                                          constrained:
                                                                              false,
                                                                          scaleEnabled:
                                                                              false,
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(50.0),
                                                                                  child: imageUrl != null
                                                                                      ? Image.network(
                                                                                          imageUrl.foto,
                                                                                          width: 40,
                                                                                          height: 40,
                                                                                          fit: BoxFit.cover,
                                                                                        )
                                                                                      : CircleAvatar(
                                                                                          backgroundColor: primaryColor,
                                                                                          radius: 20,
                                                                                          child: Text(
                                                                                            usuario.nombres[0].toUpperCase(),
                                                                                            style: const TextStyle(
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
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      usuario.nombres,
                                                                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    Text(
                                                                                      // formateo de la fecha
                                                                                      'Fecha de registro: ${formatFechaHora(usuario.fechaRegistro)}',
                                                                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            defaultPadding,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                formatFechaHora(comentario.fecha),
                                                                                style: const TextStyle(color: Colors.grey),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            defaultPadding,
                                                                      ),
                                                                      Text(
                                                                        comentario
                                                                            .descripcion,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),

                                                                      // condicional para verificar si el usuario autenticado es el dueño del comentario o si es un lider sena.
                                                                      if (usuarioAutenticado!.id ==
                                                                              comentario
                                                                                  .usuario ||
                                                                          usuarioAutenticado.rol3 ==
                                                                              "LIDER")
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(20),
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
                                                                                icon: const Icon(Icons.delete, size: 25, color: primaryColor),
                                                                                onPressed: () {
                                                                                  // Acción al presionar el botón de eliminar

                                                                                  deleteComent(comentario.id);
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      const SizedBox(
                                                                        height:
                                                                            defaultPadding,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: defaultPadding),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          bottom: 10,
                                                          top: 10),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          botonClaro, // Verde más claro
                                                          botonOscuro, // Verde más oscuro
                                                        ],
                                                      ),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color:
                                                              botonSombra, // Verde más claro para sombra
                                                          blurRadius: 5,
                                                          offset: Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          // Acción al presionar el botón
                                                          modalComentarios(
                                                              context,
                                                              comentarios,
                                                              usuarios,
                                                              allImagesUsuario);
                                                        },
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          child: Center(
                                                            child: Text(
                                                              'Ver Comentarios',
                                                              style: TextStyle(
                                                                color:
                                                                    background1,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Calibri-Bold',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      bottomNavigationBar: Container(
                        color: background1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            height: 85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.black,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      String text =
                                          "Producto: ${anuncio.titulo}\n";
                                      text +=
                                          "Descripcion: ${anuncio.descripcion} \n";
                                      text +=
                                          "Precio: ${formatFechaHora(anuncio.fecha)}} \n";
                                      text += '\n';
                                      text +=
                                          'Visitanos en nuestra pagina web o aplicacion http://localhost:65500/';
                                      if (UniversalPlatform.isAndroid ||
                                          UniversalPlatform.isIOS) {
                                        Share.share(text);
                                      } else {
                                        modalCompartirWhatsapp(context, text);
                                      }
                                    },
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(55),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.share,
                                          color: Colors.white, size: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: 10), // Espacio entre botones
                                Expanded(
                                  flex: 3, // Este botón ocupará más espacio
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Inscribirme",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Calibri-Bold',
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: 10), // Espacio entre botones
                                Expanded(
                                  flex: 3, // Este botón ocupará más espacio
                                  child: GestureDetector(
                                    onTap: () {
                                      if (usuarioAutenticado != null) {
                                        fomularioComentario(context,
                                            usuarioAutenticado.id, anuncio.id);
                                      } else {
                                        // modal inicio de sesion
                                        inicioSesionComents(context);
                                      }
                                    },
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Añadir Comentario",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Calibri-Bold',
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Ancho fijo para el diseño de escritorio
                    height: MediaQuery.of(context)
                        .size
                        .height, // Altura fija para el diseño de escritorio
                    child: Row(
                      children: [
                        // Imagen principal con miniaturas
                        Expanded(
                          flex: 3,
                          child: Stack(
                            children: [
                              // Imagen principal
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () {
                                    _modalAmpliacion(context, mainImageUrl);
                                  },
                                  child: Image.network(
                                    mainImageUrl,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              // Botón de retroceso
                              Positioned(
                                top: 20,
                                left: 20,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: background1,
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          size: 24,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Fila de miniaturas
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Container(
                                  width:
                                      800, // Ancho fijo para el diseño de escritorio
                                  height: 100,
                                  padding: const EdgeInsets.all(10),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: thumbnailUrls.map((url) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              mainImageUrl = url;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: mainImageUrl == url
                                                    ? primaryColor
                                                    : Colors
                                                        .transparent, // Color del borde resaltado
                                                width: mainImageUrl == url
                                                    ? 3
                                                    : 0, // Ancho del borde resaltado
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(
                                                      0.5), // Color de la sombra
                                                  spreadRadius:
                                                      1, // Radio de expansión de la sombra
                                                  blurRadius:
                                                      2, // Radio de desenfoque de la sombra
                                                  offset: const Offset(0,
                                                      3), // Desplazamiento de la sombra
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                url,
                                                width: mainImageUrl == url
                                                    ? 120
                                                    : 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Información del Producto
                        Expanded(
                          flex: 2,
                          child: Scaffold(
                            body: Container(
                              color: background1,
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        anuncio.titulo,
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                          fontFamily: 'Calibri-Bold',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      anuncio.descripcion,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                        fontFamily: 'Calibri-Bold',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Center(
                                      child: Container(
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                            colors: [
                                              botonClaro, // Verde más claro
                                              botonOscuro, // Verde más oscuro
                                            ],
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  botonSombra, // Verde más claro para sombra
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              // Acción al presionar el botón
                                            },
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: const Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.file_copy,
                                                    color: background1,
                                                    size: 40,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'Ver Más',
                                                    style: TextStyle(
                                                      color: background1,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    const Text(
                                      'Comentarios',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontFamily: 'Calibri-Bold',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    FutureBuilder(
                                      future: _newData.isNotEmpty ? Future.value(_newData) : fetchData(),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              'Ocurrio un error ${snapshot.error}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          );
                                        } else if (snapshot.data!.isEmpty) {
                                          return SizedBox(
                                            height: 300,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: const Center(
                                              child: Text(
                                                'No hay comentarios para este anuncio.',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          final List<UsuarioModel> usuarios =
                                              snapshot.data![2];
                                          final List<ComentarioModel>
                                              comentarios = snapshot.data![0]
                                                  .where((coment) =>
                                                      coment.anuncio.id ==
                                                      anuncio.id)
                                                  .toList();
                                          final List<ImagenUsuarioModel>
                                              allImagesUsuario =
                                              snapshot.data![1];
                                          if (comentarios.isEmpty) {
                                            return SizedBox(
                                              height: 300,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: const Center(
                                                child: Text(
                                                  'No hay comentarios para este anuncio.',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            int itemCount =
                                                comentarios.length > 4
                                                    ? 4
                                                    : comentarios.length;
                                            return Column(
                                              children: [
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: SizedBox(
                                                      height: 300,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: GridView.builder(
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                //Columnas dependiendo el ancho de la pantalla
                                                                crossAxisCount:
                                                                    Responsive.isMobile(
                                                                            context)
                                                                        ? 1
                                                                        : 2),
                                                        itemCount: itemCount,
                                                        itemBuilder:
                                                            (context, index) {
                                                          ComentarioModel
                                                              comentario =
                                                              comentarios[
                                                                  index];

                                                          UsuarioModel usuario =
                                                              usuarios
                                                                  .where((usuario) =>
                                                                      usuario
                                                                          .id ==
                                                                      comentario
                                                                          .usuario)
                                                                  .first;
                                                          final ImagenUsuarioModel?
                                                              imageUrl =
                                                              allImagesUsuario
                                                                  .where((user) =>
                                                                      user.usuario ==
                                                                      usuario
                                                                          .id)
                                                                  .firstOrNull;
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            // Card para presentar los comentarios
                                                            child: Card(
                                                              elevation: 4.0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            InteractiveViewer(
                                                                          constrained:
                                                                              false,
                                                                          scaleEnabled:
                                                                              false,
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(50.0),
                                                                                  child: imageUrl != null
                                                                                      ? Image.network(
                                                                                          imageUrl.foto,
                                                                                          width: 40,
                                                                                          height: 40,
                                                                                          fit: BoxFit.cover,
                                                                                        )
                                                                                      : CircleAvatar(
                                                                                          backgroundColor: primaryColor,
                                                                                          radius: 20,
                                                                                          child: Text(
                                                                                            usuario.nombres[0].toUpperCase(),
                                                                                            style: const TextStyle(
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
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      usuario.nombres,
                                                                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    Text(
                                                                                      // formateo de la fecha
                                                                                      'Fecha de registro: ${formatFechaHora(usuario.fechaRegistro)}',
                                                                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            defaultPadding,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                formatFechaHora(comentario.fecha),
                                                                                style: const TextStyle(color: Colors.grey),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            defaultPadding,
                                                                      ),
                                                                      Text(
                                                                        comentario
                                                                            .descripcion,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(20),
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
                                                                            child:
                                                                                IconButton(
                                                                              icon: const Icon(Icons.delete, size: 25, color: primaryColor),
                                                                              onPressed: () {
                                                                                // Acción al presionar el botón de eliminar
                                                                                deleteComent(comentario.id);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            defaultPadding,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: defaultPadding),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          bottom: 10,
                                                          top: 10),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          botonClaro, // Verde más claro
                                                          botonOscuro, // Verde más oscuro
                                                        ],
                                                      ),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color:
                                                              botonSombra, // Verde más claro para sombra
                                                          blurRadius: 5,
                                                          offset: Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          // Acción al presionar el botón
                                                          modalComentarios(
                                                              context,
                                                              comentarios,
                                                              usuarios,
                                                              allImagesUsuario);
                                                        },
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          child: Center(
                                                            child: Text(
                                                              'Ver Comentarios',
                                                              style: TextStyle(
                                                                color:
                                                                    background1,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Calibri-Bold',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            bottomNavigationBar: Container(
                              color: background1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                  height: 85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.black,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            String text =
                                                "Producto: ${anuncio.titulo}\n";
                                            text +=
                                                "Descripcion: ${anuncio.descripcion} \n";
                                            text +=
                                                "Precio: ${formatFechaHora(anuncio.fecha)}} \n";
                                            text += '\n';
                                            text +=
                                                'Visitanos en nuestra pagina web o aplicacion http://localhost:65500/';
                                            if (UniversalPlatform.isAndroid ||
                                                UniversalPlatform.isIOS) {
                                              Share.share(text);
                                            } else {
                                              modalCompartirWhatsapp(
                                                  context, text);
                                            }
                                          },
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(55),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Icon(Icons.share,
                                                color: Colors.white, size: 24),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 10), // Espacio entre botones
                                      Expanded(
                                        flex:
                                            3, // Este botón ocupará más espacio
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "Inscribirme",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri-Bold',
                                                fontSize: 20,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 10), // Espacio entre botones
                                      Expanded(
                                        flex:
                                            3, // Este botón ocupará más espacio
                                        child: GestureDetector(
                                          onTap: () {
                                            if (usuarioAutenticado != null) {
                                              fomularioComentario(
                                                  context,
                                                  usuarioAutenticado.id,
                                                  anuncio.id);
                                            } else {
                                              print('addd coment ');
                                              // modal inicio de sesion
                                              inicioSesionComents(context);
                                            }
                                          },
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "Añadir Comentario",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri-Bold',
                                                fontSize: 20,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}

void _modalAmpliacion(BuildContext context, String src) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              src,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
  );
}
