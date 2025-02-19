import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/models/condominio_model.dart';
import 'package:installatori_de/pages/appartamenti/pagina_modifica.dart';
import 'package:installatori_de/providers/appartamenti_provider.dart';
import 'package:installatori_de/providers/condomini_provider.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:installatori_de/pages/appartamenti/new_appartamento_page.dart';

class AppartamentiPage extends StatefulWidget {
  static const route = '/appartamenti';

  final AppartamentiPageArgs arguments;

  const AppartamentiPage({super.key, required this.arguments});

  @override
  State<AppartamentiPage> createState() => _AppartamentiPageState();
}

class _AppartamentiPageState extends State<AppartamentiPage> {
  late Future<List<dynamic>> appartamenti;

  List<dynamic> appartamentiSp = [];

  int _idAnaCondominio = 0;
  String _nomeCondominio = '';

  AppartamentoModel? _appartamento_;

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
    _nomeCondominio = widget.arguments.data['nome'];

    appartamenti = AppartamentiProvider().getAppartamenti(_idAnaCondominio);
  }

  void getAppartamento() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int id = 0;
    while (!sp.containsKey('appartamento_temp_$id')) {
      String? ap = sp.getString('appartamento_temp_$id');
      if (ap != null) {
        _appartamento_ = AppartamentoModel.fromJson(jsonDecode(ap));
        appartamentiSp.add(_appartamento_);
      }
      id++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            _nomeCondominio,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
          backgroundColor: CustomColors.secondaryBackground,
          scrolledUnderElevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<dynamic>>(
            future: appartamenti,
            builder: (context, snapshot) {
              List<Widget> listViewChildren = [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(HeroiconsSolid.plus,
                          color: CustomColors.iconColor),
                      title: Text('Nuovo appartamento'),
                      subtitle: Text('Aggiungi un nuovo appartamento'),
                      onTap: () {
                        Navigator.pushNamed(context, '/newAppartamento',
                            arguments: NewAppartamentoPageArgs(
                                data: {'id': _idAnaCondominio}));
                      },
                    ),
                  ),
                ),
              ];

              if (snapshot.connectionState == ConnectionState.waiting) {
                for (var i = 0; i < 2; i++) {
                  listViewChildren.add(Skeletonizer(
                      child: Card(
                    child: ListTile(
                      leading: Icon(HeroiconsSolid.home,
                          color: CustomColors.iconColor),
                      title: Text('Appartamento'),
                      subtitle: Text('Piano: - Interno:  - Scala: '),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  )));
                }
              } else {
                listViewChildren.addAll(snapshot.data!.map((appartamento) {
                  return Card(
                    child: ListTile(
                      leading: Icon(HeroiconsSolid.home,
                          color: CustomColors.iconColor),
                      title:
                          Text('Appartamento - interno: ${appartamento['id']}'),
                      subtitle: Text(
                          'Piano: ${appartamento['piano']} - Scala: ${appartamento['scala']}'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pushNamed(context, '/modifica_appartamento',
                            arguments: ModificaAppartamentoPageArgs(data: {
                              'id': _idAnaCondominio,
                              'idAppartamento': appartamento['id']
                            }));
                      },
                    ),
                  );
                }));
              }

              return ListView(
                children: listViewChildren,
              );
            },
          ),
        ),
        backgroundColor: CustomColors.secondaryBackground,
        bottomNavigationBar: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 20),
            height: 50,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                text: 'Salva ed esci',
                onPressed: () {
                  save(context, _idAnaCondominio); // Navigator.pop(context);
                },
              ),
            )));
  }
}

void save(BuildContext context, int _idAnaCondominio) async {
  final sharedPref = await SharedPreferences.getInstance();
  String? condominiString = sharedPref.getString('condomini');

  if (condominiString != null) {
    List<dynamic> jsonData = jsonDecode(condominiString);

    if (jsonData.isNotEmpty && jsonData.first is Map<String, dynamic>) {
      jsonData.forEach((element) {
        if (element is Map<String, dynamic>) {
          if (element['idAnaCondominio'] == _idAnaCondominio) {
            CondominioModel cdm = CondominioModel.fromJson(element);
            CondominiProvider().saveCondominio(context, cdm);
          }
        }
      });
    } else {
      print("Errore: Il JSON è vuoto o non è nel formato corretto!");
    }
  } else {
    print("Nessun condominio salvato nelle SharedPreferences");
  }
}

class AppartamentiPageArgs {
  final dynamic data;

  AppartamentiPageArgs({required this.data});
}
