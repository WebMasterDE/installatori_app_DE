class RipartitoriModel {
  String matricola;
  String descrizione;
  int vano;
  String tipologia;
  int? altezza;
  int? larghezza;
  int? profondita;
  int? numeroElementi;
  String pathImage;

  //Aggiungere lista ripartitori (oggetti di tipo Ripartitore)

  RipartitoriModel(
      {required this.matricola,
      required this.descrizione,
      required this.vano,
      required this.tipologia,
      this.altezza,
      this.larghezza,
      this.profondita,
      this.numeroElementi,
      required this.pathImage});

  @override
  factory RipartitoriModel.fromJson(Map<String, dynamic> json) =>
      RipartitoriModel(
          matricola: json['matricola'],
          descrizione: json['descrizione'],
          vano: json['vano'],
          tipologia: json['tipologia'],
          altezza: json['altezza'],
          larghezza: json['larghezza'],
          profondita: json['profondita'],
          numeroElementi: json['numeroElementi'],
          pathImage: json['pathImage']);

  Map<String, dynamic> toJson() {
    return {
      'matricola': matricola,
      'descrizione': descrizione,
      'vano': vano,
      'tipologia': tipologia,
      'altezza': altezza,
      'larghezza': larghezza,
      'profondita': profondita,
      'numeroElementi': numeroElementi,
      'pathImage': pathImage
    };
  }
}
