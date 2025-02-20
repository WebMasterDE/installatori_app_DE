import 'package:flutter/material.dart';
import 'package:installatori_de/config/routes.dart';
import 'package:installatori_de/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:installatori_de/providers/save_data_provider.dart';


void main() {
  runApp(const AppInstallatori());
}

class AppInstallatori extends StatelessWidget {
  const AppInstallatori({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SaveDataProvider()),
      ],
      child: MaterialApp(
        title: 'Installatori DE',
        theme: CustomTheme.getTheme(),
        debugShowCheckedModeBanner : false,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: Routes(settings).getRoute()[settings.name],
          );
        }
      )
    );
  }
}
