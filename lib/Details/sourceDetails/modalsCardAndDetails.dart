// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:tienda_app/constantsDesign.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Auth/authScreen.dart';

/// Muestra un diálogo para compartir la información de un producto a través de WhatsApp.
///
/// El diálogo solicita al usuario que ingrese un número de teléfono celular y envía
/// un mensaje con la información del producto a través de WhatsApp.
///
/// [context] es el contexto de la aplicación donde se mostrará el diálogo.
/// [text] es el texto que se enviará junto con el número de teléfono celular.
void modalCompartirWhatsappProducto(BuildContext context, String text) {
  // Crea un controlador de texto para el campo de ingreso del número de teléfono celular.
  TextEditingController telefono = TextEditingController();

  // Crea una clave global para el formulario.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Muestra el diálogo con el contenido personalizado.
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          '¿Quiere compartir la información de este producto vía WhatsApp?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  "Por favor, ingrese el número de teléfono celular de la persona con la cual desea compartir este producto."),
              const SizedBox(
                height: 10,
              ),
              // Muestra el logo de la aplicación en un contenedor circular.
              ClipOval(
                child: Container(
                  width: 100, // Ajusta el tamaño según sea necesario
                  height: 100, // Ajusta el tamaño según sea necesario
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        primaryColor, // Cambia primaryColor por un color específico
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
                        hintText: 'Teléfono Celular',
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      keyboardType: TextInputType.phone, // Cambio realizado
                      // Validación del campo
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'El teléfono celular es obligatorio';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Obtiene el número de teléfono celular del controlador de texto.
                      String celular = telefono.text;
                      // Crea la URL de WhatsApp para enviar el mensaje.
                      String url = "https://wa.me/$celular?text=$text";
                      final Uri _url = Uri.parse(url);

                      launchUrl(_url);
                    }
                  },
                  child: const Text('Enviar')),
            ],
          ),
        ],
      );
    },
  );
}

/// Muestra un diálogo de alerta que avisa al usuario que el producto ya está agregado al pedido.
///
/// El diálogo contiene un título, un mensaje, una imagen y un botón de aceptar.
/// Si el usuario hace clic en el botón de aceptar, se cierra el diálogo.
///
/// Parámetros:
///
///   - `context` (BuildContext): El contexto de la aplicación.
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
            // Muestra una imagen circular del logo de la aplicación
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
                  // Cierra el diálogo cuando se hace clic en el botón de aceptar
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

/// Muestra un diálogo de alerta que avisa al usuario que el producto seleccionado ya está agregado al pedido.
///
/// El diálogo contiene un título, un mensaje, una imagen y un botón de aceptar.
/// Si el usuario hace clic en el botón de aceptar, se cierra el diálogo.
///
/// Parámetros:
///
///   - `context` (BuildContext): El contexto de la aplicación.
void productoExclusivo(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("¿Quiere agregar un producto exclusivo?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Se muestra un mensaje explicando que para agregar productos exclusivos
            // se debe agregar previamente otro producto.
            const Text(
                "¡Tenga en cuenta que, para agregar un producto exclusivo como los huevos, tiene que agregar previamente otro producto!"),
            const SizedBox(
              height: 10,
            ),
            // Se muestra una imagen circular del logo de la aplicación.
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
                  // Cierra el diálogo cuando se hace clic en el botón de aceptar.
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

/// Muestra un diálogo para avisar al usuario que debe iniciar sesión para agregar un producto a favoritos.
///
/// El diálogo contiene un título, un mensaje, una imagen y dos botones: uno para cancelar y otro para iniciar sesión.
///
/// Parámetros:
///
///   - `context` (BuildContext): El contexto de la aplicación.
void inicioSesion(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // Título del diálogo
        title: const Text("¿Quiere agregar a favoritos?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Texto de descripción
            const Text("¡Para agregar a favoritos, debe iniciar sesión!"),
            const SizedBox(
              height: 10,
            ),
            // Muestra una imagen circular del logo de la aplicación
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
                  // Redirige al usuario a la pantalla de inicio de sesión
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

/// Muestra un diálogo modal para iniciar sesión en el pedido.
///
/// El diálogo solicita al usuario que inicie sesión para agregar un producto
/// a su pedido. Si el usuario cancela la operación, el diálogo se cierra.
/// Si el usuario hace clic en "Iniciar Sesión", se navega a la pantalla de
/// inicio de sesión.
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
            // Muestra el logo de la aplicación en un contenedor redondeado.
            ClipOval(
              child: Container(
                width: 100, // Ajusta el tamaño según sea necesario
                height: 100, // Ajusta el tamaño según sea necesario
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                // Muestra la imagen del logo en el contenedor.
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
                // Botón para cancelar la operación.
                child: _buildButton("Cancelar", () {
                  Navigator.pop(context);
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                // Botón para iniciar sesión.
                child: _buildButton("Iniciar Sesión", () {
                  // Navega a la pantalla de inicio de sesión.
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

/// Construye un botón con los estilos de diseño especificados.
///
/// El parámetro [text] es el texto que se mostrará en el botón.
/// El parámetro [onPressed] es la función que se ejecutará cuando se presione el botón.
///
/// Devuelve un widget [Container] que contiene un widget [Material] con un estilo específico.
Widget _buildButton(String text, VoidCallback onPressed) {
  // Devuelve un contenedor con una decoración circular y un gradiente de color.
  // También tiene sombra y un borde redondeado.
  // El contenedor contiene un widget [Material] que actúa como un botón interactivo.
  // El botón tiene un controlador de eventos [InkWell] que llama a la función [onPressed] cuando se presiona.
  // El [InkWell] tiene un borde redondeado y un padding vertical.
  // El contenido del botón es un texto centrado con un estilo específico.
  return Container(
    width: 200, // Ancho del contenedor
    decoration: BoxDecoration(
      borderRadius:
          BorderRadius.circular(10), // Borde redondeado con un radio de 10
      gradient: const LinearGradient(
        colors: [
          botonClaro, // Color de fondo claro
          botonOscuro, // Color de fondo oscuro
        ],
      ), // Gradiente de color
      boxShadow: const [
        BoxShadow(
          color: botonSombra, // Color de sombra
          blurRadius: 5, // Radio de la sombra
          offset: Offset(0, 3), // Desplazamiento en x e y de la sombra
        ),
      ], // Sombra
    ),
    child: Material(
      color: Colors.transparent, // Color de fondo transparente
      child: InkWell(
        onTap: onPressed, // Controlador de eventos al presionar el botón
        borderRadius:
            BorderRadius.circular(10), // Borde redondeado con un radio de 10
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10), // Padding vertical de 10
          child: Center(
            child: Text(
              text, // Texto del botón
              style: const TextStyle(
                color: background1, // Color del texto
                fontSize: 13, // Tamaño de fuente
                fontWeight: FontWeight.bold, // Fuente en negrita
                fontFamily: 'Calibri-Bold', // Fuente Calibri en negrita
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Muestra un diálogo modal con una imagen ampliada.
///
/// El parámetro [src] es la URL de la imagen a mostrar.
void modalAmpliacion(BuildContext context, String src) {
  // Muestra un diálogo modal con una imagen ampliada.
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // El contenido del diálogo debe tener un tamaño cero para que el
        // fondo transparente no afecte al diálogo completo.
        contentPadding: EdgeInsets.zero,
        // El color de fondo se establece a transparente para que la imagen
        // pueda ser visible detrás de otras partes del diálogo.
        backgroundColor: Colors.transparent,
        // Crea un contenedor con un borde redondeado para la imagen.
        content: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            // Muestra la imagen en el diálogo.
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
