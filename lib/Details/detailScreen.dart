// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tienda_app/Models/productoModel.dart';
import 'package:tienda_app/constantsDesign.dart';
import '../Models/imagenProductoModel.dart';

class DetailsScreen extends StatefulWidget {
  final ProductoModel producto;
  const DetailsScreen({super.key, required this.producto});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // URL de la imagen principal
  String mainImageUrl = '';

  // Lista de URL de miniaturas de imágenes
  List<String> thumbnailUrls = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    final allImagenes = await getImagenProductos();
    setState(() {
      // Traemos las url de las imagenes relacionadas al produco
      thumbnailUrls = allImagenes
          .where((imagen) => imagen.producto.id == widget.producto.id)
          .map((imagen) => imagen.imagen)
          .toList();
      // Usamos la primera imagen que este dentro de la lista en caso de mezclar usar
      // thumbnailUrls.shuffle();
      mainImageUrl = thumbnailUrls.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    return Scaffold(
      body: LayoutBuilder(builder: (context, responsive) {
        if (responsive.maxWidth <= 900) {
          var row = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$${formatter.format(producto.precio)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontFamily: 'Calibri-Bold',
                  decoration: TextDecoration
                      .lineThrough, // Añade una línea a través del precio original
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 16), // Espacio entre los precios

              Text(
                "\$${formatter.format(producto.precioOferta)}",
                style: const TextStyle(
                  fontSize: 28,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Calibri-Bold',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
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
                    thumbnailUrls.isNotEmpty
                        ?
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
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
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
                                  producto.nombre,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Precio',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'Calibri-Bold',
                                      letterSpacing:
                                          1.2, // Espaciado entre letras para destacar más
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                      height: 8), // Espacio entre los textos
                                  row,
                                ],
                              ),
                              const SizedBox(height: defaultPadding),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Precio Aprendiz',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'Calibri-Bold',
                                      letterSpacing:
                                          1.2, // Espaciado entre letras para destacar más
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                      height: 8), // Espacio entre los textos
                                  Text(
                                    "\$${formatter.format(producto.precioAprendiz)}",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Calibri-Bold',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding),
                              const Text(
                                'Descripción',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                producto.descripcion,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: defaultPadding),
                              const Text(
                                'Caracteristicas del producto',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: defaultPadding),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors
                                            .grey), // Añade un borde gris alrededor del DataTable
                                    borderRadius: BorderRadius.circular(
                                        10), // Opcional: Añade esquinas redondeadas
                                  ),
                                  child: DataTable(
                                    columnSpacing: defaultPadding,
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'Atributo',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontFamily: 'Calibri-Bold',
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Valor',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontFamily: 'Calibri-Bold',
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      DataRow(cells: [
                                        const DataCell(
                                          Text(
                                            'Medida',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            producto.unidadMedida,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        const DataCell(
                                          Text(
                                            'Categoría',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            producto.categoria.nombre,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        const DataCell(
                                          Text(
                                            'Unidad de producción',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            producto.unidadProduccion.nombre,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        const DataCell(
                                          Text(
                                            'Sede',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            producto
                                                .unidadProduccion.sede.nombre,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: defaultPadding),
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
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(55),
                                ),
                                alignment: Alignment.center,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.favorite_outline,
                                        color: Colors.white, size: 24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Espacio entre botones
                          Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(55),
                                ),
                                alignment: Alignment.center,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.share,
                                        color: Colors.white, size: 24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Espacio entre botones
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
                                  "Añadir al carrito",
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
          var row = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$${formatter.format(producto.precio)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontFamily: 'Calibri-Bold',
                  decoration: TextDecoration
                      .lineThrough, // Añade una línea a través del precio original
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 16), // Espacio entre los precios

              Text(
                "\$${formatter.format(producto.precioOferta)}",
                style: const TextStyle(
                  fontSize: 28,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Calibri-Bold',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
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
                  thumbnailUrls.isNotEmpty
                      ?
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
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
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
                                  producto.nombre,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Precio',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'Calibri-Bold',
                                      letterSpacing:
                                          1.2, // Espaciado entre letras para destacar más
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                      height: 8), // Espacio entre los textos
                                  row
                                ],
                              ),
                              const SizedBox(height: defaultPadding),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Precio Aprendiz',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'Calibri-Bold',
                                      letterSpacing:
                                          1.2, // Espaciado entre letras para destacar más
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                      height: 8), // Espacio entre los textos
                                  Text(
                                    "\$${formatter.format(producto.precioAprendiz)}",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Calibri-Bold',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding),
                              const Text(
                                'Descripción',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                producto.descripcion,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: defaultPadding),
                              const Text(
                                'Caracteristicas del producto',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'Calibri-Bold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: defaultPadding),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors
                                            .grey), // Añade un borde gris alrededor del DataTable
                                    borderRadius: BorderRadius.circular(
                                        10), // Opcional: Añade esquinas redondeadas
                                  ),
                                  child: DataTable(
                                    columnSpacing: defaultPadding,
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'Atributo',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontFamily: 'Calibri-Bold',
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Valor',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontFamily: 'Calibri-Bold',
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      DataRow(cells: [
                                        const DataCell(
                                          Text(
                                            'Medida',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            producto.unidadMedida,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        const DataCell(
                                          Text(
                                            'Categoría',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            producto.categoria.nombre,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        const DataCell(
                                          Text(
                                            'Unidad de producción',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            producto.unidadProduccion.nombre,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        const DataCell(
                                          Text(
                                            'Sede',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            producto
                                                .unidadProduccion.sede.nombre,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'Calibri-Bold',
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: defaultPadding),
                            ],
                          ),
                        ),
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
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(55),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.favorite_outline,
                                              color: Colors.white, size: 24),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: 10), // Espacio entre botones
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(55),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.share,
                                              color: Colors.white, size: 24),
                                        ],
                                      ),
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
                                        "Añadir al carrito",
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
