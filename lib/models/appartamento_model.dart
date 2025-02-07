import 'package:installatori_de/models/ripartitori_model.dart';

class AppartamentoModel {
  int? id;
  late String interno;
  late int piano;
  late String scala;
  String? pathUploadImage;
  late String nome;
  late String cognome;
  late String mail;
  int? numeroRipartitoriRiscaldamento; //viene inserito a 1 in caso di contatori diretti
  String? note;
  StatoRipartitori? raffrescamento;
  StatoRipartitori? riscaldamento;
  StatoRipartitori? acquaCalda;
  StatoRipartitori? acquaFredda;

  AppartamentoModel({
    this.id,
    required this.interno,
    required this.piano,
    required this.scala,
    this.pathUploadImage,
    required this.nome,
    required this.cognome,
    required this.mail,
    this.note,
    required this.numeroRipartitoriRiscaldamento,
    StatoRipartitori? raffrescamento,
    StatoRipartitori? riscaldamento,
    StatoRipartitori? acquaCalda,
    StatoRipartitori? acquaFredda,
  });

  AppartamentoModel.fromJson(Map<String, dynamic> json) {
    print("JSON data: $json");
      id= json['id'];
      interno= json['interno'];
      piano= json['piano'];
      scala= json['scala'];
      pathUploadImage= json['pathUploadImage'];
      nome= json['nome'];
      cognome= json['cognome'];
      mail= json['mail'];
      note= json['note'];
      numeroRipartitoriRiscaldamento = json['numeroRipartitoriRiscaldamento'];
      raffrescamento= json['raffrescamento'] != null ? StatoRipartitori.fromJson(json['raffrescamento']) : null;
      riscaldamento= json['riscaldamento'] != null ? StatoRipartitori.fromJson(json['riscaldamento']) : null;
      acquaCalda= json['acquaCalda'] != null ? StatoRipartitori.fromJson(json['acquaCalda']) : null;
      acquaFredda= json['acquaFredda'] != null ? StatoRipartitori.fromJson(json['acquaFredda']) : null;
  }
  

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'interno': interno,
      'piano': piano,
      'scala': scala,
      'pathUploadImage': pathUploadImage,
      'nome': nome,
      'cognome': cognome,
      'mail': mail,
      'note': note,
      'numeroRipartitoriRiscaldamento': numeroRipartitoriRiscaldamento,
      'raffrescamento': raffrescamento?.toJson(),
      'riscaldamento': riscaldamento?.toJson(),
      'acquaCalda': acquaCalda?.toJson(),
      'acquaFredda': acquaFredda?.toJson()
    };
  }
}

class StatoRipartitori {
  late bool completato;
  List<RipartitoriModel>? ripartitori;

  StatoRipartitori({this.completato = false, this.ripartitori});

  StatoRipartitori.fromJson(Map<String, dynamic> json) {

    List<RipartitoriModel> ripartitoriList = [];

    for (var ripartitore in List.from(json['ripartitori'])) {
      ripartitoriList.add(RipartitoriModel.fromJson(ripartitore));
    }

      completato= json['completato'] ?? false;
      ripartitori= ripartitoriList;
  }

  Map<String, dynamic> toJson() {
    return {
      'completato': completato,
      'ripartitori': ripartitori != null ? (ripartitori!.map((e) => e.toJson()).toList()) : List.empty(),
    };
  }
}
