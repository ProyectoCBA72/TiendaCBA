// ignore_for_file: file_names

import 'package:tienda_app/Home/homePage.dart';
import 'package:tienda_app/Home/profileCard.dart';
import 'package:tienda_app/cardProducts.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:tienda_app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TiendaScreen extends StatefulWidget {
  const TiendaScreen({super.key});

  @override
  State<TiendaScreen> createState() => _TiendaScreenState();
}

class _TiendaScreenState extends State<TiendaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 20,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    // Coloca aquí tu imagen de logo
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: Container(
                        // Contenedor que envuelve un botón de búsqueda.
                        color: primaryColor,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            )))),
                const SizedBox(width: 20),
                Stack(
                  children: [
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        child: Container(
                            // Contenedor que envuelve un botón de búsqueda.
                            color: primaryColor,
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                )))),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4)),
                        constraints:
                            const BoxConstraints(minWidth: 12, minHeight: 12),
                        child: const Text(
                          "1",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 20),
                GestureDetector(onTap: () {}, child: const ProfileCard()),
              ],
            ),
          ),
          const Positioned(
            top: 130,
            left: 0,
            right: 0,
            bottom: 0,
            child: BodyTienda(),
          ),
        ],
      ),
    );
  }
}

class BodyTienda extends StatefulWidget {
  const BodyTienda({
    super.key,
  });

  @override
  State<BodyTienda> createState() => _BodyTiendaState();
}

class _BodyTiendaState extends State<BodyTienda> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Longitud de las pestañas basada en la cantidad de categorías.
      length: 5,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // Contenedor que alberga la barra de pestañas.
            child: TabBar(
              indicatorColor: primaryColor,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              tabs: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, bottom: 4, top: 4),
                  // Contenedor que alberga el ícono y el nombre de la categoría.
                  child: Column(
                    children: [
                      Image.network(
                        "https://cdn-icons-png.freepik.com/512/11004/11004436.png",
                        width: 24,
                        height: 24,
                      ),
                      Text(
                        "Carnicos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, bottom: 4, top: 4),
                  // Contenedor que alberga el ícono y el nombre de la categoría.
                  child: Column(
                    children: [
                      Image.network(
                        "https://cdn-icons-png.freepik.com/512/11004/11004436.png",
                        width: 24,
                        height: 24,
                      ),
                      Text(
                        "Carnicos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, bottom: 4, top: 4),
                  // Contenedor que alberga el ícono y el nombre de la categoría.
                  child: Column(
                    children: [
                      Image.network(
                        "https://cdn-icons-png.freepik.com/512/11004/11004436.png",
                        width: 24,
                        height: 24,
                      ),
                      Text(
                        "Carnicos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, bottom: 4, top: 4),
                  // Contenedor que alberga el ícono y el nombre de la categoría.
                  child: Column(
                    children: [
                      Image.network(
                        "https://cdn-icons-png.freepik.com/512/11004/11004436.png",
                        width: 24,
                        height: 24,
                      ),
                      Text(
                        "Carnicos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, bottom: 4, top: 4),
                  // Contenedor que alberga el ícono y el nombre de la categoría.
                  child: Column(
                    children: [
                      Image.network(
                        "https://cdn-icons-png.freepik.com/512/11004/11004436.png",
                        width: 24,
                        height: 24,
                      ),
                      Text(
                        "Carnicos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // Contenedor que alberga el ícono y el nombre de la categoría.
            child: TabBarView(
              children: [
                // Contenedor que alberga la rejilla de sitios.
                Container(
                    padding: const EdgeInsets.all(15),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // Número de columnas basado en el tipo de dispositivo.
                          crossAxisCount: Responsive.isMobile(context)
                              ? 1
                              : Responsive.isTablet(context)
                                  ? 3
                                  : 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20),
                      children: const [
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                      ],
                    )),
                Container(
                    padding: const EdgeInsets.all(15),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // Número de columnas basado en el tipo de dispositivo.
                          crossAxisCount: Responsive.isMobile(context)
                              ? 1
                              : Responsive.isTablet(context)
                                  ? 3
                                  : 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20),
                      children: const [
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                      ],
                    )),
                Container(
                    padding: const EdgeInsets.all(15),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // Número de columnas basado en el tipo de dispositivo.
                          crossAxisCount: Responsive.isMobile(context)
                              ? 1
                              : Responsive.isTablet(context)
                                  ? 3
                                  : 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20),
                      children: const [
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                      ],
                    )),
                Container(
                    padding: const EdgeInsets.all(15),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // Número de columnas basado en el tipo de dispositivo.
                          crossAxisCount: Responsive.isMobile(context)
                              ? 1
                              : Responsive.isTablet(context)
                                  ? 3
                                  : 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20),
                      children: const [
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                      ],
                    )),
                Container(
                    padding: const EdgeInsets.all(15),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // Número de columnas basado en el tipo de dispositivo.
                          crossAxisCount: Responsive.isMobile(context)
                              ? 1
                              : Responsive.isTablet(context)
                                  ? 3
                                  : 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20),
                      children: const [
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                        CardProducts(),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
