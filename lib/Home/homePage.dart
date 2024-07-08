// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:async';
import 'package:provider/provider.dart';
import 'package:tienda_app/Home/anuncioCard.dart';
import 'package:tienda_app/Home/logoSection.dart';
import 'package:tienda_app/Home/misionSection.dart';
import 'package:tienda_app/Home/productoCard.dart';
import 'package:tienda_app/Home/profileCard.dart';
import 'package:tienda_app/Home/sedeCard.dart';
import 'package:tienda_app/Home/senaSection.dart';
import 'package:tienda_app/Models/anuncioModel.dart';
import 'package:tienda_app/Models/imagenAnuncioModel.dart';
import 'package:tienda_app/Models/imagenProductoModel.dart';
import 'package:tienda_app/Models/imagenSedeModel.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/Models/sedeModel.dart';
import 'package:tienda_app/Tienda/tiendaController.dart';
import 'package:tienda_app/Tienda/tiendaScreen.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/provider.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';

/// Clase del widget de la pantalla principal de la aplicación.
///
/// Esta clase extiende [StatefulWidget] y proporciona un estado asociado
/// [_HomePageState].
class HomePage extends StatefulWidget {
  /// Constructor sin parámetros obligatorios.
  ///
  /// Utiliza el constructor de [super] para inicializar la clase.
  const HomePage({super.key});

  /// Crea y devuelve un estado [_HomePageState] para manejar los datos de la pantalla.
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  /// Indica si la sección secundaria de la pantalla está visible.
  ///
  /// Es `true` si la sección secundaria está visible, de lo contrario es `false`.
  /// Por defecto su valor es `false`.
  ///
  /// Esta variable se utiliza para manejar la visibilidad de la sección secundaria
  /// de la pantalla principal.
  ///
  /// Esta variable se utiliza en la implementación del método [_toggleSecondary]
  /// para alternar la visibilidad de la sección secundaria.
  ///
  /// Esta variable se utiliza en la implementación del método [_buildBody] para
  /// determinar si se debe mostrar la sección secundaria o no.
  bool secundaria = false;

  /// La futura lista de datos que se obtiene de la llamada a la función [_fetchData].
  ///
  /// Esta variable se utiliza para almacenar los datos obtenidos de la fuente de datos.
  /// La variable es de tipo [Future<List<dynamic>>] para indicar que se trata de una llamada asíncrona.
  late Future<List<dynamic>> _datosFuture;

  /// Lista de URLs de imágenes.
  ///
  /// Esta lista contiene las URLs de las imágenes que se utilizarán para el fondo de pantalla.
  final List<String> imageUrls = [
    'assets/img/fondo1.jpg',
    'assets/img/fondo2.jpg',
    'assets/img/fondo3.jpg',
    'assets/img/fondo4.jpg',
  ];

  /// Índice de la imagen actual.
  ///
  /// Esta variable se utiliza para almacenar el índice de la imagen actual que se está mostrando.
  /// El valor inicial es 0, lo que indica que se está mostrando la primera imagen.
  int _currentIndex = 0;

  /// Controlador de animación.
  ///
  /// Esta variable se utiliza para controlar la animación de desplazamiento horizontal
  /// de las imágenes en el fondo de pantalla.
  late AnimationController _controller;

  /// Animación de desplazamiento horizontal.
  ///
  /// Esta variable se utiliza para almacenar la animación que controla el desplazamiento horizontal
  /// de las imágenes en el fondo de pantalla.
  late Animation<Offset> _offsetAnimation;

  @override

  /// Se llama cuando se crea el [HomePageState] por primera vez.
  ///
  /// Inicializa la variable [_datosFuture] llamando a [_fetchData] y
  /// configura el ciclo de cambio de imágenes.
  /// También configura la animación para el desplazamiento horizontal de las imágenes.
  @override
  void initState() {
    super.initState();

    // Inicializar la futura lista de datos
    _datosFuture = _fetchData();

    // Iniciar el ciclo de cambio de imágenes
    startImageSlideShow();

    // Configurar la animación
    _controller = AnimationController(
      vsync:
          this, // Sincronizar la animación con la frecuencia de actualización de la pantalla
      duration: const Duration(
          milliseconds: 500), // Duracion de la animación en milisegundos
    );

    // Configurar la animación de desplazamiento horizontal
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero, // Posición inicial
      end: const Offset(0.0,
          0.05), // Posición final: 5% del tamaño de la pantalla hacia arriba
    ).animate(CurvedAnimation(
      parent: _controller, // Animación padre
      curve: Curves.easeInOut, // Curva de animación: inicio lento, final rápido
    ));

    // Repetir la animación de forma inversa, creando un movimiento de onda
    _controller.repeat(reverse: true);
  }

  /// Inicia un ciclo de cambio de imágenes en el fondo de la pantalla.
  ///
  /// Cada 3 segundos se cambia a la siguiente imagen en la lista de [imageUrls].
  /// Si se ha alcanzado el último elemento, se vuelve a la primera.
  void startImageSlideShow() {
    // Esperar 3 segundos y luego cambiar la imagen actual
    Future.delayed(const Duration(seconds: 3), () {
      // Actualizar el estado del widget para mostrar la siguiente imagen en la lista
      setState(() {
        // Incrementar el índice de la imagen actual y reiniciarlo a 0 si se ha alcanzado el final
        _currentIndex = (_currentIndex + 1) % imageUrls.length;
      });

      // Reiniciar el ciclo de cambio de imágenes
      startImageSlideShow();
    });
  }

  /// Realiza una solicitud asíncrona a las API para obtener datos necesarios para la pantalla de inicio.
  ///
  /// Llama a las funciones [getImagenProductos], [getProductos], [getImagenSedes],
  /// [getSedes], [getAnuncios] y [getImagenesAnuncio] y espera a que todas las solicitudes
  /// se completen antes de devolver los resultados. Devuelve una [Future] que contiene una lista
  /// de [dynamic] con los datos obtenidos de cada solicitud.
  ///
  /// Este método se utiliza para obtener los datos necesarios para mostrar en la pantalla de inicio,
  /// como imágenes de productos, productos, imágenes de sedes y anuncios.
  Future<List<dynamic>> _fetchData() {
    // Realizar todas las solicitudes asíncronamente y esperar a que todas se completen
    return Future.wait([
      // Obtener las imágenes de los productos
      getImagenProductos(),
      // Obtener los productos
      getProductos(),
      // Obtener las imágenes de las sedes
      getImagenSedes(),
      // Obtener las sedes
      getSedes(),
      // Obtener los anuncios
      getAnuncios(),
      // Obtener las imágenes de los anuncios
      getImagenesAnuncio(),
    ]);
  }

  @override

  /// Libera los recursos utilizados por la animación.
  ///
  /// Se llama automáticamente cuando se elimina el widget.
  /// Se debe llamar a [dispose] para liberar los recursos utilizados por la animación.
  /// Finalmente, se llama al método [dispose] del padre para liberar recursos adicionales.
  void dispose() {
    // Liberar recursos de la animación
    _controller.dispose();

    // Liberar recursos del padre
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Consumer por si se necesita acceder al estado
    return Consumer<AppState>(builder: (context, appState, _) {
      return Scaffold(
        body: Stack(
          children: [
            // Fondo con imágenes que cambian
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Image.asset(
                imageUrls[_currentIndex], // URL de la imagen actual
                key: ValueKey<String>(
                    imageUrls[_currentIndex]), // Key única para la animación
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // Capa verde semitransparente
            Container(
              color: primaryColor.withOpacity(
                  0.5), // Ajusta el nivel de opacidad según sea necesario
              width: double.infinity,
              height: double.infinity,
            ),

            // Logo y texto
            // Verificación si la variable secundaria es false para mostrar el logo y titulo inicial
            if (secundaria == false)
              // Si el dispositivo es escritorio
              Responsive.isDesktop(context)
                  ? Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  0.2, // 20% del ancho de la pantalla
                              height: MediaQuery.of(context).size.width *
                                  0.2, // 20% del ancho de la pantalla
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withOpacity(0.5),
                              ),
                              // Coloca aquí tu imagen de logo
                              child: Image.asset('assets/img/logo.png'),
                            ),

                            const SizedBox(width: 20),

                            // Texto
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Centro de Biotecnología Agropecuaria',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Calibri-Bold",
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Color y opacidad de la sombra
                                          offset: const Offset(2,
                                              2), // Desplazamiento de la sombra (horizontal, vertical)
                                          blurRadius:
                                              3, // Radio de desenfoque de la sombra
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'SENA Mosquera',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.06, // 6% del ancho de la pantalla
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Calibri-Bold",
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(
                                              0.5), // Color y opacidad de la sombra
                                          offset: const Offset(2,
                                              2), // Desplazamiento de la sombra (horizontal, vertical)
                                          blurRadius:
                                              3, // Radio de desenfoque de la sombra
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  // Si el dispositivo es movil o tablet
                  : Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Títulos
                            Text(
                              'Centro de Biotecnología Agropecuaria',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width *
                                    0.06, // 6% del ancho de la pantalla
                                fontWeight: FontWeight.bold,
                                fontFamily: "Calibri-Bold",
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(
                                        0.5), // Color y opacidad de la sombra
                                    offset: const Offset(2,
                                        2), // Desplazamiento de la sombra (horizontal, vertical)
                                    blurRadius:
                                        3, // Radio de desenfoque de la sombra
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'SENA Mosquera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width *
                                    0.06, // 6% del ancho de la pantalla
                                fontWeight: FontWeight.bold,
                                fontFamily: "Calibri-Bold",
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(
                                        0.5), // Color y opacidad de la sombra
                                    offset: const Offset(2,
                                        2), // Desplazamiento de la sombra (horizontal, vertical)
                                    blurRadius:
                                        3, // Radio de desenfoque de la sombra
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Logo
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  0.2, // 20% del ancho de la pantalla
                              height: MediaQuery.of(context).size.width *
                                  0.2, // 20% del ancho de la pantalla
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withOpacity(0.5),
                              ),
                              // Coloca aquí tu imagen de logo
                              child: Image.asset('assets/img/logo.png'),
                            ),
                          ],
                        ),
                      ),
                    ),

            // Contenido
            // Si la variable secundaria es verdadera, se muestra el contenido.
            if (secundaria == true)
              Positioned(
                top: 130,
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Sección de Anuncios
                          Text(
                            'Anuncios',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Calibri-Bold',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(2, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          // Lista de Anuncios
                          SizedBox(
                            height: 300,
                            child: FutureBuilder(
                              future: _datosFuture,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>>
                                      snapshotAnuncios) {
                                if (snapshotAnuncios.connectionState ==
                                    ConnectionState.waiting) {
                                  // Muestra un indicador de carga mientras se espera la data
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshotAnuncios.hasError) {
                                  // Manejo de errores al cargar los datos de anuncios
                                  return Center(
                                    child: Text(
                                      'Error al cargar datos: ${snapshotAnuncios.error}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            offset: const Offset(2, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (snapshotAnuncios.data!.isEmpty) {
                                  // Si no hay anuncios disponibles para mostrar
                                  return Center(
                                    child: Text(
                                      'No hay anuncios disponibles en este momento',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            offset: const Offset(2, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  // Cuando se obtienen los datos de anuncios
                                  final List<AnuncioModel> anuncios =
                                      snapshotAnuncios.data![4];

                                  final List<ImagenAnuncioModel>
                                      imagenesAnuncios =
                                      snapshotAnuncios.data![5];

                                  // Filtrar anuncios disponibles basados en la fecha
                                  final anunciosDisponibles =
                                      anuncios.where((anuncio) {
                                    final now = DateTime.now();
                                    final fechaAnuncio =
                                        DateTime.parse(anuncio.fecha);
                                    return fechaAnuncio.isAfter(now) ||
                                        fechaAnuncio.day == now.day;
                                  }).toList();

                                  if (anunciosDisponibles.isEmpty) {
                                    // Si no hay anuncios disponibles tras el filtro
                                    return Center(
                                      child: Text(
                                        'No hay anuncios disponibles en este momento',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              offset: const Offset(2, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Mostrar la lista de anuncios disponibles
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: anunciosDisponibles.length,
                                      itemBuilder: (context, index) {
                                        AnuncioModel anuncio =
                                            anunciosDisponibles[index];

                                        // Obtener imágenes asociadas al anuncio actual
                                        List<String> imagesAnun =
                                            imagenesAnuncios
                                                .where((imagen) =>
                                                    imagen.anuncio.id ==
                                                    anuncio.id)
                                                .map((imagen) => imagen.imagen)
                                                .toList();
                                        return AnuncioCard(
                                          anuncio: anuncio,
                                          images: imagesAnun,
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          // Sección de Productos Destacados
                          Text(
                            'Productos Destacados',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Calibri-Bold',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(2, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          // Lista de Productos Destacados
                          SizedBox(
                            height: 300,
                            child: FutureBuilder(
                              future: _datosFuture,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Indicador de carga mientras se espera la data
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  // Manejo de errores al cargar los datos de productos
                                  return Center(
                                    child: Text(
                                      'Error al cargar datos: ${snapshot.error}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            offset: const Offset(2, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  final List<ImagenProductoModel> allImages =
                                      snapshot.data![0];
                                  final List<ProductoModel> productos =
                                      snapshot.data![1];

                                  if (productos.isEmpty) {
                                    // Si no hay productos para mostrar
                                    return Center(
                                      child: Text(
                                        'No hay productos',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              offset: const Offset(2, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  // Filtrar productos destacados y activos
                                  List<ProductoModel> productosFiltrados =
                                      productos
                                          .where((producto) =>
                                              producto.destacado &&
                                              producto.estado)
                                          .toList();

                                  // Mostrar la lista de productos destacados
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productosFiltrados.length,
                                    itemBuilder: (context, index) {
                                      final producto =
                                          productosFiltrados[index];
                                      List<String> imagenesProducto = allImages
                                          .where((imagen) =>
                                              imagen.producto.id == producto.id)
                                          .map((imagen) => imagen.imagen)
                                          .toList();
                                      return ProductoCard(
                                        imagenes: imagenesProducto,
                                        producto: producto,
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          // Sección de la SENA
                          const SenaSection(),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          // Sección de la Misión
                          const MisionSection(),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          // Sección del Logo
                          const LogoSection(),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          // Sección de Conozca Nuestras Sedes
                          Text(
                            'Conozca Nuestras Sedes',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Calibri-Bold',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(2, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            child: FutureBuilder(
                              future: _datosFuture,
                              builder: (context, snapshotSedes) {
                                if (snapshotSedes.connectionState ==
                                    ConnectionState.waiting) {
                                  // Indicador de carga mientras se espera la data
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshotSedes.data!.isEmpty) {
                                  // Mensaje si no hay sedes disponibles
                                  return const Center(
                                    child: Text(
                                      'Sin sedes',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  );
                                } else if (snapshotSedes.hasError) {
                                  // Manejo de errores al cargar las sedes
                                  return Center(
                                    child: Text(
                                      'Ocurrió un error, por favor reportelo: ${snapshotSedes.error}',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  );
                                } else {
                                  // Lista de todas las sedes
                                  final List<SedeModel> allsedes =
                                      snapshotSedes.data![3];
                                  final List<ImagenSedeModel> allImagesSedes =
                                      snapshotSedes.data![2];
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: allsedes.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // Sede que vamos a construir
                                      SedeModel sede = allsedes[index];
                                      // Buscamos las imágenes de la sede en base a la sede actual (index)
                                      List<String> imagesSede = allImagesSedes
                                          .where((imagen) =>
                                              imagen.sede.id == sede.id)
                                          .map((imagen) => imagen.imagen)
                                          .toList();
                                      return SedeCard(
                                        sede: sede,
                                        imagenes: imagesSede,
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          // Texto de derechos de autor
                          Center(
                            child: Text(
                              '©SENA 2024',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Calibri-Bold',
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(2, 2),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Iconos en la parte superior derecha
            // Posiciónamiento del contenido en la parte superior derecha
            // de la pantalla.
            Positioned(
              top: 40,
              right: 20,
              child: Row(
                children: [
                  // Botón de búsqueda
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                    child: Container(
                      color: primaryColor, // Color de fondo del botón.
                      child: IconButton(
                        // Botón de la tienda.
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(
                                    create: (context) => Tiendacontroller(),
                                  ),
                                ],
                                child: const TiendaScreen(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.store,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Espacio entre botones.
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                    child: Container(
                      color: primaryColor, // Color de fondo del botón.
                      child: IconButton(
                        // Botón de chat.
                        onPressed: () {},
                        icon: const Icon(
                          Icons.chat,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Espacio entre botones.
                  const ProfileCard(), // Tarjeta de perfil.
                ],
              ),
            ),

            // Si la variable secundaria es true muestra este logo
            if (secundaria == true)
              Positioned(
                top: 40,
                left: 20,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Cambia la variable secundaria a false
                        setState(() {
                          secundaria = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withOpacity(0.5),
                        ),
                        // Coloca aquí tu imagen de logo
                        child: Image.asset('assets/img/logo.png'),
                      ),
                    ),
                  ],
                ),
              ),

            // Icono de subir
            // Si la variable secundaria es false muestra este icono en la parte inferior.
            // Sirve para cambiar el valor de la variable secundaria y cambiar la vista del home.
            if (secundaria == false)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward,
                          color: Colors.green, size: 30),
                      onPressed: () {
                        // Aquí puedes añadir la lógica para ir hacia arriba
                        // Cambia la varible secundaria a true
                        setState(() {
                          secundaria = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
