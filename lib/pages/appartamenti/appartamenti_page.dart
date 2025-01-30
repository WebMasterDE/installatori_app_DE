import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/providers/appartamenti_provider.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';


class AppartamentiPage extends StatefulWidget {

  static const route = '/appartamenti';

  final AppartamentiPageArgs arguments;


  const AppartamentiPage({super.key, required this.arguments});

  @override
  State<AppartamentiPage> createState() => _AppartamentiPageState();
}

class _AppartamentiPageState extends State<AppartamentiPage> {

  late Future<List<dynamic>> appartamenti;

  int _idAnaCondominio = 0;
  String _nomeCondominio = '';

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
    _nomeCondominio = widget.arguments.data['nome'];

    appartamenti = AppartamentiProvider().getAppartamenti(_idAnaCondominio);

  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading : false,
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
                    leading: Icon(HeroiconsSolid.plus, color: CustomColors.iconColor),
                    title: Text('Nuovo appartamento'),
                    subtitle: Text('Aggiungi un nuovo appartamento'),
                    onTap: () {
                      Navigator.pushNamed(context, '/newAppartamento');
                    },
                  ),
                ),
              ),
            ];
        
            if (snapshot.connectionState == ConnectionState.waiting) {
              for (var i = 0; i < 2; i++){
                listViewChildren.add( 
                  Skeletonizer(
                    child: Card(
                            child: ListTile(
                              leading: Icon(HeroiconsSolid.home, color: CustomColors.iconColor),
                              title: Text('Appartamento'),
                              subtitle: Text('Piano: - Interno:  - Scala: '),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          )
                  )
                );
              }
            } else {
              listViewChildren.addAll(
                snapshot.data!.map((appartamento){
                  return Card(
                        child: ListTile(
                          leading: Icon(HeroiconsSolid.home, color: CustomColors.iconColor),
                          title: Text('Appartamento - interno: ${appartamento['interno']}'),
                          subtitle: Text('Piano: ${appartamento['piano']} - Scala: ${appartamento['scala']}'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.pushNamed(context, '/newAppartamento');
                          },
                        ),
                      );
                })
              );
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

          child: CustomButton(
            text: 'Salva ed esci',
            onPressed: () {
              Navigator.pop(context);
            },
          )
        )
    );
  }
}


class AppartamentiPageArgs {
  final dynamic data;

  AppartamentiPageArgs({required this.data});
}