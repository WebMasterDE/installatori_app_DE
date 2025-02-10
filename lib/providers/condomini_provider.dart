import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:installatori_de/models/condominio_model.dart';
import 'package:installatori_de/utils/api_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CondominiProvider extends ChangeNotifier {
  Future<List<dynamic>> getTicketCondomini(BuildContext context) async {
    final response = await ApiRequests.sendAuthRequest(
        'condomini/ticket_condomini', 'GET', {});
    if (response['errore_double_token'] == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      return List.empty();
    }
    if (response != null) {
      return List<dynamic>.from(response['data']);
    }

    return List.empty();
  }

  Future<List<dynamic>> getStrumentiCondomini(
      int idAnaCondominio, BuildContext context) async {
    final response = await ApiRequests.sendAuthRequest(
        'condominio/$idAnaCondominio/strumenti_condomini', 'GET', {});
    if (response['errore_double_token'] == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      return List.empty();
    }
    if (response != null) {
      return List<dynamic>.from(response['data']);
    }

    return List.empty();
  }

  Future<bool> saveCondominio(
      BuildContext context, CondominioModel condominio) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    for (int i = 0; i < condominio.appartamenti!.length; i++) {
      String? appartamento_str =
          sp.getString('appartamento_temp_${condominio.appartamenti![i].id}');
      if (appartamento_str != null) {
        AppartamentoModel appartamento =
            AppartamentoModel.fromJson(jsonDecode(appartamento_str));
        print("prova ${appartamento.toJson()}");
        condominio.appartamenti![i] =
            appartamento;
      }
    }

    print("condominio giusto${condominio.toJson()}");

    final response = await ApiRequests.sendAuthRequest(
        'condominio/${condominio.idAnaCondominio}/save',
        'POST',
        condominio.toJson());

    if (response != null) {
      return true;
    }

    return false;
  }
}
