// ignore_for_file: file_names
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/sedeModel.dart';
import 'package:tienda_app/Models/unidadProduccionModel.dart';
import 'package:tienda_app/constantsDesign.dart';

/// Esta es una pantalla para mostrar detalles de una sede.
///
/// Esta pantalla extiende [StatefulWidget] y tiene dos campos requeridos:
/// [imagenes] que son las imágenes de la sede y [sede] que es la información de la sede.
/// [SedeScreen] tiene una instancia de [_SedeScreenState] que se encarga de manejar los datos de la pantalla.
class SedeScreen extends StatefulWidget {
  /// Campos requeridos para crear una instancia de [SedeScreen]
  /// [imagenes] son las imágenes de la sede
  /// [sede] es la información de la sede
  final List<String> imagenes;
  final SedeModel sede;

  /// Constructor de [SedeScreen]
  const SedeScreen({super.key, required this.imagenes, required this.sede});

  /// Función que se encarga de crear la instancia de [_SedeScreenState]
  @override
  State<SedeScreen> createState() => _SedeScreenState();
}

class _SedeScreenState extends State<SedeScreen> {
  /// Latitud del sitio. Se inicializa posteriormente.
  /// El tipo de dato es double.
  late double latitud;

  /// Longitud del sitio. Se inicializa posteriormente.
  /// El tipo de dato es double.
  late double longitud;

  /// URL de la imagen principal del sitio.
  /// Inicialmente está vacía.
  String mainImageUrl = '';

  /// Lista de URL de las miniaturas de las imágenes del sitio.
  /// Se inicializa posteriormente.
  List<String> thumbnailUrls = [];

  /// Estado de la pantalla.
  /// Se inicializa como verdadero.
  late bool state = true;

  @override

  /// Método que se llama cuando se crea el widget.
  /// Se encarga de inicializar los estados de la pantalla.
  @override
  void initState() {
    // Llamar al método 'super.initState()' para inicializar el estado del padre.
    super.initState();

    // Llamar al método '_loadInit()' para cargar los estados de la pantalla.
    _loadInit();
  }

  /// Carga inicial de la pantalla.
  ///
  /// Esta función se llama en el método initState() de la clase _SedeScreenState.
  /// Se encarga de inicializar las variables relacionadas con las imágenes
  /// y las coordenadas del sitio.
  ///
  /// Se llama a los siguientes métodos:
  /// - _loadImages(): Carga las URL de las imágenes.
  /// - _loadCoordenadas(): Carga las coordenadas del sitio.
  void _loadInit() async {
    // Cargar URL de las imágenes.
    thumbnailUrls = widget.imagenes;

    // Asignar la URL de la imagen principal.
    mainImageUrl = thumbnailUrls.first;

    // Cargar las coordenadas del sitio.
    _loadCoordenadas();
  }

  /// Carga las coordenadas del sitio.
  ///
  /// Esta función se llama en el método _loadInit() de la clase _SedeScreenState.
  /// Se encarga de cargar las coordenadas del sitio a partir de la información
  /// recibida del widget.
  ///
  /// Las coordenadas del sitio se obtienen de la propiedad 'latitud' y 'longitud'
  /// del objeto 'sede' del widget. Estas coordenadas se convierten a double para
  /// poder utilizarlas en la aplicación.
  ///
  /// Se llama al siguiente método:
  /// - _parseLatitudLongitud(): Parsea las coordenadas del sitio.
  void _loadCoordenadas() {
    // Parsear las coordenadas del sitio y asignarlas a las variables 'latitud'
    // y 'longitud'.
    latitud = double.parse(widget.sede.latitud);
    longitud = double.parse(widget.sede.longitud);
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene la instancia de SedeModel del widget.
    //
    // La instancia de SedeModel se utiliza para obtener la información de la sede.
    // La variable 'sede' se utiliza más adelante para acceder a las propiedades de
    // la sede como el nombre, la dirección, las coordenadas, etc.
    //
    // Se utiliza el atributo 'widget' para acceder al widget actual y luego se
    // accede a la propiedad 'sede' para obtener la instancia de SedeModel.
    final sede = widget.sede; // Obtiene la instancia de SedeModel del widget.
    return Scaffold(
      body: LayoutBuilder(builder: (context, responsive) {
        // Diseño para dispositvos menores de 990px de ancho
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
                                // Mostrar la imagen ampliada
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
                                        // Al seleccionar cambia la imagen principal
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
                                            width:
                                                mainImageUrl == url ? 120 : 100,
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

                    // Información de la sede
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
                              // Nombre de la sede
                              Center(
                                child: Text(
                                  sede.nombre,
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
                              // Unidades de producción
                              const Text(
                                'Unidades de producción',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              // Lista de unidades de producción
                              /// Widget que muestra una lista horizontal de unidades de producción utilizando FutureBuilder.
                              ///
                              /// Este widget se construye basado en el estado del futuro `getUnidadesProduccion()` y
                              /// muestra un indicador de carga mientras se obtienen los datos. Si no hay unidades de
                              /// producción disponibles, muestra un mensaje correspondiente. Si hay un error, muestra
                              /// un mensaje de error. De lo contrario, muestra una lista de tarjetas con la información
                              /// de las unidades de producción disponibles.
                              SizedBox(
                                height: 200,
                                child: FutureBuilder(
                                  future: getUndadesProduccion(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<UnidadProduccionModel>>
                                          snapshotUndProduccion) {
                                    // Mientras se obtienen los datos, muestra un indicador de progreso circular.
                                    if (snapshotUndProduccion.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    // Si no hay unidades de producción disponibles, muestra un mensaje informativo.
                                    else if (snapshotUndProduccion
                                        .data!.isEmpty) {
                                      return const Center(
                                        child: Text(
                                            'No hay Unidades de producción disponibles'),
                                      );
                                    }
                                    // Si ocurre un error, muestra un mensaje de error.
                                    else if (snapshotUndProduccion.hasError) {
                                      return Center(
                                        child: Text(
                                            'Ocurrió un error: ${snapshotUndProduccion.error}, por favor repórtelo'),
                                      );
                                    }
                                    // Si hay unidades de producción disponibles, muestra una lista horizontal de tarjetas.
                                    else {
                                      final List<UnidadProduccionModel>
                                          allUndProduccion =
                                          snapshotUndProduccion.data!;
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: allUndProduccion.length,
                                        itemBuilder: (context, index) {
                                          final undProduccion =
                                              allUndProduccion[index];
                                          return Container(
                                            width: 200, // Ancho de la tarjeta
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Card(
                                              elevation:
                                                  5, // Elevación de la tarjeta
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Radio de la tarjeta
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: primaryColor
                                                                .withOpacity(
                                                                    0.3), // Color y opacidad de la sombra
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset: const Offset(
                                                                0,
                                                                3), // Desplazamiento de la sombra
                                                          ),
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: Image.network(
                                                          undProduccion.logo,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      undProduccion.nombre,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ), // Título
                                                  ],
                                                ),
                                              ),
                                            ),
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
                              // Dirección
                              const Text(
                                'Dirección',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Mapa con la ubicación de la sede
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 400,
                                  child: FlutterMap(
                                      options: MapOptions(
                                          initialCenter:
                                              LatLng(latitud, longitud),
                                          initialZoom: 14,
                                          interactionOptions:
                                              const InteractionOptions(
                                                  flags: InteractiveFlag
                                                      .doubleTapZoom)),
                                      children: [
                                        openStreetMapTileLayer,
                                        MarkerLayer(markers: [
                                          Marker(
                                              point: LatLng(latitud, longitud),
                                              width: 30,
                                              height: 30,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.location_pin,
                                                size: 30,
                                                color: primaryColor,
                                              ))
                                        ]),
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              // Puntos de venta
                              const Text(
                                'Puntos de venta',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Lista de puntos de venta
                              /// Widget que muestra una lista horizontal de puntos de venta utilizando FutureBuilder.
                              ///
                              /// Este widget se construye basado en el estado del futuro `getPuntosVenta()` y
                              /// muestra un indicador de carga mientras se obtienen los datos. Si hay un error,
                              /// muestra un mensaje de error. Si no hay puntos de venta, muestra un mensaje
                              /// correspondiente. De lo contrario, muestra una lista de tarjetas con la
                              /// información de los puntos de venta disponibles para la sede especificada.
                              SizedBox(
                                height: 190,
                                child: FutureBuilder(
                                  future: getPuntosVenta(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<PuntoVentaModel>>
                                          snapshotPunVenta) {
                                    // Mientras se obtienen los datos, muestra un indicador de progreso circular.
                                    if (snapshotPunVenta.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    // Si ocurre un error, muestra un mensaje de error.
                                    else if (snapshotPunVenta.hasError) {
                                      return Center(
                                        child: Text(
                                            'Ocurrió un error: ${snapshotPunVenta.error}'),
                                      );
                                    }
                                    // Si no hay puntos de venta disponibles, muestra un mensaje informativo.
                                    else if (snapshotPunVenta.data!.isEmpty) {
                                      return const Center(
                                        child: Text(
                                            'No hay puntos de venta disponibles para esta sede.'),
                                      );
                                    }
                                    // Si hay puntos de venta disponibles, muestra una lista horizontal de tarjetas.
                                    else {
                                      // Filtra los puntos de venta disponibles por sede.
                                      final List<PuntoVentaModel>
                                          pVentaDisponibles = snapshotPunVenta
                                              .data!
                                              .where((pVenta) =>
                                                  pVenta.sede == sede.id)
                                              .toList();

                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: pVentaDisponibles.length,
                                        itemBuilder: (context, index) {
                                          final pVenta =
                                              pVentaDisponibles[index];
                                          return Container(
                                            width: 250, // Ancho de la tarjeta
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 8.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0,
                                                      2), // Cambia la posición de la sombra
                                                ),
                                              ],
                                            ),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  // Muestra el nombre del punto de venta.
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8,
                                                      right: 8,
                                                      top: 13,
                                                      bottom: 8,
                                                    ),
                                                    child: Text(
                                                      pVenta.nombre,
                                                      style: const TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ),
                                                  // Muestra la ubicación del punto de venta.
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8.0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                          ),
                                                          child: Icon(
                                                            Icons.location_on,
                                                            size: 30,
                                                            color: botonOscuro,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              const Text(
                                                                "Ubicación: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontFamily:
                                                                      'Calibri-Bold',
                                                                ),
                                                              ),
                                                              Text(
                                                                pVenta
                                                                    .ubicacion,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                      'Calibri-Bold',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Muestra el estado del punto de venta (Activo/Inactivo).
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8.0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                          ),
                                                          child: Icon(
                                                            pVenta.estado
                                                                ? Icons
                                                                    .check_circle_outline
                                                                : Icons
                                                                    .cancel_outlined,
                                                            size: 30,
                                                            color: botonOscuro,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        const Text(
                                                          "Estado: ",
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Calibri-Bold',
                                                          ),
                                                        ),
                                                        Text(
                                                          pVenta.estado
                                                              ? "Activo"
                                                              : "Inactivo",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.grey,
                                                            fontFamily:
                                                                'Calibri-Bold',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                              // Información de la sede
                              const Text(
                                'Información',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Datos de contacto de la sede
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 15,
                                    top: 12,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      8.0,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .location_city_outlined,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Ciudad: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.ciudad,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      CupertinoIcons.map_fill,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Departamento: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.departamento,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      CupertinoIcons.globe,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Regional: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.regional,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on_sharp,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Dirección: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.direccion,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.call_rounded,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Telefono 1: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.telefono1,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.call_rounded,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Telefono 2: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.telefono2,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.email_outlined,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Correo electronico: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.correo,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          // si el dispositivo es de escritorio mayor a 900 pixeles de ancho
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
                              // Abrir modal de ampliación de imagen
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
                                        // Cambia la imagen principal
                                        mainImageUrl = url;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          url,
                                          width:
                                              mainImageUrl == url ? 120 : 100,
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

                  // Información de la sede
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
                              // Nombre de la sede
                              Center(
                                child: Text(
                                  sede.nombre,
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
                              // Unidades de producción
                              const Text(
                                'Unidades de producción',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              // Listado de unidades de producción
                              /// Widget que muestra una lista horizontal de unidades de producción utilizando FutureBuilder.
                              ///
                              /// Este widget se construye basado en el estado del futuro `getUnidadesProduccion()` y
                              /// muestra un indicador de carga mientras se obtienen los datos. Si no hay unidades de
                              /// producción disponibles, muestra un mensaje correspondiente. Si hay un error, muestra
                              /// un mensaje de error. De lo contrario, muestra una lista de tarjetas con la información
                              /// de las unidades de producción disponibles.
                              SizedBox(
                                height: 200,
                                child: FutureBuilder(
                                  future: getUndadesProduccion(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<UnidadProduccionModel>>
                                          snapshotUndProduccion) {
                                    // Mientras se obtienen los datos, muestra un indicador de progreso circular.
                                    if (snapshotUndProduccion.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    // Si no hay unidades de producción disponibles, muestra un mensaje informativo.
                                    else if (snapshotUndProduccion
                                        .data!.isEmpty) {
                                      return const Center(
                                        child: Text(
                                            'No hay Unidades de producción disponibles'),
                                      );
                                    }
                                    // Si ocurre un error, muestra un mensaje de error.
                                    else if (snapshotUndProduccion.hasError) {
                                      return Center(
                                        child: Text(
                                            'Ocurrió un error: ${snapshotUndProduccion.error}, por favor repórtelo'),
                                      );
                                    }
                                    // Si hay unidades de producción disponibles, muestra una lista horizontal de tarjetas.
                                    else {
                                      final List<UnidadProduccionModel>
                                          allUndProduccion =
                                          snapshotUndProduccion.data!;
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: allUndProduccion.length,
                                        itemBuilder: (context, index) {
                                          final undProduccion =
                                              allUndProduccion[index];
                                          return Container(
                                            width: 200, // Ancho de la tarjeta
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Card(
                                              elevation:
                                                  5, // Elevación de la tarjeta
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Radio de la tarjeta
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: primaryColor
                                                                .withOpacity(
                                                                    0.3), // Color y opacidad de la sombra
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset: const Offset(
                                                                0,
                                                                3), // Desplazamiento de la sombra
                                                          ),
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: Image.network(
                                                          undProduccion.logo,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      undProduccion.nombre,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ), // Título
                                                  ],
                                                ),
                                              ),
                                            ),
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
                              // Dirección
                              const Text(
                                'Dirección',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Mapa con la ubicación de la sede
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 400,
                                  child: FlutterMap(
                                      options: MapOptions(
                                          initialCenter:
                                              LatLng(latitud, longitud),
                                          initialZoom: 14,
                                          interactionOptions:
                                              const InteractionOptions(
                                                  flags: InteractiveFlag
                                                      .doubleTapZoom)),
                                      children: [
                                        openStreetMapTileLayer,
                                        MarkerLayer(markers: [
                                          Marker(
                                              point: LatLng(latitud, longitud),
                                              width: 30,
                                              height: 30,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.location_pin,
                                                size: 30,
                                                color: primaryColor,
                                              ))
                                        ]),
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              // Puntos de venta
                              const Text(
                                'Puntos de venta',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Listado de puntos de venta
                              /// Widget que muestra una lista horizontal de puntos de venta utilizando FutureBuilder.
                              ///
                              /// Este widget se construye basado en el estado del futuro `getPuntosVenta()` y
                              /// muestra un indicador de carga mientras se obtienen los datos. Si hay un error,
                              /// muestra un mensaje de error. Si no hay puntos de venta, muestra un mensaje
                              /// correspondiente. De lo contrario, muestra una lista de tarjetas con la
                              /// información de los puntos de venta disponibles para la sede especificada.
                              SizedBox(
                                height: 190,
                                child: FutureBuilder(
                                  future: getPuntosVenta(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<PuntoVentaModel>>
                                          snapshotPunVenta) {
                                    // Mientras se obtienen los datos, muestra un indicador de progreso circular.
                                    if (snapshotPunVenta.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    // Si ocurre un error, muestra un mensaje de error.
                                    else if (snapshotPunVenta.hasError) {
                                      return Center(
                                        child: Text(
                                            'Ocurrió un error: ${snapshotPunVenta.error}'),
                                      );
                                    }
                                    // Si no hay puntos de venta disponibles, muestra un mensaje informativo.
                                    else if (snapshotPunVenta.data!.isEmpty) {
                                      return const Center(
                                        child: Text(
                                            'No hay puntos de venta disponibles para esta sede.'),
                                      );
                                    }
                                    // Si hay puntos de venta disponibles, muestra una lista horizontal de tarjetas.
                                    else {
                                      // Filtra los puntos de venta disponibles por sede.
                                      final List<PuntoVentaModel>
                                          pVentaDisponibles = snapshotPunVenta
                                              .data!
                                              .where((pVenta) =>
                                                  pVenta.sede == sede.id)
                                              .toList();

                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: pVentaDisponibles.length,
                                        itemBuilder: (context, index) {
                                          final pVenta =
                                              pVentaDisponibles[index];
                                          return Container(
                                            width: 250, // Ancho de la tarjeta
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 8.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0,
                                                      2), // Cambia la posición de la sombra
                                                ),
                                              ],
                                            ),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  // Muestra el nombre del punto de venta.
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8,
                                                      right: 8,
                                                      top: 13,
                                                      bottom: 8,
                                                    ),
                                                    child: Text(
                                                      pVenta.nombre,
                                                      style: const TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ),
                                                  // Muestra la ubicación del punto de venta.
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8.0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                          ),
                                                          child: Icon(
                                                            Icons.location_on,
                                                            size: 30,
                                                            color: botonOscuro,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              const Text(
                                                                "Ubicación: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontFamily:
                                                                      'Calibri-Bold',
                                                                ),
                                                              ),
                                                              Text(
                                                                pVenta
                                                                    .ubicacion,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                      'Calibri-Bold',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Muestra el estado del punto de venta (Activo/Inactivo).
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8.0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                          ),
                                                          child: Icon(
                                                            pVenta.estado
                                                                ? Icons
                                                                    .check_circle_outline
                                                                : Icons
                                                                    .cancel_outlined,
                                                            size: 30,
                                                            color: botonOscuro,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        const Text(
                                                          "Estado: ",
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Calibri-Bold',
                                                          ),
                                                        ),
                                                        Text(
                                                          pVenta.estado
                                                              ? "Activo"
                                                              : "Inactivo",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.grey,
                                                            fontFamily:
                                                                'Calibri-Bold',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                              // Información de la sede
                              const Text(
                                'Información',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Datos de contácto de la sede
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 15,
                                    top: 12,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      8.0,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .location_city_outlined,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Ciudad: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.ciudad,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      CupertinoIcons.map_fill,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Departamento: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.departamento,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      CupertinoIcons.globe,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Regional: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.regional,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on_sharp,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Dirección: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.direccion,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.call_rounded,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Telefono 1: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.telefono1,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.call_rounded,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Telefono 2: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.telefono2,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.email_outlined,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Correo electronico: ",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                    Text(
                                                      sede.correo,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'Calibri-Bold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
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
      }),
    );
  }
}

/// Muestra un diálogo modal con una imagen ampliada.
///
/// El parámetro [src] es la URL de la imagen a mostrar.
void _modalAmpliacion(BuildContext context, String src) {
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
        content: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          // Muestra la imagen en el diálogo.
          child: Image.network(
            src,
            fit: BoxFit.cover,
          ),
        ),
      );
    },
  );
}

/// Devuelve un [TileLayer] para el mapa de OpenStreetMap.
///
/// El tileLayer devuelto se puede usar en un widget de Flutter Map para mostrar
/// los tiles del mapa de OpenStreetMap.
TileLayer get openStreetMapTileLayer => TileLayer(
      // La URL de los tiles del mapa de OpenStreetMap.
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      // El nombre del paquete de usuario para el agente de usuario HTTP.
      userAgentPackageName: "dev.fleaflet.flutter_map.example",
    );
