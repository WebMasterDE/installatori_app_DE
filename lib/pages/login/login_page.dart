import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const route = '/';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

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
      body: Center(
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
                Flexible(
                    child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'email',
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                  ),
                  style: Theme.of(context).textTheme.labelSmall,
                )),
                SizedBox(height: 10),
                Flexible(
                    child: TextField(
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
                              : Icons.visibility_off))),
                  style: Theme.of(context).textTheme.labelSmall,
                )),
                SizedBox(height: 10),
                Center(
                  child: TextButton(
                      onPressed: () {
                        print("entrato");
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/condomini', (route) => false);
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
