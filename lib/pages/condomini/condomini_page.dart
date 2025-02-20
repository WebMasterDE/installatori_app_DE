import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:installatori_de/components/stepper.dart';
import 'package:installatori_de/models/condominio_model.dart';
import 'package:installatori_de/pages/appartamenti/appartamenti_page.dart';
import 'package:installatori_de/providers/condomini_provider.dart';
import 'package:installatori_de/providers/save_data_provider.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:installatori_de/providers/auth_provider.dart';
import 'package:installatori_de/pages/appartamenti/selezione_strumenti_page.dart';

class CondominiPage extends StatefulWidget {
  static const route = '/condomini';

  const CondominiPage({super.key});

  @override
  State<CondominiPage> createState() => _CondominiPageState();
}

class _CondominiPageState extends State<CondominiPage> {
  late Future<List<dynamic>> _condominiList;

  @override
  void initState() {
    super.initState();
    _fetchCondomini(context);
  }

  Future<void> _fetchCondomini(BuildContext context) async {
    final CondominiProvider condominiProvider = CondominiProvider();
    _condominiList = condominiProvider.getTicketCondomini(context);
  }

  Future<bool> logout() {
    final AuthProvider authProvider = AuthProvider();
    return authProvider.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.iconColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text("Sei sicuro di voler uscire?",
                              style: Theme.of(context).textTheme.titleMedium),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(154, 247, 155, 1)),
                              child: Text('Annulla',
                                  style: Theme.of(context).textTheme.labelSmall),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (await logout()) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (route) => false);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Errore durante il logout')));
                                }
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 0, 0)),
                              child: Text('Esci',
                                  style: Theme.of(context).textTheme.labelSmall),
                            ),
                          ],
                          backgroundColor: CustomColors.iconColor,
                        )),
                icon: Icon(
                  Icons.logout,
                ),
              ),
            ),
          )
        ],
        backgroundColor: CustomColors.secondaryBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Condomini',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
                        SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
                child: FutureBuilder(
                    future: _condominiList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Skeletonizer(
                            child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      leading: Icon(
                                        HeroiconsSolid.buildingOffice2,
                                        color: CustomColors.iconColor,
                                      ),
                                      title: Text(''),
                                      subtitle: Text(''),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                    ),
                                  );
                                }));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final condominio = snapshot.data![index];
                            return Card(
                              child: ListTile(
                                leading: Icon(
                                  HeroiconsSolid.buildingOffice2,
                                  color: CustomColors.iconColor,
                                ),
                                title:
                                    Text("Condominio: ${condominio['nome']}"),
                                subtitle: Text(
                                    "${condominio['indirizzo']} ${condominio['citta']} ${condominio['cap']}"),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  Navigator.pushNamed(context, '/appartamenti',
                                      arguments: AppartamentiPageArgs(data: {
                                        'id': condominio['id_ana_condominio'],
                                        'nome': condominio['nome']
                                      })
                                  );

                                  //saveDataDev();

                                  /*Navigator.pushNamed(context, '/selezione_strumenti',
                                      arguments: SelezioneStrumentiPageArgs(data: {
                                        'id': condominio['id_ana_condominio'],
                                        'idAppartamento': 0
                                      })
                                  );*/
                                },
                              ),
                            );
                          }
                        );
                      }
                    }
                  )
            ) 
          ],
        ),
      ),
      backgroundColor: CustomColors.secondaryBackground,
    );
  }

  void saveDataDev() async {

    var sh = await SharedPreferences.getInstance();
    String? data = sh.getString('condomini');

    print(data);

    //String data = '[{"idAnaCondominio":508,"appartamenti":[{"id":0,"interno":"1","piano":1,"scala":"1","pathUploadImage":"/data/user/0/com.example.installatori_de/app_flutter/appartamento_508_1740043382326.jpg","nome":"inquilino1 ","cognome":"cinquilino1 ","mail":"inquilino1@gmail.com","note":null,"numeroRipartitoriRiscaldamento":1,"raffrescamento":null,"riscaldamento":null,"acquaCalda":null,"acquaFredda":null}]}]';
    List<CondominioModel> condominiList = List.from(jsonDecode(data!)).map((condominio) {
          return CondominioModel.fromJson(condominio);
    }).toList();

    

    for(CondominioModel cdm in condominiList){
      SaveDataProvider().saveCondominio(cdm);
    }

  }
}