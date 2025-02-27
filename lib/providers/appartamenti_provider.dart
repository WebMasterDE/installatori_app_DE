import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/models/condominio_model.dart';
import 'package:installatori_de/utils/api_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppartamentiProvider extends ChangeNotifier {

  Future<List<AppartamentoModel>> getAppartamenti(int idAnaCondominio, BuildContext context) async {

    List<AppartamentoModel> appartamenti = [];

    //var response = await ApiRequests.sendAuthRequest('condominio/$idAnaCondominio/appartamenti', 'GET', {});
    
    /*if (response['errore_double_token'] == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      return List.empty();
    }*/
    
    /*if(response != null && response['error'] == false){
      appartamenti = List.from(response['data']).map((appartamento){
        return AppartamentoModel.fromJson(appartamento);
      }).toList();*/

      var sp = await SharedPreferences.getInstance();
      String? condominiListString = sp.getString('condomini');

      if (condominiListString != null) {

        List<CondominioModel> condominiList = List.from(jsonDecode(condominiListString)).map((condominio) {
          return CondominioModel.fromJson(condominio);
        }).toList();

        for(var condominio in condominiList){
          if(condominio.idAnaCondominio == idAnaCondominio && condominio.appartamenti != null && condominio.appartamenti!.isNotEmpty){
            for (var appartamento in condominio.appartamenti!) {
                appartamenti.add(appartamento);
              }
          }
        }
      }

      return appartamenti;


    /*}else{
      return List.empty();
    }*/

  }

}