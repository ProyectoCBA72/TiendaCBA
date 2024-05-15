// ignore_for_file: file_names
import 'package:tienda_app/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';

class SedeScreen extends StatefulWidget {
  const SedeScreen({super.key});

  @override
  State<SedeScreen> createState() => _SedeScreenState();
}

class _SedeScreenState extends State<SedeScreen> {
  // pasar a double la longitud y la latitud del sitio
  double latitud = double.parse("4.695992401469883");

  double longitud = double.parse("-74.21559381784357");

  // URL de la imagen principal
  String mainImageUrl = 'https://i.ytimg.com/vi/UMBALomvR1Y/hqdefault.jpg';

  // Lista de URL de miniaturas de imágenes
  List<String> thumbnailUrls = [
    'https://i.ytimg.com/vi/UMBALomvR1Y/hqdefault.jpg',
    'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgGbwguyMNuaGlMS987Ez-BzaCGhhIMCK31lDVf1zcksljEozNYfaJJB0f4m_p95QW5sLiL57lGHXpNmAEzzTfueJyn7DHg9t9Sme4SLl29LP-eJdq3qOYD2AZ6xKrRAe-2UAdTEHKyFN0/s1600/Auditorio.JPG',
    'https://pronacon.com.co/wp-content/uploads/2023/03/WhatsApp-Image-2023-03-08-at-4.49.52-PM.jpeg',
    // Agrega más URL de miniaturas según sea necesario
  ];

  late bool state = true;

  @override
  Widget build(BuildContext context) {
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
                                    icon: Icon(
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
                                  'Centro de biotecnología agropecuaria',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                    fontFamily: 'BakbakOne',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Unidades de producción',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 200, // Ancho de la tarjeta
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Card(
                                        elevation: 5, // Elevación de la tarjeta
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Radio de la tarjeta
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: primaryColor
                                                          .withOpacity(
                                                              0.3), // Color y opacidad de la sombra
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          3), // Desplazamiento de la sombra
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                    "https://static.vecteezy.com/system/resources/previews/004/182/846/original/meat-products-flat-design-long-shadow-glyph-icon-chicken-leg-beef-steak-and-sausage-grocery-store-bbq-items-silhouette-illustration-vector.jpg",
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              const Text(
                                                "Carnicos",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  fontFamily: 'BakbakOne',
                                                ),
                                              ), // Título
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              Text(
                                'Dirección',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Mapa con la ubicación de la sede
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 400,
                                  child: OpenStreetMapSearchAndPick(
                                      //center: LatLong(longitud, latitud),
                                      buttonColor: primaryColor,
                                      buttonText: "Buscar",
                                      locationPinIconColor: primaryColor,
                                      locationPinText: "Aquí",
                                      locationPinTextStyle:
                                          TextStyle(color: primaryColor),
                                      onPicked: (pickedData) {}),
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              Text(
                                'Puntos de venta',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
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
                                                  fontFamily: 'BakbakOne',
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                  const Column(
                                                    children: [
                                                      Text(
                                                        "Ubicacion: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                              'BakbakOne',
                                                        ),
                                                      ),
                                                      Text(
                                                        "Portería del CBA",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'BakbakOne',
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
                                                      fontFamily: 'BakbakOne',
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Activo",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                      fontFamily: 'BakbakOne',
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
                              Text(
                                'Información',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
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
                                        borderRadius: BorderRadius.circular(10.0),
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
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_city_outlined,
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "Mosquera",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "Cundinamarca",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "Cundinamarca",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "Km 7 vía Mosquera-Bogotá",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "1234567890",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "1234567890",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "senacba@gmail.com",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
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
                                  icon: Icon(
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
                                  'Centro de biotecnología agropecuaria',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                    fontFamily: 'BakbakOne',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Unidades de producción',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 200, // Ancho de la tarjeta
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Card(
                                        elevation: 5, // Elevación de la tarjeta
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Radio de la tarjeta
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: primaryColor
                                                          .withOpacity(
                                                              0.3), // Color y opacidad de la sombra
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          3), // Desplazamiento de la sombra
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                    "https://static.vecteezy.com/system/resources/previews/004/182/846/original/meat-products-flat-design-long-shadow-glyph-icon-chicken-leg-beef-steak-and-sausage-grocery-store-bbq-items-silhouette-illustration-vector.jpg",
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              const Text(
                                                "Carnicos",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  fontFamily: 'BakbakOne',
                                                ),
                                              ), // Título
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              Text(
                                'Dirección',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Mapa con la ubicación de la sede
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 400,
                                  child: OpenStreetMapSearchAndPick(
                                      //center: LatLong(longitud, latitud),
                                      buttonColor: primaryColor,
                                      buttonText: "Buscar",
                                      locationPinIconColor: primaryColor,
                                      locationPinText: "Aquí",
                                      locationPinTextStyle:
                                          TextStyle(color: primaryColor),
                                      onPicked: (pickedData) {}),
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              Text(
                                'Puntos de venta',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
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
                                                  fontFamily: 'BakbakOne',
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                  const Column(
                                                    children: [
                                                      Text(
                                                        "Ubicacion: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                              'BakbakOne',
                                                        ),
                                                      ),
                                                      Text(
                                                        "Portería del CBA",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'BakbakOne',
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
                                                      fontFamily: 'BakbakOne',
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Activo",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                      fontFamily: 'BakbakOne',
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
                              Text(
                                'Información',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
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
                                        borderRadius: BorderRadius.circular(10.0),
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_city_outlined,
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "Mosquera",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "Cundinamarca",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "Cundinamarca",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "Km 7 vía Mosquera-Bogotá",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "1234567890",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "1234567890",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'BakbakOne',
                                                      ),
                                                    ),
                                                    const Text(
                                                      "senacba@gmail.com",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey,
                                                        fontFamily: 'BakbakOne',
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
