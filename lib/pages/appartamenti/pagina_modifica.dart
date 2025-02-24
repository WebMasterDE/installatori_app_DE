import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/components/custom_textField.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/pages/appartamenti/new_appartamento_page.dart';
import 'package:installatori_de/pages/appartamenti/recap_ripartitori.dart';
import 'package:installatori_de/providers/condomini_provider.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ModificaAppartamentoPage extends StatefulWidget {
  static const route = '/modifica_appartamento';

  final ModificaAppartamentoPageArgs arguments;

  const ModificaAppartamentoPage({super.key, required this.arguments});

  @override
  State<ModificaAppartamentoPage> createState() =>
      _ModificaAppartamentoPageState();
}

class _ModificaAppartamentoPageState extends State<ModificaAppartamentoPage> {
  int _idAnaCondominio = 0;
  int _idAppartamento = 0;
  late Future<AppartamentoModel> _appartamento;
  late Future<List<dynamic>> _strumentiCondominio;


  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
    _idAppartamento = widget.arguments.data['idAppartamento']; 

    _appartamento = getAppartamento();
    _strumentiCondominio =CondominiProvider().getStrumentiCondomini(_idAnaCondominio, context);
  }

  Future<AppartamentoModel> getAppartamento() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? ap = sp.getString('appartamento_temp_$_idAppartamento');
    if (ap != null) {
      print('paginamodifica${AppartamentoModel.fromJson(jsonDecode(ap))}');
      return Future.value(AppartamentoModel.fromJson(jsonDecode(ap)));
    }
    return Future.value(AppartamentoModel(
      id: 0,
      interno: '',
      piano: 0,
      scala: '',
      nome: '',
      cognome: '',
      mail: '',
      numeroRipartitoriRiscaldamento: 0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Modifica Appartamento",
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
            FutureBuilder<AppartamentoModel>(
              future: _appartamento,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Errore nel caricamento dei dati'));
                } else if (snapshot.hasData) {
                  final appartamento = snapshot.data!;
                  return Column(
                    children: [
                      Text(
                        "Appartamento int. ${appartamento.interno}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Text("Nome Inquilino",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text(appartamento.nome ?? '',
                                  style: Theme.of(context).textTheme.labelSmall)
                            ],
                          )),
                          SizedBox(width: 20),
                          Expanded(
                              child: Column(
                            children: [
                              Text("Cognome Inquilino",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text(appartamento.cognome ?? '',
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                            ],
                          )),
                        ],
                      ),
                      SizedBox(height: 30),
                      CustomButton(text: 'Modifica Dati Appartamento', onPressed: () {
                        Navigator.pushNamed(context, '/newAppartamento',
                            arguments: NewAppartamentoPageArgs(data: {
                              'id': _idAnaCondominio,
                              'idAppartamento': _idAppartamento,
                              'modifica': true,
                            }));
                      }),
                                            SizedBox(height: 40),

                    ],
                  );
                } else {
                  return Center(child: Text('Nessun dato disponibile'));
                }
              },
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait([_appartamento, _strumentiCondominio]),
                builder: (context, snapshot) {
                  List<Widget> listViewChildren = [];

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    for (var i = 0; i < 4; i++) {
                      listViewChildren.add(Skeletonizer(
                          child: Card(
                        child: ListTile(
                          leading: Icon(HeroiconsSolid.fire,
                              color: CustomColors.iconColor),
                          title: Text('Ripartitori Riscaldamento'),
                        ),
                      )));
                    }
                  } else if (snapshot.hasData) {
                    final strumenti = snapshot.data![1] as List<dynamic>;

                    listViewChildren.addAll(strumenti.map((strumento) {
                      String nomeServizio = strumento['nome_servizio'];

                      IconData iconData;
                      if (nomeServizio == "Ripartitori Riscaldamento") {
                        iconData = HeroiconsSolid.fire;
                      } else {
                        iconData = HeroiconsSolid.wrenchScrewdriver;
                      }

                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading:
                              Icon(iconData, color: CustomColors.iconColor),
                          title: Text(nomeServizio),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                           final sh = await SharedPreferences.getInstance();
                           //viene utilizzato per gestire la richiesta di modifica nella pagina di recap
                           sh.setBool('richiesta_modifica', true);

                            Navigator.pushNamed(context, '/recap_ripartitori',
                                arguments: RecapRipartitoriPageArgs(data: {
                                  'id': _idAnaCondominio,
                                  'idAppartamento': _idAppartamento,
                                  'selectedStrumento': nomeServizio,
                                  'richiestaModifica': true,
                                }));
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
                  onPressed: () async {
                    final sh = await SharedPreferences.getInstance();
                    sh.setInt('id_appartamento_from', _idAppartamento);
                    Navigator.pop(context);
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
}

class ModificaAppartamentoPageArgs {
  final dynamic data;

  ModificaAppartamentoPageArgs({required this.data});
}
