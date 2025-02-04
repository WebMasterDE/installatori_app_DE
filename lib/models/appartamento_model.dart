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
  Map<String, StatoRipartitori> raffrescamento;
  Map<String, StatoRipartitori> riscaldamento;
  Map<String, StatoRipartitori> acquaCalda;
  Map<String, StatoRipartitori> acquaFredda;

  AppartamentoModel({
    this.id,
    required this.interno,
    required this.piano,
    required this.scala,
    this.pathUploadImage,
    required this.nome,
    required this.cognome,
    required this.mail,
    Map<String, StatoRipartitori>? raffrescamento,
    Map<String, StatoRipartitori>? riscaldamento,
    Map<String, StatoRipartitori>? acquaCalda,
    Map<String, StatoRipartitori>? acquaFredda,
  })  : raffrescamento = raffrescamento ?? {},
        riscaldamento = riscaldamento ?? {},
        acquaCalda = acquaCalda ?? {},
        acquaFredda = acquaFredda ?? {};

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
      raffrescamento: (json['raffrescamento'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, StatoRipartitori.fromJson(value)),
          ) ??
          {},
      riscaldamento: (json['riscaldamento'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, StatoRipartitori.fromJson(value)),
          ) ??
          {},
      acquaCalda: (json['acquaCalda'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, StatoRipartitori.fromJson(value)),
          ) ??
          {},
      acquaFredda: (json['acquaFredda'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, StatoRipartitori.fromJson(value)),
          ) ??
          {},
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
      'raffrescamento':
          raffrescamento.map((key, value) => MapEntry(key, value.toJson())),
      'riscaldamento':
          riscaldamento.map((key, value) => MapEntry(key, value.toJson())),
      'acquaCalda':
          acquaCalda.map((key, value) => MapEntry(key, value.toJson())),
      'acquaFredda':
          acquaFredda.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

class StatoRipartitori {
  bool completato;
  List<RipartitoriModel> ripartitori;

  StatoRipartitori({this.completato = false, required this.ripartitori});

  factory StatoRipartitori.fromJson(Map<String, dynamic> json) {
    return StatoRipartitori(
      completato: json['completato'] ?? false,
      ripartitori: (json['ripartitori'] as List<dynamic>?)
              ?.map((e) => RipartitoriModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completato': completato,
      'ripartitori': ripartitori.map((e) => e.toJson()).toList(),
    };
  }
}
