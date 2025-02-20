import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:installatori_de/models/appartamento_model.dart';
import 'dart:convert';
import 'package:installatori_de/models/condominio_model.dart';
import 'package:installatori_de/utils/api_requests.dart';
import 'dart:io';


class SaveDataProvider extends ChangeNotifier {
  StreamSubscription? listener;
  bool _isListening = false;

  int idAnaCondominio = 0;
  int idAppartamento = 0;

  BuildContext? context;

  void skip(int idAnaCondominio){
    this.idAnaCondominio = idAnaCondominio;
  }

  Future<bool> saveData(BuildContext context, int idAnaCondominio, int idAppartamento) async {
    this.idAnaCondominio = idAnaCondominio;
    this.idAppartamento = idAppartamento;
    this.context = context;
    bool hasConnection = await InternetConnection().hasInternetAccess;
    
    if (hasConnection) {
      return await saveToDb(idAnaCondominio, idAppartamento);
    } else {
      if (!_isListening) {
        startConnectionListener(idAnaCondominio, idAppartamento);
      }
      return false;
    }
  }

  void startConnectionListener(int idAnaCondominio, int idAppartamento) {
    _isListening = true;
    listener = InternetConnection().onStatusChange.listen((InternetStatus status) async {
      if(status == InternetStatus.connected){
          bool isSaved = await saveToDb(idAnaCondominio, idAppartamento);
          if(isSaved){
            stopListener();
          }
      }
    });
  }

  void stopListener() {
    listener?.cancel();
    listener = null;
    _isListening = false;
  }

  @override
  void dispose() {
    stopListener();
    super.dispose();
  }

  Future<bool> saveToDb(int idAnaCondominio, int idAppartamento) async {

    final sp = await SharedPreferences.getInstance();
    String? appartamentoTemp = sp.getString('appartamento_temp_$idAppartamento');

    print("temporaneo1 $appartamentoTemp");

    if(appartamentoTemp != null){
      AppartamentoModel appartamento = AppartamentoModel.fromJson(jsonDecode(appartamentoTemp));

      print('appartamento model $appartamento');

      String? condominiString = sp.getString('condomini');

      print('condominio arrivato $condominiString');

      if(condominiString != null){

        List<CondominioModel> condominiList = List.from(jsonDecode(condominiString)).map((condominio) {
          return CondominioModel.fromJson(condominio);
        }).toList();

        print('condomini list $condominiList');


        for(var condominio in condominiList){
          if(condominio.idAnaCondominio == idAnaCondominio){
            if(condominio.appartamenti != null){
              bool find = false;
              for(var i = 0; i < condominio.appartamenti!.length; i++){
                if(condominio.appartamenti![i].id == appartamento.id){
                  find = true;
                  condominio.appartamenti![i] = appartamento;
                }
              }

              if(!find){
                condominio.appartamenti!.add(appartamento);
              }
            }else{
              condominio.appartamenti!.add(appartamento);
            }
          }
        }

        sp.setString('condomini', jsonEncode(condominiList));

        print('condomini finale ${sp.getString("condomini")}');

        for (var condominio in condominiList) {
          saveCondominio(condominio);
        }

      }
    }


    return true;
  }

  Future<bool> saveCondominio(CondominioModel condominio) async {

    List<AppartamentoModel> appartamentiToRemove = [];

    for(var appartamento in condominio.appartamenti!){
      bool result = await saveAppartamentoAndStrumenti(appartamento);
      if(result){
        appartamentiToRemove.add(appartamento);
      }
    }

    if(appartamentiToRemove.isNotEmpty){
      final sp = await SharedPreferences.getInstance();
      String? condominiString = sp.getString('condomini');
      if (condominiString != null) {
        List<CondominioModel> condominiList = List.from(jsonDecode(condominiString))
            .map((c) => CondominioModel.fromJson(c)).toList();

        for (var cond in condominiList) {
          if (cond.idAnaCondominio == condominio.idAnaCondominio) {
            cond.appartamenti?.removeWhere((app) => 
              appartamentiToRemove.any((toRemove) => toRemove.id == app.id));
          }
        }

        await sp.setString('condomini', jsonEncode(condominiList));
      }
    }

    return true;

  }

  String? getTimestampFromFilename(String filename) {
    try {
      return filename.split('_').last.split('.').first;
    } catch (e) {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  Future<bool> saveAppartamentoAndStrumenti(AppartamentoModel appartamento) async {

    List<File> fileAppartamento = [];

    if(appartamento.pathUploadImage != null){
      fileAppartamento.add(File(appartamento.pathUploadImage!));
      appartamento.pathUploadImage = "appartamento_${idAnaCondominio}_${getTimestampFromFilename(appartamento.pathUploadImage!)}.png";
    }

    List<File> fileStrumenti = [];

    Map<String, List<File>> files = {};

    files['appartamento'] = fileAppartamento;

    if(appartamento.riscaldamento != null){
      if(appartamento.riscaldamento!.ripartitori != null){
        int id = 0;
        for(var ripartitore in appartamento.riscaldamento!.ripartitori!){
            fileStrumenti.add(File(ripartitore.pathImage));

            ripartitore.pathImage = "riscaldamento_${idAnaCondominio}_${id}_${getTimestampFromFilename(ripartitore.pathImage)}.png";
            id++;
        }
      }
    }

    files['riscaldamento'] = fileStrumenti;
    fileStrumenti = [];

    if(appartamento.raffrescamento != null){
      if(appartamento.raffrescamento!.ripartitori != null){
        int id = 0;
        for(var ripartitore in appartamento.raffrescamento!.ripartitori!){
            fileStrumenti.add(File(ripartitore.pathImage));

            ripartitore.pathImage = "raffrescamento_${idAnaCondominio}_${id}_${getTimestampFromFilename(ripartitore.pathImage)}.png";
            id++;
        }
      }
    }

    files['raffrescamento'] = fileStrumenti;
    fileStrumenti = [];

    if(appartamento.acquaCalda != null){
      if(appartamento.acquaCalda!.ripartitori != null){
        int id = 0;
        for(var ripartitore in appartamento.acquaCalda!.ripartitori!){
            fileStrumenti.add(File(ripartitore.pathImage));

            ripartitore.pathImage = "acquaCalda_${idAnaCondominio}_${id}_${getTimestampFromFilename(ripartitore.pathImage)}.png";
            id++;
        }
      }
    }

    files['acquaCalda'] = fileStrumenti;
    fileStrumenti = [];

    if(appartamento.acquaFredda != null){
      if(appartamento.acquaFredda!.ripartitori != null){
        int id = 0;
        for(var ripartitore in appartamento.acquaFredda!.ripartitori!){
            fileStrumenti.add(File(ripartitore.pathImage));

            ripartitore.pathImage = "acquaFredda_${idAnaCondominio}_${id}_${getTimestampFromFilename(ripartitore.pathImage)}.png";
            id++;
        }
      }
    }

    files['acquaFredda'] = fileStrumenti;


    dynamic result = await ApiRequests.sendMultipartAuthRequest('condominio/$idAnaCondominio/appartamenti/$idAppartamento', 'POST', {'appartamento': appartamento.toJson()}, files);

    if(result['errore_double_token'] == true){
      Navigator.pushNamedAndRemoveUntil(context!, '/', (route) => false);
      return false;
    }
    

    return result['success'];
  }


}