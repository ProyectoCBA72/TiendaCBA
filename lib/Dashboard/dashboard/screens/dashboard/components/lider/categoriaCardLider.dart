// ignore_for_file: prefer_final_fields, file_names, use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tienda_app/Models/categoriaModel.dart';

class CategoriaCardLider extends StatefulWidget {
  final CategoriaModel categoria;
  const CategoriaCardLider({Key? key, required this.categoria})
      : super(key: key);

  @override
  _CategoriaCardLiderState createState() => _CategoriaCardLiderState();
}

class _CategoriaCardLiderState extends State<CategoriaCardLider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoria = widget.categoria;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        height: 200,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                image:  DecorationImage(
                  image: NetworkImage(
                      categoria.imagen),
                  fit: BoxFit.fill,
                ),
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x000005cc),
                    blurRadius: 30,
                    offset: Offset(10, 10),
                  )
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          // Acción al presionar el botón de edición
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          // Acción al presionar el botón de eliminación
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child:  Center(
                        child: Text(
                          categoria.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            fontFamily: 'Calibri-Bold',
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(3.0, 3.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
