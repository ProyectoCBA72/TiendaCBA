// ignore_for_file: file_names

import 'package:tienda_app/Anuncio/comentarioForm.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';

class AnuncioScreen extends StatefulWidget {
  const AnuncioScreen({super.key});

  @override
  State<AnuncioScreen> createState() => _AnuncioScreenState();
}

class _AnuncioScreenState extends State<AnuncioScreen> {
  // URL de la imagen principal
  String mainImageUrl =
      'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/291054585_608787604116674_5459347250647540917_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_ohc=9CpZgunGxXgQ7kNvgEsEiU8&_nc_ht=scontent-bog2-2.xx&oh=00_AYC08wPJP49Mm_7MKrVz5tCUY62v2BBlx9llMRjS0sEGTg&oe=664C87B4';

  // Lista de URL de miniaturas de imágenes
  List<String> thumbnailUrls = [
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/291054585_608787604116674_5459347250647540917_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_ohc=9CpZgunGxXgQ7kNvgEsEiU8&_nc_ht=scontent-bog2-2.xx&oh=00_AYC08wPJP49Mm_7MKrVz5tCUY62v2BBlx9llMRjS0sEGTg&oe=664C87B4',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/290347158_608787637450004_7021336845368539183_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=5f2048&_nc_ohc=DI5OZ4T9EnIQ7kNvgHzWZvD&_nc_ht=scontent-bog2-2.xx&oh=00_AYASPCVujt3prdtWPIdV7XDC3YK7hrW1YlPst2QkhGNC1g&oe=664C87E8',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/290313642_608787627450005_4351049694493049378_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=5f2048&_nc_ohc=UI9LTAh0uckQ7kNvgFLY6eU&_nc_ht=scontent-bog2-2.xx&oh=00_AYBruzjs-541wag9nOqYyxkJkBtTmNPie2P3DapSWoZAJA&oe=664C912A',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/290913004_608787674116667_203320087259222051_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=5f2048&_nc_ohc=KUzyINO3CiMQ7kNvgFVL_FC&_nc_ht=scontent-bog2-2.xx&oh=00_AYAp-6YufAAxNGS767LrenKcG2fstkjtyShASnx6pnTZtQ&oe=664C8879',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/291026333_608787700783331_5635458156048187023_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=5f2048&_nc_ohc=pG13YPSAz80Q7kNvgESDoVz&_nc_ht=scontent-bog2-2.xx&oh=00_AYAOuOnL8oE_rpzqzBikhCFC3y6rloJM-7kj6P0JV573Xg&oe=664C8EA9',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/290738690_608787727449995_8841627253605649314_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=5f2048&_nc_ohc=pu2G_JcyLhEQ7kNvgHFNC2t&_nc_ht=scontent-bog2-2.xx&oh=00_AYApEW2ybqtTtWPGN4JfzfrbsuI51kd2Qhv2KlDJbkZKpA&oe=664C6625',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/291433169_608787764116658_6133606534696421589_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=5f2048&_nc_ohc=j7uy9z6i1nwQ7kNvgFD2Hnf&_nc_ht=scontent-bog2-2.xx&oh=00_AYCubQ5siSMecAhDDJW4La7Hkw7j7hLoNHCcywFeECDA3g&oe=664C74C6',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/291755107_608787757449992_1075636043929717022_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=5f2048&_nc_ohc=dc53BRbq4V4Q7kNvgG8yNIY&_nc_ht=scontent-bog2-2.xx&oh=00_AYDaEGlyhqzA8e41wLy42Bjt-rSbGEUMAe-7nVN0OfyExw&oe=664C6D31',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/289997837_608787780783323_2583591377802539793_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=5f2048&_nc_ohc=h-6eTmM1C-EQ7kNvgFLtnPF&_nc_ht=scontent-bog2-2.xx&oh=00_AYD5DY039wX5fOTcgJcc15KgU06S4bhYQxF2SO0gwYIXUw&oe=664C6817',
    'https://scontent-bog2-2.xx.fbcdn.net/v/t39.30808-6/291142272_608787794116655_2371250142311232850_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=5f2048&_nc_ohc=EUdtb2CnJB0Q7kNvgGu0o5J&_nc_ht=scontent-bog2-2.xx&oh=00_AYBw52cbpm-pibkIdJz_0VEezWp8C4NjTKuLXwLFheZQjw&oe=664C8F37',
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
                                  'Subasta de bovinos por modalidad de sobre',
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
                              const Text(
                                '🐮🐮🐮🐮 Este mensaje es para todos los habitantes de #mosqueracundinamarca, #funzacundinamarca, #facatativacundinamarca, #madridcundinamarca y de otros municipios cercanos, que deseen participar en la subasta que organizará nuestro centro de formación el próximo 8 de julio.¡Los esperamos!',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'BakbakOne',
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              Center(
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        botonClaro, // Verde más claro
                                        botonOscuro, // Verde más oscuro
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            botonSombra, // Verde más claro para sombra
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        // Acción al presionar el botón
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.file_copy,
                                              color: background1,
                                              size: 40,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Ver Más',
                                              style: TextStyle(
                                                color: background1,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: defaultPadding),
                              Text(
                                'Comentarios',
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
                                  child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 400,
                                  child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              //Columnas dependiendo el ancho de la pantalla
                                              crossAxisCount:
                                                  Responsive.isMobile(context)
                                                      ? 1
                                                      : 2),
                                      itemCount: 4,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(20),
                                          // Card para presentar los comentarios
                                          child: Card(
                                            elevation: 4.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                      child: InteractiveViewer(
                                                        constrained: false,
                                                        scaleEnabled: false,
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50.0),
                                                                child: Image
                                                                    .network(
                                                                  "https://media.istockphoto.com/id/1786289731/es/foto/retrato-de-una-mujer-latina-sonriente-en-un-jard%C3%ADn.webp?b=1&s=170667a&w=0&k=20&c=YX8dKr_eY2neWIunkhDIdEQ2lHxBSDQVtlON-EijTmQ=",
                                                                  width: 40,
                                                                  height: 40,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width:
                                                                    defaultPadding,
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
                                                                    "María Fernandez Toro",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleMedium!
                                                                        .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    "Fecha de registro: 2024-05-06",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleSmall!
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.grey),
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
                                                    const SizedBox(
                                                      height: 20,
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "2024/05/06-12:28",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: defaultPadding,
                                                    ),
                                                    const Text(
                                                      "La primera vez que fui a una subasta de ganado bovino, me sorprendió la energía del lugar. Había una atmósfera de competencia y emoción palpable entre los compradores. Ver cómo se determinaba el valor de cada animal me dio una nueva apreciación por la industria y el trabajo que implica la cría de ganado. Fue una experiencia fascinante y educativa.",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )),
                              const SizedBox(height: defaultPadding),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10, top: 10),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        botonClaro, // Verde más claro
                                        botonOscuro, // Verde más oscuro
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            botonSombra, // Verde más claro para sombra
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        // Acción al presionar el botón
                                        _modalComentarios(context);
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Center(
                                          child: Text(
                                            'Ver Comentarios',
                                            style: TextStyle(
                                              color: background1,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'BakbakOne',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                              onTap: () {},
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
                                  "Inscribirme",
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
                          const SizedBox(width: 10), // Espacio entre botones
                          Expanded(
                            flex: 3, // Este botón ocupará más espacio
                            child: GestureDetector(
                              onTap: () {
                                fomularioComentario(context);
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
                                  'Subasta de bovinos por modalidad de sobre',
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
                              const Text(
                                '🐮🐮🐮🐮 Este mensaje es para todos los habitantes de #mosqueracundinamarca, #funzacundinamarca, #facatativacundinamarca, #madridcundinamarca y de otros municipios cercanos, que deseen participar en la subasta que organizará nuestro centro de formación el próximo 8 de julio.¡Los esperamos!',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'BakbakOne',
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              Center(
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        botonClaro, // Verde más claro
                                        botonOscuro, // Verde más oscuro
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            botonSombra, // Verde más claro para sombra
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        // Acción al presionar el botón
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.file_copy,
                                              color: background1,
                                              size: 40,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Ver Más',
                                              style: TextStyle(
                                                color: background1,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: defaultPadding),
                              Text(
                                'Comentarios',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontFamily: 'BakbakOne',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 400,
                                  child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              //Columnas dependiendo el ancho de la pantalla
                                              crossAxisCount: 2),
                                      itemCount: 4,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(20),
                                          // Card para presentar los comentarios
                                          child: Card(
                                            elevation: 4.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                      child: InteractiveViewer(
                                                        constrained: false,
                                                        scaleEnabled: false,
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50.0),
                                                                child: Image
                                                                    .network(
                                                                  "https://media.istockphoto.com/id/1786289731/es/foto/retrato-de-una-mujer-latina-sonriente-en-un-jard%C3%ADn.webp?b=1&s=170667a&w=0&k=20&c=YX8dKr_eY2neWIunkhDIdEQ2lHxBSDQVtlON-EijTmQ=",
                                                                  width: 40,
                                                                  height: 40,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width:
                                                                    defaultPadding,
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
                                                                    "María Fernandez Toro",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleMedium!
                                                                        .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    "Fecha de registro: 2024-05-06",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleSmall!
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.grey),
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
                                                    const SizedBox(
                                                      height: 20,
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "2024/05/06-12:28",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: defaultPadding,
                                                    ),
                                                    const Text(
                                                      "La primera vez que fui a una subasta de ganado bovino, me sorprendió la energía del lugar. Había una atmósfera de competencia y emoción palpable entre los compradores. Ver cómo se determinaba el valor de cada animal me dio una nueva apreciación por la industria y el trabajo que implica la cría de ganado. Fue una experiencia fascinante y educativa.",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )),
                              const SizedBox(height: defaultPadding),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10, top: 10),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        botonClaro, // Verde más claro
                                        botonOscuro, // Verde más oscuro
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            botonSombra, // Verde más claro para sombra
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        // Acción al presionar el botón
                                        _modalComentarios(context);
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Center(
                                          child: Text(
                                            'Ver Comentarios',
                                            style: TextStyle(
                                              color: background1,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'BakbakOne',
                                            ),
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
                                    onTap: () {},
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
                                          fontFamily: 'BakbakOne',
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
                                      fomularioComentario(context);
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

fomularioComentario(context) {
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
              child: const SingleChildScrollView(
                  // Llamar el formulario para hacer un comentario
                  child: Comentario())),
        ),
      );
    },
  );
}

void _modalComentarios(BuildContext context) {
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
                            crossAxisCount:
                                Responsive.isMobile(context) ? 1 : 2),
                        itemCount: 10,
                        itemBuilder: (context, index) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                      BorderRadius.circular(
                                                          50.0),
                                                  child: Image.network(
                                                    "https://media.istockphoto.com/id/1786289731/es/foto/retrato-de-una-mujer-latina-sonriente-en-un-jard%C3%ADn.webp?b=1&s=170667a&w=0&k=20&c=YX8dKr_eY2neWIunkhDIdEQ2lHxBSDQVtlON-EijTmQ=",
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.fill,
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
                                                      "María Fernandez Toro",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Text(
                                                      "Fecha de registro: 2024-05-06",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey),
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
                                      const SizedBox(
                                        height: 20,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Text(
                                                "2024/05/06-12:28",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: defaultPadding,
                                      ),
                                      const Text(
                                        "La primera vez que fui a una subasta de ganado bovino, me sorprendió la energía del lugar. Había una atmósfera de competencia y emoción palpable entre los compradores. Ver cómo se determinaba el valor de cada animal me dio una nueva apreciación por la industria y el trabajo que implica la cría de ganado. Fue una experiencia fascinante y educativa.",
                                        style: TextStyle(color: Colors.grey),
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
      });
}
