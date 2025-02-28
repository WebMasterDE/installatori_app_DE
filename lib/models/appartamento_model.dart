import 'package:installatori_de/models/ripartitori_model.dart';

class AppartamentoModel {
  int? id;
  late String? interno;
  late int? piano;
  late String? scala;
  String? pathUploadImage;
  int? idUtente;
  late String? nome;
  late String? cognome;
  late String? mail;
  int? numeroRipartitoriRiscaldamento; //viene inserito a 1 in caso di contatori diretti
  String? note;
  StatoRipartitori? raffrescamento;
  StatoRipartitori? riscaldamento;
  StatoRipartitori? acquaCalda;
  StatoRipartitori? acquaFredda;
  bool savedOnDb = false;

  AppartamentoModel({
    this.id,
    this.interno,
    this.piano,
    this.scala,
    this.pathUploadImage,
    this.nome,
    this.cognome,
    this.mail,
    this.note,
    this.numeroRipartitoriRiscaldamento,
    this.idUtente,
    StatoRipartitori? raffrescamento,
    StatoRipartitori? riscaldamento,
    StatoRipartitori? acquaCalda,
    StatoRipartitori? acquaFredda,
    savedOnDb = false
  });

  AppartamentoModel.fromJson(Map<String, dynamic> json) {
      id= json['id'] != null ? int.parse(json['id'].toString()) : null;
      interno= json['interno'];
      piano= json['piano'] != null ? int.parse(json['piano'].toString()) : null;
      scala= json['scala'];
      pathUploadImage= json['pathUploadImage'];
      nome= json['nome'];
      cognome= json['cognome'];
      mail= json['mail'];
      note= json['note'];
      idUtente = json['idUtente'];
      numeroRipartitoriRiscaldamento = json['numeroRipartitoriRiscaldamento'] != null ? int.parse(json['numeroRipartitoriRiscaldamento'].toString()) : null;
      raffrescamento= json['raffrescamento'] != null ? StatoRipartitori.fromJson(json['raffrescamento']) : null;
      riscaldamento= json['riscaldamento'] != null ? StatoRipartitori.fromJson(json['riscaldamento']) : null;
      acquaCalda= json['acquaCalda'] != null ? StatoRipartitori.fromJson(json['acquaCalda']) : null;
      acquaFredda= json['acquaFredda'] != null ? StatoRipartitori.fromJson(json['acquaFredda']) : null;
      savedOnDb = json['savedOnDb'];
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
      'acquaFredda': acquaFredda?.toJson(),
      'savedOnDb': savedOnDb
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
      'ripartitori': ripartitori != null ? (ripartitori!.map((e) => e.toJson()).toList()) : [],
    };
  }
}
