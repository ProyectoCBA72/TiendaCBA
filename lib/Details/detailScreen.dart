// ignore_for_file: file_names

import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // URL de la imagen principal
  String mainImageUrl =
      'https://definicion.de/wp-content/uploads/2011/02/carne-1.jpg';

  // Lista de URL de miniaturas de imágenes
  List<String> thumbnailUrls = [
    'https://definicion.de/wp-content/uploads/2011/02/carne-1.jpg',
    'https://media.gq.com.mx/photos/620bcf7243f71a078a355280/16:9/w_2560%2Cc_limit/carnes-85650597.jpg',
    'https://www.cocinista.es/download/bancorecursos/recetas/cocinar-la-carne-de-vacuno.jpg',
    'https://i.blogs.es/a6a88d/1366_20001/840_560.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7OG_LJtCn_w1lFXu_cbSFWX7gD3p-TroxZA&usqp=CAU',
    'https://img.freepik.com/foto-gratis/carne-cruda-mesa_23-2150857912.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoNsd_eHsX_LQFqHAU2ktVAYClBKcKc-pKjg&usqp=CAU',
    'https://www.elpais.com.co/resizer/xQKptdk_GdP0GFxCWQEyhUpmUtY=/1920x0/smart/filters:format(jpg):quality(80)/cloudfront-us-east-1.images.arcpublishing.com/semana/FG3YXS7KFVFCRNYHDKFFG6YYSA.jpg',
    'https://www.alltech.com/sites/default/files/styles/16_9_large/public/2021-05/Calidad%20de%20la%20carne.png.jpg?itok=HO1-UuVI',
    'https://cdn.forbes.com.mx/2019/04/cortes.jpg',
    'https://carnisima.com/cdn/shop/articles/IMG_4997.jpg?v=1618997052',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxkjsoKehb_3nWUD05IO_Tsq0CMEWe54EZCQ&usqp=CAU',
    // Agrega más URL de miniaturas según sea necesario
  ];

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
                                  'Carne de res',
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Precio',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'BakbakOne',
                                      letterSpacing:
                                          1.2, // Espaciado entre letras para destacar más
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                      height: 8), // Espacio entre los textos
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '\$ 11.000 COP',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontFamily: 'BakbakOne',
                                          decoration: TextDecoration
                                              .lineThrough, // Añade una línea a través del precio original
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                          width:
                                              16), // Espacio entre los precios
                                      Text(
                                        '\$ 8.000 COP',
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'BakbakOne',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Precio Aprendiz',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'BakbakOne',
                                      letterSpacing:
                                          1.2, // Espaciado entre letras para destacar más
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                      height: 8), // Espacio entre los textos
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '\$ 11.000 COP',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontFamily: 'BakbakOne',
                                          decoration: TextDecoration
                                              .lineThrough, // Añade una línea a través del precio original
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                          width:
                                              16), // Espacio entre los precios
                                      Text(
                                        '\$ 8.000 COP',
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'BakbakOne',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding),
                              Text(
                                'Descripción',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                'La carne de res es jugosa, tierna y rica en sabor. Su color rojo intenso varía según el corte y la edad del animal. Es una excelente fuente de proteínas, hierro y vitaminas del grupo B. Se utiliza en una variedad de platos, desde filetes hasta guisos, y su sabor se ve influenciado por la alimentación y el método de crianza del animal.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'BakbakOne',
                                ),
                              ),
                              const SizedBox(height: defaultPadding),
                              Text(
                                'Caracteristicas del producto',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
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
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'Atributo',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontFamily: 'BakbakOne',
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
                                            fontFamily: 'BakbakOne',
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: const [
                                      DataRow(cells: [
                                        DataCell(
                                          Text(
                                            'Medida',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            '1 Lb',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(
                                          Text(
                                            'Categoría',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            'Carnicos',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(
                                          Text(
                                            'Unidad de producción',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            'Carnicos CBA',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(
                                          Text(
                                            'Sede',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            'CBA SENA Mosquera',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
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
                                    fontFamily: 'BakbakOne',
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
                                  'Carne de res',
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Precio',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'BakbakOne',
                                      letterSpacing:
                                          1.2, // Espaciado entre letras para destacar más
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                      height: 8), // Espacio entre los textos
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '\$ 11.000 COP',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontFamily: 'BakbakOne',
                                          decoration: TextDecoration
                                              .lineThrough, // Añade una línea a través del precio original
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                          width:
                                              16), // Espacio entre los precios
                                      Text(
                                        '\$ 8.000 COP',
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'BakbakOne',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Precio Aprendiz',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'BakbakOne',
                                      letterSpacing:
                                          1.2, // Espaciado entre letras para destacar más
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                      height: 8), // Espacio entre los textos
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '\$ 11.000 COP',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontFamily: 'BakbakOne',
                                          decoration: TextDecoration
                                              .lineThrough, // Añade una línea a través del precio original
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                          width:
                                              16), // Espacio entre los precios
                                      Text(
                                        '\$ 8.000 COP',
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'BakbakOne',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding),
                              Text(
                                'Descripción',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                'La carne de res es jugosa, tierna y rica en sabor. Su color rojo intenso varía según el corte y la edad del animal. Es una excelente fuente de proteínas, hierro y vitaminas del grupo B. Se utiliza en una variedad de platos, desde filetes hasta guisos, y su sabor se ve influenciado por la alimentación y el método de crianza del animal.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'BakbakOne',
                                ),
                              ),
                              const SizedBox(height: defaultPadding),
                              Text(
                                'Caracteristicas del producto',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
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
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'Atributo',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontFamily: 'BakbakOne',
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
                                            fontFamily: 'BakbakOne',
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: const [
                                      DataRow(cells: [
                                        DataCell(
                                          Text(
                                            'Medida',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            '1 Lb',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(
                                          Text(
                                            'Categoría',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            'Carnicos',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(
                                          Text(
                                            'Unidad de producción',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            'Carnicos CBA',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(
                                          Text(
                                            'Sede',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            'CBA SENA Mosquera',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontFamily: 'BakbakOne',
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
                                          fontFamily: 'BakbakOne',
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
