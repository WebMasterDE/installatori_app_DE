import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/models/condominio_model.dart';
import 'package:installatori_de/utils/api_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppartamentiProvider extends ChangeNotifier {

  Future<List<AppartamentoModel>> getAppartamenti(int idAnaCondominio) async {

    List<AppartamentoModel> appartamenti;

    var response = await ApiRequests.sendAuthRequest('condominio/$idAnaCondominio/appartamenti', 'GET', {});

    if(response != null && response['error'] == false){
      appartamenti = List.from(response['data']).map((appartamento){
        return AppartamentoModel.fromJson(appartamento);
      }).toList();

      var sp = await SharedPreferences.getInstance();
      String? condominiString = sp.getString('condomini');

      print(condominiString);

      if (condominiString != null) {
        List<dynamic> condominiList = jsonDecode(condominiString);
        for (var condominio in condominiList) {
          if(condominio['idAnaCondominio'] == idAnaCondominio){
            CondominioModel cm = CondominioModel.fromJson(condominio);
            if(cm.appartamenti != null && cm.appartamenti!.isNotEmpty){
              List<AppartamentoModel>? listAp = cm.appartamenti;
              for (var appartamento in listAp!) {
                appartamenti.add(appartamento);
              }
            }
          }
        }
      }

      return appartamenti;


    }else{
      return List.empty();
    }

  }

}