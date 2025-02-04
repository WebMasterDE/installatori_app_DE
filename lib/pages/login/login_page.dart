import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/providers/auth_provider.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:permission_handler/permission_handler.dart';


class LoginPage extends StatefulWidget {
  static const route = '/';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _wrongCred = false;
  bool _isCameraAllowed = false;
  String _errorText = '';

  final email = TextEditingController();
  final password = TextEditingController();

  Future<bool> login() async {
    final status = await Permission.camera.request();

    if(status.isDenied){
      return false;
    }

    if(status.isPermanentlyDenied){
      openAppSettings();
      return false;
    }

    if(status.isGranted){
      _isCameraAllowed = true;
    }


    final AuthProvider authProvider = AuthProvider();
    return authProvider.login(email.text, password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.build),
              SizedBox(width: 8),
              Text(
                'DE Installation',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        backgroundColor: CustomColors.primaryBackground
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: keyboardHeight, top: 20),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Benvenuto in DE Installation',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 30),
                        Image.asset(
                          'assets/images/des_logo.png',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(height: 30),
                        if (_wrongCred)
                          Text(
                            _errorText,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        SizedBox(height: 10),
                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                          ),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: password,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: CustomButton(
                            onPressed: () async {
                              if (await login()) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/condomini', (route) => false);
                              }else{

                                if(_isCameraAllowed){
                                  setState(() {
                                    _wrongCred = true;
                                    _errorText = 'Credenziali errate';
                                  });
                                }else{
                                  setState(() {
                                    _wrongCred = true;
                                    _errorText = 'È necessario dare l\'accesso alla camera';
                                  });
                                }
                              }
                            },
                            text: 'Accedi',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Prodotto da Divisione Energia Servizi Srl',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/G_de_logo.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: CustomColors.primaryBackground,
      resizeToAvoidBottomInset: true,
    );
  }
}
