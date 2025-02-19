import 'package:flutter/material.dart';
import 'package:installatori_de/pages/appartamenti/appartamenti_page.dart';
import 'package:installatori_de/pages/appartamenti/new_appartamento_page.dart';
import 'package:installatori_de/pages/appartamenti/new_strumento_page.dart';
import 'package:installatori_de/pages/appartamenti/nota_appartameto.dart';
import 'package:installatori_de/pages/appartamenti/nota_ripartitori.dart';
import 'package:installatori_de/pages/appartamenti/pagina_modifica.dart';
import 'package:installatori_de/pages/appartamenti/recap_ripartitori.dart';
import 'package:installatori_de/pages/condomini/condomini_page.dart';
import 'package:installatori_de/pages/login/login_page.dart';
import 'package:installatori_de/pages/appartamenti/selezione_strumenti_page.dart';

class Routes {
  RouteSettings settings;

  Routes(this.settings);

  dynamic getRoute() {
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
          ),
      SelezioneStrumentiPage.route: (_) => SelezioneStrumentiPage(
            arguments: settings.arguments as SelezioneStrumentiPageArgs,
          ),
      NotaRipartitoriPage.route: (_) => NotaRipartitoriPage(
          arguments: settings.arguments as NotaRipartitoriPageArgs
          ),
      RecapRipartitori.route: (_) => RecapRipartitori(
          arguments: settings.arguments as RecapRipartitoriPageArgs
          ),
      NotaAppartamentoPage.route: (_) => NotaAppartamentoPage(
          arguments: settings.arguments as NotaAppartamentoPageArgs
          ),
      ModificaAppartamentoPage.route: (_) => ModificaAppartamentoPage(
          arguments: settings.arguments as ModificaAppartamentoPageArgs
          ),
    };
  }
}
