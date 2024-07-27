// ignore_for_file: file_names, avoid_print, unnecessary_null_comparison

import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tienda_app/Anuncio/Modals/modalsAnuncio.dart';
import 'package:tienda_app/Anuncio/comentarioForm.dart';
import 'package:tienda_app/Auth/authScreen.dart';
import 'package:tienda_app/Models/anuncioModel.dart';
import 'package:tienda_app/Models/boletaModel.dart';
import 'package:tienda_app/Models/comentarioModel.dart';
import 'package:tienda_app/Models/imagenUsuarioModel.dart';
import 'package:tienda_app/Models/usuarioModel.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/source.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

/// Widget que representa la pantalla de detalles de un anuncio.
///
/// Este widget acepta dos parámetros: [anuncio], que es el anuncio
/// que se va a mostrar, y [images], que es una lista de las imágenes
/// del anuncio.
class AnuncioScreen extends StatefulWidget {
  /// El anuncio que se va a mostrar.
  final AnuncioModel anuncio;

  /// Una lista de las imágenes del anuncio.
  final List<String> images;

  /// Construye un nuevo objeto [AnuncioScreen].
  ///
  /// Los parámetros [anuncio] y [images] son obligatorios.
  const AnuncioScreen({
    super.key,
    required this.anuncio,
    required this.images,
  });

  @override
  State<AnuncioScreen> createState() => _AnuncioScreenState();
}

class _AnuncioScreenState extends State<AnuncioScreen> {
  /// URL de la imagen principal.
  String mainImageUrl = '';

  bool _isInscrito = false;

  /// Lista de URL de miniaturas de imágenes.
  ///
  /// Cada URL representa una imagen en miniatura del anuncio.
  List<String> thumbnailUrls = [];

  /// Lista de comentarios nuevos para reinicializar.
  ///
  /// La lista se utiliza para almacenar los comentarios nuevos que se
  /// van a mostrar en la pantalla, y se reinicializa cada vez que se
  /// actualiza la lista de comentarios actuales.
  List<dynamic> _newData = [];

  @override

  /// Inicializa el estado del widget.
  ///
  /// Se llama automáticamente cuando se crea el widget. En este método, se
  /// inicializan las variables y se llama a los métodos necesarios para cargar
  /// las imágenes y obtener el estado de favorito del producto.
  ///
  /// Este método se encarga de obtener el usuario autenticado, cargar las imágenes
  /// del producto, obtener el número de pedidos del producto y el estado de favorito
  /// del producto.
  ///
  /// No devuelve nada.
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // cambia el estado del widget una vez que este este en el arbol de los mismo
  // con el fin de no perder el contexto
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  /// Carga las imágenes del anuncio.
  ///
  /// Establece la lista de URL de miniaturas de imágenes del anuncio
  /// y la URL de la imagen principal.
  ///
  /// No devuelve nada.
  void _loadData() {
    // Establece la lista de URL de miniaturas de imágenes del anuncio.
    thumbnailUrls = widget.images;
    // Establece la URL de la imagen principal como la primera URL de miniatura.
    mainImageUrl = thumbnailUrls.first;
  }

  Future setData() async {
    final usuarioAutenticado =
        Provider.of<AppState>(context).usuarioAutenticado;
    if (usuarioAutenticado != null) {
      final isInscrito = await isUserAddedBoleta(usuarioAutenticado);
      setState(() {
        _isInscrito = isInscrito;
      });
    }
  }

  // futuro que retorna un bool para verificar si el usuario ya tiene boleta.
  Future<bool> isUserAddedBoleta(UsuarioModel user) async {
    final boletas = await getBoletas();
    // verificamos si el usuario ya ha reservado una boleta en este anuncio.

    if (boletas == null || boletas.isEmpty) {
      return false;
    }

    // si nunguna coincide se retorna el false automaticamente
    return boletas.any((boleta) =>
        boleta.usuario == user.id && boleta.anuncio.id == widget.anuncio.id);
  }

  /// Función asincrónica para obtener los datos necesarios para mostrar los comentarios, las imágenes de los usuarios y los usuarios.
  ///
  /// Llama a las funciones [getComentarios], [getImagenesUsuarios] y [getUsuarios]
  /// y espera a que todas las solicitudes se completen antes de devolver los resultados.
  /// Devuelve una [Future] que contiene una lista de [dynamic] con los datos obtenidos de cada solicitud.
  ///
  /// Esta función se utiliza para obtener los datos necesarios para mostrar los comentarios, las imágenes de los usuarios y los usuarios en la pantalla del anuncio.
  ///
  /// No recibe ningún parámetro.
  /// Devuelve una [Future] que se completa cuando todas las solicitudes se completen.
  Future<List<dynamic>> fetchData() {
    // Realizar todas las solicitudes asíncronamente y esperar a que todas se completen
    return Future.wait([
      // Obtener los comentarios
      getComentarios(),
      // Obtener las imágenes de los usuarios
      getImagenesUsuarios(),
      // Obtener los usuarios
      getUsuarios(),
    ]);
  }

  /// Funación asincrónica para separar la boleta si aun esta disponible.
  ///
  Future reservarBoleta(AnuncioModel anuncio, int userID) async {
    final boletas = await getBoletas();
    String url;
    url = "$sourceApi/api/boletas/";
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = {
      'usuario': userID,
      'anuncio': anuncio.id,
    };
    // contamos las boletas relacionadas al anuncio.
    final boletasAnuncio =
        boletas.where((boleta) => boleta.anuncio.id == anuncio.id).toList();
    // verificamos si el usuario ya ha reservado una boleta en este anuncio.
    final siAdded = boletas.any((boleta) => boleta.usuario == userID);

    if (!siAdded) {
      if (boletasAnuncio.length < anuncio.maxCupos) {
        // si la lista de las boletas relacionadas a este anuncio no es vacia y es menor a la cantidad maxima se hace el post
        final http.Response responde = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(body));
        if (responde.statusCode == 201) {
          // Si la sulicitud fue correcta se muestra
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Se guardo su inscripción a este evento')));

          setState(() {
            _isInscrito = true;
          });
        } else {
          print('Error al enviar datos ${responde.body}');
        }
      }
    } else {
      // si el usuario ya reservó la boleta no podra hacerlo otra vez.
      idAddedBoleta(context);
    }
  }

  /// Función asincrónica para eliminar un comentario específico.
  ///
  /// Elimina un comentario específico basado en su [comentID].
  /// Si la operación de eliminación es exitosa, imprime un mensaje de éxito y actualiza la lista de comentarios en el estado.
  /// Si hay un error en la operación de eliminación, imprime un mensaje de error con el código de estado HTTP de la respuesta.
  ///
  /// El [comentID] es el ID del comentario a eliminar.
  /// No devuelve nada.
  Future deleteComent(int comentID) async {
    // Construye la URL de la API
    String url;
    url = "$sourceApi/api/comentarios/$comentID/";

    // Define los encabezados de la solicitud
    final headers = {
      'Content-Type': 'application/json',
    };

    // Envía una solicitud DELETE a la API con el ID del comentario específico
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    // Verifica el estado de la respuesta HTTP
    if (response.statusCode == 204) {
      // Imprime un mensaje de éxito si la operación de eliminación es exitosa
      print('Datos eliminados correctamente');

      // Obtiene los datos necesarios para mostrar los comentarios, las imágenes de los usuarios y los usuarios
      final List<dynamic> newData = await fetchData();

      // Actualiza la lista de comentarios en el estado
      setState(() {
        _newData = newData;
      });
    } else {
      // Imprime un mensaje de error si hay un error en la operación de eliminación
      print('Error al eliminar datos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Variable que recibe el anuncio actual
    final anuncio = widget.anuncio;
    return Consumer<AppState>(
      builder: (BuildContext context, appState, _) {
        // Variable que recibe el usuario autenticado
        final usuarioAutenticado = appState.usuarioAutenticado;

        return Scaffold(
          body: LayoutBuilder(
            builder: (context, responsive) {
              // Verifica si la pantalla es menor o igual a 900 pixeles de ancho
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
                                      // Llama a la función _modalAmpliacion para mostrar la imagen ampliada
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
                                              // Cambia la imagen principal
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

                          // Información del Anuncio
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
                                    // Título del anuncio
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
                                    // Descripción del anuncio
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
                                    // Botón de ver más
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
                                    // Título de los comentarios
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
                                    // Lista de comentarios
                                    FutureBuilder(
                                      future: _newData.isNotEmpty
                                          ? Future.value(_newData)
                                          : fetchData(), // Carga los datos
                                      builder:
                                          (BuildContext context, snapshot) {
                                        // Si los datos estan cargando
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                          // Si hay un error
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              'Ocurrio un error ${snapshot.error}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          );
                                          // Si no hay datos
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
                                          // Si hay datos
                                        } else {
                                          final List<UsuarioModel> usuarios =
                                              snapshot.data![
                                                  2]; // Lista de usuarios
                                          final List<ComentarioModel>
                                              comentarios = snapshot.data![0]
                                                  .where((coment) =>
                                                      coment.anuncio.id ==
                                                      anuncio.id)
                                                  .toList(); // Lista de comentarios del anuncio
                                          final List<ImagenUsuarioModel>
                                              allImagesUsuario = snapshot.data![
                                                  1]; // Lista de imagenes de usuarios
                                          // Si no hay comentarios
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
                                            // Si hay comentarios
                                          } else {
                                            int itemCount = comentarios.length >
                                                    4
                                                ? 4
                                                : comentarios
                                                    .length; // Cantidad de comentarios a mostrar
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
                                                                  index]; // Comentario

                                                          UsuarioModel usuario = usuarios
                                                              .where((usuario) =>
                                                                  usuario.id ==
                                                                  comentario
                                                                      .usuario)
                                                              .first; // Usuario
                                                          final ImagenUsuarioModel?
                                                              imageUrl =
                                                              allImagesUsuario
                                                                  .where((user) =>
                                                                      user.usuario ==
                                                                      usuario
                                                                          .id)
                                                                  .firstOrNull; // Imagen del usuario
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            // Card de los comentarios
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

                                                                      // Botones de acciones
                                                                      if (usuarioAutenticado !=
                                                                          null)
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            // Botón de editar
                                                                            if (usuarioAutenticado.id ==
                                                                                comentario.usuario)
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
                                                                                  icon: const Icon(Icons.edit, size: 25, color: primaryColor),
                                                                                  onPressed: () {
                                                                                    // Acción al presionar el botón de editar
                                                                                    fomularioComentario(
                                                                                      context,
                                                                                      usuarioAutenticado.id,
                                                                                      anuncio.id,
                                                                                      comentarioID: comentario.id,
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            if (usuarioAutenticado.id ==
                                                                                comentario.usuario)
                                                                              const SizedBox(
                                                                                width: defaultPadding,
                                                                              ),
                                                                            // Botón de eliminar
                                                                            if (usuarioAutenticado.id == comentario.usuario ||
                                                                                usuarioAutenticado.rol3 == "LIDER")
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
                                                // Botón de ver todos los comentarios
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
                                                          // Acción al presionar el botón de ver todos los comentarios
                                                          modalComentarios(
                                                              context,
                                                              anuncio,
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
                      // Barra inferior
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
                                // Botón de compartir
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Texto que se comparte
                                      String text =
                                          "Lo invitamos cordialmente a ${anuncio.titulo}, en el cual se llevará a cabo: ${anuncio.descripcion}. Para más información, visite los espacios virtuales del Centro de Biotecnología Agropecuaria.";

                                      // Verifica si el dispositivo es Android o iOS, para compartir el mensaje a diferentes aplicativos
                                      if (UniversalPlatform.isAndroid ||
                                          UniversalPlatform.isIOS) {
                                        Share.share(text);
                                        // Comparte en WhatsApp
                                      } else {
                                        modalCompartirWhatsappAnuncio(
                                            context, text);
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
                                if (anuncio.evento) const SizedBox(width: 10),
                                // Botón de inscribirme si el anuncio es un evento
                                if (anuncio.evento) // Espacio entre botones
                                  Expanded(
                                    flex: 3, // Este botón ocupará más espacio
                                    child: GestureDetector(
                                      onTap: () {
                                        if (usuarioAutenticado != null) {
                                          reservarBoleta(
                                              anuncio, usuarioAutenticado.id);
                                        } else {
                                          // mostrar modal de falta iniciar sesión
                                          inicioSesionBoleta(context);
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
                                        child: Text(
                                          _isInscrito
                                              ? "Incrito"
                                              : "Inscribirme",
                                          style: const TextStyle(
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
                                // Botón de comentar
                                Expanded(
                                  flex: 3, // Este botón ocupará más espacio
                                  child: GestureDetector(
                                    onTap: () {
                                      // Verifica si hay un usuario autenticado
                                      if (usuarioAutenticado != null) {
                                        // Abre el formulario de comentar
                                        fomularioComentario(context,
                                            usuarioAutenticado.id, anuncio.id);
                                        // No hay usuario autenticado
                                      } else {
                                        // Abre el formulario de inicio de sesión
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
                // Pantalla por defecto
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
                                    // Abre la imagen ampliada
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
                                            // Cambia la imagen principal
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

                        // Información del Anuncio
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
                                    // Título del anuncio
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
                                    // Descripción del anuncio
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
                                    // Botón de ver más
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
                                    // Titulo de los comentarios
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
                                      future: _newData.isNotEmpty
                                          ? Future.value(_newData)
                                          : fetchData(), // Obtener los datos
                                      builder:
                                          (BuildContext context, snapshot) {
                                        // Si los datos están cargando, mostrar un indicador de carga
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                          // Si hay un error, mostrar un mensaje de error
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              'Ocurrio un error ${snapshot.error}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          );
                                          // Si los datos no hay datos
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
                                          // Si hay datos
                                        } else {
                                          final List<
                                              UsuarioModel> usuarios = snapshot
                                                  .data![
                                              2]; // Obtener la lista de usuarios
                                          final List<ComentarioModel>
                                              comentarios = snapshot.data![0]
                                                  .where((coment) =>
                                                      coment.anuncio.id ==
                                                      anuncio.id)
                                                  .toList(); // Obtener la lista de comentarios
                                          final List<ImagenUsuarioModel>
                                              allImagesUsuario = snapshot.data![
                                                  1]; // Obtener la lista de imagenes de usuarios
                                          // Si no hay datos
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
                                            // Si hay datos
                                          } else {
                                            int itemCount = comentarios.length >
                                                    4
                                                ? 4
                                                : comentarios
                                                    .length; // Determinar el número de elementos a mostrar
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
                                                                  index]; // Obtener el comentario

                                                          UsuarioModel usuario = usuarios
                                                              .where((usuario) =>
                                                                  usuario.id ==
                                                                  comentario
                                                                      .usuario)
                                                              .first; // Obtener el usuario
                                                          final ImagenUsuarioModel?
                                                              imageUrl =
                                                              allImagesUsuario
                                                                  .where((user) =>
                                                                      user.usuario ==
                                                                      usuario
                                                                          .id)
                                                                  .firstOrNull; // Obtener la imagen del usuario
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            // Crear tarjeta de comentario
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
                                                                      // Botones de acciones
                                                                      if (usuarioAutenticado !=
                                                                          null)
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            // Botón de editar
                                                                            if (usuarioAutenticado.id ==
                                                                                comentario.usuario)
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
                                                                                  icon: const Icon(Icons.edit, size: 25, color: primaryColor),
                                                                                  onPressed: () {
                                                                                    // Acción al presionar el botón de editar
                                                                                    fomularioComentario(
                                                                                      context,
                                                                                      usuarioAutenticado.id,
                                                                                      anuncio.id,
                                                                                      comentarioID: comentario.id,
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            if (usuarioAutenticado.id ==
                                                                                comentario.usuario)
                                                                              const SizedBox(
                                                                                width: defaultPadding,
                                                                              ),
                                                                            // Botón de eliminar
                                                                            if (usuarioAutenticado.id == comentario.usuario ||
                                                                                usuarioAutenticado.rol3 == "LIDER")
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
                                                // Botón de ver todos los comentarios
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
                                                          // Acción al presionar el botón de ver todos los comentarios
                                                          modalComentarios(
                                                              context,
                                                              anuncio,
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
                            // Barra Inferior
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
                                      // Botón de compartir
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Texto para compartir
                                            String text =
                                                "Lo invitamos cordialmente a ${anuncio.titulo}, en el cual se llevará a cabo: ${anuncio.descripcion}. Para más información, visite los espacios virtuales del Centro de Biotecnología Agropecuaria.";
                                            // Verifica si el dispositivo es Android o iOS, para compartir el mensaje a diferentes aplicativos
                                            if (UniversalPlatform.isAndroid ||
                                                UniversalPlatform.isIOS) {
                                              Share.share(text);
                                              // Verifica si el dispositivo no es Android o IOS para compartir el mensaje a WhatsApp
                                            } else {
                                              modalCompartirWhatsappAnuncio(
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
                                      if (anuncio.evento)
                                        const SizedBox(width: 10),
                                      // Botón de inscribirme si el anuncio es un evento
                                      if (anuncio
                                          .evento) // Espacio entre botones
                                        Expanded(
                                          flex:
                                              3, // Este botón ocupará más espacio
                                          child: GestureDetector(
                                            onTap: () {
                                              // funcion para realizar la inscripcion de los anuncios con evento.
                                              if (usuarioAutenticado != null) {
                                                reservarBoleta(anuncio,
                                                    usuarioAutenticado.id);
                                              } else {
                                                // modal de inicio de sesión
                                                inicioSesionBoleta(context);
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
                                              child: Text(
                                                _isInscrito
                                                    ? "Inscrito"
                                                    : "Inscribirme",
                                                style: const TextStyle(
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
                                      // Botón de anadir comentario
                                      Expanded(
                                        flex:
                                            3, // Este botón ocupará más espacio
                                        child: GestureDetector(
                                          onTap: () {
                                            // Verifica si el usuario ha iniciado sesión
                                            if (usuarioAutenticado != null) {
                                              // Abrir formulario de comentarios
                                              fomularioComentario(
                                                  context,
                                                  usuarioAutenticado.id,
                                                  anuncio.id);
                                              // Si el usuario no ha iniciado sesión
                                            } else {
                                              // abrir ventana emergente para iniciar sesión
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

  /// Muestra un modal de comentarios en la interfaz.
  ///
  /// Muestra una ventana emergente con una lista de comentarios para visualizar y gestionar.
  ///
  /// [context]: El contexto de la aplicación donde se muestra el modal.
  /// [anuncios]: Lista de modelos de comentarios a mostrar.
  /// [usuarios]: Lista de modelos de usuarios correspondientes a los comentarios.
  /// [usersImages]: Lista de imágenes de usuarios para mostrar avatares.
  void modalComentarios(
      BuildContext context,
      AnuncioModel anuncio,
      List<ComentarioModel> comentariosAnuncio,
      List<UsuarioModel> usuarios,
      List<ImagenUsuarioModel> usersImages) {
    showDialog(
        context: context,
        builder: (context) {
          return Consumer<AppState>(
            builder: (BuildContext context, appState, _) {
              final usuarioAutenticado = appState.usuarioAutenticado;
              return AlertDialog(
                content: SizedBox(
                  height: 400,
                  width: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          Responsive.isMobile(context) ? 1 : 2),
                              itemCount: comentariosAnuncio.length,
                              itemBuilder: (context, index) {
                                ComentarioModel comentario =
                                    comentariosAnuncio[index];

                                // Obtener el usuario del comentario actual
                                UsuarioModel usuario = usuarios
                                    .where((usuario) =>
                                        usuario.id == comentario.usuario)
                                    .first;

                                // Obtener la imagen del usuario, si está disponible
                                final ImagenUsuarioModel? imageUrl = usersImages
                                    .where((user) => user.usuario == usuario.id)
                                    .firstOrNull;

                                // Construir la tarjeta de comentario
                                return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Card(
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Avatar y nombre de usuario
                                            SizedBox(
                                              height: 50,
                                              child: InteractiveViewer(
                                                constrained: false,
                                                scaleEnabled: false,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                        child: imageUrl != null
                                                            ? Image.network(
                                                                imageUrl.foto,
                                                                width: 40,
                                                                height: 40,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : CircleAvatar(
                                                                backgroundColor:
                                                                    primaryColor,
                                                                radius: 20,
                                                                child: Text(
                                                                  usuario
                                                                      .nombres[
                                                                          0]
                                                                      .toUpperCase(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                      const SizedBox(
                                                        width: defaultPadding,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            usuario.nombres,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          Text(
                                                            "Fecha de registro: ${formatFechaHora(usuario.fechaRegistro)}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .grey),
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
                                            // Fecha del comentario
                                            SizedBox(
                                              height: 20,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      formatFechaHora(
                                                          comentario.fecha),
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
                                            // Descripción del comentario
                                            Text(
                                              comentario.descripcion,
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 10),
                                            // Acciones según el usuario autenticado
                                            if (usuarioAutenticado != null)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Botón de editar (solo visible para el usuario dueño del comentario)
                                                  if (usuarioAutenticado.id ==
                                                      comentario.usuario)
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
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
                                                            offset: Offset(
                                                                0.0, 0.0),
                                                            blurRadius: 0.0,
                                                            spreadRadius: 0.0,
                                                          ), //BoxShadow
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.edit,
                                                            size: 25,
                                                            color:
                                                                primaryColor),
                                                        onPressed: () {
                                                          // Acción al presionar el botón de editar
                                                          fomularioComentario(
                                                              context,
                                                              usuarioAutenticado
                                                                  .id,
                                                              anuncio.id,
                                                              comentarioID:
                                                                  comentario
                                                                      .id);
                                                        },
                                                      ),
                                                    ),
                                                  // Espacio entre botones
                                                  if (usuarioAutenticado.id ==
                                                      comentario.usuario)
                                                    const SizedBox(
                                                      width: defaultPadding,
                                                    ),
                                                  // Botón de eliminar (visible para el usuario dueño del comentario o para usuarios con rol de "LIDER")
                                                  if (usuarioAutenticado.id ==
                                                          comentario.usuario ||
                                                      usuarioAutenticado.rol3 ==
                                                          "LIDER")
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
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
                                                            offset: Offset(
                                                                0.0, 0.0),
                                                            blurRadius: 0.0,
                                                            spreadRadius: 0.0,
                                                          ), //BoxShadow
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.delete,
                                                            size: 25,
                                                            color:
                                                                primaryColor),
                                                        onPressed: () {
                                                          // Acción al presionar el botón de eliminar
                                                          Navigator.pop(
                                                              context);
                                                          deleteComent(
                                                              comentario.id);
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
                      // Botón de cerrar el modal
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
        });
  }

  /// Muestra un diálogo con un formulario para hacer un comentario.
  ///
  /// El diálogo contiene un formulario para agregar un comentario. El
  /// [context] es el contexto de la aplicación donde se mostrará el
  /// diálogo. El [userId] es el ID del usuario que está haciendo el
  /// comentario y el [anuncioID] es el ID del anuncio al que se está
  /// haciendo el comentario.
  // Usamos el comentario ID para poder usar el mismo formulario para la creacion de comentario como la edición del mismo.
  fomularioComentario(BuildContext context, int userId, int anuncioID,
      {int? comentarioID}) {
    return showDialog(
      context: context,
      builder: (context) {
        // Crea un cuadro de diálogo centrado en la pantalla
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
                // Llama al formulario para hacer un comentario
                child: Comentario(
                  userID: userId,
                  anuncioID: anuncioID,
                  comentarioID: comentarioID,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Muestra un diálogo si no se ha logueado  para hacer el registro en el evento (Boleta).
  void inicioSesionBoleta(BuildContext context) {
    // Muestra un diálogo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Título del diálogo
          title: const Text("¿Quiere reservar su entrada?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Texto de descripción
              const Text(
                  "¡Para reservar su entrada al evento, debe iniciar sesión!"),
              const SizedBox(
                height: 10,
              ),
              // Muestra una imagen circular del logo de la aplicación
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
                // Botón para cancelar la operación
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Cancelar", () {
                    Navigator.pop(context);
                  }),
                ),
                // Botón para iniciar sesión
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Iniciar Sesión", () {
                    // Ignora el compilador y navega a la pantalla de inicio de sesión
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

  /// Muestra un diálogo si ya tiene un registro en el evento (Boleta).
  void idAddedBoleta(BuildContext context) {
    // Muestra un diálogo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Título del diálogo
          title: const Text("¡Ya tiene Boleta!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Texto de descripción
              const Text(
                  "Usted ya cuenta con una inscripción en este evento. No puede inscribirse de nuevo"),
              const SizedBox(
                height: 10,
              ),
              // Muestra una imagen circular del logo de la aplicación
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
                  child: _buildButton("Aceptar", () {
                    // Ignora el compilador y navega a la pantalla de inicio de sesión
                    Navigator.pop(context);
                  }),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  /// Muestra un diálogo con un formulario para hacer un comentario.
  ///
  /// El diálogo contiene un formulario para agregar un comentario. El
  /// [context] es el contexto de la aplicación donde se mostrará el
  /// diálogo.
  void inicioSesionComents(BuildContext context) {
    // Muestra un diálogo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Título del diálogo
          title: const Text("¿Quiere agregar un comentario?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Texto de descripción
              const Text("¡Para agregar un comentario, debe iniciar sesión!"),
              const SizedBox(
                height: 10,
              ),
              // Muestra una imagen circular del logo de la aplicación
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
                // Botón para cancelar la operación
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Cancelar", () {
                    Navigator.pop(context);
                  }),
                ),
                // Botón para iniciar sesión
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildButton("Iniciar Sesión", () {
                    // Ignora el compilador y navega a la pantalla de inicio de sesión
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

  /// Construye un botón con los estilos de diseño especificados.
  ///
  /// El parámetro [text] es el texto que se mostrará en el botón.
  /// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
  ///
  /// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
  Widget _buildButton(String text, VoidCallback onPressed) {
    // Contenedor con un ancho fijo de 200 píxeles y una apariencia personalizada
    // con un borde redondeado, un gradiente de colores y una sombra.
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Borde redondeado.
        gradient: const LinearGradient(
          colors: [
            botonClaro, // Color claro del gradiente.
            botonOscuro, // Color oscuro del gradiente.
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: botonSombra, // Color de la sombra.
            blurRadius: 5, // Radio de desfoque de la sombra.
            offset: Offset(0, 3), // Desplazamiento de la sombra.
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Color transparente para el Material.
        child: InkWell(
          onTap: onPressed, // Función de presionar.
          borderRadius:
              BorderRadius.circular(10), // Radio del borde redondeado.
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10), // Padding vertical.
            child: Center(
              child: Text(
                text, // Texto del botón.
                style: const TextStyle(
                  color: background1, // Color del texto.
                  fontSize: 13, // Tamaño de fuente.
                  fontWeight: FontWeight.bold, // Peso de fuente.
                  fontFamily: 'Calibri-Bold', // Fuente.
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Muestra un diálogo modal con una imagen ampliada.
///
/// El parámetro [src] es la URL de la imagen a mostrar.
void _modalAmpliacion(BuildContext context, String src) {
  // Muestra un diálogo modal con una imagen ampliada.
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // El contenido del diálogo debe tener un tamaño cero para que el
        // fondo transparente no afecte al diálogo completo.
        contentPadding: EdgeInsets.zero,
        // El color de fondo se establece a transparente para que la imagen
        // pueda ser visible detrás de otras partes del diálogo.
        backgroundColor: Colors.transparent,
        // Crea un contenedor con un borde redondeado para la imagen.
        content: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            // Muestra la imagen en el diálogo.
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
