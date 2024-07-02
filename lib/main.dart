// ignore_for_file: must_be_immutable

import 'package:tienda_app/Splash/page/SplashScreen.dart';
import 'constantsDesign.dart';
import 'package:flutter/material.dart';
import 'provider.dart';

void main() async {
  runApp(const AppProvider(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
