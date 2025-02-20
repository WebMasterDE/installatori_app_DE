import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/models/ripartitori_model.dart';
import 'package:installatori_de/pages/appartamenti/new_strumento_page.dart';
import 'package:installatori_de/pages/appartamenti/nota_appartameto.dart';
import 'package:installatori_de/pages/appartamenti/pagina_modifica.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:installatori_de/components/stepper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecapRipartitori extends StatefulWidget {
  static const route = '/recap_ripartitori';

  final RecapRipartitoriPageArgs arguments;

  const RecapRipartitori({super.key, required this.arguments});

  @override
  State<RecapRipartitori> createState() => _RecapRipartitoriState();
}

class _RecapRipartitoriState extends State<RecapRipartitori> {
  int _idAnaCondominio = 0;
  int _idAppartamento = 0;
  late Future<List<RipartitoriModel>> _ripartitori;
  AppartamentoModel? _appartamento;
  String _selectedStrumento = "";
  bool _richiestaModifica = false;

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
    _idAppartamento = widget.arguments.data['idAppartamento'];
    _selectedStrumento = widget.arguments.data['selectedStrumento'];
    _richiestaModifica = widget.arguments.data['richiestaModifica'] ?? false;
    _ripartitori = getRipartitori();
  }

  Future<List<RipartitoriModel>> getRipartitori() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? ap = sp.getString('appartamento_temp_$_idAppartamento');

    if (ap != null) {
      _appartamento = AppartamentoModel.fromJson(jsonDecode(ap));
      if (_selectedStrumento == "Ripartitori Riscaldamento" ||
          _selectedStrumento == "Contatore Caldo/Freddo" ||
          _selectedStrumento == "Contatore Caldo") {
        return _appartamento!.riscaldamento!.ripartitori!;
      }else if (_selectedStrumento == "Contatore Freddo") {
        return _appartamento!.raffrescamento!.ripartitori!;
      } else if (_selectedStrumento == "Contatore Acqua Calda") {
        return _appartamento!.acquaCalda!.ripartitori!;
      } else if (_selectedStrumento == "Contatore Acqua Fredda") {
        return _appartamento!.acquaFredda!.ripartitori!;
      }
    }
    return [];
  }

  void getAppartamento() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? ap = sp.getString('appartamento_temp_$_idAppartamento');

    if (ap != null) {
      _appartamento = AppartamentoModel.fromJson(jsonDecode(ap));
    }
        if (sp.containsKey('richiesta_modifica')) {
          setState(() {
                  _richiestaModifica = sp.getBool('richiesta_modifica')!;
          });
        }
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
            if (!_richiestaModifica)
              CustomHorizontalStepper(
                steps: const ["1", "2", "3", "4"],
                currentStep: 4,
              ),
            Text("Ripartitori Aggiunti",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 60),
            Flexible(
              child: FutureBuilder<List<RipartitoriModel>>(
                future: _ripartitori,
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
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Errore nel caricamento dei dati'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Nessun dato disponibile'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final ripartitore = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            leading: Icon(
                              HeroiconsSolid.wrenchScrewdriver,
                              color: CustomColors.iconColor,
                            ),
                            title: Text(
                                "Matricola: ${ripartitore.matricola} - ${ripartitore.vano}"),
                            subtitle: Text(
                                "Vano: ${ripartitore.vano} Descrizione: ${ripartitore.descrizione}"),
                            trailing: Icon(HeroiconsSolid.pencilSquare,
                                color: CustomColors.iconColor),
                            onTap: () {
                              Navigator.pushNamed(context, "/newStrumento",
                                  arguments: NewStrumentoPageArgs(data: {
                                    'id': _idAnaCondominio,
                                    'idAppartamento': _idAppartamento,
                                    'selectedStrumento': _selectedStrumento,
                                    'modifica': true,
                                    'matricola_modifica': ripartitore.matricola,
                                  }));
                            },
                          ),
                        );
                      },
                    );
                  }
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
              // Expanded(
              //   child: CustomButton(
              //     text: 'Indietro',
              //     onPressed: () async {
              //       final sh = await SharedPreferences.getInstance();
              //       sh.setInt('id_appartamento_from', _idAppartamento);
              //       Navigator.pop(context);
              //     },
              //   ),
              // ),
              // SizedBox(width: 10),
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
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey('richiesta_modifica')) {
      bool richiestaModifica = sp.getBool('richiesta_modifica')!;
      print(richiestaModifica);
      if (richiestaModifica) {
        sp.remove('richiesta_modifica');
        Navigator.pushNamed(context, "/modifica_appartamento",
            arguments: ModificaAppartamentoPageArgs(data: {
              'id': _idAnaCondominio,
              'idAppartamento': _idAppartamento,
            }));
        return;
      }
    }

    if (_selectedStrumento == "Ripartitori Riscaldamento") {
      if (_appartamento!.riscaldamento!.ripartitori!.length <
          _appartamento!.numeroRipartitoriRiscaldamento!) {
        Navigator.pushNamed(context, "/newStrumento",
            arguments: NewStrumentoPageArgs(data: {
              'id': _idAnaCondominio,
              'idAppartamento': _idAppartamento,
              'selectedStrumento': _selectedStrumento,
            }));
      } else {
        _appartamento!.riscaldamento!.completato = true;
        sp.setString('appartamento_temp_$_idAppartamento',
            jsonEncode(_appartamento!.toJson()));

        print(jsonDecode(sp.getString('appartamento_temp_$_idAppartamento')!));
        Navigator.pushNamed(context, "/nota_appartamento",
            arguments: NotaAppartamentoPageArgs(data: {
              'id': _idAnaCondominio,
              'idAppartamento': _idAppartamento,
              'selectedStrumento': _selectedStrumento,
            }));
      }
    } else if (_selectedStrumento == "Contatore Freddo" ||
        _selectedStrumento == "Contatore Caldo/Freddo" ||
        _selectedStrumento == "Contatore Caldo" ||
        _selectedStrumento == "Contatore Acqua Calda" ||
        _selectedStrumento == "Contatore Acqua Fredda") {
      Navigator.pushNamed(context, "/nota_appartamento",
          arguments: NotaAppartamentoPageArgs(data: {
            'id': _idAnaCondominio,
            'idAppartamento': _idAppartamento,
          }));
    }
  }
}

class RecapRipartitoriPageArgs {
  final dynamic data;

  RecapRipartitoriPageArgs({required this.data});
}
