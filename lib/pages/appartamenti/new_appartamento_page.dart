import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/components/custom_textField.dart';
import 'package:installatori_de/models/condominio_model.dart';
import 'package:installatori_de/pages/appartamenti/selezione_strumenti_page.dart';
import 'package:installatori_de/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:installatori_de/models/appartamento_model.dart';
import 'package:permission_handler/permission_handler.dart';

class NewAppartamentoPage extends StatefulWidget {
  static const route = '/newAppartamento';

  final NewAppartamentoPageArgs arguments;

  const NewAppartamentoPage({super.key, required this.arguments});

  @override
  State<NewAppartamentoPage> createState() => _NewAppartamentoPageState();
}

class _NewAppartamentoPageState extends State<NewAppartamentoPage> {
  File? _uploadImage;
  String? _pathUploadImage;
  int _idAnaCondominio = 0;

  final TextEditingController _internoController = TextEditingController();
  final TextEditingController _scalaController = TextEditingController();
  final TextEditingController _pianoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cognomeController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Nuovo Appartamento',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
          backgroundColor: CustomColors.secondaryBackground,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Dati appartamento',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextfield(
                              text: 'Interno',
                              controller: _internoController,
                              required: true)),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: CustomTextfield(
                              text: 'Scala',
                              controller: _scalaController,
                              required: true)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextfield(
                          text: 'Piano',
                          controller: _pianoController,
                          required: true,
                          textInputType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo richiesto';
                            }

                            final intRegExp = RegExp(r'^[0-9]+$');
                            if (!intRegExp.hasMatch(value)) {
                              return 'Inserire un numero intero';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(child: SizedBox())
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Foto campanello',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      if (_uploadImage != null)
                        Expanded(
                          child: IconButton(
                              alignment: Alignment.centerRight,
                              onPressed: () {
                                _deleteImage();
                              },
                              icon: Icon(
                                HeroiconsSolid.trash,
                                color: CustomColors.errorColor,
                              )),
                        )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_uploadImage == null)
                    Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: CustomColors.iconColor),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _takePicture();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  color: CustomColors.iconColor, size: 50),
                              Text('Scatta una foto',
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: CustomColors.iconColor),
                        ),
                        child: Image.file(
                          File(_uploadImage!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Dati inquilino',
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextfield(
                      text: 'Nome',
                      controller: _nomeController,
                      required: true),
                  CustomTextfield(
                      text: 'Cognome',
                      controller: _cognomeController,
                      required: true),
                  CustomTextfield(
                    text: 'Email',
                    controller: _mailController,
                    required: true,
                    validator: (value) {
                      if (_mailController.text.isEmpty) {
                        return 'Campo richiesto';
                      }

                      if (!EmailValidator.validate(
                          _mailController.text.trim())) {
                        return 'Email nel formato non valido';
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
        backgroundColor: CustomColors.secondaryBackground,
        bottomNavigationBar: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 20),
            height: 50,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Indietro',
                      onPressed: () {
                        _deleteImage();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      text: 'Avanti',
                      onPressed: () {
                        _stepSucc();
                      },
                    ),
                  ),
                ],
              ),
            )));
  }

  void _takePicture() async {
    try {
      final status = await Permission.camera.request();

      if (status.isGranted) {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);

        if (image == null) return;

        final Directory appDir = await getApplicationDocumentsDirectory();

        final String timestamp =
            DateTime.now().millisecondsSinceEpoch.toString();

        _pathUploadImage =
            path.join(appDir.path, '$_idAnaCondominio-$timestamp.jpg');

        final File newImage = await File(image.path).copy(_pathUploadImage!);

        setState(() {
          _uploadImage = newImage;
        });
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _deleteImage() async {
    try {
      if (_uploadImage != null) {
        await _uploadImage!.delete();

        setState(() {
          _uploadImage = null;
        });
      }
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }

  void _stepSucc() async {
    if (_formKey.currentState!.validate()) {
      final sharedPref = await SharedPreferences.getInstance();

      var condominiList = sharedPref.getString('condomini');

      List<CondominioModel> cmList = [];

      int idAppartamento = 0;

      CondominioModel? condominio;

      if (condominiList != null) {
        List<Map<String, dynamic>> cmListString =
            List.from(jsonDecode(condominiList));

        for (int i = 0; i < cmListString.length; i++) {
          cmList.add(CondominioModel.fromJson(cmListString[i]));

          CondominioModel c = cmList.last;

          if (c.idAnaCondominio == _idAnaCondominio) {
            condominio = c;
            List<AppartamentoModel>? appartamenti = c.appartamenti;

            if (appartamenti != null) {
              idAppartamento = appartamenti.last.id! + 1;
            }
          }
        }
      }

      //Creo entità appartamento
      AppartamentoModel am = AppartamentoModel(
          id: idAppartamento,
          interno: _internoController.text,
          scala: _scalaController.text,
          piano: int.parse(_pianoController.text),
          pathUploadImage: _pathUploadImage,
          nome: _nomeController.text,
          cognome: _cognomeController.text,
          mail: _mailController.text,
          numeroRipartitoriRiscaldamento: 1,
      );

      int? idAppartamentoFrom = sharedPref.getInt('id_appartamento_from');

      if (idAppartamentoFrom == null) {
        if (condominiList == null || condominio == null) {
          List<AppartamentoModel> amList = [];
          amList.add(am);

          CondominioModel cm = CondominioModel(
              idAnaCondominio: _idAnaCondominio, appartamenti: amList);

          cmList.add(cm);
        } else {
          if (condominio.appartamenti != null) {
            condominio.appartamenti!.add(am);
          } else {
            List<AppartamentoModel> amList = [];
            amList.add(am);

            condominio.appartamenti = amList;
          }
        }
      } else {
        List<AppartamentoModel> appartamenti = condominio!.appartamenti!;

        for (var appartamento in appartamenti) {
          if (appartamento.id == idAppartamentoFrom) {
            appartamento = am;
          }
        }
      }

      List<Map<String, dynamic>> cmListString = [];

      for (var condominio in cmList) {
        var condominioString = condominio.toJson();
        cmListString.add(condominioString);
      }

      sharedPref.setString('condomini', jsonEncode(cmListString));

      sharedPref.setString(
          'appartamento_temp_$idAppartamento', jsonEncode(am.toJson()));

      print('condominio ${jsonDecode(sharedPref.getString('condomini')!)}');
      print(
          'appartamento_temp ${jsonDecode(sharedPref.getString('appartamento_temp_$idAppartamento')!)}');

      sharedPref.remove('id_appartamento_from');

      Navigator.pushNamed(context, "/selezione_strumenti",
          arguments: SelezioneStrumentiPageArgs(data: {
            'id': _idAnaCondominio,
            'idAppartamento': idAppartamento
          }));
    }
  }
}

class NewAppartamentoPageArgs {
  final dynamic data;

  NewAppartamentoPageArgs({required this.data});
}
