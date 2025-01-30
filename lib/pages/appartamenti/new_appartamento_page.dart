import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_textField.dart';
import 'package:installatori_de/theme/colors.dart';

class NewAppartamentoPage extends StatelessWidget {

  static const route = '/newAppartamento';

  const NewAppartamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Nuovo Appartamento',
          style: Theme.of(context).textTheme.titleLarge, 
          ),
        centerTitle: true,
        backgroundColor: CustomColors.secondaryBackground,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Dati appartamento',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextfield(
                      text: 'Iterno',
                    )
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: CustomTextfield(
                      text: 'Scala',
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      backgroundColor: CustomColors.secondaryBackground,
    );
  }
}