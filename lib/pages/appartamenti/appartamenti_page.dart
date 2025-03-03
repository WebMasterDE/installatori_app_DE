import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/models/condominio_model.dart';
import 'package:installatori_de/pages/appartamenti/pagina_modifica.dart';
import 'package:installatori_de/providers/appartamenti_provider.dart';
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
  late Future<List<AppartamentoModel>> appartamenti;

  int _idAnaCondominio = 0;
  String _nomeCondominio = '';

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];

    if (widget.arguments.data['nome'] != null) {
      _nomeCondominio = widget.arguments.data['nome'];
    } else {
      getNomeCondominio(_idAnaCondominio);
    }

    appartamenti = AppartamentiProvider().getAppartamenti(_idAnaCondominio, context);
  }

  void getNomeCondominio(int idAnaCondominio) async {
    var sp = await SharedPreferences.getInstance();
    String? condominiListString = sp.getString('condomini');

    print("testtt $condominiListString");

    if(condominiListString != null){
      List<CondominioModel> condominiList = List.from(jsonDecode(condominiListString)).map((condominio) {
          return CondominioModel.fromJson(condominio);
      }).toList();

      for(var condominio in condominiList){
        if(condominio.idAnaCondominio == _idAnaCondominio){
          setState((){
            _nomeCondominio = condominio.nome;
          });
          
        }
      }
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
          child: FutureBuilder<List<AppartamentoModel>>(
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
                      title: Text(
                          'Appartamento - interno: ${appartamento.interno}'),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Text(
                            'Piano: ${appartamento.piano} - Scala: ${appartamento.scala}'
                          ),
                          !appartamento.savedOnDb ? 
                              Icon(
                                HeroiconsOutline.cloud,
                                size: 15,
                              ) : 
                              Icon(
                                HeroiconsSolid.cloud,
                                size: 15
                              )
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        var sp = await SharedPreferences.getInstance();
                        sp.setString('appartamento_temp_${appartamento.id}',jsonEncode(appartamento.toJson()));
                        Navigator.pushNamed(context, '/modifica_appartamento',
                            arguments: ModificaAppartamentoPageArgs(data: {
                              'id': _idAnaCondominio,
                              'idAppartamento': appartamento.id
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
                text: 'Fine',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/condomini', (route) => false);
                },
              ),
            )));
  }
}

class AppartamentiPageArgs {
  final dynamic data;

  AppartamentiPageArgs({required this.data});
}
