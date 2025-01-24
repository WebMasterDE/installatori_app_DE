import 'package:flutter/material.dart';
import 'package:installatori_de/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  static const route = '/';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _wrongCred = false;
  
  final email = TextEditingController();
  final password = TextEditingController();

  Future<bool> login() {
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
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Flexible(
                    child: Text('Benvenuto in DE Installation',
                        style: Theme.of(context).textTheme.titleMedium)),
                SizedBox(height: 30),
                Flexible(
                    child: Image.asset(
                  'assets/images/des_logo.png',
                  width: 50,
                  height: 50,
                )),
                SizedBox(height: 30),
                if(_wrongCred)
                  Flexible(
                    child: Text(
                      "Credenziali errate",
                      style: Theme.of(context).textTheme.displaySmall,

                    )
                  ),
                SizedBox(height: 10),
                Flexible(
                  child: TextField(
                    controller: email,
                    obscureText: false,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                      labelText: 'email',
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                ),
                SizedBox(height: 10),
                Flexible(
                    child: TextField(
                      controller: password,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState((){_obscureText = !_obscureText;});
                          },
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off)
                        )
                      ),
                  style: Theme.of(context).textTheme.labelSmall,
                )),
                SizedBox(height: 10),
                Center(
                  child: TextButton(
                      onPressed: () async {
                        if(await login()) {
                          Navigator.pushNamedAndRemoveUntil(
                            context, '/condomini', (route) => false);
                        }else{
                          setState(() {
                            _wrongCred = true;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.orangeAccent),
                      child: Text('Accedi',
                          style: Theme.of(context).textTheme.labelSmall)),
                ),
                SizedBox(height: 10),
                Flexible(
                  child: Text(
                    'Prodotto da Divisione Energia Servizi Srl',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Flexible(
                      child: Image.asset(
                    'assets/images/G_de_logo.png',
                    width: 50,
                    height: 50,
                  )),
                )
              ])),
        ),
      )),
      backgroundColor: Colors.orangeAccent,
      resizeToAvoidBottomInset: false,
    );
  }
}
