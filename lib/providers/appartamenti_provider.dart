import 'package:flutter/foundation.dart';
import 'package:installatori_de/utils/api_requests.dart';

class AppartamentiProvider extends ChangeNotifier {

  Future<List<dynamic>> getAppartamenti(int idAnaCondominio) async {
    var response = await ApiRequests.sendAuthRequest('condominio/$idAnaCondominio/appartamenti', 'GET', {});

    if(response != null && response['error'] == false){
      return List<dynamic>.from(response['data']);
    }else{
      return List.empty();
    }

  }

}