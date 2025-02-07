import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/pages/appartamenti/selezione_strumenti_page.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotaAppartamentoPage extends StatefulWidget {
  static const route = '/nota_appartamento';

  final NotaAppartamentoPageArgs arguments;

  const NotaAppartamentoPage({super.key, required this.arguments});

  @override
  State<NotaAppartamentoPage> createState() => _NotaAppartamentoPageState();
}

class _NotaAppartamentoPageState extends State<NotaAppartamentoPage> {
  int _idAnaCondominio = 0;
  int _idAppartamento = 0;
  AppartamentoModel? _appartamento;

  final TextEditingController _notaAppartamento = TextEditingController();

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
    _idAppartamento = widget.arguments.data['idAppartamento'];

    getAppartamento();
  }

  void getAppartamento() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? ap = sp.getString('appartamento_temp_$_idAppartamento');

    if (ap != null) {
      _appartamento = AppartamentoModel.fromJson(jsonDecode(ap));
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
            Text("Nota Appartamento",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 60),
            Expanded(
              child: TextFormField(
                minLines: 8,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _notaAppartamento,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CustomColors.iconColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CustomColors.iconColor, width: 3),
                  ),
                  hintText: "Inserisci una nota per l'appartamento",
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
          ),
        ),
      ),
      backgroundColor: CustomColors.secondaryBackground,
    );
  }

  void _stepSucc() async {
    if (_notaAppartamento.text.isNotEmpty) {
      _appartamento?.note = _notaAppartamento.text;

      final sharedPref = await SharedPreferences.getInstance();
      sharedPref.setString('appartamento_temp_$_idAppartamento',
          jsonEncode(_appartamento!.toJson()));
    }
    Navigator.pushNamed(context, "/selezione_strumenti",
        arguments: SelezioneStrumentiPageArgs(data: {
          'id': _idAnaCondominio,
          'idAppartamento': _idAppartamento,
        }));
  }
}

class NotaAppartamentoPageArgs {
  final dynamic data;

  NotaAppartamentoPageArgs({required this.data});
}
