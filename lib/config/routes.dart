import 'package:flutter/material.dart';
import 'package:installatori_de/pages/appartamenti/appartamenti_page.dart';
import 'package:installatori_de/pages/appartamenti/new_appartamento_page.dart';
import 'package:installatori_de/pages/appartamenti/new_strumento_page.dart';
import 'package:installatori_de/pages/condomini/condomini_page.dart';
import 'package:installatori_de/pages/login/login_page.dart';


class Routes{

  RouteSettings settings;

  Routes(this.settings);

  dynamic getRoute(){

    return {
      LoginPage.route: (_) => const LoginPage(),
      CondominiPage.route: (_) => const CondominiPage(),
      AppartamentiPage.route: (_) => AppartamentiPage(
        arguments: settings.arguments as AppartamentiPageArgs,
      ),
      NewAppartamentoPage.route: (_) => NewAppartamentoPage(
        arguments: settings.arguments as NewAppartamentoPageArgs,
      ),
      NewStrumentoPage.route: (_) => NewStrumentoPage(
        arguments: settings.arguments as NewStrumentoPageArgs,
      )
    };

  }

}