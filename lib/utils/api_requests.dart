import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiRequests {
  static const String BASE_URL = 'http://192.168.232.182:8443/api/';
  static bool _isRefreshing = false;

  static Future<dynamic> sendRequest(
      String url, String method, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      dynamic response;
      if (method == 'GET') {
        response = await http.get(Uri.parse(BASE_URL + url), headers: headers);
      } else if (method == 'POST') {
        response = await http.post(Uri.parse(BASE_URL + url),
            body: body, headers: headers);
      } else if (method == 'PUT') {
        response = await http.put(Uri.parse(BASE_URL + url),
            body: body, headers: headers);
      }

      var responseBody = json.decode(response.body);
      //caso in cui il token è scaduto durante l'uso dello'applicazione
      if (responseBody['error'] == true &&
          responseBody['message'] == 'jwt expired' &&
          !_isRefreshing) {
        _isRefreshing = true;

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String refreshToken = prefs.getString('refreshToken') ?? '';

        final Map<String, String> headers_r = {
          'Authorization': 'Bearer $refreshToken'
        };
        //faccio la richiesta al backen per verificare il refreshToken e nel caso ricevo un nuovo token e refreshToken
        final rs = await sendRequest('refresh', 'GET', {}, headers: headers_r);
        if (rs['error'] == false) {
          prefs.setString('token', rs['data']['token']);
          prefs.setString('refreshToken', rs['data']['refreshToken']);

          final Map<String, String> newHeaders = {
            'Authorization': 'Bearer ${rs['data']['token']}'
          };
          _isRefreshing = false;

          return await sendRequest(url, method, body, headers: newHeaders);
        } //caso in cui il refreshToken è scaduto
        else {
          _isRefreshing = false;
          return {'errore_double_token': true};
        }
      }

      return responseBody;
    } catch (e) {
      _isRefreshing = false;
      return null;
    }
  }

  static Future<dynamic> sendAuthRequest(
      String url, String method, Map<String, dynamic> body) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        return null;
      }

      final Map<String, String> headers = {'Authorization': 'Bearer $token'};

      final response = await sendRequest(url, method, body, headers: headers);

      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> sendLoginRequest(
      String url, String mail, String psw) async {
    try {
      String basicAuth = base64Encode(utf8.encode('$mail:$psw'));
      final String basicAuthString = 'Basic $basicAuth';

      final Map<String, String> headers = {
        'Authorization': basicAuthString,
        'Content-Type': 'application/json'
      };

      final response = await sendRequest(url, 'GET', {}, headers: headers);

      return response;
    } catch (e) {
      return null;
    }
  }
}
