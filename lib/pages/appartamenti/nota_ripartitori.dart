import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/models/ripartitori_model.dart';
import 'package:installatori_de/pages/appartamenti/new_strumento_page.dart';
import 'package:installatori_de/pages/appartamenti/recap_ripartitori.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:installatori_de/components/stepper.dart';

class NotaRipartitoriPage extends StatefulWidget {
  static const route = '/nota_ripartitori';

  final NotaRipartitoriPageArgs arguments;

  const NotaRipartitoriPage({super.key, required this.arguments});

  @override
  State<NotaRipartitoriPage> createState() => _NotaRipartitoriPageState();
}

class _NotaRipartitoriPageState extends State<NotaRipartitoriPage> {
  int _idAnaCondominio = 0;
  int _idAppartamento = 0;
  AppartamentoModel? _appartamento;
  String _selectedStrumento = "";
  String _matricolaRipartitore = "";
  bool _modifica = false;

  final TextEditingController _notaRipartitore = TextEditingController();

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
    _idAppartamento = widget.arguments.data['idAppartamento'];
    _matricolaRipartitore = widget.arguments.data['matricola'];
    _selectedStrumento = widget.arguments.data['selectedStrumento'];
    _modifica = widget.arguments.data['modifica'];

    getAppartamento();
  }

  void getAppartamento() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? ap = sp.getString('appartamento_temp_$_idAppartamento');

    if (ap != null) {
      _appartamento = AppartamentoModel.fromJson(jsonDecode(ap));
    }

    if (_modifica) {
      initializeModifica();
    }
  }

  void initializeModifica() async {
    RipartitoriModel ripartitore;
    switch (_selectedStrumento) {
      case "Contatore Freddo" ||
            "Contatore Caldo/Freddo" ||
            "Contatore Caldo" ||
            "Ripartitori Riscaldamento":
        ripartitore = _appartamento!.raffrescamento!.ripartitori!
            .firstWhere((rip) => rip.matricola == _matricolaRipartitore);
        _notaRipartitore.text = ripartitore.note!;
        break;
      case "Contatore Acqua Calda":
        ripartitore = _appartamento!.acquaCalda!.ripartitori!
            .firstWhere((rip) => rip.matricola == _matricolaRipartitore);
        _notaRipartitore.text = ripartitore.note!;
        break;
      case "Contatore Acqua Fredda":
        ripartitore = _appartamento!.acquaFredda!.ripartitori!
            .firstWhere((rip) => rip.matricola == _matricolaRipartitore);
        _notaRipartitore.text = ripartitore.note!;
        break;
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
            if (_modifica)
              CustomHorizontalStepper(
                steps: const [
                  "1",
                  "2",
                ],
                currentStep: 2,
              ),
              if(!_modifica)
            CustomHorizontalStepper(
              steps: const ["1", "2", "3", "4"],
              currentStep: 3,
            ),
            Text("Nota Ripartitori",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 40),
            SizedBox(height: 20),
            Expanded(
              child: TextFormField(
                minLines: 8,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _notaRipartitore,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CustomColors.iconColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CustomColors.iconColor, width: 3),
                  ),
                  hintText: "Inserisci una nota per il ripartitore",
                  filled: true,
                  fillColor: Colors.white,
                ),
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
                    _stepBack();
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
    if (_notaRipartitore.text.isNotEmpty) {
      switch (_selectedStrumento) {
        case "Contatore Freddo":
          for (final ripartitore
              in _appartamento!.raffrescamento!.ripartitori!) {
            if (ripartitore.matricola == _matricolaRipartitore) {
              ripartitore.note = _notaRipartitore.text;
            }
          }
          break;
        case "Contatore Caldo/Freddo":
          for (final ripartitore
              in _appartamento!.riscaldamento!.ripartitori!) {
            if (ripartitore.matricola == _matricolaRipartitore) {
              ripartitore.note = _notaRipartitore.text;
            }
          }

          for (final ripartitore
              in _appartamento!.raffrescamento!.ripartitori!) {
            if (ripartitore.matricola == _matricolaRipartitore) {
              ripartitore.note = _notaRipartitore.text;
            }
          }
          break;
        case "riscaldamento" || "Contatore Caldo":
          for (final ripartitore
              in _appartamento!.riscaldamento!.ripartitori!) {
            if (ripartitore.matricola == _matricolaRipartitore) {
              ripartitore.note = _notaRipartitore.text;
            }
          }
          break;
        case "Contatore Acqua Calda":
          for (final ripartitore in _appartamento!.acquaCalda!.ripartitori!) {
            if (ripartitore.matricola == _matricolaRipartitore) {
              ripartitore.note = _notaRipartitore.text;
            }
          }
          break;
        case "Contatore Acqua Fredda":
          for (final ripartitore in _appartamento!.acquaFredda!.ripartitori!) {
            if (ripartitore.matricola == _matricolaRipartitore) {
              ripartitore.note = _notaRipartitore.text;
            }
          }
          break;
      }

      final sharedPref = await SharedPreferences.getInstance();
      sharedPref.setString('appartamento_temp_$_idAppartamento',
          jsonEncode(_appartamento!.toJson()));

      print(_selectedStrumento);
      Navigator.pushNamed(context, "/recap_ripartitori",
          arguments: RecapRipartitoriPageArgs(data: {
            'id': _idAnaCondominio,
            'idAppartamento': _idAppartamento,
            'selectedStrumento': _selectedStrumento,
          }));
    }
  }

  void _stepBack() async {
    // final sp = await SharedPreferences.getInstance();
    // sp.setInt('id_appartamento_from', _idAppartamento);
    // switch (_selectedStrumento) {
    //   case "Contatore Freddo":
    //     _appartamento!.raffrescamento!.ripartitori!.removeWhere(
    //         (ripartitore) => ripartitore.matricola == _matricolaRipartitore);
    //     break;
    //   case "Contatore Caldo/Freddo":
    //     _appartamento!.raffrescamento!.ripartitori!.removeWhere(
    //         (ripartitore) => ripartitore.matricola == _matricolaRipartitore);

    //     _appartamento!.riscaldamento!.ripartitori!.removeWhere(
    //         (ripartitore) => ripartitore.matricola == _matricolaRipartitore);

    //     break;
    //   case "Contatore Caldo":
    //     _appartamento!.riscaldamento!.ripartitori!.removeWhere(
    //         (ripartitore) => ripartitore.matricola == _matricolaRipartitore);

    //     break;
    //   case "Ripartitori Riscaldamento":
    //     _appartamento!.riscaldamento!.ripartitori!.removeWhere(
    //         (ripartitore) => ripartitore.matricola == _matricolaRipartitore);
    //     break;
    //   case "Contatore Acqua Calda":
    //     _appartamento!.acquaCalda!.ripartitori!.removeWhere(
    //         (ripartitore) => ripartitore.matricola == _matricolaRipartitore);

    //     break;
    //   case "Contatore Acqua Fredda":
    //     _appartamento!.acquaFredda!.ripartitori!.removeWhere(
    //         (ripartitore) => ripartitore.matricola == _matricolaRipartitore);

    //     break;
    // }

    // sp.setString('appartamento_temp_$_idAppartamento',
    //     jsonEncode(_appartamento!.toJson()));
    // Navigator.pushNamed(context, "/newStrumento",
    //     arguments: NewStrumentoPageArgs(data: {
    //       'id': _idAnaCondominio,
    //       'idAppartamento': _idAppartamento,
    //       'selectedStrumento': _selectedStrumento,
    //     }));
    Navigator.pop(context);
  }
}

class NotaRipartitoriPageArgs {
  final dynamic data;

  NotaRipartitoriPageArgs({required this.data});
}
