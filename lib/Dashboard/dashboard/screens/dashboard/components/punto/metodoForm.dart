// ignore_for_file: file_names

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';

class MetodoForm extends StatefulWidget {
  const MetodoForm({super.key});

  @override
  State<MetodoForm> createState() => _MetodoFormState();
}

class _MetodoFormState extends State<MetodoForm> {
  int? _selectedItem;

  List<MetodoDesplegable> metodo = [
    MetodoDesplegable("Efectivo", 1),
    MetodoDesplegable("Tarjeta", 2),
    MetodoDesplegable("Nequi", 3),
    MetodoDesplegable("Daviplata", 4),
    MetodoDesplegable("PSE", 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "Elija el método de pago para completar la entrega del pedido.",
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<dynamic>(
                // Configuración del DropdownButton
                isExpanded: true,
                hint: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Seleccione método de pago',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: metodo
                    .map((item) => DropdownMenuItem<dynamic>(
                          value: item.valor,
                          child: Text(
                            item.nombre!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: _selectedItem,
                onChanged: (dynamic value) {
                  // Actualización del valor seleccionado
                  setState(() {
                    _selectedItem = value;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.white,
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStateProperty.all<double>(6),
                    thumbVisibility: WidgetStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MetodoDesplegable {
  final String? nombre;
  final int? valor;

  MetodoDesplegable(this.nombre, this.valor);
}
