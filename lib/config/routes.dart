import 'package:flutter/material.dart';
import 'package:installatori_de/pages/condomini/condomini_page.dart';
import 'package:installatori_de/pages/login/login_page.dart';

class Routes{

  final RouteSettings settings;

  Routes(this.settings);

  dynamic getRoute(){

    return {
      LoginPage.route: (_) => const LoginPage(),
      CondominiPage.route: (_) => const CondominiPage(),
    };

  }

}