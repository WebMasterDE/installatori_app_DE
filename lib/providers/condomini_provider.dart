import 'package:flutter/material.dart';
import 'package:installatori_de/utils/api_requests.dart';

class CondominiProvider extends ChangeNotifier {
  Future<List<dynamic>> get_ticket_condomini(BuildContext context) async {
    final response =
        await ApiRequests.sendAuthRequest('condomini/ticket_condomini', 'GET', {});
    if (response['errore_double_token'] == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      return List.empty();
    }
    if (response != null) {
      return List<dynamic>.from(response['data']);
    }

    return List.empty();
  }
}
