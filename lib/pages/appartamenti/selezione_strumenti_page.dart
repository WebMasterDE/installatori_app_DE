import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/components/custom_textField.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/models/condominio_model.dart';
import 'package:installatori_de/pages/appartamenti/appartamenti_page.dart';
import 'package:installatori_de/providers/condomini_provider.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:installatori_de/components/stepper.dart';
import 'package:installatori_de/pages/appartamenti/new_strumento_page.dart';
import 'package:provider/provider.dart';
import 'package:installatori_de/providers/save_data_provider.dart';

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
  int _idAppartamento = 0;
  AppartamentoModel? _appartamento;
  int _selectedIndex = -1;
  CondominioStrumenti? _selectedStrumento;

  final TextEditingController _numeroRipartitoriController =
      TextEditingController();

  bool _exit = false;
  bool _partial = false;

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
    _idAppartamento = widget.arguments.data['idAppartamento'];

    _strumentiCondominio = getStrumentiCondominio(_idAnaCondominio);

    getAppartamento();

  }

  Future<List<CondominioStrumenti>> getStrumentiCondominio(int idAnaCondominio) async {

      var sh = await SharedPreferences.getInstance();
      String? listCondominiString = sh.getString('condomini');

      if(listCondominiString != null){
        List<CondominioModel> condominiList = List.from(jsonDecode(listCondominiString)).map((condominio) {
            return CondominioModel.fromJson(condominio);
        }).toList();

        for(var condominio in condominiList){
          if(condominio.idAnaCondominio == idAnaCondominio){
            return condominio.strumenti;
          }
        }
      }

      return List.empty();
  }

  void getAppartamento() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? ap = sp.getString('appartamento_temp_$_idAppartamento');

    if (ap != null) {
      _appartamento = AppartamentoModel.fromJson(jsonDecode(ap));

      List<CondominioStrumenti> strumenti = await getStrumentiCondominio(_idAnaCondominio);

      int countActiveService = strumenti.length;

      int countCompletedService = 0;

      if(_appartamento!.riscaldamento != null && _appartamento!.riscaldamento!.completato){
          countCompletedService++;
      }

      if(_appartamento!.raffrescamento != null && _appartamento!.raffrescamento!.completato){
          countCompletedService++;
      }

      if(_appartamento!.acquaCalda != null && _appartamento!.acquaCalda!.completato){
          countCompletedService++;
      }

      if(_appartamento!.acquaFredda != null && _appartamento!.acquaFredda!.completato){
          countCompletedService++;
      }
      
      if(countActiveService != 0 || countCompletedService != 0){
        if(countActiveService == countCompletedService){
          setState(() {
            _exit = true;
          });
        }else{
          setState(() {
            _partial = true;
          });
        }
      }
    }
  }

  String getNameOfStrumento(CondominioStrumenti strumento){
    switch(strumento){
      case CondominioStrumenti.ripartitoriRiscaldamento:
        return "Ripartitori riscaldamento";
      case CondominioStrumenti.contatoreCaldo:
        return "Contatore caldo";
      case CondominioStrumenti.contatoreFreddo:
        return "Contatore freddo";
      case CondominioStrumenti.contatoreCaldoFreddo:
        return "Contatore caldo/freddo";
      case CondominioStrumenti.contatoreAcquaCalda:
        return "Contatore acqua calda";
      case CondominioStrumenti.contatoreAcquaFredda:
        return "Contatore acqua fredda";
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
            CustomHorizontalStepper(
              steps: const ["1", "2", "3", "4"],
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
                    for (var i = 0; i < 4; i++) {
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
                      
                      bool isDisabled = false;
                      if (_appartamento != null) {
                        switch (strumento) {
                          case CondominioStrumenti.contatoreFreddo:
                            if (_appartamento!.raffrescamento != null) {
                              isDisabled =
                                  _appartamento!.raffrescamento!.completato;
                            }
                            break;
                          case CondominioStrumenti.contatoreCaldoFreddo:
                            if (_appartamento!.riscaldamento != null &&
                                _appartamento!.raffrescamento != null) {
                              isDisabled =
                                  _appartamento!.riscaldamento!.completato &&
                                      _appartamento!.raffrescamento!.completato;
                            }
                            break;
                          case CondominioStrumenti.contatoreCaldo:
                            if (_appartamento!.riscaldamento != null) {
                              isDisabled =
                                  _appartamento!.riscaldamento!.completato;
                            }
                            break;
                          case CondominioStrumenti.ripartitoriRiscaldamento:
                            if (_appartamento!.riscaldamento != null) {
                              isDisabled =
                                  _appartamento!.riscaldamento!.completato;
                            }
                            break;
                          case CondominioStrumenti.contatoreAcquaCalda:
                            if (_appartamento!.acquaCalda != null) {
                              isDisabled =
                                  _appartamento!.acquaCalda!.completato;
                            }
                            break;
                          case CondominioStrumenti.contatoreAcquaFredda:
                            if (_appartamento!.acquaFredda != null) {
                              isDisabled =
                                  _appartamento!.acquaFredda!.completato;
                            }
                            break;
                        }
                      }

                      CondominioStrumenti nomeServizio = strumento;

                      Color cardColor = isDisabled
                          ? Colors.grey
                          : (_selectedIndex == index
                              ? const Color.fromARGB(255, 253, 192, 99)
                              : Colors.white);

                      IconData iconData;
                      if (nomeServizio == CondominioStrumenti.ripartitoriRiscaldamento) {
                        iconData = HeroiconsSolid.fire;
                      } else {
                        iconData = HeroiconsSolid.wrenchScrewdriver;
                      }

                      return Card(
                        color: cardColor,
                        child: ListTile(
                          leading:
                              Icon(iconData, color: CustomColors.iconColor),
                          title: Text(getNameOfStrumento(nomeServizio)),
                          onTap: isDisabled
                              ? null
                              : () {
                                  setState(() {
                                    _selectedIndex = index;
                                    _selectedStrumento = nomeServizio;
                                  });
                                },
                        ),
                      );
                    }).toList());

                    if (_selectedStrumento == CondominioStrumenti.ripartitoriRiscaldamento) {
                      listViewChildren.addAll([
                        SizedBox(height: 20),
                        Text(
                            'Inserire il numero dei ripartitori del riscaldamento, in caso di contatori diretti inserire 1',
                            style: Theme.of(context).textTheme.displaySmall),
                        CustomTextfield(
                            text: 'Numero Ripartitori riscaldamento',
                            controller: _numeroRipartitoriController,
                            required: true),
                      ]);
                    }
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
          child: _createButton()
        ),
      ),
      backgroundColor: CustomColors.secondaryBackground,
    );
  }

  void _stepSucc() async {
    if (_selectedIndex != -1 && _appartamento != null) {
      if (_selectedStrumento == CondominioStrumenti.ripartitoriRiscaldamento &&
          _numeroRipartitoriController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Inserire il numero dei ripartitori del riscaldamento')));
        return;
      }
      switch (_selectedStrumento!) {
        case CondominioStrumenti.contatoreFreddo:
          _appartamento!.raffrescamento =
              StatoRipartitori(completato: false, ripartitori: []);
          break;
        case CondominioStrumenti.contatoreCaldoFreddo:
          _appartamento!.riscaldamento =
              StatoRipartitori(completato: false, ripartitori: []);

          _appartamento!.raffrescamento =
              StatoRipartitori(completato: false, ripartitori: []);
          break;
        case CondominioStrumenti.contatoreCaldo:
          _appartamento!.riscaldamento =
              StatoRipartitori(completato: false, ripartitori: []);
          break;
        case CondominioStrumenti.ripartitoriRiscaldamento:
          _appartamento!.riscaldamento =
              StatoRipartitori(completato: false, ripartitori: []);
          _appartamento!.numeroRipartitoriRiscaldamento =
              int.parse(_numeroRipartitoriController.text);
          break;
        case CondominioStrumenti.contatoreAcquaCalda:
          _appartamento!.acquaCalda =
              StatoRipartitori(completato: false, ripartitori: []);
          break;
        case CondominioStrumenti.contatoreAcquaFredda:
          _appartamento!.acquaFredda =
              StatoRipartitori(completato: false, ripartitori: []);
          break;
      }

      final sharedPref = await SharedPreferences.getInstance();
      sharedPref.setString('appartamento_temp_$_idAppartamento',
          jsonEncode(_appartamento!.toJson()));

      print(jsonDecode(
          sharedPref.getString('appartamento_temp_$_idAppartamento')!));

      Navigator.pushNamed(context, "/newStrumento",
          arguments: NewStrumentoPageArgs(data: {
            'id': _idAnaCondominio,
            'idAppartamento': _idAppartamento,
            'selectedStrumento': _selectedStrumento,
            'modifica': false,
            'matricola_modifica': ''
          }));
    }
  }


  Widget _createButton(){
    if(_exit){
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CustomButton(
                text: 'Salva ed esci',
                onPressed: () {
                  Provider.of<SaveDataProvider>(context, listen: false).saveData(context, _idAnaCondominio, _idAppartamento);
                  Navigator.pushNamedAndRemoveUntil(context, '/appartamenti', (route) => false, arguments: AppartamentiPageArgs(data: {'id': _idAnaCondominio}));
                },
              ),
            ),
          ],
        );
    }else if(!_exit && _partial){
      return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Salva ed esci',
                  onPressed: () async {
                    Provider.of<SaveDataProvider>(context, listen: false).saveData(context, _idAnaCondominio, _idAppartamento);
                    Navigator.pushNamedAndRemoveUntil(context, '/appartamenti', (route) => false,  arguments: AppartamentiPageArgs(data: {'id': _idAnaCondominio}));
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
          );
    }else{
      return Row(
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
          );
    }
  }


}

class SelezioneStrumentiPageArgs {
  final dynamic data;

  SelezioneStrumentiPageArgs({required this.data});
}
