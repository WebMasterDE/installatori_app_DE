class RipartitoriModel {
  String matricola;
  String descrizione;
  int vano;
  String? tipologia;
  double? altezza;
  double? larghezza;
  double? profondita;
  int? numeroElementi;
  String pathImage;
  String? note;

  RipartitoriModel(
      {required this.matricola,
      required this.descrizione,
      required this.vano,
      this.tipologia,
      this.altezza,
      this.larghezza,
      this.profondita,
      this.numeroElementi,
      required this.pathImage,
      this.note
      }
    );
   RipartitoriModel.fromJson(Map<String, dynamic> json)
       : matricola = json['matricola'],
         descrizione = json['descrizione'],
         vano = json['vano'],
         pathImage = json['pathImage'],
         tipologia = json['tipologia'],
         altezza = json['altezza'],
         larghezza = json['larghezza'],
         profondita = json['profondita'],
         numeroElementi = json['numeroElementi'],
         note = json['note'];


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
      'pathImage': pathImage,
      'note': note
    };
  }
}
