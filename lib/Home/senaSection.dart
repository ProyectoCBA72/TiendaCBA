// ignore_for_file: file_names
import 'package:flutter/material.dart';

class SenaSection extends StatefulWidget {
  const SenaSection({super.key});

  @override
  State<SenaSection> createState() => _SenaSectionState();
}

class _SenaSectionState extends State<SenaSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Quienes Somos",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'BakbakOne',
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "El SENA es un establecimiento público nacional con autonomía administrativa, adscrito al Ministerio del Trabajo. Cuenta con personería jurídica, patrimonio propio, y ofrece formación gratuita en programas técnicos, tecnológicos y complementarios para el desarrollo económico y social del país. Autorizado por el Estado, invierte en infraestructura para mejorar el desarrollo social y técnico de los trabajadores en diferentes regiones. La entidad funciona en alianza con el Gobierno, empresarios y trabajadores para aumentar la capacidad de progreso en Colombia, promoviendo la inclusión social y la creación de empleo. Impulsa programas de responsabilidad social, formación, innovación y transferencia de conocimientos y tecnologías para aumentar la productividad y competitividad de las empresas colombianas.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'BakbakOne',
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 400,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/sena1.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
