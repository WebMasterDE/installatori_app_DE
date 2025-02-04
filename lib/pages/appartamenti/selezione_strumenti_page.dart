import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/models/condominio_model.dart';
import 'package:installatori_de/providers/condomini_provider.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:installatori_de/components/stepper.dart';

class SelezioneStrumentiPage extends StatefulWidget {
  static const route = '/selezione_strumenti';

  final SelezioneStrumentiPageArgs arguments;

  const SelezioneStrumentiPage({super.key, required this.arguments});

  @override
  State<SelezioneStrumentiPage> createState() => _SelezioneStrumentiPageState();
}

class _SelezioneStrumentiPageState extends State<SelezioneStrumentiPage> {
  late Future<List<dynamic>> _strumentiCondominio;

  int _idAnaCondominio = 0;
  String _internoAppartamento = "";
  int _selectedIndex = -1;
  String _selectedStrumento = "";

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
    _internoAppartamento = widget.arguments.data['interno'];

    _strumentiCondominio =
        CondominiProvider().getStrumentiCondomini(_idAnaCondominio, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Nuovo Appartamento",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: CustomColors.secondaryBackground,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomHorizontalStepper(
              steps: const ["1", "2", "3", "4", "5"],
              currentStep: 1,
            ),
            SizedBox(height: 40),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _strumentiCondominio,
                builder: (context, snapshot) {
                  List<Widget> listViewChildren = [];

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    for (var i = 0; i < 3; i++) {
                      listViewChildren.add(Skeletonizer(
                          child: Card(
                        child: ListTile(
                          leading: Icon(HeroiconsSolid.fire,
                              color: CustomColors.iconColor),
                          title: Text('Ripartitore Riscaldamento'),
                        ),
                      )));
                    }
                  } else if (snapshot.hasData) {
                    listViewChildren.addAll(snapshot.data!.map((strumento) {
                      int index = snapshot.data!.indexOf(strumento);

                      return Card(
                        color: _selectedIndex == index
                            ? const Color.fromARGB(255, 253, 192, 99)
                            : Colors.white,
                        child: ListTile(
                          leading: strumento['nome_servizio'] ==
                                  "Ripartitori Riscaldamento"
                              ? Icon(HeroiconsSolid.fire,
                                  color: CustomColors.iconColor)
                              : Icon(HeroiconsSolid.wrenchScrewdriver,
                                  color: CustomColors.iconColor),
                          title: Text('${strumento['nome_servizio']}'),
                          onTap: () {
                            setState(() {                        
                              _selectedIndex = index;
                              _selectedStrumento = strumento['nome_servizio'];
                            });
                          },
                        ),
                      );
                    }).toList());
                  } else {
                    listViewChildren
                        .add(Center(child: Text('Nessun dato disponibile')));
                  }

                  return ListView(
                    children: listViewChildren,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 20),
        height: 50,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Indietro',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'Avanti',
                  onPressed: () {
                    _stepSucc();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: CustomColors.secondaryBackground,
    );
  }

  void _stepSucc() async {
    if (_selectedIndex != -1) {
      final sharedPref = await SharedPreferences.getInstance();
      var condominiList = sharedPref.getString('condomini');

      if (condominiList != null) {
        List<Map<String, dynamic>> cmListString =
            List.from(jsonDecode(condominiList));
        List<CondominioModel> cmList =
            cmListString.map((c) => CondominioModel.fromJson(c)).toList();

        for (var condominio in cmList) {
          if (condominio.idAnaCondominio == _idAnaCondominio) {
            for (var appartamento in condominio.appartamenti!) {
              if (appartamento.interno == _internoAppartamento) {
                switch (_selectedStrumento) {
                  case "Contatore Caldo/Freddo" || "Contatore Freddo" :
                    appartamento.raffrescamento[_selectedStrumento] =
                        StatoRipartitori(completato: false, ripartitori: []);
                    break;
                  case "riscaldamento" || "Contatore Caldo":
                    appartamento.riscaldamento[_selectedStrumento] =
                        StatoRipartitori(completato: false, ripartitori: []);
                    break;
                  case "Contatore Acqua Calda":
                    appartamento.acquaCalda[_selectedStrumento] =
                        StatoRipartitori(completato: false, ripartitori: []);
                    break;
                  case "Contatore Acqua Fredda":
                    appartamento.acquaFredda[_selectedStrumento] =
                        StatoRipartitori(completato: false, ripartitori: []);
                    break;
                }
                break;
              }
            }
          }
        }

        print(cmList.map((c) => c.toJson()).toList());

        sharedPref.setString(
            'condomini', jsonEncode(cmList.map((c) => c.toJson()).toList()));

        Navigator.pushNamed(context, "/selezione_strumenti",
            arguments: SelezioneStrumentiPageArgs(data: {
              'id': _idAnaCondominio,
              'interno': _internoAppartamento,
            }));
      }
    }
  }
}

class SelezioneStrumentiPageArgs {
  final dynamic data;

  SelezioneStrumentiPageArgs({required this.data});
}
