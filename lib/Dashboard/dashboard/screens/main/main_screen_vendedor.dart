import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Chatbot/chatBot.dart';
import 'package:tienda_app/Dashboard/controllers/MenuAppController.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/dashboard_screen_vendedor.dart';
import 'package:tienda_app/responsive.dart';
import 'components/side_menu.dart';

// Clase que representa la pantalla principal del punto de venta, dividida en partes para el dashboard.
class MainScreenVendedor extends StatefulWidget {
  const MainScreenVendedor({super.key});

  @override
  State<MainScreenVendedor> createState() => _MainScreenVendedorState();
}

class _MainScreenVendedorState extends State<MainScreenVendedor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context
          .read<MenuAppController>()
          .scaffoldKey, // Clave del scaffold obtenida desde el controlador del menú de la aplicación.
      drawer: const SideMenu(), // Menú lateral constante.
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar el menú lateral solo en pantallas grandes
            if (Responsive.isDesktop(context))
              const Expanded(
                // Flex por defecto = 1
                // Ocupa 1/6 parte de la pantalla.
                child: SideMenu(),
              ),
            const Expanded(
              // Ocupa 5/6 partes de la pantalla.
              flex: 5,
              child: DashboardScreenVendedor(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBot()),
          );
        },
        child: const Icon(Icons.support_agent),
      ),
    );
  }
}
