import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/providers/condomini_provider.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SelezioneStrumentiPage extends StatefulWidget {
  static const route = '/selezione_strumenti';

  // final SelezioneStrumentiPageArgs arguments;

  // const SelezioneStrumentiPage({super.key, required this.arguments});
  const SelezioneStrumentiPage({super.key});

  @override
  State<SelezioneStrumentiPage> createState() => _SelezioneStrumentiPageState();
}

class _SelezioneStrumentiPageState extends State<SelezioneStrumentiPage> {
  late Future<List<dynamic>> _strumentiCondominio;

  int _idAnaCondominio = 610;
  int _internoAppartamento = 1;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();

    // _idAnaCondominio = widget.arguments.data['id'];
    // _internoAppartamento = widget.arguments.data['interno'];

    _strumentiCondominio =
        CondominiProvider().getStrumentiCondomini(_idAnaCondominio, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Nuovo Appartamento Interno: $_internoAppartamento",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: CustomColors.secondaryBackground,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
            } else {
              listViewChildren.addAll(snapshot.data!.map((strumento) {
                int index = snapshot.data!.indexOf(strumento);

                return Card(
                  color: _selectedIndex == index ? const Color.fromARGB(255, 253, 192, 99) : Colors.white,
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
                      });
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
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 20),
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CustomButton(
                text: 'indietro',
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
                  Navigator.pushNamed(context, "/nuovo_ripartitore");
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: CustomColors.secondaryBackground,
    );
  }
}

class SelezioneStrumentiPageArgs {
  final dynamic data;

  SelezioneStrumentiPageArgs({required this.data});
}
