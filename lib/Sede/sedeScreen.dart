// ignore_for_file: file_names
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/Models/puntoVentaModel.dart';
import 'package:tienda_app/Models/sedeModel.dart';
import 'package:tienda_app/Models/unidadProduccionModel.dart';
import 'package:tienda_app/constantsDesign.dart';

class SedeScreen extends StatefulWidget {
  final SedeModel sede;
  final List<String> imagenes;
  const SedeScreen({super.key, required this.imagenes, required this.sede});

  @override
  State<SedeScreen> createState() => _SedeScreenState();
}

class _SedeScreenState extends State<SedeScreen> {
  // pasar a double la longitud y la latitud del sitio
  late double latitud;

  late double longitud;

  // URL de la imagen principal
  String mainImageUrl = '';

  // Lista de URL de miniaturas de imágenes
  List<String> thumbnailUrls = [];

  late bool state = true;

  @override
  void initState() {
    super.initState();
    _loadInit();
  }

  void _loadInit() async {
    thumbnailUrls = widget.imagenes;
    mainImageUrl = thumbnailUrls.first;
    latitud = double.parse(widget.sede.latitud);
    longitud = double.parse(widget.sede.longitud);
  }

  @override
  Widget build(BuildContext context) {
    final sede = widget.sede;
    return Scaffold(
      body: LayoutBuilder(builder: (context, responsive) {
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

                    // Información del Producto
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
                              SizedBox(
                                height: 200,
                                child: FutureBuilder(
                                  future: getUndadesProduccion(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<UnidadProduccionModel>>
                                          snapshotUndProduccion) {
                                    if (snapshotUndProduccion.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshotUndProduccion
                                        .data!.isEmpty) {
                                      return const Center(
                                        child: Text(
                                            'No hay Unidades de producción disponibles'),
                                      );
                                    } else if (snapshotUndProduccion.hasError) {
                                      return Center(
                                          child: Text(
                                              'Ocurrio un error: ${snapshotUndProduccion.error}, por favor reportelo'));
                                    } else {
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
                              SizedBox(
                                height: 190,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 2,
                                  itemBuilder: (context, index) {
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
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 13,
                                                bottom: 8,
                                              ),
                                              child: Text(
                                                "Principal",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Calibri-Bold',
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 8.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                    ),
                                                    child: Icon(
                                                      Icons.location_on,
                                                      size: 30,
                                                      color: botonOscuro,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Ubicacion: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                              'Calibri-Bold',
                                                        ),
                                                      ),
                                                      Text(
                                                        "Portería del CBA",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'Calibri-Bold',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 8.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                    ),
                                                    child: Icon(
                                                      state
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
                                                  const Text(
                                                    "Activo",
                                                    style: TextStyle(
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
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                              SizedBox(
                                height: 200,
                                child: FutureBuilder(
                                  future: getUndadesProduccion(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<UnidadProduccionModel>>
                                          snapshotUndProduccion) {
                                    if (snapshotUndProduccion.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshotUndProduccion
                                        .data!.isEmpty) {
                                      return const Center(
                                        child: Text(
                                            'No hay Unidades de producción disponibles'),
                                      );
                                    } else if (snapshotUndProduccion.hasError) {
                                      return Center(
                                          child: Text(
                                              'Ocurrio un error: ${snapshotUndProduccion.error}, por favor reportelo'));
                                    } else {
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
                              SizedBox(
                                height: 190,
                                child: FutureBuilder(
                                  future: getPuntosVenta(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<PuntoVentaModel>>
                                          snapshotPunVenta) {
                                    if (snapshotPunVenta.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshotPunVenta.hasError) {
                                      return Center(
                                        child: Text(
                                            'Ocurrio un error: ${snapshotPunVenta.error}'),
                                      );
                                    } else if (snapshotPunVenta.data!.isEmpty) {
                                      return const Center(
                                        child: Text(
                                            'No hay puntos de venta disponibles para esta sede.'),
                                      );
                                    } else {
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
                                                      2), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                   Padding(
                                                    padding: const EdgeInsets.only(
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
                                                   Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
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
                                                        Column(
                                                          children: [
                                                            const Text(
                                                              "Ubicacion: ",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0,
                                                                fontFamily:
                                                                    'Calibri-Bold',
                                                              ),
                                                            ),
                                                            Text(
                                                              pVenta.ubicacion,
                                                              style: const TextStyle(
                                                                fontSize: 16.0,
                                                                color:
                                                                    Colors.grey,
                                                                fontFamily:
                                                                    'Calibri-Bold',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
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
                                                          pVenta.estado? "Activo" : "Inactivo",
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

void _modalAmpliacion(BuildContext context, String src) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            src,
            fit: BoxFit.cover,
          ),
        ),
      );
    },
  );
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: "dev.fleaflet.flutter_map.example",
    );
