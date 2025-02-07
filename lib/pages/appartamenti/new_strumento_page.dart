import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/components/custom_textField.dart';
import 'package:installatori_de/components/stepper.dart';
import 'package:installatori_de/models/ripartitori_model.dart';
import 'package:installatori_de/pages/appartamenti/nota_ripartitori.dart';
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
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class NewStrumentoPage extends StatefulWidget {
  static const route = '/newStrumento';

  final NewStrumentoPageArgs arguments;

  const NewStrumentoPage({super.key, required this.arguments});

  @override
  State<NewStrumentoPage> createState() => _NewStrumentoPageState();
}

class _NewStrumentoPageState extends State<NewStrumentoPage> {
  bool _riscaldamento = false;
  bool _raffrescamento = false;

  File? _uploadImage;
  String? _pathUploadImage;
  int _idAnaCondominio = 0;

  final TextEditingController _matricolaController = TextEditingController();
  final TextEditingController _descrizioneController = TextEditingController();
  final TextEditingController _vanoController = TextEditingController();
  final TextEditingController _tipologiaController = TextEditingController();
  final TextEditingController _altezzaController = TextEditingController();
  final TextEditingController _larghezzaController = TextEditingController();
  final TextEditingController _profonditaController = TextEditingController();
  final TextEditingController _nElementiController = TextEditingController();

  bool _isNotCompletedCheck = false;
  bool _isNotCompletedImage = false;

  int _idAppartamento = 0;
  String _selectedStrumento = '';

  final _formKey = GlobalKey<FormState>();

  String matricolaString = '';
  AppartamentoModel? _appartamento;

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
    _idAppartamento = widget.arguments.data['idAppartamento'];
    _selectedStrumento = widget.arguments.data['selectedStrumento'];

    getAppartamento();
  }

  void getAppartamento() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? ap = sp.getString('appartamento_temp_$_idAppartamento');

    print("test ${jsonEncode(ap)}");

    if (ap != null) {
      _appartamento = AppartamentoModel.fromJson(jsonDecode(ap));
    }

    print(jsonEncode(_appartamento));
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
        body: Column(
          children: [
            CustomHorizontalStepper(
              steps: const ["1", "2", "3", "4"],
              currentStep: 2,
            ),
            Expanded(
              child: SingleChildScrollView(
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
                          'Dati ripartitori',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (_selectedStrumento == "Contatore Caldo/Freddo")
                          Text('Tipologia ripartitori',
                              style: Theme.of(context).textTheme.labelSmall),
                        SizedBox(
                          height: 10,
                        ),
                        Row(spacing: 2, children: [
                          Checkbox(
                            value: _riscaldamento,
                            onChanged: (value) {
                              setState(() {
                                _riscaldamento = value ?? false;
                              });
                            },
                            activeColor: CustomColors.iconColor,
                          ),
                          Text("Riscaldamento")
                        ]),
                        Row(spacing: 2, children: [
                          Checkbox(
                            value: _raffrescamento,
                            onChanged: (value) => {
                              setState(() {
                                _raffrescamento = value ?? false;
                              })
                            },
                            activeColor: CustomColors.iconColor,
                          ),
                          Text("Raffrescamento")
                        ]),
                        if (_isNotCompletedCheck)
                          Text('Campo necessario',
                              style: Theme.of(context).textTheme.displaySmall),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextfield(
                                text: 'Matricola',
                                controller: _matricolaController,
                                required: true,
                              ),
                            ),
                            Column(children: [
                              SizedBox(
                                height: 22,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: CustomColors.iconColor,
                                ),
                                onPressed: () async {
                                  String? res =
                                      await SimpleBarcodeScanner.scanBarcode(
                                    context,
                                    barcodeAppBar: const BarcodeAppBar(
                                      appBarTitle: 'Test',
                                      centerTitle: false,
                                      enableBackButton: true,
                                      backButtonIcon:
                                          Icon(Icons.arrow_back_ios),
                                    ),
                                    isShowFlashIcon: true,
                                    delayMillis: 1000,
                                    cameraFace: CameraFace.back,
                                  );
                                  setState(() {
                                    _matricolaController.text = res as String;
                                  });
                                },
                                alignment: Alignment.center,
                              ),
                            ]),
                          ],
                        ),
                        CustomTextfield(
                            text: "Descrizione",
                            controller: _descrizioneController,
                            required: true),
                        CustomTextfield(
                          text: "Vano",
                          controller: _vanoController,
                          required: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo richiesto';
                            }

                            final intRegExp = RegExp(r'^[0-9]+$');
                            if (!intRegExp.hasMatch(value)) {
                              return 'Inserire un numero intero';
                            }
                          },
                          textInputType: TextInputType.number,
                        ),
                        if (_selectedStrumento == "riscaldamento")
                          CustomTextfield(
                            text: "Tipologia",
                            controller: _tipologiaController,
                            required: true,
                          ),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                                child: CustomTextfield(
                              text: "Altezza (cm)",
                              controller: _altezzaController,
                              required: true,
                              textInputType: TextInputType.numberWithOptions(
                                  decimal: true),
                            )),
                            Expanded(
                                child: CustomTextfield(
                              text: "Larghezza (cm)",
                              controller: _larghezzaController,
                              required: true,
                              textInputType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ))
                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                                child: CustomTextfield(
                              text: "Profodità (cm)",
                              controller: _profonditaController,
                              required: true,
                              textInputType: TextInputType.numberWithOptions(
                                  decimal: true),
                            )),
                            Expanded(
                                child: CustomTextfield(
                              text: "Numero elementi",
                              controller: _nElementiController,
                              required: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo richiesto';
                                }

                                final intRegExp = RegExp(r'^[0-9]+$');
                                if (!intRegExp.hasMatch(value)) {
                                  return 'Inserire un numero intero';
                                }
                              },
                              textInputType: TextInputType.number,
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Foto termosifone',
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
                                border:
                                    Border.all(color: CustomColors.iconColor),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  _takePicture();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt,
                                        color: CustomColors.iconColor,
                                        size: 50),
                                    Text('Scatta una foto',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
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
                                border:
                                    Border.all(color: CustomColors.iconColor),
                              ),
                              child: Image.file(
                                File(_uploadImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if (_isNotCompletedImage)
                          Text('Campo necessario',
                              style: Theme.of(context).textTheme.displaySmall),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
      if (_riscaldamento || _raffrescamento) {
        setState(() {
          _isNotCompletedCheck = false;
        });
      } else {
        setState(() {
          _isNotCompletedCheck = true;
        });
      }

      if (_uploadImage == null) {
        setState(() {
          _isNotCompletedImage = true;
        });
      } else {
        setState(() {
          _isNotCompletedImage = false;
        });
      }

      if ((_riscaldamento || _raffrescamento) && _uploadImage != null) {
        RipartitoriModel ripartitore = RipartitoriModel(
            matricola: _matricolaController.text,
            descrizione: _descrizioneController.text,
            vano: int.parse(_vanoController.text),
            tipologia: _tipologiaController.text,
            altezza: double.parse(_altezzaController.text.replaceAll(',', '.')),
            larghezza:
                double.parse(_larghezzaController.text.replaceAll(',', '.')),
            profondita:
                double.parse(_profonditaController.text.replaceAll(',', '.')),
            numeroElementi:
                int.parse(_nElementiController.text.replaceAll(',', '.')),
            pathImage: _pathUploadImage!);

        print(jsonEncode(_appartamento));

        switch (_selectedStrumento) {
          case "Contatore Freddo":
            _appartamento!.raffrescamento!.ripartitori!.add(ripartitore);
            _appartamento!.raffrescamento!.completato = true;
            break;
          case "Contatore Caldo/Freddo":
            _appartamento!.riscaldamento!.ripartitori!.add(ripartitore);

            _appartamento!.raffrescamento!.ripartitori!.add(ripartitore);

            _appartamento!.riscaldamento!.completato = true;
            break;
          case "Contatore Caldo":
            _appartamento!.riscaldamento!.ripartitori!.add(ripartitore);

            _appartamento!.riscaldamento!.completato = true;
            break;
          case "Ripartitori Riscaldamento":
            _appartamento!.riscaldamento!.ripartitori!.add(ripartitore);
            break;
          case "Contatore Acqua Calda":
            _appartamento!.acquaCalda!.ripartitori!.add(ripartitore);
            _appartamento!.acquaCalda!.completato = true;
            break;
          case "Contatore Acqua Fredda":
            _appartamento!.acquaFredda!.ripartitori!.add(ripartitore);
            _appartamento!.acquaFredda!.completato = true;
            break;
        }

        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('appartamento_temp_$_idAppartamento',
            jsonEncode(_appartamento!.toJson()));

        print(jsonDecode(sp.getString('appartamento_temp_$_idAppartamento')!));

        Navigator.pushNamed(context, "/nota_ripartitori",
            arguments: NotaRipartitoriPageArgs(data: {
              'id': _idAnaCondominio,
              'idAppartamento': _idAppartamento,
              'matricola': ripartitore.matricola,
              'selectedStrumento': _selectedStrumento
            }));
      }
    }
  }
}

class NewStrumentoPageArgs {
  final dynamic data;

  NewStrumentoPageArgs({required this.data});
}
