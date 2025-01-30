import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:installatori_de/providers/appartamenti_provider.dart';


class AppartamentiPage extends StatefulWidget {

  static const route = '/appartamenti';

  final AppartamentiPageArgs arguments;


  const AppartamentiPage({super.key, required this.arguments});

  @override
  State<AppartamentiPage> createState() => _AppartamentiPageState();
}

class _AppartamentiPageState extends State<AppartamentiPage> {

  late Future<List<dynamic>> appartamenti;

  @override
  void initState() {
    super.initState();
    appartamenti = AppartamentiProvider().getAppartamenti(508);

    print(widget.arguments.data);
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              'condominio 1',
              style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: FutureBuilder<List<dynamic>>(
                future: appartamenti, 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {

                    return Center(child: CircularProgressIndicator());

                  } else {
                    print(snapshot.data);
                    return ListView.builder(
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {

                        if(index == 0){

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 60.0),
                            child: Card(
                              child: ListTile(
                                leading: Icon(HeroiconsSolid.plus, color: Color.fromRGBO(255, 146, 7, 1),),
                                title: Text('Nuovo appartamento'),
                                subtitle: Text('Aggiungi un nuovo appartamento'),
                                onTap: () {
                                  Navigator.pushNamed(context, '/nuovo_appartamento');
                                },
                              ),
                            ),
                          );

                        }else{

                          var appartamento = snapshot.data![index - 1];

                          return Card(
                            child: ListTile(
                              leading: Icon(HeroiconsSolid.home, color: Color.fromRGBO(255, 146, 7, 1),),
                              title: Text('Appartamento $index'),
                              subtitle: Text('Piano: ${appartamento['piano']} - Interno: ${appartamento['interno']} - Scala: ${appartamento['scala']}'),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.pushNamed(context, '/nuovo_appartamento');
                              },
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
              
              
            ),
            SizedBox()
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(255, 252, 248, 100),
    );
  }
}


class AppartamentiPageArgs {
  final dynamic data;

  AppartamentiPageArgs({required this.data});
}