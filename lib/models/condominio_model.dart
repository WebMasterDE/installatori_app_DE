import 'package:installatori_de/models/appartamento_model.dart';

class CondominioModel {
  late int idAnaCondominio;
  late String nome;
  List<AppartamentoModel>? appartamenti;
  late List<CondominioStrumenti> strumenti;
  

  CondominioModel({
    required this.idAnaCondominio,
    required this.nome,
    this.appartamenti,
    required this.strumenti
  });

  CondominioModel.fromJson(Map<String, dynamic> json) {
    idAnaCondominio = int.parse(json['idAnaCondominio'].toString());
    nome = json['nome'];

    List<AppartamentoModel> appartamentiList = [];

    List.from(json['appartamenti']).forEach((appartamento){
      appartamentiList.add(AppartamentoModel.fromJson(appartamento));
    });
    appartamenti=appartamentiList;

    strumenti = List<CondominioStrumenti>.from(
      json['servizi'].map((x) => CondominioStrumenti.values.firstWhere(
          (e) => e.toString() == 'CondominioStrumenti.$x'
      ))
    );
  }

  Map<String, dynamic> toJson(){
    if(appartamenti != null){
      return {
        'idAnaCondominio': idAnaCondominio,
        'nome': nome,
        'appartamenti': appartamenti!.map((appartamento) => appartamento.toJson()).toList(),
        'servizi': strumenti.map((x) => x.name).toList()
      };
    }else{
      return{
        'idAnaCondominio': idAnaCondominio,
        'nome': nome,
        'appartamenti': null,
        'servizi': strumenti.map((x) => x.name).toList()
      };
    }
  }
    
}

enum CondominioStrumenti {
  ripartitoriRiscaldamento,
  contatoreCaldo,
  contatoreFreddo,
  contatoreCaldoFreddo,
  contatoreAcquaCalda,
  contatoreAcquaFredda
}
