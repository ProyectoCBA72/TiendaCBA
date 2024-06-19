import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/Dashboard/controllers/MenuAppController.dart';
import 'package:tienda_app/Dashboard/dashboard/screens/dashboard/dashboard_screen_punto.dart';
import 'package:tienda_app/responsive.dart';
import 'components/side_menu.dart';

// División por partes de los elementos principales del dashboard

class MainScreenPunto extends StatefulWidget {


  const MainScreenPunto({super.key});

  @override
  State<MainScreenPunto> createState() => _MainScreenPuntoState();
}

class _MainScreenPuntoState extends State<MainScreenPunto> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            const Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreenPunto(),
            ),
          ],
        ),
      ),
    );
  }
}
