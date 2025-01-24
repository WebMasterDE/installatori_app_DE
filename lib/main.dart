import 'package:flutter/material.dart';
import 'package:installatori_de/config/routes.dart';
import 'package:installatori_de/theme/theme.dart';

void main() {
  runApp(const AppInstallatori());
}

class AppInstallatori extends StatelessWidget {
  const AppInstallatori({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Installatori DE',
      theme: CustomTheme.getTheme(),
      debugShowCheckedModeBanner : false,
      initialRoute: '/',
      onGenerateRoute: (setting) {
        return MaterialPageRoute(
          builder: Routes(setting).getRoute()[setting.name],
        );
      }
    );
  }
}
