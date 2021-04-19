import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:pet_auxilium/models/ImageUploadModel.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/storage_util.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';
import 'package:pet_auxilium/widgets/button_widget.dart';

class KeeperPage extends StatefulWidget {
  @override
  KeeperPageState createState() => KeeperPageState();
}

class KeeperPageState extends State<KeeperPage> {
  final _db = dbUtil();
  final auth = AuthUtil();
  final prefs = new preferencesUtil();
  var _pricingTxtController = TextEditingController();

  var _descTxtController = TextEditingController();
  final StorageUtil _storage = StorageUtil();
  final MapsUtil mapsUtil = MapsUtil();

  List<String> _selectedServices = [];
  List listItems = [
    'CUIDADOS ESPECIALES',
    'CONSULTORÍA',
    'ENTRENAMIENTO',
    'GUARDERÍA / HOTEL ANIMAL',
    'LIMPIEZA / ASEO',
    'SERVICIOS DE SALUD'
  ];
  String _pricing;
  String _desc;

  List<String> imagesRef = [];
  List<Object> images = [];
  Future<File> _imageFile;
  List<ImageUploadModel> _imgsFiles = [];
  File imageFile;
  List<File> _listImages = [];
  final picker = ImagePicker();
  FocusScopeNode _node;
  //GlobalKey<FormFieldState<dynamic>> _multiSelectKey = GlobalKey();
  void initState() {
    super.initState();
    setState(() {
      images.add("Add Image");
    });
    _pricing = prefs.keeperPricing ?? ' ';
    _desc = prefs.keeperDescription;
    //_selectedCategory = 'ENTRENAMIENTO';
    _pricingTxtController = TextEditingController(text: _pricing);

    _descTxtController = TextEditingController(text: _desc);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _node = FocusScope.of(context);
    return Scaffold(
      body: SingleChildScrollView(child: _publicationForm(context)),
      backgroundColor: Colors.white,
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          print(uploadModel.imageUrl);
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.removeAt(index);

                        imagesRef.removeAt(index);
                        //
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AddImageButton(onTap: () {
              images.length < 6
                  ? _onAddImageClick(index)
                  : _limitImages(context);
            }),
          );
        }
      }),
    );
  }

  Future _onAddImageClick(int index) async {
    //FIXME: cambiar .pickimage a -getimage para evitar errores futuros
    final _imageFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(_imageFile.path);
    setState(() {
      if (imageFile != null) {
        if (images.length < 6) images.add("Add Image");
        getFileImage(index);
        print("xd" + imageFile.toString());
      } else {
        print("faros");
      }
    });
  }

  _limitImages(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text('Solo se pueden insertar 5 imágenes a la vez')));
  }

  void getFileImage(int index) async {
    setState(() {
      if (imageFile == null) {
        images.remove("Add Image");
      }
    });
    imagesRef.add(await _storage.uploadFile(imageFile, 'PublicationImages'));

    setState(() {
      ImageUploadModel imageUpload = new ImageUploadModel();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = imageFile;
      imageUpload.imageUrl = '';
      // _imgsFiles.add(imageUpload);
      images.replaceRange(index, index + 1, [imageUpload]);
    });
  }

  Widget _publicationForm(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                'CREAR PERFIL DE CUIDADOR',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            _services(),
            _pricingTxt(),
            _descTxt(),
            buildGridView(),
            _buttons()
          ],
        ),
      ),
    );
  }

  Widget _services() {
    return Container(
      // height: 100.0,
      margin: const EdgeInsets.fromLTRB(8, 24, 8, 18),
      child: MultiSelectBottomSheetField<String>(
        //key: _multiSelectKey,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        cancelText: Text(
          'CANCELAR',
          style: TextStyle(color: Color.fromRGBO(49, 232, 93, 1)),
        ),
        confirmText: Text(
          'OK',
          style: TextStyle(color: Color.fromRGBO(49, 232, 93, 1)),
        ),
        selectedColor: Color.fromRGBO(49, 232, 93, 1),
        decoration: BoxDecoration(
          color: Color.fromRGBO(235, 235, 235, 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Color.fromRGBO(235, 235, 235, 1),
            width: 6,
          ),
        ),
        title: Text(
          'Servicios',
          style: TextStyle(
            //color: Color.fromRGBO(202, 202, 202, 1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonText: Text(
          "Servicios que ofrece",
          style: TextStyle(
            //color: Color.fromRGBO(202, 202, 202, 1),
            fontSize: 16,
          ),
        ),
        buttonIcon: Icon(
          Icons.arrow_drop_down, color: Colors.grey[800],
          //color: Colors.blue,
        ),
        items: listItems
            .map((item) => MultiSelectItem<String>(item, item))
            .toList(),
        searchable: false,

        onConfirm: (values) {
          setState(() {
            _selectedServices = values;
          });
          // _multiSelectKey.currentState.validate();
        },
        chipDisplay: MultiSelectChipDisplay.none(),
      ),
    );
  }

  Widget _pricingTxt() {
    return Container(
        child: Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text(
              'Completa los siguientes campos',
              style: TextStyle(fontSize: 18),
            )),
      ),
      Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          child: GrayTextFormField(
            keyboardType: TextInputType.number,
            controller: _pricingTxtController,
            hintText: 'Tarifa por hora',
            suffixIcon: IconButton(
              onPressed: () {
                _pricingTxtController.clear();
                prefs.keeperPricing = '';
              },
              icon: Icon(Icons.clear),
            ),
            onChanged: (value) {
              setState(() {
                _pricing = value;
                prefs.keeperPricing = value;
              });
            },
            onEditingComplete: () => _node.nextFocus(),
          ))
    ]));
  }

  Widget _descTxt() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        child: TextField(
          controller: _descTxtController,
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              labelText: 'Descripción',
              labelStyle: TextStyle(
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  _descTxtController.clear();
                  prefs.keeperDescription = '';
                },
                icon: Icon(Icons.clear),
              )),
          maxLength: 500,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onChanged: (value) {
            setState(() {
              prefs.keeperDescription = value;
              _desc = value;
            });
          },
          onEditingComplete: () => _node.unfocus(),
        ));
  }

  Widget _buttons() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_CancelBtn(), _saveBtn()],
      ),
    );
  }

  Widget _CancelBtn() {
    return Container(
      margin: const EdgeInsets.only(right: 30.0, bottom: 50),
      child: TextButton(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Cancelar', style: TextStyle(color: Colors.black)),
        ),
        onPressed: () {
          Navigator.pop(context);
          _pricing = null;
          _desc = null;
        },
        style: TextButton.styleFrom(
          primary: Color.fromRGBO(49, 232, 93, 1),
        ),
      ),
    );
  }

  Widget _saveBtn() {
    return Container(
      margin: const EdgeInsets.only(right: 12.0, bottom: 50),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(49, 232, 93, 1),
          ),
          onPressed: () {
            bool _isTarifa = _isNumeric(_pricing[0]) &&
                _isNumeric(_pricing[_pricing.length - 1]);
            if (_pricing.isEmpty ||
                _desc.isEmpty ||
                imagesRef.isEmpty ||
                _selectedServices.isEmpty) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text('Es necesario llenar todos los campos')));
            } else {
              print(_imgsFiles.toString());
              if (_isTarifa) {
                PublicationModel ad = PublicationModel(
                    category: 'CUIDADOR',
                    name: prefs.userName,
                    location: ['29.115967, -111.025490'],
                    userID: prefs.userID,
                    description: _desc,
                    pricing: '\$$_pricing por hora',
                    imgRef: imagesRef,
                    services: _selectedServices);
                _db.addKeeper(ad).then((value) {
                  prefs.keeperPricing = '';
                  prefs.keeperDescription = '';
                  //prefs.keeperCategory = 'ENTRENAMIENTO';
                  Navigator.popAndPushNamed(context, 'navigation');
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Text(
                            'Te registraste correctamente como cuidador')));
                });
              } else {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content:
                          Text('La tarifa debe tener un formato numérico')));
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Publicar'),
          )),
    );
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
