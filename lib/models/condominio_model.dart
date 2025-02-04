import 'package:installatori_de/models/appartamento_model.dart';

class CondominioModel {
  int idAnaCondominio;
  List<AppartamentoModel>? appartamenti;
  

  CondominioModel({
    required this.idAnaCondominio,
    this.appartamenti
  });

  @override
  factory CondominioModel.fromJson(Map<String, dynamic> json) {
    List<AppartamentoModel> appartamentiList = [];

    List.from(json['appartamenti']).forEach((appartamento){
      appartamentiList.add(AppartamentoModel.fromJson(appartamento));
    });

    return CondominioModel(
      idAnaCondominio: json['idAnaCondominio'],
      appartamenti: appartamentiList
    );

  }

  Map<String, dynamic> toJson(){
    if(appartamenti != null){
      return {
        'idAnaCondominio': idAnaCondominio,
        'appartamenti': appartamenti!.map((appartamento) => appartamento.toJson()).toList()
      };
    }else{
      return{
        'idAnaCondominio': idAnaCondominio,
        'appartamenti': null
      };
    }
  }
    
}
