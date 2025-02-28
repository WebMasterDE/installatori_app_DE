import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:installatori_de/components/custom_button.dart';
import 'package:installatori_de/components/custom_textField.dart';
import 'package:installatori_de/components/stepper.dart';
import 'package:installatori_de/models/condominio_model.dart';
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

  bool _isNotCompletedImage = false;

  int _idAppartamento = 0;
  late CondominioStrumenti _selectedStrumento;

  final _formKey = GlobalKey<FormState>();

  String matricolaString = '';
  AppartamentoModel? _appartamento;

  bool _modifica = false;

  String _matricolaModifica = "";

  String _saveNota = ""; //serve per salvare la nota prima della modifica

  @override
  void initState() {
    super.initState();

    _idAnaCondominio = widget.arguments.data['id'];
    _idAppartamento = widget.arguments.data['idAppartamento'];
    _selectedStrumento = widget.arguments.data['selectedStrumento'];
    _modifica = widget.arguments.data['modifica'];
    _matricolaModifica = widget.arguments.data['matricola_modifica'];

    getAppartamento();
  }

  void getAppartamento() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? ap = sp.getString('appartamento_temp_$_idAppartamento');

    if (ap != null) {
      _appartamento = AppartamentoModel.fromJson(jsonDecode(ap));
    }
    if (_modifica) {
      initializeModifica();
    }
  }

  void initializeModifica() async {
    RipartitoriModel ripartitore;
    switch (_selectedStrumento) {
      case CondominioStrumenti.contatoreFreddo:
        ripartitore = _appartamento!.raffrescamento!.ripartitori!
            .firstWhere((rip) => rip.matricola == _matricolaModifica);
        break;
      case CondominioStrumenti.contatoreCaldoFreddo:
        ripartitore = _appartamento!.riscaldamento!.ripartitori!
            .firstWhere((rip) => rip.matricola == _matricolaModifica);
        break;
      case CondominioStrumenti.contatoreCaldo:
        ripartitore = _appartamento!.riscaldamento!.ripartitori!
            .firstWhere((rip) => rip.matricola == _matricolaModifica);
        break;
      case CondominioStrumenti.ripartitoriRiscaldamento:
        ripartitore = _appartamento!.riscaldamento!.ripartitori!
            .firstWhere((rip) => rip.matricola == _matricolaModifica);
        _altezzaController.text =ripartitore.altezza.toString().replaceAll('.', ',');
        _larghezzaController.text =ripartitore.larghezza.toString().replaceAll('.', ',');
        _profonditaController.text =ripartitore.profondita.toString().replaceAll('.', ',');
        _nElementiController.text =ripartitore.numeroElementi.toString().replaceAll('.', ',');
        break;
      case CondominioStrumenti.contatoreAcquaCalda:
        ripartitore = _appartamento!.acquaCalda!.ripartitori!
            .firstWhere((rip) => rip.matricola == _matricolaModifica);
        break;
      case CondominioStrumenti.contatoreAcquaFredda:
        ripartitore = _appartamento!.acquaFredda!.ripartitori!
            .firstWhere((rip) => rip.matricola == _matricolaModifica);
        break;
    }

    _matricolaController.text = ripartitore.matricola;
    _descrizioneController.text = ripartitore.descrizione ?? '';
    _vanoController.text = ripartitore.vano.toString();
    _tipologiaController.text = ripartitore.tipologia!;
    _altezzaController.text =
        ripartitore.altezza.toString().replaceAll('.', ',');
    _larghezzaController.text =
        ripartitore.larghezza.toString().replaceAll('.', ',');
    _profonditaController.text =
        ripartitore.profondita.toString().replaceAll('.', ',');
    _nElementiController.text =
        ripartitore.numeroElementi.toString().replaceAll('.', ',');
    if (ripartitore.pathImage != null) {
      final File newImage = File(ripartitore.pathImage!);
      _pathUploadImage = ripartitore.pathImage;
      _saveNota = ripartitore.note!;

      setState(() {
        _uploadImage = newImage;
      });
    }
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
            if (_modifica)
              CustomHorizontalStepper(
                steps: const [
                  "1",
                  "2",
                ],
                currentStep: 1,
              ),
            if (!_modifica)
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
                          height: 10,
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
                        if (_selectedStrumento == CondominioStrumenti.ripartitoriRiscaldamento)
                          CustomTextfield(
                            text: "Tipologia",
                            controller: _tipologiaController,
                            required: true,
                          ),
                        if (_selectedStrumento == CondominioStrumenti.ripartitoriRiscaldamento)
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
                        if (_selectedStrumento == CondominioStrumenti.ripartitoriRiscaldamento)
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

        String nomeTipologia = '';

        switch (_selectedStrumento) {
          case CondominioStrumenti.contatoreFreddo:
            nomeTipologia = 'raffrescamento';
            break;
          case CondominioStrumenti.contatoreCaldoFreddo:
            nomeTipologia = 'riscaldamento_raffrescamento';
            break;
          case CondominioStrumenti.contatoreCaldo || CondominioStrumenti.ripartitoriRiscaldamento:
            nomeTipologia = 'riscaldamento';
            break;
          case CondominioStrumenti.contatoreAcquaCalda:
            nomeTipologia = 'acquaCalda';
            break;
          case CondominioStrumenti.contatoreAcquaFredda:
            nomeTipologia = 'acquaFredda';
            break;
        }

        _pathUploadImage = path.join(appDir.path,
            '${_idAnaCondominio}_${_idAppartamento}_${nomeTipologia}_$timestamp.${image.path.split('.').last.toLowerCase()}');

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
      if (_uploadImage == null) {
        setState(() {
          _isNotCompletedImage = true;
        });
      } else {
        setState(() {
          _isNotCompletedImage = false;
        });
      }

      if (_uploadImage != null) {
        RipartitoriModel ripartitore = RipartitoriModel(
            matricola: _matricolaController.text,
            descrizione: _descrizioneController.text,
            vano: int.parse(_vanoController.text),
            tipologia: _tipologiaController.text,
            altezza: _altezzaController.text.isNotEmpty
                ? double.parse(_altezzaController.text.replaceAll(',', '.'))
                : null,
            larghezza: _larghezzaController.text.isNotEmpty
                ? double.parse(_larghezzaController.text.replaceAll(',', '.'))
                : null,
            profondita: _profonditaController.text.isNotEmpty
                ? double.parse(_profonditaController.text.replaceAll(',', '.'))
                : null,
            numeroElementi: _nElementiController.text.isNotEmpty
                ? int.parse(_nElementiController.text.replaceAll(',', '.'))
                : null,
            //TODO: inserire campo nel form!!
            produttore: 'produttore',
            pathImage: _pathUploadImage!);

        print(jsonEncode(_appartamento));

        switch (_selectedStrumento) {
          case CondominioStrumenti.contatoreFreddo:
            int indexra = _appartamento!.raffrescamento!.ripartitori!
                .indexWhere((rip) => rip.matricola == _matricolaModifica);
            if (indexra != -1) {
              
              ripartitore.note = _saveNota;
              _appartamento!.raffrescamento!.ripartitori![indexra] =
                  ripartitore;
            } else {
              _appartamento!.raffrescamento!.ripartitori!.add(ripartitore);
            }
            _appartamento!.raffrescamento!.completato = true;
            break;
          case CondominioStrumenti.contatoreCaldoFreddo:
            int indexra = _appartamento!.raffrescamento!.ripartitori!
                .indexWhere((rip) => rip.matricola == _matricolaModifica);
            if (indexra != -1) {
              ripartitore.note = _saveNota;
              _appartamento!.raffrescamento!.ripartitori![indexra] =
                  ripartitore;
            } else {
              _appartamento!.raffrescamento!.ripartitori!.add(ripartitore);
            }
            int indexri = _appartamento!.riscaldamento!.ripartitori!
                .indexWhere((rip) => rip.matricola == _matricolaModifica);
            if (indexri != -1) {
              ripartitore.note = _saveNota;

              _appartamento!.riscaldamento!.ripartitori![indexri] = ripartitore;
            } else {
              _appartamento!.riscaldamento!.ripartitori!.add(ripartitore);
            }

            _appartamento!.riscaldamento!.completato = true;
            _appartamento!.raffrescamento!.completato = true;
            break;
          case CondominioStrumenti.contatoreCaldo:
            int index = _appartamento!.riscaldamento!.ripartitori!
                .indexWhere((rip) => rip.matricola == _matricolaModifica);
            if (index != -1) {
              ripartitore.note = _saveNota;

              _appartamento!.riscaldamento!.ripartitori![index] = ripartitore;
            } else {
              _appartamento!.riscaldamento!.ripartitori!.add(ripartitore);
            }
            _appartamento!.riscaldamento!.completato = true;
            break;
          case CondominioStrumenti.ripartitoriRiscaldamento:
            int index = _appartamento!.riscaldamento!.ripartitori!
                .indexWhere((rip) => rip.matricola == _matricolaModifica);
            if (index != -1) {
              ripartitore.note = _saveNota;

              _appartamento!.riscaldamento!.ripartitori![index] = ripartitore;
            } else {
              _appartamento!.riscaldamento!.ripartitori!.add(ripartitore);
            }
            break;
          case CondominioStrumenti.contatoreAcquaCalda:
            int index = _appartamento!.acquaCalda!.ripartitori!
                .indexWhere((rip) => rip.matricola == _matricolaModifica);
            if (index != -1) {
              ripartitore.note = _saveNota;

              _appartamento!.acquaCalda!.ripartitori![index] = ripartitore;
            } else {
              _appartamento!.acquaCalda!.ripartitori!.add(ripartitore);
            }
            _appartamento!.acquaCalda!.completato = true;
            break;
          case CondominioStrumenti.contatoreAcquaFredda:
            int indexri = _appartamento!.acquaFredda!.ripartitori!
                .indexWhere((rip) => rip.matricola == _matricolaModifica);
            if (indexri != -1) {
              ripartitore.note = _saveNota;

              _appartamento!.acquaFredda!.ripartitori![indexri] = ripartitore;
            } else {
              _appartamento!.acquaFredda!.ripartitori!.add(ripartitore);
            }
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
              'selectedStrumento': _selectedStrumento,
              'modifica': _modifica,
            }));
      }
    }
  }
}

class NewStrumentoPageArgs {
  final dynamic data;

  NewStrumentoPageArgs({required this.data});
}
