import 'package:flutter/material.dart';

class AppartamentiPage extends StatelessWidget {
  const AppartamentiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Condominio',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('Appartamenti Page'),
      ),
    );
  }
}