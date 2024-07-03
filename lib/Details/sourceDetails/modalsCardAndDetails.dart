import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';

import '../../Auth/authScreen.dart';

void modalCompartirWhatsapp(
    BuildContext context, String text) {
  TextEditingController telefono = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          '¿Quiere compartir la información de este producto vía WhatsApp?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
                "Por favor, ingrese el número de teléfono celular de la persona con la cual desea compartir este producto."),
            const SizedBox(
              height: 10,
            ),
            ClipOval(
              child: Container(
                width: 100, // Ajusta el tamaño según sea necesario
                height: 100, // Ajusta el tamaño según sea necesario
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Image.asset(
                  "assets/img/logo.png",
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: telefono,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Teléfono',
                      hintStyle: const TextStyle(color: Colors.black),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    keyboardType: TextInputType.text,
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'El teléfono es obligatorio';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        actions: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar')),
              ElevatedButton(
                  onPressed: () async {
                    // vincular whatsapp
                    String celular = telefono.text;
                    String mensaje = text;
                    String url = "https://wa.me/$celular?text=$mensaje";
                    final Uri _url = Uri.parse(url);

                    await launchUrl(_url);
                    log(text);
                  },
                  child: const Text('Enviar')),
            ],
          ),
        ],
      );
    },
  );
}

void isProductAddedModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("¡Este producto ya está agregado!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("El producto seleccionado ya está en su pedido."),
            const SizedBox(
              height: 10,
            ),
            ClipOval(
              child: Container(
                width: 100, // Ajusta el tamaño según sea necesario
                height: 100, // Ajusta el tamaño según sea necesario
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Image.asset(
                  "assets/img/logo.png",
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Aceptar", () {
                  Navigator.pop(context);
                }),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void productoExclusivo(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("¿Quiere agregar un producto exclusivo?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
                "¡Tenga en cuenta que, para agregar un producto exclusivo como los huevos, tiene que agregar previamente otro producto!"),
            const SizedBox(
              height: 10,
            ),
            ClipOval(
              child: Container(
                width: 100, // Ajusta el tamaño según sea necesario
                height: 100, // Ajusta el tamaño según sea necesario
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Image.asset(
                  "assets/img/logo.png",
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Aceptar", () {
                  Navigator.pop(context);
                }),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void inicioSesion(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("¿Quiere agregar a favoritos?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("¡Para agregar a favoritos, debe iniciar sesión!"),
            const SizedBox(
              height: 10,
            ),
            ClipOval(
              child: Container(
                width: 100, // Ajusta el tamaño según sea necesario
                height: 100, // Ajusta el tamaño según sea necesario
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Image.asset(
                  "assets/img/logo.png",
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Cancelar", () {
                  Navigator.pop(context);
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Iniciar Sesión", () {
                  // ignore: prefer_const_constructors
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }),
              )
            ],
          ),
        ],
      );
    },
  );
}

Widget _buildButton(String text, VoidCallback onPressed) {
  return Container(
    width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        colors: [
          botonClaro,
          botonOscuro,
        ],
      ),
      boxShadow: const [
        BoxShadow(
          color: botonSombra,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: background1,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'Calibri-Bold',
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void modalAmpliacion(BuildContext context, String src) {
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

void loginPedidoScreen(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("¿Quiere agregar un producto a su pedido?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("¡Para agregar un pedido, debe iniciar sesión!"),
            const SizedBox(
              height: 10,
            ),
            ClipOval(
              child: Container(
                width: 100, // Ajusta el tamaño según sea necesario
                height: 100, // Ajusta el tamaño según sea necesario
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Image.asset(
                  "assets/img/logo.png",
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Cancelar", () {
                  Navigator.pop(context);
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: _buildButton("Iniciar Sesión", () {
                  // ignore: prefer_const_constructors
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }),
              )
            ],
          ),
        ],
      );
    },
  );
}
