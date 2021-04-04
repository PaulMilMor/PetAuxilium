import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
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

  String _selectedCategory;
  List listItems = ['ENTRENAMIENTO'];
  String _pricing;
  String _desc;

  List<String> imagesRef = [];
  List<Object> images = [];
  Future<File> _imageFile;
  List<ImageUploadModel> _imgsFiles = [];
  File imagefile;
  List<File> _listImages = [];
  final picker = ImagePicker();
  FocusScopeNode _node;
  void initState() {
    super.initState();
    setState(() {
      images.add("Add Image");
      /*images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");*/
    });
    _pricing = prefs.keeperPricing ?? ' ';
    _desc = prefs.keeperDescription;
    _selectedCategory = 'ENTRENAMIENTO';
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

                        _imgsFiles.remove(index);
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
            child: FlatButton(
              onPressed: () {
                images.length < 6
                    ? _onAddImageClick(index)
                    : _limitImages(context);
              },
              color: Colors.grey[200],
              height: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 48,
                    color: Color.fromRGBO(210, 210, 210, 1),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      //FIXME: cambiar .pickimage a -getimage para evitar errores futuros
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      if (_imageFile != null) {
        getFileImage(index);
        print("xd" + _imageFile.toString());
      } else {
        print("faros");
      }
      if (images.length < 6) images.add("Add Image");
    });
  }

  _limitImages(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text('Solo se pueden insertar 5 imágenes a la vez')));
  }

  void getFileImage(int index) async {
    _imageFile.then((file) async {
      imagesRef.add(await _storage.uploadFile(file, 'PublicationImages'));

      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;
        imageUpload.imageUrl = '';
        // _imgsFiles.add(imageUpload);
        images.replaceRange(index, index + 1, [imageUpload]);
      });
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imagefile = File(pickedFile.path);
      } else {
        print('No image selected');
      }
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
            _pricingTxt(),
            _descTxt(),
            buildGridView(),
            _buttons()
          ],
        ),
      ),
    );
  }

  Widget _category() {
    return Container(
      // height: 100.0,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Center(
          child: Column(children: [
        Container(
          margin: const EdgeInsets.only(right: 4.5),
          child: Text(
            'Servicios que ofrece:',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          child: GrayDropdownButton(
            hint: Text("Selecciona una categoria"),
            value: _selectedCategory,
            onChanged: (newValue) {
              prefs.keeperCategory = newValue;
              setState(() {
                _selectedCategory = newValue;
              });
            },
            items: listItems.map((valueItem) {
              return DropdownMenuItem(
                value: valueItem,
                child: Text(valueItem),
              );
            }).toList(),
          ),
        )
      ])),
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
        child: Text('Cancelar', style: TextStyle(color: Colors.black)),
        onPressed: () {
          Navigator.pop(context);
          _pricing = null;
          _desc = null;
        },
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
            if (_pricing.isEmpty || _desc.isEmpty || imagesRef.isEmpty) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text('Es necesario llenar todos los campos')));
            } else {
              print(_imgsFiles.toString());

              PublicationModel ad = PublicationModel(
                  category: 'CUIDADOR',
                  name: prefs.userName,
                  location: ['29.115967, -111.025490'],
                  userID: prefs.userID,
                  description: _desc,
                  pricing: '\$$_pricing por hora',
                  imgRef: imagesRef);
              _db.addKeeper(ad).then((value) {
                prefs.keeperPricing = '';
                prefs.keeperDescription = '';
                prefs.keeperCategory = 'ENTRENAMIENTO';
                Navigator.popAndPushNamed(context, 'navigation');
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content:
                          Text('Te registraste correctamente como cuidador')));
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Publicar'),
          )),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
