class AppartamentoModel {
  int? id;
  String interno;
  int piano;
  String scala;
  String? pathUploadImage;
  String nome;
  String cognome;
  String mail;
  //Aggiungere lista ripartitori (oggetti di tipo Ripartitore)
  

  AppartamentoModel({
    this.id,
    required this.interno,
    required this.piano,
    required this.scala,
    this.pathUploadImage,
    required this.nome,
    required this.cognome,
    required this.mail
  });

  @override
  factory AppartamentoModel.fromJson(Map<String, dynamic> json) => AppartamentoModel(
      id: json['id'],
      interno: json['interno'],
      piano: json['piano'],
      scala: json['scala'],
      pathUploadImage: json['pathUploadImage'],
      nome: json['nome'],
      cognome: json['cognome'],
      mail: json['mail']
  );

  Map<String, dynamic> toJson(){
    return {
      'interno': interno,
      'piano': piano,
      'scala': scala,
      'pathUploadImage': pathUploadImage,
      'nome': nome,
      'cognome': cognome,
      'mail': mail
    };
  }

      
}
