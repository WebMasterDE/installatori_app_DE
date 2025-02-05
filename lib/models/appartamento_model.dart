import 'package:installatori_de/models/ripartitori_model.dart';

class AppartamentoModel {
  int? id;
  String interno;
  int piano;
  String scala;
  String? pathUploadImage;
  String nome;
  String cognome;
  String mail;
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
    StatoRipartitori? raffrescamento,
    StatoRipartitori? riscaldamento,
    StatoRipartitori? acquaCalda,
    StatoRipartitori? acquaFredda,
  });

  factory AppartamentoModel.fromJson(Map<String, dynamic> json) {
    return AppartamentoModel(
      id: json['id'],
      interno: json['interno'],
      piano: json['piano'],
      scala: json['scala'],
      pathUploadImage: json['pathUploadImage'],
      nome: json['nome'],
      cognome: json['cognome'],
      mail: json['mail'],
      raffrescamento: json['raffrescamento'] != null ? StatoRipartitori.fromJson(json['raffrescamento']) : null,
      riscaldamento: json['riscaldamento'] != null ? StatoRipartitori.fromJson(json['riscaldamento']) : null,
      acquaCalda: json['acquaCalda'] != null ? StatoRipartitori.fromJson(json['acquaCalda']) : null,
      acquaFredda: json['acquaFredda'] != null ? StatoRipartitori.fromJson(json['acquaFredda']) : null,
    );
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
      'raffrescamento': raffrescamento?.toJson(),
      'riscaldamento': riscaldamento?.toJson(),
      'acquaCalda': acquaCalda?.toJson(),
      'acquaFredda': acquaFredda?.toJson()
    };
  }
}

class StatoRipartitori {
  bool completato;
  List<RipartitoriModel>? ripartitori;

  StatoRipartitori({this.completato = false, this.ripartitori});

  factory StatoRipartitori.fromJson(Map<String, dynamic> json) {

    List<RipartitoriModel> ripartitoriList = [];

    for (var ripartitore in List.from(json['ripartitori'])) {
      ripartitoriList.add(RipartitoriModel.fromJson(ripartitore));
    }

    return StatoRipartitori(
      completato: json['completato'] ?? false,
      ripartitori: ripartitoriList
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completato': completato,
      'ripartitori': ripartitori != null ? (ripartitori!.map((e) => e.toJson()).toList()) : List.empty(),
    };
  }
}
