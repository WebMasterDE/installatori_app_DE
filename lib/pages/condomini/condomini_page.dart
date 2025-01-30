import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:installatori_de/pages/appartamenti/appartamenti_page.dart';


class CondominiPage extends StatefulWidget {
  static const route = '/condomini';

  const CondominiPage({super.key});

  @override
  State<CondominiPage> createState() => _CondominiPageState();
}

class _CondominiPageState extends State<CondominiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 146, 7, 1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
                  title: Text("Sei sicuro di voler uscire?", style: Theme.of(context).textTheme.titleMedium),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(backgroundColor:  Color.fromRGBO(154, 247, 155, 1)),
                      child: Text('Annulla', style: Theme.of(context).textTheme.labelSmall),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/',(route) => false),
                      style: TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 0, 0)),
                      child: Text('Esci', style:  Theme.of(context).textTheme.labelSmall),
                    ),
                  ],
                  backgroundColor: Colors.orangeAccent,
                )),
                icon: Icon(
                  Icons.logout,
                ),
              ),
            ),
          )
        ],
        backgroundColor: Color.fromRGBO(255, 252, 248, 100),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Condomini',
              style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(HeroiconsSolid.buildingOffice2, color: Color.fromRGBO(255, 146, 7, 1),),
                      title: Text('Condominio $index'),
                      subtitle: Text('Via Roma 1'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pushNamed(context, '/appartamenti', arguments: AppartamentiPageArgs(data: {'id': index}));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(255, 252, 248, 100),
    );
  }
}
