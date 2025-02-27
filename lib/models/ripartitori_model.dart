class RipartitoriModel {
  String matricola;
  String? descrizione;
  int? vano;
  String? tipologia;
  double? altezza;
  double? larghezza;
  double? profondita;
  int? numeroElementi;
  String? pathImage;
  String? note;
  String? produttore;

  RipartitoriModel(
      {required this.matricola,
      this.descrizione,
      this.vano,
      this.tipologia,
      this.altezza,
      this.larghezza,
      this.profondita,
      this.numeroElementi,
      this.pathImage,
      this.note,
      this.produttore
      }
    );
   RipartitoriModel.fromJson(Map<String, dynamic> json)
       : matricola = json['matricola'],
         descrizione = json['descrizione'],
         vano = json['vano'] != null ? int.parse(json['vano'].toString()) : null,
         pathImage = json['pathImage'],
         tipologia = json['tipologia'],
         altezza = json['altezza'] != null ? double.parse(json['altezza'].toString()) : null,
         larghezza = json['larghezza'] != null ? double.parse(json['larghezza'].toString()) : null,
         profondita = json['profondita'] != null ? double.parse(json['profondita'].toString()) : null,
         numeroElementi = json['numeroElementi'] != null ? int.parse(json['numeroElementi'].toString()) : null,
         note = json['note'],
         produttore = json['produttore'];

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
      'note': note,
      'produttore': produttore
    };
  }
}
