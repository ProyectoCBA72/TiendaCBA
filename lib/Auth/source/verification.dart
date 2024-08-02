// ENVIO DEL EMAIL FUTURE...
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';
import '../../source.dart';
import 'package:device_info_plus/device_info_plus.dart';

class VerificationService {
  // Uso de una funcion en django para el envio de los correos.
  Future djangoSendEmail(String toEmail, String confirmationCode) async {
    String url = "";

    url = "$sourceApi/api/send-email/";
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'subject': 'Código de confirmación',
      'message': 'Tu código de confirmación es: $confirmationCode',
      'recipient_list': toEmail,
    });
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Correo electrónico enviado exitosamente');
    } else {
      print('Error al enviar correo electrónico: ${response.body}');
    }
  }

  Future sendEmailLogin(String toEmail) async {
    final deviceInfo = await getDeviceInfo();

    String url = "";

    url = "$sourceApi/api/send-email/";
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'subject': 'Inicio de sesión',
      'message': '''
      Hemos detectado un inicio de sesión en su cuenta de la tienda, con los siguientes datos:
      - Dispositivo: ${deviceInfo['model']}
      - Sistema Operativo: ${deviceInfo['version']}
      - IP: ${deviceInfo['ip']}
      Si no fue usted, comuníquese con nosotros al 3177636631
    ''',
      'recipient_list': toEmail,
    });
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Correo electrónico enviado exitosamente');
    } else {
      print('Error al enviar correo electrónico: ${response.body}');
    }
  }

  Future<Map<String, String>> getDeviceInfo() async {
    Map<String, String> deviceData = {};

    final ip = await getPublicIpAddress();

    if (kIsWeb) {
      deviceData['model'] = 'Navegador Web';
      deviceData['ip'] = ip;
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfoPlugin.androidInfo;
          deviceData['model'] = androidInfo.model;
          deviceData['version'] = androidInfo.version.release;
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfoPlugin.iosInfo;
          deviceData['model'] = iosInfo.utsname.machine;
          deviceData['version'] = iosInfo.systemVersion;
        }
      }
    }

    return deviceData;
  }

  Future<String> getPublicIpAddress() async {
    final response = await http.get(Uri.parse('https://api.ipify.org'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get public IP address');
    }
  }
}
