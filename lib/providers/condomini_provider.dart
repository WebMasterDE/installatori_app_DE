import 'package:flutter/material.dart';
import 'package:installatori_de/utils/api_requests.dart';

class CondominiProvider extends ChangeNotifier {


  Future<List<dynamic>> get_ticket_condomini() async {

    final response = await ApiRequests.sendAuthRequest('ticket_condomini', 'GET', {});

    if(response != null) {
      return List<dynamic>.from(response['data']);
    }

    return List.empty();
  }

}